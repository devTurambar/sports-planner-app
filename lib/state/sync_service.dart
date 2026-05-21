import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/activity.dart';
import '../utils/date_utils.dart';
import 'activity_db.dart';

/// Ownership state for local data.
enum LocalDataOwner { none, sameUser, differentUser }

/// Handles syncing between local SQLite and Supabase.
///
/// Strategy: offline-first with last-write-wins (by `updated_at`).
/// Ownership tracking prevents data leaking between accounts.
class SyncService {
  SyncService._();

  static const _lastUserKey = 'kadence.last_synced_user_id';
  static const _pendingDeletesKey = 'kadence.pending_deletes';

  static SupabaseClient get _client => Supabase.instance.client;

  // ── ownership ──────────────────────────────────────────────────────────

  /// Check who owns the local data relative to the given user.
  static LocalDataOwner checkOwnership(
    SharedPreferences prefs,
    String userId,
  ) {
    final lastUser = prefs.getString(_lastUserKey);
    if (lastUser == null) return LocalDataOwner.none;
    if (lastUser == userId) return LocalDataOwner.sameUser;
    return LocalDataOwner.differentUser;
  }

  /// Record the current user as owner of local data.
  static Future<void> setOwner(SharedPreferences prefs, String userId) async {
    await prefs.setString(_lastUserKey, userId);
  }

  // ── pending deletes ───────────────────────────────────────────────────

  /// Queue a delete that couldn't be pushed to cloud (offline / signed out).
  static Future<void> addPendingDelete(
    SharedPreferences prefs,
    String activityId,
  ) async {
    final list = prefs.getStringList(_pendingDeletesKey) ?? [];
    if (!list.contains(activityId)) {
      list.add(activityId);
      await prefs.setStringList(_pendingDeletesKey, list);
    }
  }

  /// Get all pending deletes.
  static List<String> getPendingDeletes(SharedPreferences prefs) {
    return prefs.getStringList(_pendingDeletesKey) ?? [];
  }

  /// Clear pending deletes after they've been processed.
  static Future<void> clearPendingDeletes(SharedPreferences prefs) async {
    await prefs.remove(_pendingDeletesKey);
  }

  /// Flush pending deletes to cloud and remove from the list.
  static Future<void> _flushPendingDeletes(SharedPreferences prefs) async {
    final ids = getPendingDeletes(prefs);
    if (ids.isEmpty) return;
    for (final id in ids) {
      await _client.from('activities').delete().eq('id', id);
    }
    await clearPendingDeletes(prefs);
  }

  // ── cloud reads ────────────────────────────────────────────────────────

  /// Fetch all activities for a user from Supabase.
  static Future<List<Map<String, dynamic>>> fetchCloud(String userId) async {
    final response = await _client
        .from('activities')
        .select()
        .eq('user_id', userId)
        .order('date');
    return List<Map<String, dynamic>>.from(response);
  }

  /// Check if the user has any cloud data.
  static Future<bool> hasCloudData(String userId) async {
    final response = await _client
        .from('activities')
        .select('id')
        .eq('user_id', userId)
        .limit(1);
    return (response as List).isNotEmpty;
  }

  // ── cloud writes ───────────────────────────────────────────────────────

  /// Push a single activity to Supabase (upsert).
  static Future<void> pushActivity(Activity a, String userId) async {
    await _client.from('activities').upsert(toCloud(a, userId));
  }

  /// Push all local activities to Supabase.
  static Future<void> pushAll(
    Map<String, List<Activity>> byDate,
    String userId,
  ) async {
    final rows = <Map<String, dynamic>>[];
    for (final list in byDate.values) {
      for (final a in list) {
        rows.add(toCloud(a, userId));
      }
    }
    if (rows.isEmpty) return;
    await _client.from('activities').upsert(rows);
  }

  /// Replace all cloud activities for a user (delete + insert).
  /// Used by import to ensure stale cloud rows are removed.
  static Future<void> replaceAllCloud(
    Map<String, List<Activity>> byDate,
    String userId,
  ) async {
    await _client.from('activities').delete().eq('user_id', userId);
    final rows = <Map<String, dynamic>>[];
    for (final list in byDate.values) {
      for (final a in list) {
        rows.add(toCloud(a, userId));
      }
    }
    if (rows.isNotEmpty) {
      await _client.from('activities').upsert(rows);
    }
  }

  /// Clear the ownership tag so next sign-in treats local data as unowned.
  static Future<void> clearOwner(SharedPreferences prefs) async {
    await prefs.remove(_lastUserKey);
  }

  /// Delete an activity from Supabase.
  static Future<void> deleteFromCloud(String activityId) async {
    await _client.from('activities').delete().eq('id', activityId);
  }

  // ── full sync ──────────────────────────────────────────────────────────

  /// Run a full sync on sign-in. Returns the merged activity map to load
  /// into PlanController.
  ///
  /// Logic:
  /// - [LocalDataOwner.none]: local data was created offline with no
  ///   account. Push it all to cloud, pull any cloud data, merge.
  /// - [LocalDataOwner.sameUser]: normal sync — merge local + cloud
  ///   with last-write-wins.
  /// - [LocalDataOwner.differentUser]: discard local data, pull cloud.
  static Future<Map<String, List<Activity>>> syncOnSignIn({
    required SharedPreferences prefs,
    required String userId,
    required Map<String, List<Activity>> localData,
  }) async {
    final ownership = checkOwnership(prefs, userId);

    switch (ownership) {
      case LocalDataOwner.differentUser:
        // Local data belongs to someone else — wipe and pull cloud.
        await clearPendingDeletes(prefs);
        await ActivityDb.deleteAll();
        final cloud = await fetchCloud(userId);
        final merged = cloudToMap(cloud);
        await _writeLocalMap(merged);
        await setOwner(prefs, userId);
        return merged;

      case LocalDataOwner.none:
        // No previous owner. Push local to cloud, then merge with any
        // cloud data (shouldn't exist for a brand-new account, but
        // handles the case where the user signed up on another device).
        await pushAll(localData, userId);
        final cloud = await fetchCloud(userId);
        final merged = mergeLastWriteWins(localData, cloud, userId);
        await _writeLocalMap(merged);
        await setOwner(prefs, userId);
        return merged;

      case LocalDataOwner.sameUser:
        // Flush any deletes made while signed out, then merge.
        await _flushPendingDeletes(prefs);
        final cloud = await fetchCloud(userId);
        final merged = mergeLastWriteWins(localData, cloud, userId);
        // Push any local-only activities to cloud.
        await _pushLocalOnly(merged, cloud, userId);
        await _writeLocalMap(merged);
        return merged;
    }
  }

  /// Push local changes after a mutation (save/toggle/delete).
  /// Fire-and-forget — failures are silent (offline-first).
  static void pushChange(Activity a, String userId) {
    pushActivity(a, userId).catchError((_) {});
  }

  /// Delete from cloud after a local delete. Fire-and-forget.
  static void pushDelete(String activityId) {
    deleteFromCloud(activityId).catchError((_) {});
  }

  // ── merge helpers ──────────────────────────────────────────────────────

  @visibleForTesting
  static Map<String, List<Activity>> mergeLastWriteWins(
    Map<String, List<Activity>> local,
    List<Map<String, dynamic>> cloudRows,
    String userId,
  ) {
    // Index cloud by ID.
    final cloudById = <String, Map<String, dynamic>>{};
    for (final row in cloudRows) {
      cloudById[row['id'] as String] = row;
    }

    // Start with local data.
    final merged = <String, List<Activity>>{};
    final seenIds = <String>{};

    for (final entry in local.entries) {
      for (final a in entry.value) {
        seenIds.add(a.id);
        final cloudRow = cloudById[a.id];
        if (cloudRow != null) {
          // Both exist — cloud wins (it has the authoritative updated_at).
          // After first sync they stay in lockstep.
          final winner = fromCloudRow(cloudRow);
          final key = KDate.keyFor(winner.date);
          merged.putIfAbsent(key, () => <Activity>[]).add(winner);
        } else {
          // Local only — keep it.
          merged.putIfAbsent(entry.key, () => <Activity>[]).add(a);
        }
      }
    }

    // Add cloud-only activities.
    for (final row in cloudRows) {
      final id = row['id'] as String;
      if (!seenIds.contains(id)) {
        final a = fromCloudRow(row);
        final key = KDate.keyFor(a.date);
        merged.putIfAbsent(key, () => <Activity>[]).add(a);
      }
    }

    return merged;
  }

  /// Push activities that exist locally but not in cloud.
  static Future<void> _pushLocalOnly(
    Map<String, List<Activity>> merged,
    List<Map<String, dynamic>> cloudRows,
    String userId,
  ) async {
    final cloudIds = cloudRows.map((r) => r['id'] as String).toSet();
    final toPush = <Map<String, dynamic>>[];
    for (final list in merged.values) {
      for (final a in list) {
        if (!cloudIds.contains(a.id)) {
          toPush.add(toCloud(a, userId));
        }
      }
    }
    if (toPush.isNotEmpty) {
      await _client.from('activities').upsert(toPush);
    }
  }

  /// Write a full activity map to local SQLite.
  static Future<void> _writeLocalMap(
    Map<String, List<Activity>> map,
  ) async {
    await ActivityDb.deleteAll();
    final all = <Activity>[];
    for (final list in map.values) {
      all.addAll(list);
    }
    if (all.isNotEmpty) {
      await ActivityDb.upsertAll(all);
    }
  }

  // ── row mapping ────────────────────────────────────────────────────────

  @visibleForTesting
  static Map<String, dynamic> toCloud(Activity a, String userId) => {
        'id': a.id,
        'user_id': userId,
        'date': KDate.keyFor(a.date),
        'status': a.status.name,
        'name': a.name,
        'type': a.type?.name,
        'duration': a.duration,
        'time_of_day': a.timeOfDay,
        'notes': a.notes,
        'calendar_event_id': a.calendarEventId,
      };

  @visibleForTesting
  static Activity fromCloudRow(Map<String, dynamic> row) {
    final dateParts = (row['date'] as String).split('-');
    return Activity(
      id: row['id'] as String,
      date: DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      ),
      status: DayStatus.values.byName(row['status'] as String),
      name: row['name'] as String?,
      type: row['type'] != null
          ? ActivityType.values.byName(row['type'] as String)
          : null,
      duration: row['duration'] as String?,
      timeOfDay: row['time_of_day'] as String?,
      notes: row['notes'] as String?,
      calendarEventId: row['calendar_event_id'] as String?,
    );
  }

  @visibleForTesting
  static Map<String, List<Activity>> cloudToMap(
    List<Map<String, dynamic>> rows,
  ) {
    final map = <String, List<Activity>>{};
    for (final row in rows) {
      final a = fromCloudRow(row);
      final key = KDate.keyFor(a.date);
      map.putIfAbsent(key, () => <Activity>[]).add(a);
    }
    return map;
  }
}

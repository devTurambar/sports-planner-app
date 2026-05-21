import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kadence/models/activity.dart';
import 'package:kadence/state/backup_service.dart';
import 'package:kadence/state/sync_service.dart';

Activity _activity({
  required String id,
  required DateTime date,
  DayStatus status = DayStatus.planned,
  String? name,
  ActivityType? type,
  String? duration,
  String? timeOfDay,
  String? notes,
  String? calendarEventId,
}) =>
    Activity(
      id: id,
      date: date,
      status: status,
      name: name,
      type: type,
      duration: duration,
      timeOfDay: timeOfDay,
      notes: notes,
      calendarEventId: calendarEventId,
    );

Map<String, List<Activity>> _grouped(List<Activity> activities) {
  final map = <String, List<Activity>>{};
  for (final a in activities) {
    final key =
        '${a.date.year}-${a.date.month.toString().padLeft(2, '0')}-${a.date.day.toString().padLeft(2, '0')}';
    map.putIfAbsent(key, () => <Activity>[]).add(a);
  }
  return map;
}

Map<String, dynamic> _cloudRow({
  required String id,
  required String date,
  String status = 'planned',
  String userId = 'user-b',
  String? name,
  String? type,
  String? duration,
  String? timeOfDay,
  String? notes,
  String? calendarEventId,
}) =>
    {
      'id': id,
      'user_id': userId,
      'date': date,
      'status': status,
      'name': name,
      'type': type,
      'duration': duration,
      'time_of_day': timeOfDay,
      'notes': notes,
      'calendar_event_id': calendarEventId,
    };

void main() {
  // ── ownership ───────────────────────────────────────────────────────

  group('checkOwnership', () {
    test('returns none when no owner is set', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      expect(
        SyncService.checkOwnership(prefs, 'user-a'),
        LocalDataOwner.none,
      );
    });

    test('returns sameUser when owner matches', () async {
      SharedPreferences.setMockInitialValues({
        'kadence.last_synced_user_id': 'user-a',
      });
      final prefs = await SharedPreferences.getInstance();

      expect(
        SyncService.checkOwnership(prefs, 'user-a'),
        LocalDataOwner.sameUser,
      );
    });

    test('returns differentUser when owner differs', () async {
      SharedPreferences.setMockInitialValues({
        'kadence.last_synced_user_id': 'user-a',
      });
      final prefs = await SharedPreferences.getInstance();

      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.differentUser,
      );
    });
  });

  group('setOwner / clearOwner', () {
    test('setOwner persists and clearOwner removes', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await SyncService.setOwner(prefs, 'user-a');
      expect(
        SyncService.checkOwnership(prefs, 'user-a'),
        LocalDataOwner.sameUser,
      );

      await SyncService.clearOwner(prefs);
      expect(
        SyncService.checkOwnership(prefs, 'user-a'),
        LocalDataOwner.none,
      );
    });

    test('clearOwner makes any user return none', () async {
      SharedPreferences.setMockInitialValues({
        'kadence.last_synced_user_id': 'user-a',
      });
      final prefs = await SharedPreferences.getInstance();

      await SyncService.clearOwner(prefs);
      expect(
        SyncService.checkOwnership(prefs, 'user-a'),
        LocalDataOwner.none,
      );
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.none,
      );
    });
  });

  // ── pending deletes ─────────────────────────────────────────────────

  group('pending deletes', () {
    test('add and retrieve pending deletes', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await SyncService.addPendingDelete(prefs, 'id-1');
      await SyncService.addPendingDelete(prefs, 'id-2');

      expect(SyncService.getPendingDeletes(prefs), ['id-1', 'id-2']);
    });

    test('duplicate IDs are not added twice', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await SyncService.addPendingDelete(prefs, 'id-1');
      await SyncService.addPendingDelete(prefs, 'id-1');

      expect(SyncService.getPendingDeletes(prefs), ['id-1']);
    });

    test('clearPendingDeletes empties the list', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await SyncService.addPendingDelete(prefs, 'id-1');
      await SyncService.clearPendingDeletes(prefs);

      expect(SyncService.getPendingDeletes(prefs), isEmpty);
    });

    test('getPendingDeletes returns empty when nothing queued', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      expect(SyncService.getPendingDeletes(prefs), isEmpty);
    });
  });

  // ── toCloud / fromCloudRow round-trip ───────────────────────────────

  group('toCloud / fromCloudRow', () {
    test('round-trips a full activity', () {
      final a = _activity(
        id: 'act-1',
        date: DateTime(2026, 5, 21),
        status: DayStatus.done,
        name: 'Morning Run',
        type: ActivityType.run,
        duration: '45 min',
        timeOfDay: '07:30',
        notes: 'Felt great',
        calendarEventId: '{"cal1":"evt1"}',
      );

      final row = SyncService.toCloud(a, 'user-x');

      expect(row['id'], 'act-1');
      expect(row['user_id'], 'user-x');
      expect(row['date'], '2026-05-21');
      expect(row['status'], 'done');
      expect(row['name'], 'Morning Run');
      expect(row['type'], 'run');
      expect(row['duration'], '45 min');
      expect(row['time_of_day'], '07:30');
      expect(row['notes'], 'Felt great');
      expect(row['calendar_event_id'], '{"cal1":"evt1"}');

      final restored = SyncService.fromCloudRow(row);
      expect(restored.id, a.id);
      expect(restored.date, a.date);
      expect(restored.status, a.status);
      expect(restored.name, a.name);
      expect(restored.type, a.type);
      expect(restored.duration, a.duration);
      expect(restored.timeOfDay, a.timeOfDay);
      expect(restored.notes, a.notes);
      expect(restored.calendarEventId, a.calendarEventId);
    });

    test('round-trips activity with null optional fields', () {
      final a = _activity(
        id: 'act-2',
        date: DateTime(2026, 3, 1),
        status: DayStatus.planned,
      );

      final row = SyncService.toCloud(a, 'user-y');
      expect(row['type'], isNull);
      expect(row['duration'], isNull);
      expect(row['time_of_day'], isNull);
      expect(row['notes'], isNull);
      expect(row['calendar_event_id'], isNull);

      final restored = SyncService.fromCloudRow(row);
      expect(restored.type, isNull);
      expect(restored.duration, isNull);
      expect(restored.timeOfDay, isNull);
      expect(restored.notes, isNull);
      expect(restored.calendarEventId, isNull);
    });

    test('toCloud always stamps the given userId', () {
      final a = _activity(id: 'x', date: DateTime(2026, 1, 1));

      final rowA = SyncService.toCloud(a, 'user-a');
      final rowB = SyncService.toCloud(a, 'user-b');

      expect(rowA['user_id'], 'user-a');
      expect(rowB['user_id'], 'user-b');
      expect(rowA['id'], rowB['id']);
    });
  });

  // ── cloudToMap ──────────────────────────────────────────────────────

  group('cloudToMap', () {
    test('groups cloud rows by date', () {
      final rows = [
        _cloudRow(id: '1', date: '2026-05-21', name: 'Run'),
        _cloudRow(id: '2', date: '2026-05-21', name: 'Swim'),
        _cloudRow(id: '3', date: '2026-05-22', name: 'Yoga'),
      ];

      final map = SyncService.cloudToMap(rows);

      expect(map.keys, containsAll(['2026-05-21', '2026-05-22']));
      expect(map['2026-05-21']!.length, 2);
      expect(map['2026-05-22']!.length, 1);
    });

    test('returns empty map for empty rows', () {
      expect(SyncService.cloudToMap([]), isEmpty);
    });
  });

  // ── mergeLastWriteWins ──────────────────────────────────────────────

  group('mergeLastWriteWins', () {
    test('local-only activities are kept', () {
      final local = _grouped([
        _activity(id: 'loc-1', date: DateTime(2026, 5, 20), name: 'Run'),
        _activity(id: 'loc-2', date: DateTime(2026, 5, 21), name: 'Swim'),
      ]);

      final merged = SyncService.mergeLastWriteWins(local, [], 'user-a');

      final all = merged.values.expand((l) => l).toList();
      expect(all.length, 2);
      expect(all.map((a) => a.id).toSet(), {'loc-1', 'loc-2'});
    });

    test('cloud-only activities are added', () {
      final cloudRows = [
        _cloudRow(id: 'cld-1', date: '2026-05-20', name: 'Hike'),
        _cloudRow(id: 'cld-2', date: '2026-05-21', name: 'Gym'),
      ];

      final merged = SyncService.mergeLastWriteWins({}, cloudRows, 'user-a');

      final all = merged.values.expand((l) => l).toList();
      expect(all.length, 2);
      expect(all.map((a) => a.id).toSet(), {'cld-1', 'cld-2'});
    });

    test('cloud wins when both local and cloud have same ID', () {
      final local = _grouped([
        _activity(
          id: 'shared-1',
          date: DateTime(2026, 5, 20),
          name: 'Local Name',
          status: DayStatus.planned,
        ),
      ]);
      final cloudRows = [
        _cloudRow(
          id: 'shared-1',
          date: '2026-05-20',
          name: 'Cloud Name',
          status: 'done',
        ),
      ];

      final merged =
          SyncService.mergeLastWriteWins(local, cloudRows, 'user-a');

      final all = merged.values.expand((l) => l).toList();
      expect(all.length, 1);
      expect(all.first.name, 'Cloud Name');
      expect(all.first.status, DayStatus.done);
    });

    test('merge with mixed local-only, cloud-only, and shared', () {
      final local = _grouped([
        _activity(id: 'loc-1', date: DateTime(2026, 5, 20), name: 'Local A'),
        _activity(
            id: 'shared-1', date: DateTime(2026, 5, 21), name: 'Old Name'),
      ]);
      final cloudRows = [
        _cloudRow(id: 'shared-1', date: '2026-05-21', name: 'New Name'),
        _cloudRow(id: 'cld-1', date: '2026-05-22', name: 'Cloud Only'),
      ];

      final merged =
          SyncService.mergeLastWriteWins(local, cloudRows, 'user-a');

      final all = merged.values.expand((l) => l).toList();
      expect(all.length, 3);

      final byId = {for (final a in all) a.id: a};
      expect(byId['loc-1']!.name, 'Local A');
      expect(byId['shared-1']!.name, 'New Name');
      expect(byId['cld-1']!.name, 'Cloud Only');
    });

    test('empty local and empty cloud returns empty', () {
      final merged = SyncService.mergeLastWriteWins({}, [], 'user-a');
      expect(merged, isEmpty);
    });

    test('cloud row with changed date regroups under new key', () {
      final local = _grouped([
        _activity(
            id: 'moved-1', date: DateTime(2026, 5, 20), name: 'Original'),
      ]);
      final cloudRows = [
        _cloudRow(id: 'moved-1', date: '2026-05-22', name: 'Moved'),
      ];

      final merged =
          SyncService.mergeLastWriteWins(local, cloudRows, 'user-a');

      expect(merged.containsKey('2026-05-20'), isFalse);
      expect(merged['2026-05-22']!.first.name, 'Moved');
    });
  });

  // ── ownership + import interaction ──────────────────────────────────

  group('import ownership scenarios', () {
    test('import while signed out clears owner tag', () async {
      SharedPreferences.setMockInitialValues({
        'kadence.last_synced_user_id': 'user-a',
      });
      final prefs = await SharedPreferences.getInstance();

      // Simulate import while signed out: clear owner
      await SyncService.clearOwner(prefs);

      // Next sign-in as any user should see "none" (not differentUser)
      expect(
        SyncService.checkOwnership(prefs, 'user-a'),
        LocalDataOwner.none,
      );
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.none,
      );
    });

    test('import while signed out then sign-in as different user pushes data',
        () async {
      SharedPreferences.setMockInitialValues({
        'kadence.last_synced_user_id': 'user-a',
      });
      final prefs = await SharedPreferences.getInstance();

      // Before clearing: signing in as B would discard local data
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.differentUser,
      );

      // Import clears owner
      await SyncService.clearOwner(prefs);

      // Now signing in as B sees "none" → will push local data
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.none,
      );
    });

    test('import while signed in then sign-out preserves owner', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Simulate: signed in as B, import runs replaceAllCloud (cloud is
      // replaced), owner is set to B by the sync layer.
      await SyncService.setOwner(prefs, 'user-b');

      // Sign out doesn't change ownership
      // (AuthController only clears userId, not the prefs tag)
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.sameUser,
      );
    });
  });

  // ── full scenario: the reported bug ─────────────────────────────────

  group('reported bug scenario', () {
    // Reproduce the exact user-reported flow step by step,
    // testing only the ownership and merge logic (no Supabase).

    test('export from A, import into B, sign-out/in cycle', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // ── Step 1: User A has 17 activities, exports, signs out ──
      await SyncService.setOwner(prefs, 'user-a');
      // After sign-out, owner stays user-a

      // ── Step 2: Sign into B ──
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.differentUser,
      );
      // differentUser → local is wiped, cloud (B) is pulled.
      // Simulate: B has 0 activities in cloud. Owner set to B.
      await SyncService.setOwner(prefs, 'user-b');

      // ── Step 3: Log 3 activities in B (local + cloud) ──
      // B creates b-1, b-2, b-3 locally and pushes to cloud.
      // (We don't need the actual map here — just tracking state.)

      // ── Step 4: Import 17 activities (from A's export) into B ──
      // With the fix: replaceAllCloud is called (cloud replaced),
      // and owner stays user-b (signed in).
      // Local now has the 17 imported activities.

      // ── Step 5: Sign out from B ──
      // Owner stays user-b.
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.sameUser,
      );

      // ── Step 6: Sign into A ──
      expect(
        SyncService.checkOwnership(prefs, 'user-a'),
        LocalDataOwner.differentUser,
      );
      // differentUser → local wiped, A's cloud pulled.
      await SyncService.setOwner(prefs, 'user-a');

      // ── Step 7: Sign out from A ──
      // Owner stays user-a.

      // ── Step 8: Sign into B ──
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.differentUser,
      );
      // differentUser → local wiped, B's cloud pulled.
      // With the fix: B's cloud has the 17 imported activities
      // (not the old 3), because replaceAllCloud deleted B's
      // stale rows at step 4.
      await SyncService.setOwner(prefs, 'user-b');

      // Simulate: B's cloud now has the 17 imported activities.
      // Merge with empty local → just the cloud data.
      final importedActivities = List.generate(
        17,
        (i) => _activity(
          id: 'a-$i',
          date: DateTime(2026, 5, 1 + (i % 28)),
          name: 'Imported $i',
        ),
      );
      final importedCloudRows = importedActivities
          .map((a) => SyncService.toCloud(a, 'user-b'))
          .toList();
      final merged = SyncService.mergeLastWriteWins(
        {}, // local is empty after differentUser wipe
        importedCloudRows,
        'user-b',
      );

      final allMerged = merged.values.expand((l) => l).toList();
      expect(allMerged.length, 17);
      // B's old 3 are NOT in the result
      expect(allMerged.any((a) => a.id.startsWith('b-')), isFalse);
    });

    test('import while signed out preserves data on next sign-in', () async {
      SharedPreferences.setMockInitialValues({
        'kadence.last_synced_user_id': 'user-a',
      });
      final prefs = await SharedPreferences.getInstance();

      // Import while signed out → clearOwner
      await SyncService.clearOwner(prefs);

      // Sign into B → none → pushes local to cloud
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.none,
      );

      // Simulate: local has the imported data, push to B's cloud,
      // merge local + cloud. Both should survive.
      final imported = _grouped([
        _activity(id: 'imp-1', date: DateTime(2026, 5, 20), name: 'Imported'),
      ]);
      final cloudAfterPush = [
        _cloudRow(
            id: 'imp-1',
            date: '2026-05-20',
            name: 'Imported',
            userId: 'user-b'),
      ];
      final merged = SyncService.mergeLastWriteWins(
        imported,
        cloudAfterPush,
        'user-b',
      );

      final all = merged.values.expand((l) => l).toList();
      expect(all.length, 1);
      expect(all.first.id, 'imp-1');
    });

    test(
        'without fix: import while signed out then sign-in as different user loses data',
        () async {
      // This test documents the OLD behavior (before the fix).
      // Without clearOwner after import, the tag stays as user-a,
      // and signing in as user-b triggers differentUser → data lost.
      SharedPreferences.setMockInitialValues({
        'kadence.last_synced_user_id': 'user-a',
      });
      final prefs = await SharedPreferences.getInstance();

      // OLD behavior: import does NOT clear owner.
      // Sign in as B → differentUser → local wiped.
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.differentUser,
      );

      // NEW behavior: import clears owner.
      await SyncService.clearOwner(prefs);
      expect(
        SyncService.checkOwnership(prefs, 'user-b'),
        LocalDataOwner.none, // none → push instead of wipe
      );
    });
  });

  // ── backup service parse + group ────────────────────────────────────

  group('backup round-trip via toCloud', () {
    test('exported activities have no user_id in the model', () {
      final a = _activity(
        id: 'act-1',
        date: DateTime(2026, 5, 21),
        name: 'Run',
      );

      // The Activity model has no userId field.
      // toCloud adds it from the parameter.
      final rowA = SyncService.toCloud(a, 'user-a');
      final rowB = SyncService.toCloud(a, 'user-b');

      expect(rowA['user_id'], 'user-a');
      expect(rowB['user_id'], 'user-b');
      // Same activity, different user_id depending on who imports.
    });
  });

  // ── edge cases ──────────────────────────────────────────────────────

  group('edge cases', () {
    test('merge handles multiple activities on the same date', () {
      final local = _grouped([
        _activity(id: 'a', date: DateTime(2026, 5, 20), name: 'Morning'),
        _activity(id: 'b', date: DateTime(2026, 5, 20), name: 'Evening'),
      ]);
      final cloudRows = [
        _cloudRow(id: 'c', date: '2026-05-20', name: 'Cloud Session'),
      ];

      final merged =
          SyncService.mergeLastWriteWins(local, cloudRows, 'user-a');

      final dayActivities = merged['2026-05-20']!;
      expect(dayActivities.length, 3);
      expect(
        dayActivities.map((a) => a.id).toSet(),
        {'a', 'b', 'c'},
      );
    });

    test('merge with all IDs overlapping returns cloud versions', () {
      final local = _grouped([
        _activity(id: 'x', date: DateTime(2026, 5, 20), name: 'Old'),
        _activity(id: 'y', date: DateTime(2026, 5, 21), name: 'Old 2'),
      ]);
      final cloudRows = [
        _cloudRow(id: 'x', date: '2026-05-20', name: 'New'),
        _cloudRow(id: 'y', date: '2026-05-21', name: 'New 2'),
      ];

      final merged =
          SyncService.mergeLastWriteWins(local, cloudRows, 'user-a');

      final all = merged.values.expand((l) => l).toList();
      expect(all.length, 2);
      expect(all.every((a) => a.name!.startsWith('New')), isTrue);
    });

    test('ownership transitions: none → sameUser → differentUser', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Initially no owner
      expect(
          SyncService.checkOwnership(prefs, 'user-a'), LocalDataOwner.none);

      // Set owner to A
      await SyncService.setOwner(prefs, 'user-a');
      expect(SyncService.checkOwnership(prefs, 'user-a'),
          LocalDataOwner.sameUser);
      expect(SyncService.checkOwnership(prefs, 'user-b'),
          LocalDataOwner.differentUser);

      // Change owner to B
      await SyncService.setOwner(prefs, 'user-b');
      expect(SyncService.checkOwnership(prefs, 'user-a'),
          LocalDataOwner.differentUser);
      expect(SyncService.checkOwnership(prefs, 'user-b'),
          LocalDataOwner.sameUser);

      // Clear owner
      await SyncService.clearOwner(prefs);
      expect(
          SyncService.checkOwnership(prefs, 'user-a'), LocalDataOwner.none);
      expect(
          SyncService.checkOwnership(prefs, 'user-b'), LocalDataOwner.none);
    });

    test('fromCloudRow handles all ActivityType values', () {
      for (final type in ActivityType.values) {
        final row = _cloudRow(
          id: 'type-${type.name}',
          date: '2026-01-01',
          type: type.name,
        );
        final a = SyncService.fromCloudRow(row);
        expect(a.type, type);
      }
    });

    test('fromCloudRow handles all DayStatus values', () {
      for (final status in DayStatus.values) {
        final row = _cloudRow(
          id: 'status-${status.name}',
          date: '2026-01-01',
          status: status.name,
        );
        final a = SyncService.fromCloudRow(row);
        expect(a.status, status);
      }
    });
  });

  // ── reassignIds ─────────────────────────────────────────────────────

  group('reassignIds', () {
    test('generates new unique IDs for all activities', () {
      final original = [
        _activity(id: 'a1', date: DateTime(2026, 5, 20), name: 'Run'),
        _activity(id: 'a2', date: DateTime(2026, 5, 21), name: 'Swim'),
        _activity(id: 'a3', date: DateTime(2026, 5, 22), name: 'Gym'),
      ];

      final reassigned = BackupService.reassignIds(original);

      expect(reassigned.length, 3);
      // None of the new IDs match the originals
      for (final a in reassigned) {
        expect(a.id, isNot('a1'));
        expect(a.id, isNot('a2'));
        expect(a.id, isNot('a3'));
      }
    });

    test('preserves all activity data except id and calendarEventId', () {
      final original = [
        _activity(
          id: 'a1',
          date: DateTime(2026, 5, 20),
          status: DayStatus.done,
          name: 'Morning Run',
          type: ActivityType.run,
          duration: '45 min',
          timeOfDay: '07:30',
          notes: 'Felt great',
          calendarEventId: '{"cal1":"evt1"}',
        ),
      ];

      final reassigned = BackupService.reassignIds(original);

      expect(reassigned.first.date, original.first.date);
      expect(reassigned.first.status, original.first.status);
      expect(reassigned.first.name, original.first.name);
      expect(reassigned.first.type, original.first.type);
      expect(reassigned.first.duration, original.first.duration);
      expect(reassigned.first.timeOfDay, original.first.timeOfDay);
      expect(reassigned.first.notes, original.first.notes);
      // calendarEventId is NOT preserved (it references the old device's calendar)
      expect(reassigned.first.calendarEventId, isNull);
    });

    test('all generated IDs are unique within the batch', () {
      final original = List.generate(
        50,
        (i) => _activity(id: 'a$i', date: DateTime(2026, 5, 1 + (i % 28))),
      );

      final reassigned = BackupService.reassignIds(original);
      final ids = reassigned.map((a) => a.id).toSet();

      expect(ids.length, 50);
    });

    test('IDs do not use the aNN format to avoid seed collisions', () {
      final original = [
        _activity(id: 'a1', date: DateTime(2026, 5, 20)),
      ];

      final reassigned = BackupService.reassignIds(original);

      // New IDs start with 'i' (import prefix), not 'a'
      expect(reassigned.first.id, startsWith('i'));
    });

    test('two calls produce different ID prefixes', () {
      final original = [
        _activity(id: 'a1', date: DateTime(2026, 5, 20)),
      ];

      final first = BackupService.reassignIds(original);
      final second = BackupService.reassignIds(original);

      expect(first.first.id, isNot(second.first.id));
    });

    test('empty list returns empty', () {
      expect(BackupService.reassignIds([]), isEmpty);
    });
  });

  // ── PK collision scenario ───────────────────────────────────────────

  group('PK collision prevention', () {
    test('imported activities with reassigned IDs do not collide with originals',
        () {
      // A's activities with original IDs
      final aActivities = [
        _activity(id: 'a1', date: DateTime(2026, 5, 20), name: 'A Run'),
        _activity(id: 'a2', date: DateTime(2026, 5, 21), name: 'A Swim'),
      ];
      final aCloudRows = aActivities
          .map((a) => SyncService.toCloud(a, 'user-a'))
          .toList();

      // B imports the same activities but with reassigned IDs
      final imported = BackupService.reassignIds(aActivities);
      final bCloudRows = imported
          .map((a) => SyncService.toCloud(a, 'user-b'))
          .toList();

      // No ID overlap between A's cloud rows and B's cloud rows
      final aIds = aCloudRows.map((r) => r['id'] as String).toSet();
      final bIds = bCloudRows.map((r) => r['id'] as String).toSet();
      expect(aIds.intersection(bIds), isEmpty);
    });

    test(
        'merge after import: reassigned IDs are treated as new, not overwritten by cloud',
        () {
      // B has cloud activities
      final bCloudRows = [
        _cloudRow(id: 'b1', date: '2026-05-20', name: 'B Original'),
      ];

      // B imports and gets reassigned IDs (no overlap with b1)
      final imported = BackupService.reassignIds([
        _activity(id: 'a1', date: DateTime(2026, 5, 20), name: 'Imported'),
      ]);
      final local = _grouped(imported);

      final merged =
          SyncService.mergeLastWriteWins(local, bCloudRows, 'user-b');

      final all = merged.values.expand((l) => l).toList();
      // Both survive: the imported (new ID) and B's original
      expect(all.length, 2);
      expect(all.any((a) => a.name == 'Imported'), isTrue);
      expect(all.any((a) => a.name == 'B Original'), isTrue);
    });
  });
}

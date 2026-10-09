import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/activity.dart';
import '../utils/date_utils.dart';
import 'plan_controller.dart';
import 'strava_type_mapping.dart';

/// One-way Strava → Kadence import.
///
/// Tokens live server-side (Supabase `strava_tokens` table, written by the
/// `strava-auth` edge function and refreshed by `strava-token`), so the
/// client secret never ships in the app. Requires a signed-in user, which
/// in practice means Pro (sign-in is Pro-gated).
///
/// Dedup: activities created from Strava get the id `s<stravaId>`. When a
/// Strava activity instead ticks off an existing planned session, its
/// Strava id is remembered in [_matchedKey] so it's never applied twice.
class StravaService extends ChangeNotifier with WidgetsBindingObserver {
  StravaService({
    required SharedPreferences prefs,
    required PlanController planController,
  })  : _prefs = prefs,
        _plan = planController {
    _lastSync = _prefs.getString(_lastSyncKey);
    WidgetsBinding.instance.addObserver(this);
  }

  static const _ownerKey = 'kadence.strava_user_id';
  static const _lastSyncKey = 'kadence.strava_last_sync';
  static const _matchedKey = 'kadence.strava_matched_ids';
  static const _stateKey = 'kadence.strava_oauth_state';

  static const _clientId = String.fromEnvironment('STRAVA_CLIENT_ID');
  static const _redirectUri = 'io.supabase.kadence://strava-callback/';

  /// Re-scan this far back on incremental syncs to catch late uploads.
  static const _overlap = Duration(days: 30);

  /// Minimum gap between automatic syncs (on startup / resume).
  static const _autoInterval = Duration(minutes: 15);

  final SharedPreferences _prefs;
  final PlanController _plan;

  String? _lastSync;
  bool _importing = false;
  StravaImportResult? _lastResult;

  SupabaseClient get _client => Supabase.instance.client;
  String? get _userId => _client.auth.currentUser?.id;

  /// Connected = the signed-in user has linked Strava on this device.
  bool get isConnected =>
      _userId != null && _prefs.getString(_ownerKey) == _userId;
  DateTime? get lastSync =>
      _lastSync == null ? null : DateTime.tryParse(_lastSync!);
  bool get isImporting => _importing;
  StravaImportResult? get lastResult => _lastResult;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) autoSync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ── OAuth flow ──────────────────────────────────────────────────────────

  Future<void> startAuth() async {
    final state = _randomState();
    await _prefs.setString(_stateKey, state);
    // The mobile endpoint hands off to the Strava app when installed.
    final url = Uri.https('www.strava.com', '/oauth/mobile/authorize', {
      'client_id': _clientId,
      'redirect_uri': _redirectUri,
      'response_type': 'code',
      'approval_prompt': 'auto',
      'scope': 'activity:read_all',
      'state': state,
    });
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  /// Handles `io.supabase.kadence://strava-callback/?code=…&scope=…`.
  /// On success, kicks off a full history import.
  Future<void> handleCallback(Uri uri) async {
    final params = uri.queryParameters;
    final expectedState = _prefs.getString(_stateKey);
    await _prefs.remove(_stateKey);

    if (params['error'] != null) {
      return _fail(StravaError.denied);
    }
    final code = params['code'];
    if (code == null || params['state'] != expectedState) {
      return _fail(StravaError.failed);
    }
    if (!(params['scope'] ?? '').contains('activity:read')) {
      return _fail(StravaError.scope);
    }
    if (_userId == null) return _fail(StravaError.notSignedIn);

    try {
      await _client.functions.invoke('strava-auth', body: {'code': code});
      await _prefs.setString(_ownerKey, _userId!);
      notifyListeners();
    } catch (e) {
      debugPrint('Strava auth failed: $e');
      return _fail(StravaError.failed);
    }
    await sync(full: true);
  }

  Future<void> disconnect() async {
    try {
      // Revoke on Strava's side too, then drop our stored tokens.
      final token = await _accessToken();
      if (token != null) {
        final req = await HttpClient().postUrl(
          Uri.https('www.strava.com', '/oauth/deauthorize'),
        );
        req.headers.set('Authorization', 'Bearer $token');
        await (await req.close()).drain<void>();
      }
      if (_userId != null) {
        await _client.from('strava_tokens').delete().eq('user_id', _userId!);
      }
    } catch (e) {
      debugPrint('Strava disconnect: $e');
    }
    _lastSync = null;
    _lastResult = null;
    await _prefs.remove(_ownerKey);
    await _prefs.remove(_lastSyncKey);
    notifyListeners();
  }

  // ── Sync ────────────────────────────────────────────────────────────────

  /// Incremental sync when connected and the last one is stale. Called on
  /// startup and app resume; failures are silent.
  Future<void> autoSync() async {
    if (!isConnected || _importing) return;
    final last = lastSync;
    if (last != null && DateTime.now().difference(last) < _autoInterval) {
      return;
    }
    await sync();
  }

  /// Fetches Strava activities and merges them additively — never deletes.
  /// [full] re-scans the whole history; otherwise only since last sync.
  Future<StravaImportResult> sync({bool full = false}) async {
    if (_importing) return const StravaImportResult();
    _importing = true;
    notifyListeners();

    try {
      final token = await _accessToken();
      if (token == null) {
        return _lastResult = const StravaImportResult(
          error: StravaError.failed,
        );
      }
      final last = lastSync;
      final after = full || last == null ? null : last.subtract(_overlap);
      final raw = await _fetchAll(token, after: after);
      final result = await _merge(raw);

      _lastSync = DateTime.now().toIso8601String();
      await _prefs.setString(_lastSyncKey, _lastSync!);
      return _lastResult = result;
    } on _RateLimited {
      return _lastResult = const StravaImportResult(
        error: StravaError.rateLimited,
      );
    } catch (e) {
      debugPrint('Strava sync failed: $e');
      return _lastResult = const StravaImportResult(error: StravaError.failed);
    } finally {
      _importing = false;
      notifyListeners();
    }
  }

  Future<String?> _accessToken() async {
    try {
      final res = await _client.functions.invoke('strava-token');
      return (res.data as Map<String, dynamic>)['access_token'] as String?;
    } catch (e) {
      debugPrint('Strava token fetch failed: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAll(
    String token, {
    DateTime? after,
  }) async {
    final all = <Map<String, dynamic>>[];
    const perPage = 200;
    for (var page = 1;; page++) {
      final uri = Uri.https('www.strava.com', '/api/v3/athlete/activities', {
        'page': '$page',
        'per_page': '$perPage',
        if (after != null) 'after': '${after.millisecondsSinceEpoch ~/ 1000}',
      });
      final list = jsonDecode(await _get(uri, token)) as List;
      all.addAll(list.cast<Map<String, dynamic>>());
      if (list.length < perPage) break;
    }
    return all;
  }

  Future<String> _get(Uri uri, String token) async {
    final req = await HttpClient().getUrl(uri);
    req.headers.set('Authorization', 'Bearer $token');
    final res = await req.close();
    final body = await res.transform(utf8.decoder).join();
    if (res.statusCode == 429) throw _RateLimited();
    if (res.statusCode != 200) {
      throw HttpException('Strava ${res.statusCode}: $body', uri: uri);
    }
    return body;
  }

  /// Turns raw Strava activities into Kadence changes:
  /// 1. Already imported (by id) → skip.
  /// 2. A planned, not-done session of the same type that day → mark done.
  /// 3. Otherwise → add a new done activity.
  Future<StravaImportResult> _merge(List<Map<String, dynamic>> raw) async {
    final matched = (_prefs.getStringList(_matchedKey) ?? const []).toSet();
    final added = <Activity>[];
    final markDone = <String>{};
    var skipped = 0;

    // Oldest first so same-day matches pair up in chronological order.
    raw.sort((a, b) => '${a['start_date']}'.compareTo('${b['start_date']}'));

    for (final sa in raw) {
      final stravaId = '${sa['id']}';
      final localId = 's$stravaId';
      final start = _parseLocal(sa['start_date_local'] as String?);
      if (start == null ||
          matched.contains(stravaId) ||
          _plan.containsId(localId)) {
        skipped++;
        continue;
      }

      final date = KDate.startOfDay(start);
      final mapped = mapStravaSport(
        (sa['sport_type'] ?? sa['type'] ?? '') as String,
      );

      final planned = _plan.activitiesFor(date).where((a) =>
          a.status != DayStatus.done &&
          !markDone.contains(a.id) &&
          a.type == mapped.type &&
          (mapped.subType == null || a.subType == mapped.subType));
      if (planned.isNotEmpty) {
        markDone.add(planned.first.id);
        matched.add(stravaId);
        continue;
      }

      final seconds = (sa['moving_time'] as num?)?.toInt();
      final name = (sa['name'] as String?)?.trim();
      added.add(Activity(
        id: localId,
        date: date,
        status: DayStatus.done,
        name: name == null || name.isEmpty ? mapped.label : name,
        type: mapped.type,
        subType: mapped.subType,
        timeOfDay: '${_two(start.hour)}:${_two(start.minute)}',
        duration: seconds == null || seconds < 60
            ? null
            : '${(seconds / 60).round()} min',
      ));
    }

    _plan.mergeExternal(added: added, markDoneIds: markDone);
    await _prefs.setStringList(_matchedKey, matched.toList());
    return StravaImportResult(
      added: added.length,
      matched: markDone.length,
      skipped: skipped,
    );
  }

  /// `start_date_local` is wall-clock time with a misleading `Z` suffix;
  /// parse the components as-is so the date/time match what the athlete saw.
  static DateTime? _parseLocal(String? iso) {
    if (iso == null) return null;
    final dt = DateTime.tryParse(iso);
    if (dt == null) return null;
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _randomState() {
    final r = Random.secure();
    return List.generate(16, (_) => r.nextInt(16).toRadixString(16)).join();
  }

  void _fail(StravaError error) {
    _lastResult = StravaImportResult(error: error);
    notifyListeners();
  }
}

class _RateLimited implements Exception {}

enum StravaError { denied, scope, notSignedIn, rateLimited, failed }

class StravaImportResult {
  const StravaImportResult({
    this.added = 0,
    this.matched = 0,
    this.skipped = 0,
    this.error,
  });

  /// New done activities created from Strava.
  final int added;

  /// Existing planned sessions marked done.
  final int matched;

  /// Already imported (or unparseable) — left alone.
  final int skipped;
  final StravaError? error;

  bool get hasError => error != null;
}

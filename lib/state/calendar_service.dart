import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/activity.dart';
import '../utils/date_utils.dart';

const _kCalendarIdKey = 'kadence.calendar.id';
const _kCalendarSyncKey = 'kadence.calendar.sync';

class CalendarService {
  CalendarService._();

  static final _plugin = DeviceCalendarPlugin();
  static SharedPreferences? _prefs;

  static bool get _isSupported => !kIsWeb;

  static Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
  }

  // ── preferences ──────────────────────────────────────────────────────

  static bool get syncEnabled =>
      _prefs?.getBool(_kCalendarSyncKey) ?? false;

  static Future<void> setSyncEnabled(bool value) async {
    await _prefs?.setBool(_kCalendarSyncKey, value);
  }

  /// null means "all writable calendars" (the default).
  static String? get selectedCalendarId =>
      _prefs?.getString(_kCalendarIdKey);

  static Future<void> setSelectedCalendarId(String? id) async {
    if (id == null) {
      await _prefs?.remove(_kCalendarIdKey);
    } else {
      await _prefs?.setString(_kCalendarIdKey, id);
    }
  }

  // ── permissions ──────────────────────────────────────────────────────

  static Future<bool> hasPermission() async {
    if (!_isSupported) return false;
    final result = await _plugin.hasPermissions();
    return result.data ?? false;
  }

  static Future<bool> requestPermission() async {
    if (!_isSupported) return false;
    final result = await _plugin.requestPermissions();
    return result.data ?? false;
  }

  // ── calendars ────────────────────────────────────────────────────────

  static Future<List<Calendar>> getWritableCalendars() async {
    if (!_isSupported) return const [];
    final result = await _plugin.retrieveCalendars();
    if (!result.isSuccess || result.data == null) return const [];
    return result.data!
        .where((c) => !(c.isReadOnly ?? true))
        .toList();
  }

  static Future<List<String>> _targetCalendarIds() async {
    final picked = selectedCalendarId;
    if (picked != null) return [picked];
    final calendars = await getWritableCalendars();
    return calendars.map((c) => c.id!).where((id) => id.isNotEmpty).toList();
  }

  // ── event CRUD ───────────────────────────────────────────────────────

  /// Creates events in target calendars. Returns a JSON-encoded map of
  /// {calendarId: eventId} to store on the Activity.
  static Future<String?> createEvent(Activity activity) async {
    if (!_isSupported || !syncEnabled) return null;
    final calIds = await _targetCalendarIds();
    if (calIds.isEmpty) return null;

    final map = <String, String>{};
    for (final calId in calIds) {
      final event = _buildEvent(calId, activity);
      final result = await _plugin.createOrUpdateEvent(event);
      if (result?.isSuccess == true && result!.data != null) {
        map[calId] = result.data!;
      }
    }
    return map.isEmpty ? null : jsonEncode(map);
  }

  static Future<void> updateEvent(Activity activity) async {
    if (!_isSupported || !syncEnabled) return;
    if (activity.calendarEventId == null) return;

    final existing = _parseEventIds(activity.calendarEventId!);
    for (final entry in existing.entries) {
      final event = _buildEvent(entry.key, activity)
        ..eventId = entry.value;
      await _plugin.createOrUpdateEvent(event);
    }
  }

  static Future<void> deleteEvent(Activity activity) async {
    if (!_isSupported || !syncEnabled) return;
    if (activity.calendarEventId == null) return;

    final existing = _parseEventIds(activity.calendarEventId!);
    for (final entry in existing.entries) {
      await _plugin.deleteEvent(entry.key, entry.value);
    }
  }

  // ── helpers ──────────────────────────────────────────────────────────

  static Map<String, String> _parseEventIds(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    } catch (_) {}
    return {};
  }

  static Event _buildEvent(String calendarId, Activity activity) {
    final date = KDate.startOfDay(activity.date);
    final location = tz.getLocation('UTC');
    final start = tz.TZDateTime(
      location,
      date.year,
      date.month,
      date.day,
      8,
    );

    final durationMin = _parseDurationMinutes(activity.duration);
    final end = start.add(Duration(minutes: durationMin));

    final description = <String>[
      if (activity.intensity != null) 'Intensity: ${activity.intensity}',
      if (activity.notes != null) activity.notes!,
    ].join('\n');

    return Event(
      calendarId,
      title: activity.name ?? 'Session',
      start: start,
      end: end,
      description: description.isEmpty ? null : description,
    );
  }

  static int _parseDurationMinutes(String? raw) {
    if (raw == null || raw.isEmpty) return 60;
    final digits = RegExp(r'\d+').firstMatch(raw)?.group(0);
    if (digits == null) return 60;
    final n = int.tryParse(digits);
    return (n != null && n > 0) ? n : 60;
  }
}

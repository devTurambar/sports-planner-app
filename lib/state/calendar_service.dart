import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/activity.dart';
import '../theme/kadence_colors.dart';
import '../utils/date_utils.dart';

const _kCalendarIdsKey = 'kadence.calendar.ids';
const _kCalendarSyncKey = 'kadence.calendar.sync';

class CalendarService {
  CalendarService._();

  static final _plugin = DeviceCalendarPlugin();
  static SharedPreferences? _prefs;

  static const _channel = MethodChannel('com.kadencesports.app/calendar_color');

  static bool get _isSupported => !kIsWeb;
  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static const _paletteTints = [
    0xFFFF7A45, // Coral
    0xFF3B82F6, // Blue
    0xFFF43F5E, // Rose
    0xFFB16CF4, // Purple
    0xFF22B8D9, // Teal
    0xFF34C77B, // Green
    0xFFF0B43A, // Amber
  ];

  static Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
  }

  // ── preferences ──────────────────────────────────────────────────────

  static bool get syncEnabled =>
      _prefs?.getBool(_kCalendarSyncKey) ?? false;

  static Future<void> setSyncEnabled(bool value) async {
    await _prefs?.setBool(_kCalendarSyncKey, value);
  }

  /// Empty set means "all writable calendars" (the default).
  static Set<String> get selectedCalendarIds {
    final raw = _prefs?.getStringList(_kCalendarIdsKey);
    if (raw == null || raw.isEmpty) return const {};
    return raw.toSet();
  }

  static Future<void> setSelectedCalendarIds(Set<String> ids) async {
    if (ids.isEmpty) {
      await _prefs?.remove(_kCalendarIdsKey);
    } else {
      await _prefs?.setStringList(_kCalendarIdsKey, ids.toList());
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
    final picked = selectedCalendarIds;
    if (picked.isNotEmpty) return picked.toList();
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
        _setEventColor(result.data!, activity.type);
      }
    }
    return map.isEmpty ? null : jsonEncode(map);
  }

  /// Updates existing calendar events, or creates them if none exist yet.
  /// Returns a new calendarEventId when events were created (null otherwise).
  static Future<String?> updateEvent(Activity activity) async {
    if (!_isSupported || !syncEnabled) return null;

    if (activity.calendarEventId == null) {
      return createEvent(activity);
    }

    final existing = _parseEventIds(activity.calendarEventId!);
    for (final entry in existing.entries) {
      final event = _buildEvent(entry.key, activity)
        ..eventId = entry.value;
      await _plugin.createOrUpdateEvent(event);
      _setEventColor(entry.value, activity.type);
    }
    return null;
  }

  /// Creates calendar events for a batch of imported activities,
  /// skipping any that already have a matching event (same title +
  /// start time on the same day). Returns a map of activity ID →
  /// calendarEventId for activities that got new events.
  static Future<Map<String, String>> syncImportedBatch(
    List<Activity> activities,
  ) async {
    if (!_isSupported || !syncEnabled) return const {};
    final calIds = await _targetCalendarIds();
    if (calIds.isEmpty) return const {};

    final result = <String, String>{};

    for (final activity in activities) {
      final builtEvent = _buildEvent(calIds.first, activity);
      final isDuplicate = await _hasDuplicate(calIds, builtEvent);
      if (isDuplicate) continue;

      final eventId = await createEvent(activity);
      if (eventId != null) {
        result[activity.id] = eventId;
      }
    }

    return result;
  }

  static Future<bool> _hasDuplicate(
    List<String> calendarIds,
    Event reference,
  ) async {
    final start = reference.start!;
    final dayStart = tz.TZDateTime(start.location, start.year, start.month, start.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final params = RetrieveEventsParams(startDate: dayStart, endDate: dayEnd);

    for (final calId in calendarIds) {
      final result = await _plugin.retrieveEvents(calId, params);
      if (result.isSuccess && result.data != null) {
        for (final existing in result.data!) {
          if (existing.title == reference.title &&
              existing.start == reference.start) {
            return true;
          }
        }
      }
    }
    return false;
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
    final startHour = _parseStartHour(activity.timeOfDay);
    final startMinute = _parseStartMinute(activity.timeOfDay);
    final start = tz.TZDateTime(
      location,
      date.year,
      date.month,
      date.day,
      startHour,
      startMinute,
    );

    final durationMin = _parseDurationMinutes(activity.duration);
    final end = start.add(Duration(minutes: durationMin));

    final description = <String>[
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

  static final _timeRe = RegExp(r'(\d{1,2}):(\d{2})');

  static int _parseStartHour(String? raw) {
    if (raw == null) return 8;
    final m = _timeRe.firstMatch(raw);
    if (m == null) return 8;
    var h = int.parse(m.group(1)!);
    if (raw.toLowerCase().contains('pm') && h < 12) h += 12;
    if (raw.toLowerCase().contains('am') && h == 12) h = 0;
    return h.clamp(0, 23);
  }

  static int _parseStartMinute(String? raw) {
    if (raw == null) return 0;
    final m = _timeRe.firstMatch(raw);
    if (m == null) return 0;
    return int.parse(m.group(2)!).clamp(0, 59);
  }

  static int _colorForType(ActivityType? type) {
    if (type == null) return _paletteTints[6];
    final overrides = _prefs?.getStringList('kadence.type_colors');
    if (overrides != null) {
      for (final entry in overrides) {
        final parts = entry.split(':');
        if (parts.length == 2 && parts[0] == type.name) {
          final idx = int.tryParse(parts[1]);
          if (idx != null && idx >= 0 && idx < 7) return _paletteTints[idx];
        }
      }
    }
    return _paletteTints[KadenceColors.defaultIndexFor(type)];
  }

  static Future<void> _setEventColor(String eventId, ActivityType? type) async {
    if (!_isAndroid) return;
    try {
      await _channel.invokeMethod('setEventColor', {
        'eventId': eventId,
        'color': _colorForType(type),
      });
    } catch (_) {}
  }
}

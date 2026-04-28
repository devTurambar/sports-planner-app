import 'package:flutter/foundation.dart';

import '../models/activity.dart';
import '../utils/date_utils.dart';

/// Owns the user's planned sessions, keyed by calendar date.
///
/// In a production build this would load from local storage (or sync). Here
/// it ships with a hand-authored sample plan that mirrors the HTML
/// prototype so the app is explorable immediately after install.
class PlanController extends ChangeNotifier {
  PlanController({DateTime? now})
      : _today = KDate.startOfDay(now ?? DateTime.now()) {
    _seed();
  }

  final DateTime _today;
  final Map<String, Activity> _byDate = <String, Activity>{};
  int _idSeed = 0;

  DateTime get today => _today;

  /// All activities for the week containing [date], Monday first.
  List<Activity> weekFor(DateTime date) {
    final week = KDate.weekFor(date);
    return week.map(_slotFor).toList(growable: false);
  }

  /// Activity for a specific day — an empty placeholder if none exists.
  Activity forDate(DateTime date) => _slotFor(date);

  /// Upsert an activity. Passing an empty [name] deletes the entry.
  void save({
    required DateTime date,
    required String name,
    ActivityType? type,
    String? duration,
    String? intensity,
    String? notes,
  }) {
    final trimmed = name.trim();
    final key = KDate.keyFor(date);
    if (trimmed.isEmpty) {
      _byDate.remove(key);
      notifyListeners();
      return;
    }

    final existing = _byDate[key];
    _byDate[key] = Activity(
      id: existing?.id ?? _nextId(),
      date: KDate.startOfDay(date),
      status: existing?.status == DayStatus.done
          ? DayStatus.done
          : _isToday(date)
              ? DayStatus.today
              : DayStatus.planned,
      name: trimmed,
      type: type,
      duration: duration,
      intensity: intensity,
      notes: notes,
    );
    notifyListeners();
  }

  /// Mark a session complete / un-complete.
  void toggleDone(DateTime date) {
    final key = KDate.keyFor(date);
    final existing = _byDate[key];
    if (existing == null) return;
    _byDate[key] = existing.copyWith(
      status: existing.status == DayStatus.done
          ? (_isToday(date) ? DayStatus.today : DayStatus.planned)
          : DayStatus.done,
    );
    notifyListeners();
  }

  /// Mark the date as a rest day (clears any planned session).
  void markRest(DateTime date) {
    final key = KDate.keyFor(date);
    _byDate[key] = Activity(
      id: _byDate[key]?.id ?? _nextId(),
      date: KDate.startOfDay(date),
      status: DayStatus.rest,
      name: 'Rest',
    );
    notifyListeners();
  }

  /// Remove any planned content for [date].
  void clear(DateTime date) {
    _byDate.remove(KDate.keyFor(date));
    notifyListeners();
  }

  /// Wipes every planned session — used for the empty-state demo.
  void clearAll() {
    _byDate.clear();
    notifyListeners();
  }

  // ── internals ────────────────────────────────────────────────────────────

  Activity _slotFor(DateTime date) {
    final day = KDate.startOfDay(date);
    final existing = _byDate[KDate.keyFor(day)];
    if (existing != null) {
      // Keep `today` marker in sync if the calendar ticks over while the
      // app is open.
      if (existing.status == DayStatus.planned && _isToday(day)) {
        return existing.copyWith(status: DayStatus.today);
      }
      if (existing.status == DayStatus.today && !_isToday(day)) {
        return existing.copyWith(status: DayStatus.planned);
      }
      return existing;
    }
    return Activity(
      id: 'empty-${KDate.keyFor(day)}',
      date: day,
      status: DayStatus.empty,
    );
  }

  bool _isToday(DateTime date) => KDate.isSameDay(date, _today);

  String _nextId() => 'a${++_idSeed}';

  void _seed() {
    // Anchor the sample plan around "today" so the app always shows
    // something meaningful regardless of when it's launched.
    final monday = KDate.mondayOfWeek(_today);
    Activity put(
      int offsetFromMonday, {
      required DayStatus status,
      String? name,
      ActivityType? type,
      String? duration,
      String? intensity,
    }) {
      final date = monday.add(Duration(days: offsetFromMonday));
      final activity = Activity(
        id: _nextId(),
        date: date,
        status: _isToday(date) && status == DayStatus.planned
            ? DayStatus.today
            : status,
        name: name,
        type: type,
        duration: duration,
        intensity: intensity,
      );
      _byDate[KDate.keyFor(date)] = activity;
      return activity;
    }

    put(0,
        status: DayStatus.done,
        name: 'Morning run',
        type: ActivityType.run,
        duration: '45 min',
        intensity: 'Zone 2');
    put(1,
        status: DayStatus.done,
        name: 'Strength training',
        type: ActivityType.gym,
        duration: '60 min',
        intensity: 'Upper body');
    put(2,
        status: DayStatus.planned,
        name: 'Evening yoga',
        type: ActivityType.yoga,
        duration: '30 min',
        intensity: 'Home');
    put(3, status: DayStatus.rest, name: 'Rest');
    put(4,
        status: DayStatus.planned,
        name: 'Long ride',
        type: ActivityType.cycle,
        duration: '90 min',
        intensity: 'Outdoor');
    // Saturday left empty on purpose.
    put(6, status: DayStatus.rest, name: 'Rest');

    // Scatter a handful of sessions across the surrounding month so the
    // month view has some history when the user first opens it.
    final month = _today.month;
    final year = _today.year;
    for (var d = 1; d <= KDate.daysInMonth(year, month); d++) {
      final date = DateTime(year, month, d);
      if (_byDate.containsKey(KDate.keyFor(date))) continue;
      if (date.isAfter(_today)) continue;
      final weekday = date.weekday;
      if (weekday == DateTime.sunday || weekday == DateTime.thursday) {
        _byDate[KDate.keyFor(date)] = Activity(
          id: _nextId(),
          date: date,
          status: DayStatus.rest,
          name: 'Rest',
        );
      } else if (weekday == DateTime.monday || weekday == DateTime.wednesday) {
        _byDate[KDate.keyFor(date)] = Activity(
          id: _nextId(),
          date: date,
          status: DayStatus.done,
          name: weekday == DateTime.monday ? 'Morning run' : 'Strength',
          type: weekday == DateTime.monday
              ? ActivityType.run
              : ActivityType.gym,
          duration: weekday == DateTime.monday ? '45 min' : '60 min',
        );
      }
    }
  }
}

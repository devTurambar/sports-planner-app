import 'package:flutter/foundation.dart';

import '../models/activity.dart';
import '../utils/date_utils.dart';

/// Owns the user's planned sessions, keyed by calendar date. Each date can
/// hold multiple activities; consumers that need a single representative
/// activity (e.g. the week list) read [forDate].
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
  final Map<String, List<Activity>> _byDate = <String, List<Activity>>{};
  int _idSeed = 0;

  DateTime get today => _today;

  /// All activities for the week containing [date], Monday first. Returns
  /// the *primary* activity for each day (see [forDate]).
  List<Activity> weekFor(DateTime date) {
    final week = KDate.weekFor(date);
    return week.map(_primaryFor).toList(growable: false);
  }

  /// Primary activity for a specific day. Empty placeholder if the day has
  /// no entries.
  Activity forDate(DateTime date) => _primaryFor(date);

  /// Every activity stored for [date], in insertion order. Empty if none.
  List<Activity> activitiesFor(DateTime date) {
    final list = _byDate[KDate.keyFor(date)];
    if (list == null) return const <Activity>[];
    return list.map((a) => _withSyncedTodayStatus(a)).toList(growable: false);
  }

  /// Number of secondary activities beyond the primary one. Useful for
  /// "+N" badges. Always 0 if the day has 0 or 1 activities.
  int extrasFor(DateTime date) {
    final list = _byDate[KDate.keyFor(date)];
    if (list == null) return 0;
    return list.length <= 1 ? 0 : list.length - 1;
  }

  /// Upsert an activity. When [id] matches an existing entry, the entry is
  /// replaced; otherwise a new activity is appended to the day. Saving any
  /// non-rest activity removes a pre-existing rest marker for that day.
  /// Passing an empty [name] is treated as a no-op for new activities and
  /// as a delete for existing ones.
  void save({
    required DateTime date,
    String? id,
    required String name,
    ActivityType? type,
    String? duration,
    String? intensity,
    String? notes,
  }) {
    final trimmed = name.trim();
    final key = KDate.keyFor(date);
    final list = _byDate.putIfAbsent(key, () => <Activity>[]);

    if (trimmed.isEmpty) {
      if (id != null) {
        list.removeWhere((a) => a.id == id);
        if (list.isEmpty) _byDate.remove(key);
        notifyListeners();
      }
      return;
    }

    if (id != null) {
      final index = list.indexWhere((a) => a.id == id);
      if (index >= 0) {
        final existing = list[index];
        list[index] = existing.copyWith(
          name: trimmed,
          type: type,
          duration: duration,
          intensity: intensity,
          notes: notes,
        );
        notifyListeners();
        return;
      }
    }

    list.add(Activity(
      id: _nextId(),
      date: KDate.startOfDay(date),
      status: _isToday(date) ? DayStatus.today : DayStatus.planned,
      name: trimmed,
      type: type,
      duration: duration,
      intensity: intensity,
      notes: notes,
    ));
    notifyListeners();
  }

  /// Toggle a specific activity's done state. If [id] is null the day's
  /// primary activity is toggled (convenience for the week view).
  void toggleDone(DateTime date, {String? id}) {
    final list = _byDate[KDate.keyFor(date)];
    if (list == null || list.isEmpty) return;

    final targetIndex = id == null
        ? list.indexOf(_pickPrimary(list))
        : list.indexWhere((a) => a.id == id);
    if (targetIndex < 0) return;

    final target = list[targetIndex];
    list[targetIndex] = target.copyWith(
      status: target.status == DayStatus.done
          ? (_isToday(date) ? DayStatus.today : DayStatus.planned)
          : DayStatus.done,
    );
    notifyListeners();
  }

  /// Flip every activity on [date] in lockstep: if all are done, mark
  /// them planned/today; otherwise mark them all done. Used by the week
  /// view's parent check button.
  void toggleAllDone(DateTime date) {
    final list = _byDate[KDate.keyFor(date)];
    if (list == null || list.isEmpty) return;

    final allDone = list.every((a) => a.status == DayStatus.done);
    final fallback = _isToday(date) ? DayStatus.today : DayStatus.planned;
    for (var i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(
        status: allDone ? fallback : DayStatus.done,
      );
    }
    notifyListeners();
  }

  /// Remove every activity stored for [date].
  void clear(DateTime date) {
    if (_byDate.remove(KDate.keyFor(date)) != null) notifyListeners();
  }

  /// Remove a single activity by id.
  void delete({required DateTime date, required String id}) {
    final key = KDate.keyFor(date);
    final list = _byDate[key];
    if (list == null) return;
    final removed = list.length;
    list.removeWhere((a) => a.id == id);
    if (list.isEmpty) {
      _byDate.remove(key);
    }
    if (list.length != removed) notifyListeners();
  }

  /// Wipes every planned session — used for the empty-state demo.
  void clearAll() {
    _byDate.clear();
    notifyListeners();
  }

  // ── internals ────────────────────────────────────────────────────────────

  Activity _primaryFor(DateTime date) {
    final day = KDate.startOfDay(date);
    final list = _byDate[KDate.keyFor(day)];
    if (list == null || list.isEmpty) {
      return Activity(
        id: 'empty-${KDate.keyFor(day)}',
        date: day,
        status: DayStatus.empty,
      );
    }
    return _withSyncedTodayStatus(_pickPrimary(list));
  }

  /// Choose the most representative activity for the day. Priority:
  /// today > planned > done, falling back to insertion order.
  Activity _pickPrimary(List<Activity> list) {
    int rank(Activity a) {
      switch (a.status) {
        case DayStatus.today:
          return 0;
        case DayStatus.planned:
          return 1;
        case DayStatus.done:
          return 2;
        case DayStatus.empty:
          return 3;
      }
    }

    var best = list.first;
    for (final a in list.skip(1)) {
      if (rank(a) < rank(best)) best = a;
    }
    return best;
  }

  /// Keep the [DayStatus.today] marker accurate if the calendar ticks over
  /// while the app is open. Pure read-time projection — does not mutate
  /// stored state.
  Activity _withSyncedTodayStatus(Activity a) {
    if (a.status == DayStatus.planned && _isToday(a.date)) {
      return a.copyWith(status: DayStatus.today);
    }
    if (a.status == DayStatus.today && !_isToday(a.date)) {
      return a.copyWith(status: DayStatus.planned);
    }
    return a;
  }

  bool _isToday(DateTime date) => KDate.isSameDay(date, _today);

  String _nextId() => 'a${++_idSeed}';

  void _seed() {
    final monday = KDate.mondayOfWeek(_today);
    void put(
      int offsetFromMonday, {
      required DayStatus status,
      String? name,
      ActivityType? type,
      String? duration,
      String? intensity,
    }) {
      final date = monday.add(Duration(days: offsetFromMonday));
      final key = KDate.keyFor(date);
      final list = _byDate.putIfAbsent(key, () => <Activity>[]);
      list.add(Activity(
        id: _nextId(),
        date: date,
        status: _isToday(date) && status == DayStatus.planned
            ? DayStatus.today
            : status,
        name: name,
        type: type,
        duration: duration,
        intensity: intensity,
      ));
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
    // Wednesday left empty.
    put(4,
        status: DayStatus.planned,
        name: 'Long ride',
        type: ActivityType.cycle,
        duration: '90 min',
        intensity: 'Outdoor');
    // Saturday + Sunday left empty.

    // Scatter a handful of sessions across the surrounding month so the
    // month view has some history when the user first opens it.
    final month = _today.month;
    final year = _today.year;
    for (var d = 1; d <= KDate.daysInMonth(year, month); d++) {
      final date = DateTime(year, month, d);
      if (_byDate.containsKey(KDate.keyFor(date))) continue;
      if (date.isAfter(_today)) continue;
      final weekday = date.weekday;
      if (weekday == DateTime.monday || weekday == DateTime.wednesday) {
        _byDate[KDate.keyFor(date)] = <Activity>[
          Activity(
            id: _nextId(),
            date: date,
            status: DayStatus.done,
            name: weekday == DateTime.monday ? 'Morning run' : 'Strength',
            type: weekday == DateTime.monday
                ? ActivityType.run
                : ActivityType.gym,
            duration: weekday == DateTime.monday ? '45 min' : '60 min',
          ),
        ];
      }
    }
  }
}

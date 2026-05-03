import 'package:flutter/foundation.dart';

import '../models/activity.dart';
import '../utils/date_utils.dart';
import 'activity_db.dart';
import 'calendar_service.dart';

class PlanController extends ChangeNotifier {
  PlanController._({required DateTime today}) : _today = today;

  static Future<PlanController> create({DateTime? now}) async {
    final today = KDate.startOfDay(now ?? DateTime.now());
    final controller = PlanController._(today: today);
    await controller._loadOrSeed();
    return controller;
  }

  final DateTime _today;
  final Map<String, List<Activity>> _byDate = <String, List<Activity>>{};
  int _idSeed = 0;

  DateTime get today => _today;

  // ── public reads ──────────────────────────────────────────────────────

  List<Activity> weekFor(DateTime date) {
    final week = KDate.weekFor(date);
    return week.map(_primaryFor).toList(growable: false);
  }

  Activity forDate(DateTime date) => _primaryFor(date);

  List<Activity> activitiesFor(DateTime date) {
    final list = _byDate[KDate.keyFor(date)];
    if (list == null) return const <Activity>[];
    return list.map((a) => _withSyncedTodayStatus(a)).toList(growable: false);
  }

  Iterable<Activity> allActivities() sync* {
    for (final list in _byDate.values) {
      for (final a in list) {
        yield _withSyncedTodayStatus(a);
      }
    }
  }

  int extrasFor(DateTime date) {
    final list = _byDate[KDate.keyFor(date)];
    if (list == null) return 0;
    return list.length <= 1 ? 0 : list.length - 1;
  }

  // ── public writes ─────────────────────────────────────────────────────

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
        final removed = list.where((a) => a.id == id).toList();
        list.removeWhere((a) => a.id == id);
        if (list.isEmpty) _byDate.remove(key);
        ActivityDb.deleteById(id);
        for (final a in removed) {
          CalendarService.deleteEvent(a);
        }
        notifyListeners();
      }
      return;
    }

    if (id != null) {
      final index = list.indexWhere((a) => a.id == id);
      if (index >= 0) {
        final updated = list[index].copyWith(
          name: trimmed,
          type: type,
          duration: duration,
          intensity: intensity,
          notes: notes,
        );
        list[index] = updated;
        ActivityDb.upsert(updated);
        CalendarService.updateEvent(updated);
        notifyListeners();
        return;
      }
    }

    final activity = Activity(
      id: _nextId(),
      date: KDate.startOfDay(date),
      status: _isToday(date) ? DayStatus.today : DayStatus.planned,
      name: trimmed,
      type: type,
      duration: duration,
      intensity: intensity,
      notes: notes,
    );
    list.add(activity);
    ActivityDb.upsert(activity);
    _syncNewEvent(activity, key, list.length - 1);
    notifyListeners();
  }

  void _syncNewEvent(Activity activity, String key, int index) {
    CalendarService.createEvent(activity).then((eventId) {
      if (eventId != null) {
        final list = _byDate[key];
        if (list != null && index < list.length && list[index].id == activity.id) {
          final updated = list[index].copyWith(calendarEventId: eventId);
          list[index] = updated;
          ActivityDb.upsert(updated);
        }
      }
    });
  }

  void toggleDone(DateTime date, {String? id}) {
    if (KDate.startOfDay(date).isAfter(_today)) return;
    final list = _byDate[KDate.keyFor(date)];
    if (list == null || list.isEmpty) return;

    final targetIndex = id == null
        ? list.indexOf(_pickPrimary(list))
        : list.indexWhere((a) => a.id == id);
    if (targetIndex < 0) return;

    final target = list[targetIndex];
    final updated = target.copyWith(
      status: target.status == DayStatus.done
          ? (_isToday(date) ? DayStatus.today : DayStatus.planned)
          : DayStatus.done,
    );
    list[targetIndex] = updated;
    ActivityDb.upsert(updated);
    notifyListeners();
  }

  void toggleAllDone(DateTime date) {
    if (KDate.startOfDay(date).isAfter(_today)) return;
    final list = _byDate[KDate.keyFor(date)];
    if (list == null || list.isEmpty) return;

    final allDone = list.every((a) => a.status == DayStatus.done);
    final fallback = _isToday(date) ? DayStatus.today : DayStatus.planned;
    final updated = <Activity>[];
    for (var i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(status: allDone ? fallback : DayStatus.done);
      updated.add(list[i]);
    }
    ActivityDb.upsertAll(updated);
    notifyListeners();
  }

  void clear(DateTime date) {
    final key = KDate.keyFor(date);
    final removed = _byDate.remove(key);
    if (removed != null) {
      for (final a in removed) {
        CalendarService.deleteEvent(a);
      }
      ActivityDb.deleteByDate(key);
      notifyListeners();
    }
  }

  void delete({required DateTime date, required String id}) {
    final key = KDate.keyFor(date);
    final list = _byDate[key];
    if (list == null) return;
    final target = list.where((a) => a.id == id).toList();
    list.removeWhere((a) => a.id == id);
    if (list.isEmpty) {
      _byDate.remove(key);
    }
    if (target.isNotEmpty) {
      ActivityDb.deleteById(id);
      for (final a in target) {
        CalendarService.deleteEvent(a);
      }
      notifyListeners();
    }
  }

  void clearAll() {
    for (final list in _byDate.values) {
      for (final a in list) {
        CalendarService.deleteEvent(a);
      }
    }
    _byDate.clear();
    ActivityDb.deleteAll();
    notifyListeners();
  }

  // ── internals ─────────────────────────────────────────────────────────

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

  Future<void> _loadOrSeed() async {
    final loaded = await ActivityDb.loadAll();
    if (loaded.isNotEmpty) {
      _byDate.addAll(loaded);
      for (final list in _byDate.values) {
        for (final a in list) {
          final n = int.tryParse(a.id.replaceFirst('a', ''));
          if (n != null && n > _idSeed) _idSeed = n;
        }
      }
    }
    notifyListeners();
  }
}

import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../utils/date_utils.dart';

const int kStatsWeekCount = 26;

class DayCell {
  const DayCell({
    this.date,
    this.primaryType,
    this.activities = const <CellActivity>[],
  });

  final DateTime? date;
  final ActivityType? primaryType;
  final List<CellActivity> activities;

  bool get isEmpty => activities.isEmpty;

  int get doneCount =>
      activities.where((a) => a.status == DayStatus.done).length;
  int get plannedCount =>
      activities.where((a) => a.status != DayStatus.done).length;
  bool get hasPlannedOnly => doneCount == 0 && plannedCount > 0;

  ({ActivityType? type, bool dimmed})? renderForFilter(ActivityType? filter) {
    if (isEmpty) return null;
    if (filter == null) {
      return (type: primaryType, dimmed: hasPlannedOnly);
    }
    final matches = activities.where((a) => a.type == filter).toList();
    if (matches.isEmpty) return null;
    final done = matches.where((a) => a.status == DayStatus.done).length;
    return (type: filter, dimmed: done == 0);
  }
}

class CellActivity {
  const CellActivity({
    required this.type,
    this.subType,
    required this.status,
  });

  final ActivityType? type;
  final String? subType;
  final DayStatus status;
}

class TypeBucket {
  const TypeBucket({required this.type, this.subType, required this.count});

  final ActivityType? type;
  final String? subType;
  final int count;

  String get label {
    if (type == ActivityType.other && subType != null) return subType!;
    return type?.label ?? 'Other';
  }
}

class StatsData {
  const StatsData({
    required this.totalSessions,
    required this.currentStreak,
    required this.avgPerWeek,
    required this.typeCounts,
    required this.dayCells,
    required this.weekStarts,
    required this.allDone,
    required this.allActivities,
  });

  final int totalSessions;
  final int currentStreak;
  final double avgPerWeek;
  final List<TypeBucket> typeCounts;
  final List<DayCell> dayCells;
  final List<DateTime> weekStarts;
  final List<Activity> allDone;
  final List<Activity> allActivities;

  static StatsData compute(PlanController plan, DateTime today,
      [int startDay = DateTime.monday]) {
    final all = plan.allActivities().toList(growable: false);
    final done = all
        .where((a) => a.status == DayStatus.done)
        .toList(growable: false);

    final thisWeekStart = KDate.startOfWeek(today, startDay);
    bool inWeek(Activity a, DateTime weekStart) {
      final end = weekStart.add(const Duration(days: 7));
      return !a.date.isBefore(weekStart) && a.date.isBefore(end);
    }

    final weekStarts = <DateTime>[];
    for (var i = kStatsWeekCount - 1; i >= 0; i--) {
      weekStarts.add(thisWeekStart.subtract(Duration(days: 7 * i)));
    }

    final todayStart = KDate.startOfDay(today);
    final dayCells = <DayCell>[];
    for (final ws in weekStarts) {
      for (var d = 0; d < 7; d++) {
        final date = ws.add(Duration(days: d));
        if (date.isAfter(todayStart)) break;
        final dayActivities = all
            .where((a) =>
                KDate.isSameDay(a.date, date) &&
                a.status != DayStatus.empty)
            .toList();
        if (dayActivities.isEmpty) {
          dayCells.add(DayCell(date: date));
        } else {
          dayCells.add(DayCell(
            date: date,
            primaryType: plan.forDate(date).type,
            activities: dayActivities
                .map((a) => CellActivity(
                    type: a.type, subType: a.subType, status: a.status))
                .toList(growable: false),
          ));
        }
      }
    }

    final currentDone = done.any((a) => inWeek(a, thisWeekStart));
    var streak = 0;
    final startOffset = currentDone ? 0 : 1;
    for (var i = startOffset; i < 520; i++) {
      final weekStart = thisWeekStart.subtract(Duration(days: 7 * i));
      final hasDone = done.any((a) => inWeek(a, weekStart));
      if (hasDone) {
        streak++;
      } else {
        break;
      }
    }

    double avgPerWeek = 0.0;
    if (done.isNotEmpty) {
      final firstDate = done.map((a) => a.date).reduce((a, b) => a.isBefore(b) ? a : b);
      final firstWeekStart = KDate.startOfWeek(firstDate, startDay);
      final totalWeeks = thisWeekStart.difference(firstWeekStart).inDays ~/ 7 + 1;
      avgPerWeek = done.length / totalWeeks;
    }

    return StatsData(
      totalSessions: done.length,
      currentStreak: streak,
      avgPerWeek: avgPerWeek,
      typeCounts: _buildTypeBuckets(done),
      dayCells: dayCells,
      weekStarts: weekStarts,
      allDone: done,
      allActivities: all,
    );
  }

  static List<TypeBucket> _buildTypeBuckets(List<Activity> activities) {
    final bucketMap = <(ActivityType?, String?), int>{};
    for (final a in activities) {
      final key = a.type == ActivityType.other
          ? (a.type, a.subType)
          : (a.type, null);
      bucketMap[key] = (bucketMap[key] ?? 0) + 1;
    }
    return bucketMap.entries
        .map((e) =>
            TypeBucket(type: e.key.$1, subType: e.key.$2, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
  }
}

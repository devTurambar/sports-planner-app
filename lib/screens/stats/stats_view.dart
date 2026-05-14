import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';


const int _kWeekCount = 26;

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  ActivityType? _typeFilter;

  @override
  Widget build(BuildContext context) {
    final today = TodayScope.of(context);
    final plan = context.watch<PlanController>();
    final data = _StatsData.compute(plan, today);

    final hasAnyActivity = data.dayCells.any((c) => !c.isEmpty);
    if (data.totalSessions == 0 && !hasAnyActivity) {
      return const _StatsEmpty();
    }

    final filteredBreakdown = _typeFilter != null
        ? data.typeCounts.where((b) => b.type == _typeFilter).toList()
        : data.typeCounts;
    final filteredTotal = _typeFilter != null
        ? filteredBreakdown.fold<int>(0, (s, b) => s + b.count)
        : data.totalSessions;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KSpace.s4,
        4,
        KSpace.s4,
        KSpace.s16,
      ),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        const SizedBox(height: KSpace.s2),
        Row(
          children: <Widget>[
            Expanded(
              child: _Kpi(value: data.totalSessions.toString(), label: 'Sessions'),
            ),
            const SizedBox(width: KSpace.s2),
            Expanded(
              child: _Kpi(
                value: data.currentStreak.toString(),
                label: 'Streak',
                suffix: 'wk',
              ),
            ),
            const SizedBox(width: KSpace.s2),
            Expanded(
              child: _Kpi(
                value: data.avgPerWeek.toStringAsFixed(1),
                label: 'Average',
                suffix: '/wk',
              ),
            ),
          ],
        ),
        const SizedBox(height: KSpace.s3),
        _HeatmapCard(
          data: data,
          typeFilter: _typeFilter,
        ),
        const SizedBox(height: KSpace.s3),
        _TypeBreakdown(
          buckets: filteredBreakdown,
          allBuckets: data.typeCounts,
          total: filteredTotal,
          maxCount: data.typeCounts.isEmpty
              ? 1
              : data.typeCounts.first.count,
          typeFilter: _typeFilter,
          onTypeSelected: (type) => setState(() {
            _typeFilter = _typeFilter == type ? null : type;
          }),
          onClear: _typeFilter != null
              ? () => setState(() => _typeFilter = null)
              : null,
        ),
      ],
    );
  }
}

// ── data ─────────────────────────────────────────────────────────────────

class _DayCell {
  const _DayCell({
    this.primaryType,
    this.activities = const <_CellActivity>[],
  });

  final ActivityType? primaryType;
  final List<_CellActivity> activities;

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

class _CellActivity {
  const _CellActivity({required this.type, required this.status});

  final ActivityType? type;
  final DayStatus status;
}

class _StatsData {
  const _StatsData({
    required this.totalSessions,
    required this.currentStreak,
    required this.avgPerWeek,
    required this.typeCounts,
    required this.dayCells,
    required this.weekStarts,
  });

  final int totalSessions;
  final int currentStreak;
  final double avgPerWeek;
  final List<_TypeBucket> typeCounts;
  final List<_DayCell> dayCells;
  final List<DateTime> weekStarts;

  static _StatsData compute(PlanController plan, DateTime today) {
    final done = plan
        .allActivities()
        .where((a) => a.status == DayStatus.done)
        .toList(growable: false);

    final mondayThis = KDate.mondayOfWeek(today);
    bool inWeek(Activity a, DateTime weekStart) {
      final end = weekStart.add(const Duration(days: 7));
      return !a.date.isBefore(weekStart) && a.date.isBefore(end);
    }

    final weekStarts = <DateTime>[];
    for (var i = _kWeekCount - 1; i >= 0; i--) {
      weekStarts.add(mondayThis.subtract(Duration(days: 7 * i)));
    }

    final all = plan.allActivities().toList(growable: false);

    final todayStart = KDate.startOfDay(today);
    final dayCells = <_DayCell>[];
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
          dayCells.add(const _DayCell());
        } else {
          dayCells.add(_DayCell(
            primaryType: plan.forDate(date).type,
            activities: dayActivities
                .map((a) => _CellActivity(type: a.type, status: a.status))
                .toList(growable: false),
          ));
        }
      }
    }

    final currentDone = done.any((a) => inWeek(a, mondayThis));
    var streak = 0;
    final startOffset = currentDone ? 0 : 1;
    for (var i = startOffset; i < 520; i++) {
      final weekStart = mondayThis.subtract(Duration(days: 7 * i));
      final hasDone = done.any((a) => inWeek(a, weekStart));
      if (hasDone) {
        streak++;
      } else {
        break;
      }
    }

    final weeksWithData = weekStarts.where((ws) {
      return done.any((a) => inWeek(a, ws));
    }).length;
    final avgPerWeek =
        weeksWithData == 0 ? 0.0 : done.length / weeksWithData;

    return _StatsData(
      totalSessions: done.length,
      currentStreak: streak,
      avgPerWeek: avgPerWeek,
      typeCounts: _buildTypeBuckets(done),
      dayCells: dayCells,
      weekStarts: weekStarts,
    );
  }

  static List<_TypeBucket> _buildTypeBuckets(List<Activity> activities) {
    final typeMap = <ActivityType?, int>{};
    for (final a in activities) {
      typeMap[a.type] = (typeMap[a.type] ?? 0) + 1;
    }
    return typeMap.entries
        .map((e) => _TypeBucket(type: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
  }
}

class _TypeBucket {
  const _TypeBucket({required this.type, required this.count});

  final ActivityType? type;
  final int count;

  String get label => type?.label ?? 'Other';
}

// ── 26-week contribution heatmap ─────────────────────────────────────────

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.data, this.typeFilter});

  final _StatsData data;
  final ActivityType? typeFilter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filtered = typeFilter != null;
    final filterLabel = filtered
        ? 'Filtered to ${typeFilter!.label}'
        : 'Tinted by primary activity';

    final firstWeek = data.weekStarts.first;
    final lastWeek = data.weekStarts.last.add(const Duration(days: 6));

    return Container(
      padding: const EdgeInsets.all(KSpace.s4),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(KRadius.lg + 4),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_kWeekCount-week activity',
                      style: KText.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.fgPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      filterLabel,
                      style: KText.caption.copyWith(
                        fontSize: 10,
                        color: colors.fgTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (filtered)
                _ClearPill(onTap: () {})
              else
                Text(
                  '${firstWeek.shortMonth} ${firstWeek.year % 100} → ${lastWeek.shortMonth} ${lastWeek.day}',
                  style: KText.caption.copyWith(
                    fontSize: 11,
                    color: colors.fgSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: KSpace.s3),
          _HeatmapGrid(
            cells: data.dayCells,
            typeFilter: typeFilter,
          ),
          const SizedBox(height: 6),
          _MonthLabels(weekStarts: data.weekStarts),
        ],
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  const _HeatmapGrid({required this.cells, this.typeFilter});

  final List<_DayCell> cells;
  final ActivityType? typeFilter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final todayIndex = cells.length - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        const totalGap = (_kWeekCount - 1) * 2.0;
        final cellSize = (constraints.maxWidth - totalGap) / _kWeekCount;
        final clampedSize = cellSize.clamp(8.0, 14.0);

        return SizedBox(
          height: 7 * clampedSize + 6 * 2.0,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: cells.length,
            itemBuilder: (context, index) {
              final cell = cells[index];
              final isToday = index == todayIndex;
              final render = cell.renderForFilter(typeFilter);

              if (render == null) {
                return Container(
                  decoration: BoxDecoration(
                    color: colors.fgTertiary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(2),
                    border: isToday
                        ? Border.all(color: colors.fgPrimary, width: 1.5)
                        : null,
                  ),
                );
              }

              final tint = context.typeColor(render.type).tint;

              return Container(
                decoration: BoxDecoration(
                  color: render.dimmed
                      ? Color.lerp(colors.bgCard, tint, 0.35)
                      : tint,
                  borderRadius: BorderRadius.circular(2),
                  border: isToday
                      ? Border.all(color: colors.fgPrimary, width: 1.5)
                      : null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MonthLabels extends StatelessWidget {
  const _MonthLabels({required this.weekStarts});

  final List<DateTime> weekStarts;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labels = <String>[];
    for (var i = 0; i < weekStarts.length; i++) {
      if (i == 0 ||
          weekStarts[i].month != weekStarts[i - 1].month) {
        labels.add(weekStarts[i].shortMonth);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map((m) => Text(
                m,
                style: KText.caption.copyWith(
                  fontSize: 9,
                  color: colors.fgTertiary,
                ),
              ))
          .toList(),
    );
  }
}

// ── KPI tiles ───────────────────────────────────────────────────────────

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.value,
    required this.label,
    this.suffix,
  });

  final String value;
  final String label;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(KRadius.lg + 4),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: KText.h2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                    height: 1,
                  ),
                ),
                if (suffix != null)
                  TextSpan(
                    text: ' $suffix',
                    style: KText.caption.copyWith(
                      fontSize: 12,
                      color: colors.fgTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: KText.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: colors.fgTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── activity type breakdown (filter buttons) ──────────────────────────────

class _TypeBreakdown extends StatelessWidget {
  const _TypeBreakdown({
    required this.buckets,
    required this.allBuckets,
    required this.total,
    required this.maxCount,
    this.typeFilter,
    required this.onTypeSelected,
    this.onClear,
  });

  final List<_TypeBucket> buckets;
  final List<_TypeBucket> allBuckets;
  final int total;
  final int maxCount;
  final ActivityType? typeFilter;
  final ValueChanged<ActivityType?> onTypeSelected;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(KRadius.lg + 4),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'By activity',
                  style: KText.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.fgPrimary,
                  ),
                ),
              ),
              if (onClear != null)
                _ClearPill(onTap: onClear!)
              else
                Text(
                  'All time',
                  style: KText.caption.copyWith(
                    fontSize: 10,
                    color: colors.fgTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: KSpace.s3),
          if (allBuckets.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: KSpace.s4),
              child: Center(
                child: Text(
                  'No sessions yet',
                  style: KText.bodySm.copyWith(color: colors.fgTertiary),
                ),
              ),
            )
          else
            for (var i = 0; i < allBuckets.length; i++) ...<Widget>[
              _TypeRow(
                bucket: allBuckets[i],
                maxCount: maxCount,
                active: typeFilter == allBuckets[i].type,
                dim: typeFilter != null && typeFilter != allBuckets[i].type,
                onTap: () => onTypeSelected(allBuckets[i].type),
              ),
              if (i < allBuckets.length - 1) const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow({
    required this.bucket,
    required this.maxCount,
    required this.active,
    required this.dim,
    required this.onTap,
  });

  final _TypeBucket bucket;
  final int maxCount;
  final bool active;
  final bool dim;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tc = context.typeColor(bucket.type);
    final fraction = maxCount == 0 ? 0.0 : bucket.count / maxCount;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: KMotion.fast,
        opacity: dim ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: active
                ? Color.lerp(Colors.transparent, tc.tint, 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: tc.tint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  bucket.label,
                  style: KText.bodySm.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.fgPrimary,
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(KRadius.full),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 6,
                    backgroundColor: colors.bgSubtle,
                    valueColor: AlwaysStoppedAnimation<Color>(tc.tint),
                  ),
                ),
              ),
              const SizedBox(width: KSpace.s2),
              SizedBox(
                width: 24,
                child: Text(
                  bucket.count.toString(),
                  textAlign: TextAlign.right,
                  style: KText.bodySm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.fgPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClearPill extends StatelessWidget {
  const _ClearPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colors.bgSubtle,
          borderRadius: BorderRadius.circular(KRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.x, size: 10, color: colors.fgSecondary),
            const SizedBox(width: 4),
            Text(
              'Clear',
              style: KText.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.fgSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── empty state ─────────────────────────────────────────────────────────

class _StatsEmpty extends StatelessWidget {
  const _StatsEmpty();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            KSpace.s8,
            KSpace.s8,
            KSpace.s8,
            KSpace.s16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.border, width: 1.5),
                ),
                child: Icon(
                  LucideIcons.chartColumn,
                  size: 36,
                  color: colors.fgTertiary,
                ),
              ),
              const SizedBox(height: KSpace.s6 + 4),
              Text(
                'No stats yet',
                textAlign: TextAlign.center,
                style: KText.h3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colors.fgPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: KSpace.s2),
              Text(
                'Complete your first session to start tracking your progress.',
                textAlign: TextAlign.center,
                style: KText.bodySm.copyWith(
                  fontSize: 14,
                  color: colors.fgSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
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
const double _kBarWidth = 20;
const double _kBarSpacing = 6;
const double _kChartHeight = 180;

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  int _selectedWeek = -1;

  @override
  Widget build(BuildContext context) {
    final today = TodayScope.of(context);
    final plan = context.watch<PlanController>();
    final data = _StatsData.compute(plan, today);

    if (data.totalSessions == 0) {
      return const _StatsEmpty();
    }

    final hasSelection =
        _selectedWeek >= 0 && _selectedWeek < data.weekBuckets.length;
    final breakdownBuckets =
        hasSelection ? data.weekTypeCounts[_selectedWeek] : data.typeCounts;
    final breakdownTotal = hasSelection
        ? data.weekBuckets[_selectedWeek].count
        : data.totalSessions;
    final breakdownLabel = hasSelection
        ? _weekRangeLabel(data.weekBuckets[_selectedWeek])
        : null;

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
              child: _Kpi(
                value: data.totalSessions.toString(),
                label: 'Total sessions',
                accent: true,
              ),
            ),
            const SizedBox(width: KSpace.s2),
            Expanded(
              child: _Kpi(
                value: data.currentStreak.toString(),
                label: data.currentStreak == 1
                    ? 'Week streak'
                    : 'Weeks streak',
              ),
            ),
          ],
        ),
        const SizedBox(height: KSpace.s3),
        _SessionsChart(
          buckets: data.weekBuckets,
          selectedIndex: _selectedWeek,
          onSelected: (i) => setState(() {
            _selectedWeek = _selectedWeek == i ? -1 : i;
          }),
        ),
        const SizedBox(height: KSpace.s3),
        _TypeBreakdown(
          buckets: breakdownBuckets,
          total: breakdownTotal,
          weekLabel: breakdownLabel,
          onClear: hasSelection
              ? () => setState(() => _selectedWeek = -1)
              : null,
        ),
      ],
    );
  }

  String _weekRangeLabel(_WeekBucket bucket) {
    final start = bucket.start;
    final end = start.add(const Duration(days: 6));
    if (start.month == end.month) {
      return '${start.shortMonth} ${start.day} – ${end.day}';
    }
    return '${start.shortMonth} ${start.day} – ${end.shortMonth} ${end.day}';
  }
}

// ── data ─────────────────────────────────────────────────────────────────

class _StatsData {
  const _StatsData({
    required this.totalSessions,
    required this.currentStreak,
    required this.weekBuckets,
    required this.typeCounts,
    required this.weekTypeCounts,
  });

  final int totalSessions;
  final int currentStreak;
  final List<_WeekBucket> weekBuckets;
  final List<_TypeBucket> typeCounts;
  final List<List<_TypeBucket>> weekTypeCounts;

  static _StatsData compute(PlanController plan, DateTime today) {
    final all = plan
        .allActivities()
        .where((a) => a.status != DayStatus.empty)
        .toList(growable: false);
    final done = all.where((a) => a.status == DayStatus.done).toList();

    final mondayThis = KDate.mondayOfWeek(today);
    bool inWeek(Activity a, DateTime weekStart) {
      final end = weekStart.add(const Duration(days: 7));
      return !a.date.isBefore(weekStart) && a.date.isBefore(end);
    }

    final weekBuckets = <_WeekBucket>[];
    final weekTypeCounts = <List<_TypeBucket>>[];
    for (var i = _kWeekCount - 1; i >= 0; i--) {
      final weekStart = mondayThis.subtract(Duration(days: 7 * i));
      final weekDone = done.where((a) => inWeek(a, weekStart)).toList();
      weekBuckets.add(_WeekBucket(
        start: weekStart,
        count: weekDone.length,
        isCurrent: i == 0,
      ));
      weekTypeCounts.add(_buildTypeBuckets(weekDone));
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

    return _StatsData(
      totalSessions: done.length,
      currentStreak: streak,
      weekBuckets: weekBuckets,
      typeCounts: _buildTypeBuckets(done),
      weekTypeCounts: weekTypeCounts,
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

class _WeekBucket {
  const _WeekBucket({
    required this.start,
    required this.count,
    required this.isCurrent,
  });

  final DateTime start;
  final int count;
  final bool isCurrent;
}

class _TypeBucket {
  const _TypeBucket({required this.type, required this.count});

  final ActivityType? type;
  final int count;

  String get label => type?.label ?? 'Other';
}

// ── scrollable sessions chart ───────────────────────────────────────────

class _SessionsChart extends StatefulWidget {
  const _SessionsChart({
    required this.buckets,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_WeekBucket> buckets;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<_SessionsChart> createState() => _SessionsChartState();
}

class _SessionsChartState extends State<_SessionsChart> {
  late final ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final buckets = widget.buckets;
    final selected = widget.selectedIndex;
    final maxCount = buckets.fold<int>(0, (m, b) => math.max(m, b.count));
    final maxY = (maxCount == 0 ? 1 : maxCount + 1).toDouble();

    final chartWidth =
        buckets.length * (_kBarWidth + _kBarSpacing) + _kBarSpacing;

    final monthLabels = <int, String>{};
    for (var i = 0; i < buckets.length; i++) {
      final cur = buckets[i].start;
      if (i == 0 ||
          cur.month != buckets[i - 1].start.month ||
          cur.year != buckets[i - 1].start.year) {
        monthLabels[i] = cur.shortMonth;
      }
    }

    final hasSelection = selected >= 0 && selected < buckets.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        KSpace.s4,
        KSpace.s4,
        KSpace.s4,
        KSpace.s2,
      ),
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: BorderRadius.circular(KRadius.md),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sessions per week',
                      style: KText.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.fgPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Last $_kWeekCount weeks',
                      style: KText.caption.copyWith(
                        fontSize: 11,
                        color: colors.fgSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasSelection)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.accentLight,
                    borderRadius: BorderRadius.circular(KRadius.full),
                  ),
                  child: Text(
                    '${buckets[selected].count} sessions',
                    style: KText.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.accent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: KSpace.s4),
          SizedBox(
            height: _kChartHeight + 28,
            child: Row(
              children: <Widget>[
                _YAxis(maxY: maxY, colors: colors),
                const SizedBox(width: 4),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollCtrl,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: chartWidth,
                      height: _kChartHeight + 28,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY,
                          minY: 0,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => Colors.transparent,
                              tooltipPadding: EdgeInsets.zero,
                              tooltipMargin: 0,
                              getTooltipItem: (_, __, ___, ____) => null,
                            ),
                            touchCallback: (event, response) {
                              if (event is FlTapUpEvent) {
                                final idx =
                                    response?.spot?.touchedBarGroupIndex;
                                if (idx != null) widget.onSelected(idx);
                              }
                            },
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval:
                                maxY > 4 ? (maxY / 4).ceilToDouble() : 1,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: colors.border.withValues(alpha: 0.5),
                              strokeWidth: 0.5,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 24,
                                getTitlesWidget: (value, meta) {
                                  final i = value.toInt();
                                  if (!monthLabels.containsKey(i)) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      monthLabels[i]!,
                                      style: KText.caption.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: colors.fgSecondary,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: <BarChartGroupData>[
                            for (var i = 0; i < buckets.length; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: <BarChartRodData>[
                                  BarChartRodData(
                                    toY: math.max(
                                        buckets[i].count.toDouble(), 0),
                                    color: _barColor(
                                        i, buckets[i], selected, colors),
                                    width: _kBarWidth,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(KRadius.xs),
                                    ),
                                    backDrawRodData:
                                        BackgroundBarChartRodData(
                                      show: true,
                                      toY: maxY,
                                      color: colors.bgSubtle
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _barColor(
      int index, _WeekBucket bucket, int selected, KadenceColors colors) {
    if (index == selected) return colors.accentHover;
    if (selected >= 0) return colors.accent.withValues(alpha: 0.25);
    if (bucket.isCurrent) return colors.accent.withValues(alpha: 0.45);
    return colors.accent;
  }
}

class _YAxis extends StatelessWidget {
  const _YAxis({required this.maxY, required this.colors});

  final double maxY;
  final KadenceColors colors;

  @override
  Widget build(BuildContext context) {
    final interval = maxY > 4 ? (maxY / 4).ceilToDouble() : 1.0;
    final labels = <double>[];
    for (var v = 0.0; v <= maxY; v += interval) {
      labels.add(v);
    }

    return SizedBox(
      width: 22,
      height: _kChartHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: labels.reversed
            .map((v) => Text(
                  v.toInt().toString(),
                  style: KText.caption.copyWith(
                    fontSize: 9,
                    color: colors.fgTertiary,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ── KPI tiles ───────────────────────────────────────────────────────────

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.value,
    required this.label,
    this.accent = false,
  });

  final String value;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = accent ? colors.accent : colors.fgPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: KSpace.s4,
        vertical: KSpace.s3,
      ),
      decoration: BoxDecoration(
        color: accent ? colors.accentLight : colors.bgElevated,
        borderRadius: BorderRadius.circular(KRadius.md),
        border: Border.all(
          color:
              accent ? colors.accent.withValues(alpha: 0.15) : colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: KText.h2.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: fg,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: KText.caption.copyWith(
              fontSize: 11,
              color: fg.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

// ── activity type breakdown ─────────────────────────────────────────────

class _TypeBreakdown extends StatelessWidget {
  const _TypeBreakdown({
    required this.buckets,
    required this.total,
    this.weekLabel,
    this.onClear,
  });

  final List<_TypeBucket> buckets;
  final int total;
  final String? weekLabel;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isFiltered = weekLabel != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        KSpace.s4,
        KSpace.s4,
        KSpace.s4,
        KSpace.s3,
      ),
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: BorderRadius.circular(KRadius.md),
        border: Border.all(
          color: isFiltered
              ? colors.accent.withValues(alpha: 0.3)
              : colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'By activity',
                      style: KText.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.fgPrimary,
                      ),
                    ),
                    if (isFiltered) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        weekLabel!,
                        style: KText.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.accent,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colors.bgSubtle,
                      borderRadius: BorderRadius.circular(KRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(LucideIcons.x, size: 12, color: colors.fgSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'All time',
                          style: KText.caption.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colors.fgSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: KSpace.s3),
          if (buckets.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: KSpace.s4),
              child: Center(
                child: Text(
                  'No sessions this week',
                  style: KText.bodySm.copyWith(color: colors.fgTertiary),
                ),
              ),
            )
          else
            for (var i = 0; i < buckets.length; i++) ...<Widget>[
              _TypeRow(bucket: buckets[i], total: total),
              if (i < buckets.length - 1) const SizedBox(height: KSpace.s3),
            ],
        ],
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow({required this.bucket, required this.total});

  final _TypeBucket bucket;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fraction = total == 0 ? 0.0 : bucket.count / total;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 64,
          child: Text(
            bucket.label,
            style: KText.bodySm.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.fgPrimary,
            ),
          ),
        ),
        const SizedBox(width: KSpace.s2),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(KRadius.full),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: colors.bgSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ),
        ),
        const SizedBox(width: KSpace.s2),
        SizedBox(
          width: 28,
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
                  color: colors.accent,
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

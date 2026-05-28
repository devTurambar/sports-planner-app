import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

enum _Period {
  month1('1M', 4),
  month3('3M', 13),
  month6('6M', 26),
  year1('1Y', 52),
  allTime('All', null);

  const _Period(this.label, this.weeks);
  final String label;
  final int? weeks;
}

class PeriodBreakdown extends StatefulWidget {
  const PeriodBreakdown({
    required this.data,
    required this.startDay,
    required this.today,
    super.key,
  });

  final StatsData data;
  final int startDay;
  final DateTime today;

  @override
  State<PeriodBreakdown> createState() => _PeriodBreakdownState();
}

class _PeriodBreakdownState extends State<PeriodBreakdown> {
  _Period _period = _Period.month3;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final d = _compute();

    return ProStatCard(
      title: 'Period breakdown',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PeriodSelector(
            selected: _period,
            onSelect: (p) => setState(() => _period = p),
          ),
          const SizedBox(height: KSpace.s3),
          if (d.weekEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: KSpace.s4),
              child: Center(
                child: Text(
                  'No sessions in this period',
                  style: KText.bodySm.copyWith(color: colors.fgTertiary),
                ),
              ),
            )
          else ...[
            _MiniKpiRow(data: d),
            const SizedBox(height: KSpace.s3),
            _MonthlyBarChart(
              key: ValueKey(_period),
              entries: d.monthEntries,
            ),
            const SizedBox(height: 6),
            _TrendBadge(trend: d.trend),
          ],
        ],
      ),
    );
  }

  _PeriodData _compute() {
    final thisWeekStart = KDate.startOfWeek(widget.today, widget.startDay);

    final int weekCount;
    if (_period.weeks != null) {
      weekCount = _period.weeks!;
    } else {
      if (widget.data.allDone.isEmpty) return const _PeriodData.empty();
      final firstDate = widget.data.allDone
          .map((a) => a.date)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      final firstWeekStart = KDate.startOfWeek(firstDate, widget.startDay);
      weekCount = thisWeekStart.difference(firstWeekStart).inDays ~/ 7 + 1;
    }

    // Weekly entries, oldest → newest
    final weekEntries = <_WeekEntry>[];
    for (var i = weekCount - 1; i >= 0; i--) {
      final ws = thisWeekStart.subtract(Duration(days: 7 * i));
      final end = ws.add(const Duration(days: 7));
      final count = widget.data.allDone
          .where((a) => !a.date.isBefore(ws) && a.date.isBefore(end))
          .length;
      weekEntries.add(_WeekEntry(weekStart: ws, count: count));
    }

    // Aggregate weekly entries by month (a week belongs to its start month)
    final monthMap = <(int, int), int>{};
    for (final e in weekEntries) {
      final key = (e.weekStart.year, e.weekStart.month);
      monthMap[key] = (monthMap[key] ?? 0) + e.count;
    }
    final monthEntries = monthMap.entries
        .map((e) => _MonthEntry(year: e.key.$1, month: e.key.$2, count: e.value))
        .toList()
      ..sort((a, b) =>
          a.year != b.year ? a.year.compareTo(b.year) : a.month.compareTo(b.month));

    final total = weekEntries.fold(0, (s, e) => s + e.count);
    final avg = total / weekCount;
    final weeksActive = weekEntries.where((e) => e.count > 0).length;
    final consistency = weeksActive / weekCount;
    final peak = weekEntries.fold(0, (m, e) => e.count > m ? e.count : m);

    // Trend: compare avg sessions/wk in the older half vs the more recent half
    double trend = 0;
    if (weekEntries.length >= 4) {
      final mid = weekEntries.length ~/ 2;
      final firstAvg =
          weekEntries.sublist(0, mid).fold(0, (s, e) => s + e.count) / mid;
      final secondAvg =
          weekEntries.sublist(mid).fold(0, (s, e) => s + e.count) /
              (weekEntries.length - mid);
      trend = firstAvg == 0
          ? (secondAvg > 0 ? 1.0 : 0.0)
          : (secondAvg - firstAvg) / firstAvg;
    }

    return _PeriodData(
      weekEntries: weekEntries,
      monthEntries: monthEntries,
      total: total,
      avg: avg,
      consistency: consistency,
      peak: peak,
      trend: trend,
    );
  }
}

// ── Period selector ───────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.selected, required this.onSelect});

  final _Period selected;
  final ValueChanged<_Period> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: _Period.values.map((p) {
        final active = p == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: GestureDetector(
            onTap: () => onSelect(p),
            child: AnimatedContainer(
              duration: KMotion.fast,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: active ? colors.accent : colors.bgSubtle,
                borderRadius: BorderRadius.circular(KRadius.full),
              ),
              child: Text(
                p.label,
                style: KText.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : colors.fgSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Mini KPI row ──────────────────────────────────────────────────────────

class _MiniKpiRow extends StatelessWidget {
  const _MiniKpiRow({required this.data});

  final _PeriodData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniKpi(label: 'Sessions', value: data.total.toString()),
        const SizedBox(width: 6),
        _MiniKpi(label: 'Avg / wk', value: data.avg.toStringAsFixed(1)),
        const SizedBox(width: 6),
        _MiniKpi(
            label: 'Consistency',
            value: '${(data.consistency * 100).round()}%'),
        const SizedBox(width: 6),
        _MiniKpi(label: 'Peak week', value: data.peak.toString()),
      ],
    );
  }
}

class _MiniKpi extends StatelessWidget {
  const _MiniKpi({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: colors.bgSubtle,
          borderRadius: BorderRadius.circular(KRadius.md),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: KText.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 1,
                color: colors.fgPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: KText.caption.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: colors.fgTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Monthly bar chart ─────────────────────────────────────────────────────

class _MonthlyBarChart extends StatefulWidget {
  const _MonthlyBarChart({required this.entries, super.key});

  final List<_MonthEntry> entries;

  @override
  State<_MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<_MonthlyBarChart> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _jumpToEnd();
  }

  void _jumpToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients &&
          _controller.position.maxScrollExtent > 0) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.entries;
    if (entries.isEmpty) return const SizedBox.shrink();

    final maxCount = entries.fold(0, (m, e) => e.count > m ? e.count : m);

    return LayoutBuilder(builder: (context, constraints) {
      const minBarW = 22.0;
      const maxBarW = 52.0;
      const barGap = 6.0;
      final n = entries.length;
      final idealW =
          n <= 1 ? maxBarW : (constraints.maxWidth - (n - 1) * barGap) / n;
      final barW = idealW.clamp(minBarW, maxBarW);
      final totalW = n * barW + (n - 1) * barGap;
      final needsScroll = totalW > constraints.maxWidth + 0.5;

      final content = _buildBars(
        context,
        entries,
        maxCount,
        barW,
        barGap,
        needsScroll ? totalW : constraints.maxWidth,
      );

      if (!needsScroll) return content;

      return SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    });
  }

  Widget _buildBars(
    BuildContext context,
    List<_MonthEntry> entries,
    int maxCount,
    double barW,
    double barGap,
    double totalW,
  ) {
    final colors = context.colors;
    return SizedBox(
      width: totalW,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // bars
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(entries.length, (i) {
                final e = entries[i];
                final frac = maxCount == 0 ? 0.0 : e.count / maxCount;
                final isCurrent = i == entries.length - 1;
                final barH =
                    maxCount == 0 ? 3.0 : (frac * 60.0).clamp(3.0, 60.0);
                return Padding(
                  padding: EdgeInsets.only(
                      right: i < entries.length - 1 ? barGap : 0),
                  child: SizedBox(
                    width: barW,
                    height: 60,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: barW,
                        height: barH,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? colors.accent
                              : e.count == 0
                                  ? colors.fgTertiary.withValues(alpha: 0.07)
                                  : colors.accent.withValues(alpha: 0.35),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3)),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 4),
          // month labels — one per bar, no overlap possible
          SizedBox(
            height: 14,
            child: Row(
              children: List.generate(entries.length, (i) {
                final e = entries[i];
                final isCurrent = i == entries.length - 1;
                return Padding(
                  padding: EdgeInsets.only(
                      right: i < entries.length - 1 ? barGap : 0),
                  child: SizedBox(
                    width: barW,
                    child: Text(
                      e.label,
                      textAlign: TextAlign.center,
                      style: KText.caption.copyWith(
                        fontSize: 9,
                        fontWeight:
                            isCurrent ? FontWeight.w600 : FontWeight.w400,
                        color: isCurrent
                            ? colors.fgSecondary
                            : colors.fgTertiary,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Trend badge ───────────────────────────────────────────────────────────

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend});

  final double trend;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final IconData icon;
    final String label;
    final Color color;

    if (trend > 0.15) {
      icon = LucideIcons.trendingUp;
      label = 'Trending up vs earlier in period';
      color = const Color(0xFF4CAF50);
    } else if (trend < -0.15) {
      icon = LucideIcons.trendingDown;
      label = 'Trending down vs earlier in period';
      color = const Color(0xFFE57373);
    } else {
      icon = LucideIcons.minus;
      label = 'Steady pace';
      color = colors.fgTertiary;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: KText.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Data classes ──────────────────────────────────────────────────────────

class _PeriodData {
  const _PeriodData({
    required this.weekEntries,
    required this.monthEntries,
    required this.total,
    required this.avg,
    required this.consistency,
    required this.peak,
    required this.trend,
  });

  const _PeriodData.empty()
      : weekEntries = const [],
        monthEntries = const [],
        total = 0,
        avg = 0.0,
        consistency = 0.0,
        peak = 0,
        trend = 0.0;

  final List<_WeekEntry> weekEntries;
  final List<_MonthEntry> monthEntries;
  final int total;
  final double avg;
  final double consistency;
  final int peak;
  final double trend;
}

class _WeekEntry {
  const _WeekEntry({required this.weekStart, required this.count});

  final DateTime weekStart;
  final int count;
}

class _MonthEntry {
  const _MonthEntry({
    required this.year,
    required this.month,
    required this.count,
  });

  final int year;
  final int month;
  final int count;

  String get label => KDate.shortMonths[month - 1];
}

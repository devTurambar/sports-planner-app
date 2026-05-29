import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../state/theme_controller.dart';
import '../../state/tip_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';
import '../../widgets/k_tip_banner.dart';
import 'stats_data.dart';
import 'widgets/personal_records.dart';
import 'widgets/period_breakdown.dart';
import 'widgets/best_day_of_week.dart';
import 'widgets/completion_rate.dart';
import 'widgets/monthly_trends.dart';
import 'widgets/weekly_activity_chart.dart';
import 'widgets/activity_variety.dart';
import 'widgets/longest_gap.dart';
import 'widgets/month_vs_month.dart';
import 'widgets/most_consistent.dart';
import 'widgets/weekly_patterns.dart';
import 'widgets/year_in_review.dart';
import 'widgets/full_year_heatmap.dart';
import 'widgets/insights.dart';
import 'widgets/shareable_recap.dart';

class StatsView extends StatefulWidget {
  const StatsView({required this.isActive, super.key});

  final bool isActive;

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  ActivityType? _typeFilter;
  bool _tipShown = false;

  void _checkStatsTip(bool hasMultipleTypes) {
    if (_tipShown || !hasMultipleTypes || !widget.isActive) return;
    _tipShown = true;
    final tips = context.read<TipController>();
    if (!tips.shouldShow(TipKey.statsFilter)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      KTutorialOverlay.show(
        context: context,
        gesture: TutorialGesture.tap,
        title: loc.statsTipFilterTitle,
        subtitle: loc.statsTipFilterBody,
        onDismiss: () => tips.markSeen(TipKey.statsFilter),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final today = TodayScope.of(context);
    final plan = context.watch<PlanController>();
    final startDay = context.watch<ThemeController>().weekStartDay;
    final data = StatsData.compute(plan, today, startDay);

    final hasAnyActivity = data.dayCells.any((c) => !c.isEmpty);
    if (data.totalSessions == 0 && !hasAnyActivity) {
      return const _StatsEmpty();
    }

    context.watch<TipController>();
    final hasMultipleTypes = data.typeCounts.length > 1;
    _checkStatsTip(hasMultipleTypes);

    final filteredBreakdown = _typeFilter != null
        ? data.typeCounts.where((b) => b.type == _typeFilter).toList()
        : data.typeCounts;
    final filteredTotal = _typeFilter != null
        ? filteredBreakdown.fold<int>(0, (s, b) => s + b.count)
        : data.totalSessions;

    final loc = AppLocalizations.of(context)!;
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
                label: loc.statsKpiSessions,
              ),
            ),
            const SizedBox(width: KSpace.s2),
            Expanded(
              child: _Kpi(
                value: data.currentStreak.toString(),
                label: loc.statsKpiStreak,
                suffix: loc.statsWeekSuffix,
              ),
            ),
            const SizedBox(width: KSpace.s2),
            Expanded(
              child: _Kpi(
                value: data.avgPerWeek.toStringAsFixed(1),
                label: loc.statsKpiAverage,
                suffix: loc.statsPerWeekSuffix,
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
        const SizedBox(height: KSpace.s8),
        _ProSectionHeader(colors: colors),
        const SizedBox(height: KSpace.s3),
        PersonalRecords(data: data),
        const SizedBox(height: KSpace.s3),
        PeriodBreakdown(data: data, startDay: startDay, today: today),
        const SizedBox(height: KSpace.s3),
        WeeklyActivityChart(data: data, startDay: startDay),
        const SizedBox(height: KSpace.s3),
        BestDayOfWeek(data: data, startDay: startDay),
        const SizedBox(height: KSpace.s3),
        CompletionRate(data: data),
        const SizedBox(height: KSpace.s3),
        MonthlyTrends(data: data),
        const SizedBox(height: KSpace.s3),
        ActivityVariety(data: data, startDay: startDay),
        const SizedBox(height: KSpace.s3),
        LongestGap(data: data),
        const SizedBox(height: KSpace.s3),
        MonthVsMonth(data: data),
        const SizedBox(height: KSpace.s3),
        MostConsistent(data: data),
        const SizedBox(height: KSpace.s3),
        WeeklyPatterns(data: data, startDay: startDay),
        const SizedBox(height: KSpace.s3),
        YearInReview(data: data),
        const SizedBox(height: KSpace.s3),
        FullYearHeatmap(data: data, startDay: startDay),
        const SizedBox(height: KSpace.s3),
        Insights(data: data, startDay: startDay),
        const SizedBox(height: KSpace.s3),
        ShareableRecap(data: data),
      ],
    );
  }
}

class _ProSectionHeader extends StatelessWidget {
  const _ProSectionHeader({required this.colors});

  final KadenceColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(LucideIcons.crown, size: 14, color: colors.accent),
        const SizedBox(width: 6),
        Text(
          AppLocalizations.of(context)!.statsProSection,
          style: KText.body.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.accent,
          ),
        ),
        const SizedBox(width: KSpace.s3),
        Expanded(
          child: Container(
            height: 1,
            color: colors.accent.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}

// Data classes are in stats_data.dart

// ── 26-week contribution heatmap ─────────────────────────────────────────

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.data, this.typeFilter});

  final StatsData data;
  final ActivityType? typeFilter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final filtered = typeFilter != null;
    final filterLabel = filtered
        ? loc.statsHeatmapFilteredTo(typeFilter!.localized(loc))
        : loc.statsHeatmapTinted;

    final firstWeek = data.weekStarts.first;
    final lastWeek = data.weekStarts.last.add(const Duration(days: 6));
    final shortMonthFmt = DateFormat.MMM(localeName);

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
                      loc.statsHeatmapTitle(kStatsWeekCount),
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
                  '${shortMonthFmt.format(firstWeek)} ${firstWeek.year % 100} → ${shortMonthFmt.format(lastWeek)} ${lastWeek.day}',
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

  final List<DayCell> cells;
  final ActivityType? typeFilter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final todayIndex = cells.length - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        const totalGap = (kStatsWeekCount - 1) * 2.0;
        final cellSize = (constraints.maxWidth - totalGap) / kStatsWeekCount;
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
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final fmt = DateFormat.MMM(localeName);
    final labels = <String>[];
    for (var i = 0; i < weekStarts.length; i++) {
      if (i == 0 ||
          weekStarts[i].month != weekStarts[i - 1].month) {
        labels.add(fmt.format(weekStarts[i]));
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

  final List<TypeBucket> buckets;
  final List<TypeBucket> allBuckets;
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
                  AppLocalizations.of(context)!.statsByActivity,
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
                  AppLocalizations.of(context)!.statsAllTime,
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
                  AppLocalizations.of(context)!.statsNoSessionsYet,
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

  final TypeBucket bucket;
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
                  bucket.localizedLabel(AppLocalizations.of(context)!),
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
              AppLocalizations.of(context)!.actionClear,
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
                AppLocalizations.of(context)!.statsEmptyTitle,
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
                AppLocalizations.of(context)!.statsEmptyBody,
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

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class YearInReview extends StatelessWidget {
  const YearInReview({required this.data, super.key});

  final StatsData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final review = _compute();

    return ProStatCard(
      title: '${review.year} in review',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ReviewKpi(
                  icon: LucideIcons.activity,
                  iconColor: colors.accent,
                  value: '${review.totalSessions}',
                  label: 'Sessions',
                ),
              ),
              const SizedBox(width: KSpace.s2),
              Expanded(
                child: _ReviewKpi(
                  icon: LucideIcons.calendarCheck,
                  iconColor: colors.typeWalk.tint,
                  value: '${review.activeDays}',
                  label: 'Active days',
                ),
              ),
            ],
          ),
          const SizedBox(height: KSpace.s2),
          Row(
            children: [
              Expanded(
                child: _ReviewKpi(
                  icon: LucideIcons.trophy,
                  iconColor: colors.typeOther.tint,
                  value: review.topMonth,
                  label: 'Best month',
                ),
              ),
              const SizedBox(width: KSpace.s2),
              Expanded(
                child: _ReviewKpi(
                  icon: LucideIcons.heart,
                  iconColor: colors.typeGym.tint,
                  value: review.topType,
                  label: 'Top activity',
                ),
              ),
            ],
          ),
          if (review.typesUsed > 0) ...[
            const SizedBox(height: KSpace.s3),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: KSpace.s3,
                vertical: KSpace.s2,
              ),
              decoration: BoxDecoration(
                color: colors.bgSubtle,
                borderRadius: BorderRadius.circular(KRadius.md),
              ),
              child: Text(
                'You tried ${review.typesUsed} different ${review.typesUsed == 1 ? 'activity' : 'activities'} this year',
                style: KText.bodySm.copyWith(
                  color: colors.fgSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _YearReview _compute() {
    final year = DateTime.now().year;
    final yearDone = data.allDone
        .where((a) => a.date.year == year)
        .toList();

    final activeDays = yearDone
        .map((a) => KDate.keyFor(a.date))
        .toSet()
        .length;

    // Best month
    final monthCounts = <int, int>{};
    for (final a in yearDone) {
      monthCounts[a.date.month] = (monthCounts[a.date.month] ?? 0) + 1;
    }
    var topMonthIdx = 0;
    var topMonthCount = 0;
    for (final e in monthCounts.entries) {
      if (e.value > topMonthCount) {
        topMonthCount = e.value;
        topMonthIdx = e.key;
      }
    }

    // Top activity type
    final typeCounts = <ActivityType, int>{};
    for (final a in yearDone) {
      if (a.type != null) {
        typeCounts[a.type!] = (typeCounts[a.type!] ?? 0) + 1;
      }
    }
    ActivityType? topType;
    var topTypeCount = 0;
    for (final e in typeCounts.entries) {
      if (e.value > topTypeCount) {
        topTypeCount = e.value;
        topType = e.key;
      }
    }

    final typesUsed = typeCounts.keys.length;

    return _YearReview(
      year: year,
      totalSessions: yearDone.length,
      activeDays: activeDays,
      topMonth: topMonthIdx > 0
          ? KDate.shortMonths[topMonthIdx - 1]
          : '—',
      topType: topType?.label ?? '—',
      typesUsed: typesUsed,
    );
  }
}

class _YearReview {
  const _YearReview({
    required this.year,
    required this.totalSessions,
    required this.activeDays,
    required this.topMonth,
    required this.topType,
    required this.typesUsed,
  });

  final int year;
  final int totalSessions;
  final int activeDays;
  final String topMonth;
  final String topType;
  final int typesUsed;
}

class _ReviewKpi extends StatelessWidget {
  const _ReviewKpi({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(KSpace.s3),
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        borderRadius: BorderRadius.circular(KRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: KText.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                  ),
                ),
                Text(
                  label,
                  style: KText.caption.copyWith(
                    fontSize: 10,
                    color: colors.fgTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

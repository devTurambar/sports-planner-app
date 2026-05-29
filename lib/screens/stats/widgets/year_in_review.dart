import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/generated/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final review = _compute(loc, localeName);

    return ProStatCard(
      title: loc.statsYearInReviewTitle(review.year),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ReviewKpi(
                  icon: LucideIcons.activity,
                  iconColor: colors.accent,
                  value: '${review.totalSessions}',
                  label: loc.statsKpiSessions,
                ),
              ),
              const SizedBox(width: KSpace.s2),
              Expanded(
                child: _ReviewKpi(
                  icon: LucideIcons.calendarCheck,
                  iconColor: colors.typeWalk.tint,
                  value: '${review.activeDays}',
                  label: loc.statsActiveDays,
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
                  label: loc.statsBestMonth,
                ),
              ),
              const SizedBox(width: KSpace.s2),
              Expanded(
                child: _ReviewKpi(
                  icon: LucideIcons.heart,
                  iconColor: colors.typeGym.tint,
                  value: review.topType,
                  label: loc.statsTopActivity,
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
                loc.statsTriedTypes(review.typesUsed),
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

  _YearReview _compute(AppLocalizations loc, String localeName) {
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

    // Top activity type (keyed by localized label to split sub-types)
    final typeLabelCounts = <String, int>{};
    for (final a in yearDone) {
      if (a.type != null) {
        final lbl = a.type == ActivityType.other && a.subType != null
            ? localizedSubType(a.subType!, loc)
            : a.type!.localized(loc);
        typeLabelCounts[lbl] = (typeLabelCounts[lbl] ?? 0) + 1;
      }
    }
    String? topTypeLabel;
    var topTypeCount = 0;
    for (final e in typeLabelCounts.entries) {
      if (e.value > topTypeCount) {
        topTypeCount = e.value;
        topTypeLabel = e.key;
      }
    }

    final typesUsed = typeLabelCounts.keys.length;
    final monthFmt = DateFormat.MMM(localeName);

    return _YearReview(
      year: year,
      totalSessions: yearDone.length,
      activeDays: activeDays,
      topMonth: topMonthIdx > 0
          ? monthFmt.format(DateTime(year, topMonthIdx))
          : '—',
      topType: topTypeLabel ?? '—',
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

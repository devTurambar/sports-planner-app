import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class MonthVsMonth extends StatelessWidget {
  const MonthVsMonth({required this.data, super.key});

  final StatsData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final comparison = _compute();

    return ProStatCard(
      title: 'Month vs month',
      subtitle: comparison.currentLabel,
      child: Row(
        children: [
          Expanded(
            child: _MonthColumn(
              label: comparison.prevLabel,
              count: comparison.prevCount,
              types: comparison.prevTypes,
              isCurrent: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: KSpace.s3),
            child: Column(
              children: [
                Icon(
                  comparison.diff >= 0
                      ? LucideIcons.trendingUp
                      : LucideIcons.trendingDown,
                  size: 20,
                  color: comparison.diff >= 0
                      ? colors.typeWalk.tint
                      : colors.typeGym.tint,
                ),
                const SizedBox(height: 4),
                Text(
                  comparison.diff >= 0
                      ? '+${comparison.diff}'
                      : '${comparison.diff}',
                  style: KText.bodySm.copyWith(
                    fontWeight: FontWeight.w700,
                    color: comparison.diff >= 0
                        ? colors.typeWalk.tint
                        : colors.typeGym.tint,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _MonthColumn(
              label: comparison.currentLabel,
              count: comparison.currentCount,
              types: comparison.currentTypes,
              isCurrent: true,
            ),
          ),
        ],
      ),
    );
  }

  _Comparison _compute() {
    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;
    var prevYear = curYear;
    var prevMonth = curMonth - 1;
    if (prevMonth == 0) {
      prevMonth = 12;
      prevYear--;
    }

    final curDone = data.allDone
        .where((a) => a.date.year == curYear && a.date.month == curMonth)
        .toList();
    final prevDone = data.allDone
        .where((a) => a.date.year == prevYear && a.date.month == prevMonth)
        .toList();

    return _Comparison(
      currentLabel: KDate.shortMonths[curMonth - 1],
      prevLabel: KDate.shortMonths[prevMonth - 1],
      currentCount: curDone.length,
      prevCount: prevDone.length,
      diff: curDone.length - prevDone.length,
      currentTypes: curDone
          .map((a) => a.type)
          .where((t) => t != null)
          .toSet()
          .length,
      prevTypes: prevDone
          .map((a) => a.type)
          .where((t) => t != null)
          .toSet()
          .length,
    );
  }
}

class _Comparison {
  const _Comparison({
    required this.currentLabel,
    required this.prevLabel,
    required this.currentCount,
    required this.prevCount,
    required this.diff,
    required this.currentTypes,
    required this.prevTypes,
  });

  final String currentLabel;
  final String prevLabel;
  final int currentCount;
  final int prevCount;
  final int diff;
  final int currentTypes;
  final int prevTypes;
}

class _MonthColumn extends StatelessWidget {
  const _MonthColumn({
    required this.label,
    required this.count,
    required this.types,
    required this.isCurrent,
  });

  final String label;
  final int count;
  final int types;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(KSpace.s3),
      decoration: BoxDecoration(
        color: isCurrent ? colors.accent.withValues(alpha: 0.08) : colors.bgSubtle,
        borderRadius: BorderRadius.circular(KRadius.md),
        border: isCurrent
            ? Border.all(color: colors.accent.withValues(alpha: 0.2))
            : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: KText.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isCurrent ? colors.accent : colors.fgSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: KText.h2.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.fgPrimary,
            ),
          ),
          Text(
            count == 1 ? 'session' : 'sessions',
            style: KText.caption.copyWith(
              fontSize: 10,
              color: colors.fgTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$types ${types == 1 ? 'type' : 'types'}',
            style: KText.caption.copyWith(
              fontSize: 10,
              color: colors.fgTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

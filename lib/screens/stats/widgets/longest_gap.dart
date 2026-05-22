import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class LongestGap extends StatelessWidget {
  const LongestGap({required this.data, super.key});

  final StatsData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final gap = _compute();

    return ProStatCard(
      title: 'Longest gap',
      subtitle: 'Between sessions',
      child: gap == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: KSpace.s3),
                child: Text(
                  'Need at least 2 sessions',
                  style: KText.bodySm.copyWith(color: colors.fgTertiary),
                ),
              ),
            )
          : Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.bgSubtle,
                    borderRadius: BorderRadius.circular(KRadius.md),
                  ),
                  child: Icon(
                    LucideIcons.calendarOff,
                    size: 22,
                    color: colors.fgTertiary,
                  ),
                ),
                const SizedBox(width: KSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '${gap.days}',
                            style: KText.h3.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.fgPrimary,
                            ),
                          ),
                          TextSpan(
                            text: gap.days == 1 ? ' day' : ' days',
                            style: KText.bodySm.copyWith(
                              color: colors.fgTertiary,
                            ),
                          ),
                        ]),
                      ),
                      Text(
                        '${gap.startDate.shortMonth} ${gap.startDate.day} → ${gap.endDate.shortMonth} ${gap.endDate.day}',
                        style: KText.caption.copyWith(
                          fontSize: 11,
                          color: colors.fgTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.bgSubtle,
                    borderRadius: BorderRadius.circular(KRadius.full),
                  ),
                  child: Text(
                    _currentGapLabel(),
                    style: KText.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: colors.fgSecondary,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _currentGapLabel() {
    if (data.allDone.isEmpty) return 'No data';
    final sorted = data.allDone.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final last = sorted.last.date;
    final now = KDate.startOfDay(DateTime.now());
    final daysSince = now.difference(last).inDays;
    if (daysSince == 0) return 'Today';
    if (daysSince == 1) return '1 day ago';
    return '$daysSince days ago';
  }

  _GapResult? _compute() {
    if (data.allDone.length < 2) return null;

    final dates = data.allDone
        .map((a) => KDate.startOfDay(a.date))
        .toSet()
        .toList()
      ..sort();

    var maxGap = 0;
    var gapStart = dates.first;
    var gapEnd = dates.first;

    for (var i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff > maxGap) {
        maxGap = diff;
        gapStart = dates[i - 1];
        gapEnd = dates[i];
      }
    }

    return _GapResult(days: maxGap, startDate: gapStart, endDate: gapEnd);
  }
}

class _GapResult {
  const _GapResult({
    required this.days,
    required this.startDate,
    required this.endDate,
  });

  final int days;
  final DateTime startDate;
  final DateTime endDate;
}

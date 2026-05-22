import 'package:flutter/material.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class MonthlyTrends extends StatelessWidget {
  const MonthlyTrends({required this.data, super.key});

  final StatsData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final months = _compute();
    if (months.isEmpty) {
      return ProStatCard(
        title: 'Monthly trends',
        subtitle: 'Last 12 months',
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: KSpace.s4),
            child: Text(
              'No data yet',
              style: KText.bodySm.copyWith(color: colors.fgTertiary),
            ),
          ),
        ),
      );
    }
    final max = months.fold<int>(0, (m, e) => e.count > m ? e.count : m);

    return ProStatCard(
      title: 'Monthly trends',
      subtitle: 'Last 12 months',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(months.length, (i) {
          final m = months[i];
          final fraction = max == 0 ? 0.0 : m.count / max;
          final isMax = m.count == max && max > 0;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 0 : 2,
                right: i == months.length - 1 ? 0 : 2,
              ),
              child: Column(
                children: [
                  if (m.count > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        '${m.count}',
                        style: KText.caption.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: isMax ? colors.accent : colors.fgTertiary,
                        ),
                      ),
                    ),
                  Container(
                    height: max == 0 ? 4 : (fraction * 70).clamp(4.0, 70.0),
                    decoration: BoxDecoration(
                      color: isMax
                          ? colors.accent
                          : colors.accent.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    m.label,
                    style: KText.caption.copyWith(
                      fontSize: 9,
                      color: colors.fgTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  List<_MonthEntry> _compute() {
    final now = DateTime.now();
    final entries = <_MonthEntry>[];
    for (var i = 11; i >= 0; i--) {
      var year = now.year;
      var month = now.month - i;
      while (month <= 0) {
        month += 12;
        year--;
      }
      final count = data.allDone.where((a) =>
          a.date.year == year && a.date.month == month).length;
      entries.add(_MonthEntry(
        label: KDate.shortMonths[month - 1],
        count: count,
      ));
    }
    return entries;
  }
}

class _MonthEntry {
  const _MonthEntry({required this.label, required this.count});

  final String label;
  final int count;
}

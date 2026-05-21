import 'package:flutter/material.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class BestDayOfWeek extends StatelessWidget {
  const BestDayOfWeek({
    required this.data,
    required this.startDay,
    super.key,
  });

  final StatsData data;
  final int startDay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final counts = _compute();
    final max = counts.fold<int>(0, (m, v) => v > m ? v : m);
    final labels = KDate.orderedMinWeekdays(startDay);

    return ProStatCard(
      title: 'Best day of week',
      subtitle: 'Done sessions',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final fraction = max == 0 ? 0.0 : counts[i] / max;
          final isMax = counts[i] == max && max > 0;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 0 : 3,
                right: i == 6 ? 0 : 3,
              ),
              child: Column(
                children: [
                  if (counts[i] > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${counts[i]}',
                        style: KText.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isMax ? colors.accent : colors.fgTertiary,
                        ),
                      ),
                    ),
                  Container(
                    height: max == 0 ? 4 : (fraction * 80).clamp(4.0, 80.0),
                    decoration: BoxDecoration(
                      color: isMax
                          ? colors.accent
                          : colors.accent.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[i],
                    style: KText.caption.copyWith(
                      fontSize: 10,
                      color: isMax ? colors.fgPrimary : colors.fgTertiary,
                      fontWeight: isMax ? FontWeight.w600 : FontWeight.w400,
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

  List<int> _compute() {
    final counts = List<int>.filled(7, 0);
    for (final a in data.allDone) {
      final dayIndex = startDay == DateTime.sunday
          ? (a.date.weekday % 7)
          : (a.date.weekday - 1);
      counts[dayIndex]++;
    }
    return counts;
  }
}

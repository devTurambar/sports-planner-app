import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class ActivityVariety extends StatelessWidget {
  const ActivityVariety({
    required this.data,
    required this.startDay,
    super.key,
  });

  final StatsData data;
  final int startDay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weeks = _compute();
    final max = weeks.fold<int>(0, (m, w) => w.typeCount > m ? w.typeCount : m);
    final allTimeTypes = data.allDone
        .map((a) => a.type)
        .where((t) => t != null)
        .toSet()
        .length;

    final loc = AppLocalizations.of(context)!;
    return ProStatCard(
      title: loc.statsActivityVarietyTitle,
      subtitle: loc.statsTypesAllTime(allTimeTypes),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(weeks.length, (i) {
              final w = weeks[i];
              final fraction = max == 0 ? 0.0 : w.typeCount / max;
              final isCurrent = i == weeks.length - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 2,
                    right: i == weeks.length - 1 ? 0 : 2,
                  ),
                  child: Column(
                    children: [
                      if (w.typeCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            '${w.typeCount}',
                            style: KText.caption.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: isCurrent
                                  ? colors.typeWalk.tint
                                  : colors.fgTertiary,
                            ),
                          ),
                        ),
                      Container(
                        height: max == 0
                            ? 4
                            : (fraction * 60).clamp(4.0, 60.0),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? colors.typeWalk.tint
                              : colors.typeWalk.tint.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: KSpace.s2),
          Row(
            children: [
              Text(
                loc.statsDifferentTypesPerWeek,
                style: KText.caption.copyWith(
                  fontSize: 10,
                  color: colors.fgTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<_WeekVariety> _compute() {
    final now = DateTime.now();
    final thisWeekStart = KDate.startOfWeek(now, startDay);
    final entries = <_WeekVariety>[];
    for (var i = 11; i >= 0; i--) {
      final ws = thisWeekStart.subtract(Duration(days: 7 * i));
      final end = ws.add(const Duration(days: 7));
      final types = data.allDone
          .where((a) => !a.date.isBefore(ws) && a.date.isBefore(end))
          .map((a) => a.type)
          .where((t) => t != null)
          .toSet();
      entries.add(_WeekVariety(typeCount: types.length));
    }
    return entries;
  }
}

class _WeekVariety {
  const _WeekVariety({required this.typeCount});

  final int typeCount;
}

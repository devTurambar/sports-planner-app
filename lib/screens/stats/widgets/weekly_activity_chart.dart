import 'package:flutter/material.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class WeeklyActivityChart extends StatelessWidget {
  const WeeklyActivityChart({
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
    final max = weeks.fold<int>(0, (m, w) => w.count > m ? w.count : m);
    final avg = weeks.isEmpty
        ? 0.0
        : weeks.fold<int>(0, (s, w) => s + w.count) / weeks.length;
    final thisWeek = weeks.isNotEmpty ? weeks.last.count : 0;

    return ProStatCard(
      title: 'Weekly activity',
      subtitle: 'Last 12 weeks',
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(weeks.length, (i) {
              final w = weeks[i];
              final fraction = max == 0 ? 0.0 : w.count / max;
              final isCurrent = i == weeks.length - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 2,
                    right: i == weeks.length - 1 ? 0 : 2,
                  ),
                  child: Container(
                    height: max == 0 ? 4 : (fraction * 70).clamp(4.0, 70.0),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? colors.accent
                          : colors.accent.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                      border: isCurrent
                          ? Border.all(
                              color: colors.accent,
                              width: 1.5,
                            )
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: KSpace.s2),
          Row(
            children: [
              _Label(label: 'Avg', value: avg.toStringAsFixed(1), suffix: '/wk'),
              const Spacer(),
              _Label(
                label: 'This week',
                value: '$thisWeek',
                accent: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<_WeekEntry> _compute() {
    final now = DateTime.now();
    final thisWeekStart = KDate.startOfWeek(now, startDay);
    final entries = <_WeekEntry>[];
    for (var i = 11; i >= 0; i--) {
      final ws = thisWeekStart.subtract(Duration(days: 7 * i));
      final end = ws.add(const Duration(days: 7));
      final count = data.allDone.where((a) =>
          !a.date.isBefore(ws) && a.date.isBefore(end)).length;
      entries.add(_WeekEntry(weekStart: ws, count: count));
    }
    return entries;
  }
}

class _WeekEntry {
  const _WeekEntry({required this.weekStart, required this.count});

  final DateTime weekStart;
  final int count;
}

class _Label extends StatelessWidget {
  const _Label({
    required this.label,
    required this.value,
    this.suffix,
    this.accent = false,
  });

  final String label;
  final String value;
  final String? suffix;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: KText.caption.copyWith(
            fontSize: 11,
            color: colors.fgTertiary,
          ),
        ),
        Text(
          value,
          style: KText.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: accent ? colors.accent : colors.fgSecondary,
          ),
        ),
        if (suffix != null)
          Text(
            ' $suffix',
            style: KText.caption.copyWith(
              fontSize: 11,
              color: colors.fgTertiary,
            ),
          ),
      ],
    );
  }
}

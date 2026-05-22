import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class FullYearHeatmap extends StatelessWidget {
  const FullYearHeatmap({
    required this.data,
    required this.startDay,
    super.key,
  });

  final StatsData data;
  final int startDay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cells = _compute();
    final year = DateTime.now().year;

    return ProStatCard(
      title: '$year heatmap',
      subtitle: '${cells.where((c) => c.hasActivity).length} active days',
      child: Column(
        children: [
          SizedBox(
            height: 7 * 14.0 + 6 * 2.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final weekCount = (cells.length / 7).ceil();
                final totalGap = (weekCount - 1) * 2.0;
                final cellSize =
                    ((constraints.maxWidth - totalGap) / weekCount)
                        .clamp(6.0, 14.0);
                final gridHeight = 7 * cellSize + 6 * 2.0;

                return SizedBox(
                  height: gridHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weekCount,
                    itemBuilder: (context, weekIdx) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: weekIdx < weekCount - 1 ? 2 : 0,
                        ),
                        child: Column(
                          children: List.generate(7, (dayIdx) {
                            final cellIdx = weekIdx * 7 + dayIdx;
                            if (cellIdx >= cells.length) {
                              return SizedBox(
                                width: cellSize,
                                height: cellSize + (dayIdx < 6 ? 2 : 0),
                              );
                            }
                            final cell = cells[cellIdx];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: dayIdx < 6 ? 2 : 0,
                              ),
                              child: Container(
                                width: cellSize,
                                height: cellSize,
                                decoration: BoxDecoration(
                                  color: cell.color(context),
                                  borderRadius: BorderRadius.circular(2),
                                  border: cell.isToday
                                      ? Border.all(
                                          color: colors.fgPrimary,
                                          width: 1.5,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _MonthLabelsRow(startDay: startDay),
        ],
      ),
    );
  }

  List<_YearCell> _compute() {
    final now = DateTime.now();
    final jan1 = DateTime(now.year, 1, 1);
    final startOffset = (jan1.weekday - startDay + 7) % 7;
    final gridStart = jan1.subtract(Duration(days: startOffset));
    final todayStart = KDate.startOfDay(now);

    final doneByDate = <String, ActivityType?>{};
    final plannedByDate = <String, bool>{};
    for (final a in data.allActivities) {
      if (a.date.year != now.year && a.date.year != now.year - 1) continue;
      final key = KDate.keyFor(a.date);
      if (a.status == DayStatus.done) {
        doneByDate[key] = a.type;
      } else if (a.status != DayStatus.empty) {
        plannedByDate.putIfAbsent(key, () => true);
      }
    }

    final cells = <_YearCell>[];
    var date = gridStart;
    while (date.year <= now.year) {
      if (date.isAfter(todayStart)) {
        cells.add(_YearCell.empty());
        date = date.add(const Duration(days: 1));
        continue;
      }
      final key = KDate.keyFor(date);
      final isToday = KDate.isSameDay(date, todayStart);
      if (doneByDate.containsKey(key)) {
        cells.add(_YearCell(
          type: doneByDate[key],
          isDone: true,
          isPlanned: false,
          isToday: isToday,
        ));
      } else if (plannedByDate.containsKey(key)) {
        cells.add(_YearCell(
          type: null,
          isDone: false,
          isPlanned: true,
          isToday: isToday,
        ));
      } else {
        cells.add(_YearCell(
          type: null,
          isDone: false,
          isPlanned: false,
          isToday: isToday,
        ));
      }
      date = date.add(const Duration(days: 1));
    }
    return cells;
  }
}

class _YearCell {
  const _YearCell({
    this.type,
    required this.isDone,
    required this.isPlanned,
    required this.isToday,
  });

  _YearCell.empty()
      : type = null,
        isDone = false,
        isPlanned = false,
        isToday = false;

  final ActivityType? type;
  final bool isDone;
  final bool isPlanned;
  final bool isToday;

  bool get hasActivity => isDone || isPlanned;

  Color color(BuildContext context) {
    final colors = context.colors;
    if (isDone) {
      final tint = type != null
          ? context.typeColor(type).tint
          : colors.accent;
      return tint;
    }
    if (isPlanned) {
      return colors.accent.withValues(alpha: 0.2);
    }
    return colors.fgTertiary.withValues(alpha: 0.06);
  }
}

class _MonthLabelsRow extends StatelessWidget {
  const _MonthLabelsRow({required this.startDay});

  final int startDay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const labels = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map((m) => Text(
                m,
                style: KText.caption.copyWith(
                  fontSize: 8,
                  color: colors.fgTertiary,
                ),
              ))
          .toList(),
    );
  }
}

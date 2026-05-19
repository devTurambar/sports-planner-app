import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_heatmap_cell.dart';

class MonthDayCell extends StatelessWidget {
  const MonthDayCell({
    required this.day,
    required this.status,
    required this.selected,
    required this.onTap,
    this.onLongPress,
    this.type,
    this.secondaryType,
    this.sessionCount = 0,
    super.key,
  });

  final int day;
  final DayStatus status;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final ActivityType? type;
  final ActivityType? secondaryType;
  final int sessionCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isToday = status == DayStatus.today;
    final isDone = status == DayStatus.done;
    final isEmpty = status == DayStatus.empty;
    final hasActivity = !isEmpty && type != null;
    final tc = hasActivity ? context.typeColor(type!) : null;
    final tint = tc?.tint;

    final int level;
    if (isDone) {
      level = 4;
    } else if (status == DayStatus.today || status == DayStatus.planned) {
      level = 1;
    } else {
      level = 0;
    }

    final bgColor = hasActivity
        ? colors.heatLevel(tint!, level)
        : colors.bgCard;

    final bool darkText = hasActivity && level >= 3;
    final numberColor = darkText
        ? const Color(0xFF0A0A08)
        : isToday
            ? colors.fgPrimary
            : hasActivity
                ? colors.fgSecondary
                : colors.fgTertiary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(9),
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedContainer(
            duration: KMotion.fast,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: isToday
                  ? Border.all(color: colors.fgPrimary, width: 1.5)
                  : selected
                      ? Border.all(color: colors.fgPrimary, width: 1.5)
                      : Border.all(color: colors.borderSubtle),
            ),
            child: CustomPaint(
              painter: !hasActivity
                  ? KEmptyDayPainter(
                      dotColor: colors.fgTertiary.withValues(alpha: 0.18),
                    )
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(5),
                child: Stack(
                  children: [
                    Text(
                      day.toString(),
                      style: KText.bodySm.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: numberColor,
                        height: 1,
                      ),
                    ),
                    if (hasActivity)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: darkText
                                ? const Color(0xFF0A0A08)
                                : tint!,
                          ),
                        ),
                      ),
                    if (secondaryType != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: context.typeColor(secondaryType!).tint,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: colors.bgBase,
                                spreadRadius: 1.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';

/// Single cell in the month grid. The cell itself is square; content is a
/// day number with a shape underneath that signals status without relying
/// on color alone.
class MonthDayCell extends StatelessWidget {
  const MonthDayCell({
    required this.day,
    required this.status,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final int day;
  final DayStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final isToday = status == DayStatus.today;
    final isDone = status == DayStatus.done;
    final isPlan = status == DayStatus.planned;
    final isRest = status == DayStatus.rest;

    Color? bg;
    Border? border;
    Color numberColor = colors.fgPrimary;

    if (isToday) {
      bg = colors.accent;
      numberColor = colors.accentFg;
    } else if (isDone) {
      bg = colors.accentLight;
      numberColor = colors.accent;
    } else if (isRest) {
      numberColor = colors.fgDisabled;
    }

    if (selected) {
      bg ??= colors.bgWash;
      if (!isToday) {
        border = Border.all(color: colors.accent, width: 1.5);
      }
    }

    Widget? indicator;
    if (isDone) {
      indicator = _Shape.dot(color: colors.accent);
    } else if (isPlan) {
      indicator = _Shape.ring(color: colors.fgTertiary);
    } else if (isToday) {
      indicator = _Shape.dot(color: colors.accentFg.withValues(alpha: 0.7));
    } else if (isRest) {
      indicator = _Shape.dash(color: colors.fgDisabled);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedContainer(
            duration: KMotion.fast,
            decoration: BoxDecoration(
              color: bg,
              border: border,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  day.toString(),
                  style: KText.bodySm.copyWith(
                    fontSize: 13,
                    height: 1,
                    fontWeight: isToday
                        ? FontWeight.w700
                        : isDone
                            ? FontWeight.w600
                            : FontWeight.w400,
                    color: numberColor,
                  ),
                ),
                if (indicator != null) ...<Widget>[
                  const SizedBox(height: 3),
                  indicator,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A tiny visual indicator. Factory constructors keep callsites readable.
class _Shape extends StatelessWidget {
  const _Shape.dot({required this.color})
      : _variant = _ShapeVariant.dot,
        size = 5;

  const _Shape.ring({required this.color})
      : _variant = _ShapeVariant.ring,
        size = 5;

  const _Shape.dash({required this.color})
      : _variant = _ShapeVariant.dash,
        size = 8;

  final Color color;
  final double size;
  final _ShapeVariant _variant;

  @override
  Widget build(BuildContext context) {
    switch (_variant) {
      case _ShapeVariant.dot:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      case _ShapeVariant.ring:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
        );
      case _ShapeVariant.dash:
        return Container(
          width: size,
          height: 1.5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        );
    }
  }
}

enum _ShapeVariant { dot, ring, dash }

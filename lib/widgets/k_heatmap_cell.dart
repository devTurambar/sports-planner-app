import 'package:flutter/material.dart';

import '../theme/kadence_colors.dart';

class KEmptyDayPainter extends CustomPainter {
  KEmptyDayPainter({required this.dotColor});

  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    const spacing = 6.0;
    const radius = 1.0;
    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(KEmptyDayPainter oldDelegate) =>
      dotColor != oldDelegate.dotColor;
}

class KHeatmapCell extends StatelessWidget {
  const KHeatmapCell({
    super.key,
    required this.tint,
    required this.level,
    this.isToday = false,
    this.size,
    this.borderRadius = 3,
    this.secondaryTint,
  });

  final Color? tint;
  final int level;
  final bool isToday;
  final double? size;
  final double borderRadius;
  final Color? secondaryTint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final empty = level == 0 || tint == null;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: empty
            ? KEmptyDayPainter(
                dotColor: colors.fgTertiary.withValues(alpha: 0.18),
              )
            : null,
        child: Container(
          decoration: BoxDecoration(
            color: empty ? colors.bgCard : colors.heatLevel(tint!, level),
            borderRadius: BorderRadius.circular(borderRadius),
            border: isToday
                ? Border.all(color: colors.fgPrimary, width: 1.5)
                : null,
          ),
          child: secondaryTint != null
              ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: secondaryTint,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: colors.bgBase,
                          spreadRadius: 1.5,
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

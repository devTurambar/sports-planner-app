import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class CompletionRate extends StatelessWidget {
  const CompletionRate({required this.data, super.key});

  final StatsData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = data.allActivities
        .where((a) => a.status != DayStatus.empty)
        .length;
    final done = data.totalSessions;
    final rate = total == 0 ? 0.0 : done / total;
    final pct = (rate * 100).round();

    return ProStatCard(
      title: 'Completion rate',
      subtitle: 'Planned vs done',
      child: Row(
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: _ArcPainter(
                fraction: rate,
                trackColor: colors.bgSubtle,
                fillColor: colors.accent,
              ),
              child: Center(
                child: Text(
                  '$pct%',
                  style: KText.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: KSpace.s5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Stat(
                  label: 'Planned',
                  value: '$total',
                  color: colors.fgSecondary,
                ),
                const SizedBox(height: KSpace.s2),
                _Stat(
                  label: 'Done',
                  value: '$done',
                  color: colors.accent,
                ),
                const SizedBox(height: KSpace.s2),
                _Stat(
                  label: 'Missed',
                  value: '${total - done}',
                  color: colors.fgTertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: KText.bodySm.copyWith(color: colors.fgSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: KText.bodySm.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.fgPrimary,
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.fraction,
    required this.trackColor,
    required this.fillColor,
  });

  final double fraction;
  final Color trackColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 5;
    const strokeWidth = 8.0;
    const startAngle = -math.pi / 2;
    const fullSweep = 2 * math.pi;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        fullSweep * fraction,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.fraction != fraction ||
      old.trackColor != trackColor ||
      old.fillColor != fillColor;
}

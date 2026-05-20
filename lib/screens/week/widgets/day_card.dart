import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../models/activity.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/k_type_tile.dart';

class DayCard extends StatelessWidget {
  const DayCard({
    required this.activity,
    required this.onTap,
    required this.onCheckTap,
    this.onLongPress,
    this.extras = 0,
    this.secondaryType,
    super.key,
  });

  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback onCheckTap;
  final VoidCallback? onLongPress;
  final int extras;
  final ActivityType? secondaryType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = activity.status;
    final isToday = status == DayStatus.today;
    final isEmpty = status == DayStatus.empty;
    final type = activity.type;
    final tc = type != null ? context.typeColor(type) : null;
    final tint = tc?.tint ?? colors.fgTertiary;

    final borderColor = isToday
        ? tint
        : isEmpty
            ? colors.borderSubtle
            : colors.borderSubtle;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onCheckTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(KRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: isEmpty ? Colors.transparent : colors.bgCard,
            borderRadius: BorderRadius.circular(KRadius.lg),
            border: isEmpty
                ? null
                : Border.all(color: borderColor, width: isToday ? 1.5 : 1),
            boxShadow: isEmpty ? null : [],
          ),
          child: CustomPaint(
            painter: isEmpty
                ? _DashedBorderPainter(color: colors.borderSubtle)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: KSpace.s3,
                vertical: KSpace.s3,
              ),
              child: Row(
                children: <Widget>[
                  if (!isEmpty) ...[
                    _TypeStripe(
                      tint: tint,
                      secondaryTint: secondaryType != null
                          ? context.typeColor(secondaryType!).tint
                          : null,
                    ),
                    const SizedBox(width: KSpace.s2),
                  ],
                  _DayStamp(activity: activity, tint: tint),
                  const SizedBox(width: KSpace.s2 + 2),
                  if (type != null) ...[
                    KTypeTile(type: type),
                    const SizedBox(width: KSpace.s2 + 2),
                  ],
                  Expanded(
                    child: _Content(
                      activity: activity,
                      extras: extras,
                      tint: tint,
                    ),
                  ),
                  const SizedBox(width: KSpace.s2),
                  _CheckButton(
                    activity: activity,
                    onTap: onCheckTap,
                    tint: tint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeStripe extends StatelessWidget {
  const _TypeStripe({required this.tint, this.secondaryTint});

  final Color tint;
  final Color? secondaryTint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: secondaryTint != null
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [tint, secondaryTint!],
                stops: const [0.6, 0.6],
              )
            : null,
        color: secondaryTint == null ? tint : null,
      ),
    );
  }
}

class _DayStamp extends StatelessWidget {
  const _DayStamp({required this.activity, required this.tint});

  final Activity activity;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isToday = activity.status == DayStatus.today;
    return SizedBox(
      width: 30,
      child: Column(
        children: <Widget>[
          Text(
            activity.date.weekdayShort.toUpperCase(),
            style: KText.caption.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: isToday ? tint : colors.fgTertiary,
              letterSpacing: 0.6,
            ),
          ),
          Text(
            activity.date.day.toString(),
            style: KText.body.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isToday ? tint : colors.fgSecondary,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.activity,
    this.extras = 0,
    required this.tint,
  });

  final Activity activity;
  final int extras;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = activity.status;

    if (status == DayStatus.empty) {
      final today = TodayScope.of(context);
      final isPast = activity.date.isBefore(KDate.startOfDay(today));
      return Text(
        isPast ? 'Rest day' : 'No session',
        style: KText.body.copyWith(
          color: colors.fgTertiary,
          fontSize: 14,
        ),
      );
    }

    final isDone = status == DayStatus.done;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(
                activity.name ?? '—',
                style: KText.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDone ? colors.fgTertiary : colors.fgPrimary,
                  decoration:
                      isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: colors.fgTertiary,
                ),
              ),
            ),
            if (extras > 0) ...<Widget>[
              const SizedBox(width: 6),
              _MoreBadge(count: extras, tint: tint),
            ],
          ],
        ),
        if (activity.timeOfDay != null || activity.duration != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(
            activity.formattedMeta(false) ?? '',
            style: KText.caption.copyWith(
              fontSize: 11,
              color: colors.fgSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _MoreBadge extends StatelessWidget {
  const _MoreBadge({required this.count, required this.tint});

  final int count;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Color.lerp(Colors.transparent, tint, 0.16),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '+$count more',
        style: KText.caption.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: tint,
        ),
      ),
    );
  }
}

class _CheckButton extends StatelessWidget {
  const _CheckButton({
    required this.activity,
    required this.onTap,
    required this.tint,
  });

  final Activity activity;
  final VoidCallback onTap;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = activity.status;
    final isDone = status == DayStatus.done;
    final isEmpty = status == DayStatus.empty;

    final bg = isDone ? tint : Colors.transparent;
    final fg = isDone
        ? const Color(0xFF0A0A08)
        : isEmpty
            ? colors.fgTertiary
            : colors.borderStrong;

    final IconData icon;
    if (isDone) {
      icon = LucideIcons.check;
    } else if (isEmpty) {
      icon = LucideIcons.plus;
    } else {
      icon = LucideIcons.circleDashed;
    }

    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isDone
                ? null
                : Border.all(color: colors.borderStrong, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 14, color: fg),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const radius = Radius.circular(KRadius.lg);
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, radius);
    final path = Path()..addRRect(rrect);
    _drawDashedPath(canvas, path, paint, dashWidth: 5, dashSpace: 3);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashWidth,
    required double dashSpace,
  }) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(
            distance,
            end > metric.length ? metric.length : end,
          ),
          paint,
        );
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

extension on DateTime {
  String get weekdayShort {
    const names = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }
}

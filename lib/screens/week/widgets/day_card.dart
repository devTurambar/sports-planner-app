import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';

/// A row in the week list. Structure: day/date column, status dot,
/// activity block, and a tappable check/action circle on the right.
class DayCard extends StatelessWidget {
  const DayCard({
    required this.activity,
    required this.onTap,
    required this.onCheckTap,
    this.extras = 0,
    super.key,
  });

  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback onCheckTap;

  /// Count of additional activities on the same day, beyond [activity].
  /// When greater than 0 a "+N" badge is shown.
  final int extras;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = activity.status;

    final isToday = status == DayStatus.today;
    final isDone = status == DayStatus.done;
    final isEmpty = status == DayStatus.empty;

    final borderColor = isToday
        ? colors.accent
        : isDone
            ? colors.accentMuted
            : isEmpty
                ? colors.borderSubtle
                : colors.border;

    final background = (isToday || isDone)
        ? colors.accentLight.withValues(
            alpha: Theme.of(context).brightness == Brightness.light ? 0.3 : 1)
        : isEmpty
            ? Colors.transparent
            : colors.bgElevated;

    final dotColor =
        isToday || isDone ? colors.accent : colors.fgDisabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(KRadius.lg),
            border: isEmpty
                ? null
                : Border.all(color: borderColor, width: 1),
          ),
          child: CustomPaint(
            painter: isEmpty
                ? _DashedBorderPainter(color: colors.border)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: KSpace.s4,
                vertical: KSpace.s3 + 1,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 64),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  _DayStamp(activity: activity),
                  const SizedBox(width: KSpace.s3 + 2),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: KSpace.s3 + 2),
                  Expanded(child: _Content(activity: activity, extras: extras)),
                  const SizedBox(width: KSpace.s2),
                  _CheckButton(activity: activity, onTap: onCheckTap),
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

class _DayStamp extends StatelessWidget {
  const _DayStamp({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isToday = activity.status == DayStatus.today;
    return SizedBox(
      width: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            activity.date.weekdayShort.toUpperCase(),
            style: KText.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isToday ? colors.accent : colors.fgTertiary,
              letterSpacing: 0.44,
            ),
          ),
          Text(
            activity.date.day.toString(),
            style: KText.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isToday ? colors.accent : colors.fgSecondary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.activity, this.extras = 0});

  final Activity activity;
  final int extras;

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
          color: colors.fgSecondary,
          fontSize: 14,
        ),
      );
    }

    final isDone = status == DayStatus.done;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                activity.name ?? '—',
                style: KText.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDone ? colors.accentMuted : colors.fgPrimary,
                  decoration: isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: colors.accentMuted,
                ),
              ),
            ),
            if (extras > 0) ...<Widget>[
              const SizedBox(width: 6),
              _MoreBadge(count: extras),
            ],
          ],
        ),
        if (activity.meta != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(
            activity.meta!,
            style: KText.caption.copyWith(color: colors.fgSecondary),
          ),
        ],
        if (activity.type != null) ...<Widget>[
          const SizedBox(height: 5),
          _TypePill(type: activity.type!),
        ],
      ],
    );
  }
}

class _MoreBadge extends StatelessWidget {
  const _MoreBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: colors.accentLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '+$count more',
        style: KText.caption.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: colors.accent,
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.type});

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        type.label,
        style: KText.caption.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: colors.fgSecondary,
        ),
      ),
    );
  }
}

class _CheckButton extends StatelessWidget {
  const _CheckButton({required this.activity, required this.onTap});

  final Activity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = activity.status;
    final isDone = status == DayStatus.done;
    final isToday = status == DayStatus.today;
    final isEmpty = status == DayStatus.empty;

    final bg = isDone
        ? colors.accent
        : isToday
            ? colors.accentLight
            : colors.bgSubtle;

    final fg = isDone
        ? colors.accentFg
        : isToday
            ? colors.accent
            : colors.fgDisabled;

    final IconData icon;
    if (isDone) {
      icon = LucideIcons.check;
    } else if (isEmpty) {
      icon = LucideIcons.plus;
    } else {
      icon = LucideIcons.circleDashed;
    }

    return Material(
      color: isEmpty ? Colors.transparent : bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isEmpty
                ? Border.all(color: colors.border, width: 1.5)
                : null,
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

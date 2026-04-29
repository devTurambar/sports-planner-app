import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_text_styles.dart';

/// A small pill showing a day's planning status.
class KStatusChip extends StatelessWidget {
  const KStatusChip({required this.status, super.key});

  final DayStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    late final Color bg;
    late final Color fg;
    late final String label;
    late final Widget icon;

    switch (status) {
      case DayStatus.done:
        bg = colors.statusDoneBg;
        fg = colors.statusDone;
        label = 'Done';
        icon = _Dot(size: 6, color: fg);
        break;
      case DayStatus.today:
        bg = colors.accentLight;
        fg = colors.accent;
        label = 'Today';
        icon = _Dot(size: 6, color: fg, filled: false);
        break;
      case DayStatus.planned:
        bg = colors.statusPlannedBg;
        fg = colors.fgSecondary;
        label = 'Planned';
        icon = _Dot(size: 6, color: colors.statusPlanned, filled: false);
        break;
      case DayStatus.empty:
        bg = colors.bgSubtle;
        fg = colors.fgTertiary;
        label = 'Open';
        icon = _Dot(size: 6, color: fg, filled: false);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          const SizedBox(width: 5),
          Text(
            label,
            style: KText.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color, this.filled = true});

  final double size;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : Colors.transparent,
        border: filled ? null : Border.all(color: color, width: 1.5),
      ),
    );
  }
}

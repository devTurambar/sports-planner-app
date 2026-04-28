import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';

/// Expandable detail card that appears below the grid when the user taps a
/// day. Mirrors the status-specific layouts from the prototype.
class SelectedDayCard extends StatelessWidget {
  const SelectedDayCard({
    required this.activity,
    required this.onClose,
    required this.onEdit,
    required this.onAdd,
    super.key,
  });

  final Activity activity;
  final VoidCallback onClose;
  final VoidCallback onEdit;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: BorderRadius.circular(KRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Header(activity: activity, onClose: onClose),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
            child: _Body(
              activity: activity,
              onEdit: onEdit,
              onAdd: onAdd,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.activity, required this.onClose});

  final Activity activity;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final date = activity.date;
    final label =
        '${date.shortWeekday.toUpperCase()} · ${date.shortMonth} ${date.day}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 11, 10, 11),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: KText.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.fgTertiary,
                letterSpacing: 0.6,
              ),
            ),
          ),
          InkWell(
            onTap: onClose,
            customBorder: const CircleBorder(),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: colors.bgSubtle,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(LucideIcons.x, size: 12, color: colors.fgTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.activity,
    required this.onEdit,
    required this.onAdd,
  });

  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    switch (activity.status) {
      case DayStatus.done:
        return _Row(
          icon: _DotIcon(color: colors.accent, background: colors.accentLight),
          title: activity.name ?? 'Session',
          titleStrike: true,
          chipLabel: 'Done',
          chipBg: colors.accentLight,
          chipFg: colors.accent,
          trailing: _CheckCircle(color: colors.accent, fg: colors.accentFg),
          onTap: onEdit,
        );
      case DayStatus.today:
        return _Row(
          icon: _DotIcon(color: colors.accent, background: colors.accentLight),
          title: activity.name ?? 'Session',
          chipLabel: 'Today',
          chipBg: colors.accentLight,
          chipFg: colors.accent,
          trailing: _CheckCircle(
            color: colors.accentLight,
            fg: colors.accent,
            icon: LucideIcons.circleDashed,
          ),
          onTap: onEdit,
        );
      case DayStatus.planned:
        return _Row(
          icon: _RingIcon(color: colors.fgTertiary, background: colors.bgSubtle),
          title: activity.name ?? 'Session planned',
          chipLabel: 'Planned',
          chipBg: colors.bgSubtle,
          chipFg: colors.fgSecondary,
          onTap: onEdit,
        );
      case DayStatus.rest:
        return Row(
          children: <Widget>[
            _DashIcon(background: colors.bgSubtle, color: colors.fgDisabled),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Rest day',
                style: KText.bodySm.copyWith(
                  color: colors.fgTertiary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      case DayStatus.empty:
        return Row(
          children: <Widget>[
            _PlusIcon(background: colors.bgSubtle, color: colors.fgDisabled),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Nothing planned',
                style: KText.caption.copyWith(
                  color: colors.fgTertiary,
                  fontSize: 13,
                ),
              ),
            ),
            _AddButton(onPressed: onAdd),
          ],
        );
    }
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.chipLabel,
    required this.chipBg,
    required this.chipFg,
    this.trailing,
    this.titleStrike = false,
    this.onTap,
  });

  final Widget icon;
  final String title;
  final String chipLabel;
  final Color chipBg;
  final Color chipFg;
  final Widget? trailing;
  final bool titleStrike;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(KRadius.sm),
      child: Row(
        children: <Widget>[
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: KText.bodySm.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.fgPrimary,
                    decoration: titleStrike
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    chipLabel,
                    style: KText.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: chipFg,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _DotIcon extends StatelessWidget {
  const _DotIcon({required this.color, required this.background});
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(9),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      );
}

class _RingIcon extends StatelessWidget {
  const _RingIcon({required this.color, required this.background});
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(9),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
      );
}

class _DashIcon extends StatelessWidget {
  const _DashIcon({required this.color, required this.background});
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(9),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 14,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

class _PlusIcon extends StatelessWidget {
  const _PlusIcon({required this.color, required this.background});
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context)
        .extension<KadenceColors>()!
        .border;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Icon(LucideIcons.plus, color: color, size: 16),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({
    required this.color,
    required this.fg,
    this.icon = LucideIcons.check,
  });

  final Color color;
  final Color fg;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, size: 14, color: fg),
      );
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.accent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'Add',
            style: KText.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.accentFg,
            ),
          ),
        ),
      ),
    );
  }
}

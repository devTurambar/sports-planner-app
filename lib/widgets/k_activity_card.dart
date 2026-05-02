import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/activity.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_spacing.dart';
import '../theme/kadence_text_styles.dart';

/// A bordered card that renders one [Activity]: name + status chip,
/// optional meta line, and a trailing affordance (a check button when
/// [onCheckTap] is provided, otherwise a chevron). Used wherever the
/// app shows a list of activities (the day overview sheet, the month
/// view's selected-day card, etc.).
class KActivityCard extends StatelessWidget {
  const KActivityCard({
    required this.activity,
    required this.onTap,
    this.onCheckTap,
    super.key,
  });

  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback? onCheckTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = activity.status;
    final isDone = status == DayStatus.done;

    final (chipLabel, chipBg, chipFg) = switch (status) {
      DayStatus.done => ('Done', colors.accentLight, colors.accent),
      DayStatus.today => ('Today', colors.accentLight, colors.accent),
      DayStatus.planned => ('Planned', colors.bgSubtle, colors.fgSecondary),
      DayStatus.empty => ('—', colors.bgSubtle, colors.fgSecondary),
    };

    return Material(
      color: colors.bgElevated,
      borderRadius: BorderRadius.circular(KRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KRadius.md),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(KRadius.md),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            activity.name ?? 'Session',
                            style: KText.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colors.fgPrimary,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusChip(label: chipLabel, bg: chipBg, fg: chipFg),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Visibility(
                      visible: activity.meta != null,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Text(
                        activity.meta ?? '',
                        style: KText.caption.copyWith(
                          color: colors.fgSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onCheckTap != null)
                _CheckButton(activity: activity, onTap: onCheckTap!)
              else
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: colors.fgTertiary,
                ),
            ],
          ),
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
    final icon = isDone ? LucideIcons.check : LucideIcons.circleDashed;

    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(icon, size: 14, color: fg),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.bg,
    required this.fg,
  });

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: KText.caption.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}

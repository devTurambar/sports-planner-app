import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/activity.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_spacing.dart';
import '../theme/kadence_text_styles.dart';
import 'k_type_tile.dart';

class KActivityCard extends StatelessWidget {
  const KActivityCard({
    required this.activity,
    required this.onTap,
    this.onCheckTap,
    this.onLongPress,
    super.key,
  });

  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback? onCheckTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = activity.status;
    final isDone = status == DayStatus.done;
    final type = activity.type;
    final tc = type != null ? context.typeColor(type) : null;
    final tint = tc?.tint ?? colors.fgTertiary;
    final bg = tc?.bg ?? colors.bgCard;

    final statusLabel = switch (status) {
      DayStatus.done => 'DONE',
      DayStatus.today => 'TODAY',
      DayStatus.planned => 'PLANNED',
      DayStatus.empty => '',
    };

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(KRadius.lg + 4),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(KRadius.lg + 4),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: tc != null
                  ? tint.withValues(alpha: 0.18)
                  : colors.borderSubtle,
            ),
            borderRadius: BorderRadius.circular(KRadius.lg + 4),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              if (type != null) ...[
                KTypeTile(type: type, size: 44, iconSize: 20),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            activity.name ?? 'Session',
                            style: KText.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.fgPrimary,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: colors.fgTertiary,
                            ),
                          ),
                        ),
                        if (statusLabel.isNotEmpty)
                          Text(
                            statusLabel,
                            style: KText.caption.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: tint,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Visibility(
                      visible: activity.timeOfDay != null ||
                          activity.duration != null,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Text(
                        activity.formattedMeta(false) ?? '',
                        style: KText.caption.copyWith(
                          fontSize: 11,
                          color: colors.fgSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onCheckTap != null)
                _CheckButton(isDone: isDone, tint: tint, onTap: onCheckTap!)
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
  const _CheckButton({
    required this.isDone,
    required this.tint,
    required this.onTap,
  });

  final bool isDone;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bg = isDone ? tint : Colors.transparent;
    final fg = isDone ? const Color(0xFF0A0A08) : colors.borderStrong;

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
          child: Icon(
            isDone ? LucideIcons.check : LucideIcons.circleDashed,
            size: 14,
            color: fg,
          ),
        ),
      ),
    );
  }
}

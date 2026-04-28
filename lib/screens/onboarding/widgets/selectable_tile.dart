import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';

/// A multi-select tile used across several onboarding steps (sports, days,
/// reminder choice). Selecting fills the tile with the accent wash and
/// marks it with a check.
class SelectableTile extends StatelessWidget {
  const SelectableTile({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.checkAlignment = Alignment.centerRight,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  final Alignment checkAlignment;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = selected ? colors.accent : colors.border;
    return AnimatedContainer(
      duration: KMotion.fast,
      decoration: BoxDecoration(
        color: selected ? colors.accentLight : colors.bgElevated,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(KRadius.lg),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: KSpace.s4,
              vertical: KSpace.s3 + 1,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 22,
                    color: selected ? colors.accent : colors.fgSecondary,
                  ),
                  const SizedBox(width: KSpace.s3),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: KText.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: selected ? colors.accent : colors.fgPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: KText.caption.copyWith(
                            color: selected
                                ? colors.accentMuted
                                : colors.fgTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _CheckIndicator(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckIndicator extends StatelessWidget {
  const _CheckIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: KMotion.fast,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: selected ? colors.accent : Colors.transparent,
        border: Border.all(
          color: selected ? colors.accent : colors.border,
          width: 1.5,
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: selected
          ? Icon(LucideIcons.check, size: 12, color: colors.accentFg)
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';

String _format12h(TimeOfDay t) {
  final h = t.hour;
  final m = t.minute.toString().padLeft(2, '0');
  final period = h >= 12 ? 'PM' : 'AM';
  final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
  return '$hour12:$m $period';
}

class TimePickerField extends StatelessWidget {
  const TimePickerField({
    required this.value,
    required this.onTap,
    this.onClear,
    super.key,
  });

  final TimeOfDay? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasValue = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Time',
          style: KText.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.fgSecondary,
          ),
        ),
        const SizedBox(height: KSpace.s1 + 1),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(KRadius.md),
            child: AnimatedContainer(
              duration: KMotion.base,
              decoration: BoxDecoration(
                color: colors.bgElevated,
                borderRadius: BorderRadius.circular(KRadius.md),
                border: Border.all(
                  color: hasValue ? colors.accent : colors.border,
                  width: 1.5,
                ),
                boxShadow: hasValue
                    ? <BoxShadow>[
                        BoxShadow(
                          color: colors.accentLight,
                          blurRadius: 0,
                          spreadRadius: 3,
                        ),
                      ]
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      hasValue ? _format12h(value!) : 'Set time',
                      style: KText.body.copyWith(
                        color: hasValue ? colors.fgPrimary : colors.fgTertiary,
                      ),
                    ),
                  ),
                  if (hasValue)
                    GestureDetector(
                      onTap: onClear,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          LucideIcons.x,
                          size: 14,
                          color: colors.fgTertiary,
                        ),
                      ),
                    )
                  else
                    Icon(
                      LucideIcons.clock,
                      size: 16,
                      color: colors.fgTertiary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

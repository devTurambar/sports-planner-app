import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';

class TypeSelector extends StatelessWidget {
  const TypeSelector({required this.value, required this.onChanged, super.key});

  final ActivityType? value;
  final ValueChanged<ActivityType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Type',
          style: KText.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.fgSecondary,
          ),
        ),
        const SizedBox(height: 7),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: ActivityType.values
              .map((t) => _TypeChip(
                    type: t,
                    selected: value == t,
                    onTap: () => onChanged(t),
                  ))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final ActivityType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.accentLight : colors.bgSubtle,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: KMotion.fast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? colors.accent : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            type.label,
            style: KText.bodySm.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? colors.accent : colors.fgSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

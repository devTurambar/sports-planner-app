import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_type_tile.dart';
import 'sub_type_sheet.dart';

class TypeSelector extends StatelessWidget {
  const TypeSelector({
    required this.value,
    required this.onChanged,
    this.subType,
    this.onSubTypeChanged,
    super.key,
  });

  final ActivityType? value;
  final ValueChanged<ActivityType> onChanged;
  final String? subType;
  final ValueChanged<String?>? onSubTypeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          loc.typeLabel,
          style: KText.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.fgSecondary,
          ),
        ),
        const SizedBox(height: 7),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: ActivityType.values
              .map((t) => _TypeChip(
                    type: t,
                    selected: value == t,
                    subTypeLabel:
                        t == ActivityType.other && value == t ? subType : null,
                    onTap: () async {
                      if (t == ActivityType.other) {
                        onChanged(t);
                        final picked = await showSubTypeSheet(context);
                        onSubTypeChanged?.call(picked);
                      } else {
                        onSubTypeChanged?.call(null);
                        onChanged(t);
                      }
                    },
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
    this.subTypeLabel,
  });

  final ActivityType type;
  final bool selected;
  final VoidCallback onTap;
  final String? subTypeLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final tc = context.typeColor(type);
    final bg = selected ? tc.bg : colors.bgSubtle;
    final border = selected ? tc.tint : Colors.transparent;
    final fg = selected ? tc.tint : colors.fgSecondary;

    final label = subTypeLabel ??
        (type == ActivityType.other ? loc.typeMore : type.localized(loc));

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: KMotion.fast,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(KTypeTile.iconFor(type), size: 14, color: fg),
              const SizedBox(width: 5),
              Text(
                label,
                style: KText.bodySm.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

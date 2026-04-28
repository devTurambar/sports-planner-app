import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../widgets/k_button.dart';

/// Shown when the week has no planned, done, or rest days. The circular
/// mini calendar illustration is drawn from primitives rather than an
/// asset so it tracks the theme and reads crisp at any density.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            KSpace.s8,
            KSpace.s8,
            KSpace.s8,
            KSpace.s16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _CalendarMark(),
              const SizedBox(height: KSpace.s6 + 4),
              Text(
                'Nothing planned yet',
                textAlign: TextAlign.center,
                style: KText.h3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colors.fgPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: KSpace.s2),
              Text(
                'Tap + to add your first session for the week.',
                textAlign: TextAlign.center,
                style: KText.bodySm.copyWith(
                  fontSize: 14,
                  color: colors.fgSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: KSpace.s6 + 4),
              KButton(
                label: 'Add activity',
                onPressed: onAdd,
                expanded: false,
                leading: Icon(
                  LucideIcons.plus,
                  size: 16,
                  color: colors.accentFg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.border, width: 1.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List<Widget>.generate(9, (i) {
                final isCenter = i == 4;
                return Container(
                  decoration: BoxDecoration(
                    color: isCenter ? colors.accentLight : colors.bgSubtle,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isCenter
                          ? colors.accent.withValues(alpha: 0.25)
                          : colors.border,
                    ),
                  ),
                );
              }),
            ),
          ),
          Icon(LucideIcons.plus, color: colors.accent, size: 20),
        ],
      ),
    );
  }
}

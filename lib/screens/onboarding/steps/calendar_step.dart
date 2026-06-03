import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_button.dart';
import '../widgets/progress_dots.dart';

/// Informs the user that activities sync with their device calendar.
class CalendarStep extends StatelessWidget {
  const CalendarStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, KSpace.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colors.accentLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      LucideIcons.calendarSync,
                      size: 28,
                      color: colors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: KSpace.s6),
                Text(
                  loc.onboardingCalendarTitle,
                  textAlign: TextAlign.center,
                  style: KText.h2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                    letterSpacing: -0.44,
                  ),
                ),
                const SizedBox(height: KSpace.s2),
                Text(
                  loc.onboardingCalendarBody,
                  textAlign: TextAlign.center,
                  style: KText.bodySm.copyWith(
                    color: colors.fgSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: KSpace.s6),
                _InfoRow(
                  icon: LucideIcons.calendarPlus,
                  text: loc.onboardingCalendarFeature1,
                  colors: colors,
                ),
                const SizedBox(height: KSpace.s2 + 2),
                _InfoRow(
                  icon: LucideIcons.refreshCw,
                  text: loc.onboardingCalendarFeature2,
                  colors: colors,
                ),
                const SizedBox(height: KSpace.s2 + 2),
                _InfoRow(
                  icon: LucideIcons.settings2,
                  text: loc.onboardingCalendarFeature3,
                  colors: colors,
                ),
              ],
            ),
          ),
          const ProgressDots(total: 3, current: 1),
          const SizedBox(height: KSpace.s1 + 2),
          KButton(label: loc.actionContinue, onPressed: onNext),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.colors,
  });

  final IconData icon;
  final String text;
  final KadenceColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: colors.accentLight,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 14, color: colors.accent),
        ),
        const SizedBox(width: KSpace.s2 + 2),
        Expanded(
          child: Text(
            text,
            style: KText.bodySm.copyWith(color: colors.fgSecondary),
          ),
        ),
      ],
    );
  }
}

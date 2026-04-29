import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_button.dart';
import '../widgets/progress_dots.dart';

/// Final onboarding screen with a mini preview of the week the user just
/// configured.
class ReadyStep extends StatelessWidget {
  const ReadyStep({
    required this.trainingDays,
    required this.onDone,
    super.key,
  });

  final List<String> trainingDays;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const weekdays = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final planned = trainingDays.toSet();

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
                Text(
                  'Your week is ready.',
                  textAlign: TextAlign.center,
                  style: KText.h2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                    letterSpacing: -0.44,
                  ),
                ),
                const SizedBox(height: KSpace.s1 + 2),
                Text(
                  "Here's a starting template based on your preferences. "
                  'Tap any day to adjust.',
                  textAlign: TextAlign.center,
                  style: KText.bodySm.copyWith(
                    color: colors.fgSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: KSpace.s5),
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgElevated,
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(KRadius.lg),
                  ),
                  child: Column(
                    children: <Widget>[
                      for (var i = 0; i < weekdays.length; i++) ...<Widget>[
                        _PreviewRow(
                          day: weekdays[i],
                          planned: planned.contains(weekdays[i]),
                        ),
                        if (i < weekdays.length - 1)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: colors.borderSubtle,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const ProgressDots(total: 5, current: 4),
          const SizedBox(height: KSpace.s1 + 2),
          KButton(label: 'Start planning', onPressed: onDone),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.day, required this.planned});

  final String day;
  final bool planned;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 32,
            child: Text(
              day.toUpperCase(),
              style: KText.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.fgTertiary,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: planned ? colors.accent : colors.border,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              planned ? 'Session planned' : 'Open',
              style: KText.bodySm.copyWith(
                color: planned ? colors.fgPrimary : colors.fgTertiary,
                fontWeight: planned ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
          if (planned)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: colors.accentLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.circleDashed,
                size: 12,
                color: colors.accent,
              ),
            ),
        ],
      ),
    );
  }
}

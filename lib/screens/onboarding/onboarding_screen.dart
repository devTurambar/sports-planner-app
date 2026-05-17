import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/onboarding_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import 'steps/days_step.dart';
import 'steps/notify_step.dart';
import 'steps/ready_step.dart';
import 'steps/signin_step.dart';
import 'steps/sport_step.dart';
import 'steps/welcome_step.dart';

/// Multi-step onboarding. State is persisted as the user advances so
/// dropping the app and coming back lands on the same step.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onFinished, super.key});

  /// Invoked after the user completes the final step.
  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  Future<void> _go(int next) async {
    if (next >= 6) {
      await context.read<OnboardingController>().complete();
      widget.onFinished();
      return;
    }
    setState(() => _step = next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onboarding = context.watch<OnboardingController>();

    final steps = <Widget>[
      WelcomeStep(onNext: () => _go(1)),
      SportStep(
        initialSelection: onboarding.sports,
        onNext: (sports) async {
          await onboarding.setSports(sports);
          _go(2);
        },
      ),
      DaysStep(
        initialSelection: onboarding.trainingDays,
        onNext: (days) async {
          await onboarding.setTrainingDays(days);
          _go(3);
        },
      ),
      NotifyStep(
        initialValue: null,
        onNext: (enabled) async {
          await onboarding.setReminders(enabled: enabled);
          _go(4);
        },
      ),
      ReadyStep(
        trainingDays: onboarding.trainingDays,
        onDone: () => _go(5),
      ),
      SignInStep(
        onSkip: () => _go(6),
      ),
    ];

    return Scaffold(
      backgroundColor: colors.bgBase,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _TopRow(
              canGoBack: _step > 0 && _step < 4 || _step == 5,
              onBack: () => _go(_step - 1),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, animation) {
                  final offset = Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: offset, child: child),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(_step),
                  child: steps[_step],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.canGoBack, required this.onBack});

  final bool canGoBack;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: KSpace.s5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: canGoBack
              ? TextButton.icon(
                  onPressed: onBack,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: colors.fgTertiary,
                  ),
                  icon: Icon(LucideIcons.chevronLeft,
                      size: 16, color: colors.fgTertiary),
                  label: Text(
                    'Back',
                    style: KText.bodySm.copyWith(color: colors.fgTertiary),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

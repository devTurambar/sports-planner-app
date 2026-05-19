import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/onboarding_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import 'steps/calendar_step.dart';
import 'steps/signin_step.dart';
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
    if (next >= 3) {
      await context.read<OnboardingController>().complete();
      widget.onFinished();
      return;
    }
    setState(() => _step = next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final steps = <Widget>[
      WelcomeStep(onNext: () => _go(1)),
      CalendarStep(onNext: () => _go(2)),
      SignInStep(onSkip: () => _go(3)),
    ];

    return Scaffold(
      backgroundColor: colors.bgBase,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _TopRow(
              canGoBack: _step > 0,
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

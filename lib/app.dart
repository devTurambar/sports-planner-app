import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/onboarding_controller.dart';
import 'state/theme_controller.dart';
import 'theme/kadence_theme.dart';
import 'utils/date_utils.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

/// Root app widget. Rebuilds the MaterialApp whenever the theme
/// controller changes mode.
class KadenceApp extends StatelessWidget {
  const KadenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    return MaterialApp(
      title: 'Kadence',
      debugShowCheckedModeBanner: false,
      themeMode: theme.mode,
      theme: buildKadenceTheme(Brightness.light),
      darkTheme: buildKadenceTheme(Brightness.dark),
      builder: (context, child) => TodayScope(child: child ?? const SizedBox()),
      home: const _AppGate(),
    );
  }
}

/// Routes between onboarding and home. Watching [OnboardingController]
/// means completing or resetting onboarding transitions automatically.
class _AppGate extends StatelessWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingController>();
    final child = onboarding.isCompleted
        ? const HomeScreen()
        : OnboardingScreen(
            key: const ValueKey<String>('onboarding'),
            onFinished: () {},
          );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: KeyedSubtree(
        key: ValueKey<bool>(onboarding.isCompleted),
        child: child,
      ),
    );
  }
}

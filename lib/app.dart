import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/generated/app_localizations.dart';
import 'state/locale_controller.dart';
import 'state/onboarding_controller.dart';
import 'state/theme_controller.dart';
import 'theme/kadence_theme.dart';
import 'utils/date_utils.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

class KadenceApp extends StatelessWidget {
  const KadenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    final localeCtrl = context.watch<LocaleController>();
    return MaterialApp(
      title: 'Kadence',
      debugShowCheckedModeBanner: false,
      themeMode: theme.mode,
      theme: buildKadenceTheme(Brightness.light),
      darkTheme: buildKadenceTheme(Brightness.dark),
      locale: localeCtrl.locale,
      supportedLocales: LocaleController.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => TodayScope(child: child ?? const SizedBox()),
      home: const _AppGate(),
    );
  }
}

/// Routes between onboarding and home. Auth is optional — users can
/// sign in from Settings when they want cloud sync.
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

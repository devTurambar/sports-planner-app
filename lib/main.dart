import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'state/onboarding_controller.dart';
import 'state/plan_controller.dart';
import 'state/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Keep the status bar transparent so the warm base background extends
  // edge-to-edge.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(prefs),
        ),
        ChangeNotifierProvider<OnboardingController>(
          create: (_) => OnboardingController(prefs),
        ),
        ChangeNotifierProvider<PlanController>(
          create: (_) => PlanController(),
        ),
      ],
      child: const KadenceApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'state/calendar_service.dart';
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

  tz.initializeTimeZones();
  final prefs = await SharedPreferences.getInstance();
  await CalendarService.init(prefs);
  final planController = await PlanController.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(prefs),
        ),
        ChangeNotifierProvider<OnboardingController>(
          create: (_) => OnboardingController(prefs),
        ),
        ChangeNotifierProvider<PlanController>.value(
          value: planController,
        ),
      ],
      child: const KadenceApp(),
    ),
  );
}

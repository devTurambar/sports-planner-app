import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'state/auth_controller.dart';
import 'state/calendar_service.dart';
import 'state/onboarding_controller.dart';
import 'state/plan_controller.dart';
import 'state/theme_controller.dart';
import 'state/locale_controller.dart';
import 'state/review_service.dart';
import 'state/goal_controller.dart';
import 'state/tip_controller.dart';
import 'state/pro_controller.dart';
import 'state/type_color_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  tz.initializeTimeZones();
  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();
  await CalendarService.init(prefs);
  ReviewService.init(prefs);
  final planController = await PlanController.create(prefs: prefs);
  final authController = AuthController(
    prefs: prefs,
    planController: planController,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(
          value: authController,
        ),
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(prefs),
        ),
        ChangeNotifierProvider<LocaleController>(
          create: (_) => LocaleController(prefs),
        ),
        ChangeNotifierProvider<OnboardingController>(
          create: (_) => OnboardingController(prefs),
        ),
        ChangeNotifierProvider<TypeColorController>(
          create: (_) => TypeColorController(prefs),
        ),
        ChangeNotifierProvider<GoalController>(
          create: (_) => GoalController(prefs),
        ),
        ChangeNotifierProvider<ProController>(
          create: (_) => ProController(prefs, authController: authController),
        ),
        ChangeNotifierProvider<TipController>(
          create: (_) => TipController(prefs),
        ),
        ChangeNotifierProvider<PlanController>.value(
          value: planController,
        ),
      ],
      child: const KadenceApp(),
    ),
  );
}

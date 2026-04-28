import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'kadence_colors.dart';

/// Builds a Material [ThemeData] for Kadence from the token set.
ThemeData buildKadenceTheme(Brightness brightness) {
  final colors =
      brightness == Brightness.dark ? KadenceColors.dark : KadenceColors.light;

  final textTheme = GoogleFonts.soraTextTheme(
    ThemeData(brightness: brightness).textTheme,
  ).apply(
    bodyColor: colors.fgPrimary,
    displayColor: colors.fgPrimary,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: colors.bgBase,
    canvasColor: colors.bgBase,
    dividerColor: colors.border,
    splashFactory: InkSparkle.splashFactory,
    highlightColor: colors.bgSubtle,
    splashColor: colors.bgSubtle,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: colors.accentFg,
      secondary: colors.accentMuted,
      onSecondary: colors.accentFg,
      surface: colors.bgElevated,
      onSurface: colors.fgPrimary,
      error: const Color(0xFFB94C4C),
      onError: Colors.white,
    ),
    textTheme: textTheme,
    iconTheme: IconThemeData(color: colors.fgSecondary, size: 24),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.bgBase,
      foregroundColor: colors.fgPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.fgPrimary,
        letterSpacing: -0.2,
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[colors],
  );
}

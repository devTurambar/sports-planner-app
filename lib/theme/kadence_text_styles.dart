import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Named text styles for Kadence. All use Sora via google_fonts.
///
/// Styles intentionally omit a color — consumers apply a color from
/// [KadenceColors] so styles reuse across light and dark.
class KText {
  const KText._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    double height = 1.5,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.sora(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      // Tabular numerals keep durations and dates aligned.
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle get display => _base(
        size: 36,
        weight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -36 * 0.02,
      );

  static TextStyle get h1 => _base(
        size: 30,
        weight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -30 * 0.02,
      );

  static TextStyle get h2 => _base(
        size: 24,
        weight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -24 * 0.02,
      );

  static TextStyle get h3 => _base(
        size: 20,
        weight: FontWeight.w500,
        height: 1.3,
      );

  static TextStyle get body => _base(
        size: 15,
        weight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySm => _base(
        size: 13,
        weight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get label => _base(
        size: 12,
        weight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 12 * 0.04,
      );

  static TextStyle get caption => _base(
        size: 12,
        weight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get button => _base(
        size: 15,
        weight: FontWeight.w600,
        height: 1.2,
      );
}

import 'package:flutter/material.dart';

/// Kadence color tokens. Light and dark palettes live side by side so any
/// widget can pick the right swatch for the current [Brightness].
///
/// Source of truth mirrors `colors_and_type.css` from the design bundle.
@immutable
class KadenceColors extends ThemeExtension<KadenceColors> {
  const KadenceColors({
    required this.bgBase,
    required this.bgElevated,
    required this.bgSubtle,
    required this.bgWash,
    required this.fgPrimary,
    required this.fgSecondary,
    required this.fgTertiary,
    required this.fgDisabled,
    required this.fgInverse,
    required this.accent,
    required this.accentHover,
    required this.accentMuted,
    required this.accentLight,
    required this.accentFg,
    required this.statusPlanned,
    required this.statusDone,
    required this.statusRest,
    required this.statusActive,
    required this.statusPlannedBg,
    required this.statusDoneBg,
    required this.statusRestBg,
    required this.border,
    required this.borderSubtle,
    required this.borderStrong,
    required this.scrim,
  });

  final Color bgBase;
  final Color bgElevated;
  final Color bgSubtle;
  final Color bgWash;

  final Color fgPrimary;
  final Color fgSecondary;
  final Color fgTertiary;
  final Color fgDisabled;
  final Color fgInverse;

  final Color accent;
  final Color accentHover;
  final Color accentMuted;
  final Color accentLight;
  final Color accentFg;

  final Color statusPlanned;
  final Color statusDone;
  final Color statusRest;
  final Color statusActive;

  final Color statusPlannedBg;
  final Color statusDoneBg;
  final Color statusRestBg;

  final Color border;
  final Color borderSubtle;
  final Color borderStrong;

  final Color scrim;

  static const KadenceColors light = KadenceColors(
    bgBase: Color(0xFFF8F7F4),
    bgElevated: Color(0xFFFFFFFF),
    bgSubtle: Color(0xFFF0EEE9),
    bgWash: Color(0xFFE8E6DF),
    fgPrimary: Color(0xFF1C1B18),
    fgSecondary: Color(0xFF6B6860),
    fgTertiary: Color(0xFFA09D97),
    fgDisabled: Color(0xFFC8C5BF),
    fgInverse: Color(0xFFF8F7F4),
    accent: Color(0xFF4A7C59),
    accentHover: Color(0xFF3D6A4A),
    accentMuted: Color(0xFF7BA88A),
    accentLight: Color(0xFFEBF3EE),
    accentFg: Color(0xFFFFFFFF),
    statusPlanned: Color(0xFFA09D97),
    statusDone: Color(0xFF4A7C59),
    statusRest: Color(0xFFC8C5BF),
    statusActive: Color(0xFF4A7C59),
    statusPlannedBg: Color(0xFFF0EEE9),
    statusDoneBg: Color(0xFFEBF3EE),
    statusRestBg: Color(0xFFF5F4F1),
    border: Color(0xFFE5E3DC),
    borderSubtle: Color(0xFFEEECE6),
    borderStrong: Color(0xFFC8C5BF),
    scrim: Color(0x521C1B18),
  );

  static const KadenceColors dark = KadenceColors(
    bgBase: Color(0xFF151513),
    bgElevated: Color(0xFF1E1E1B),
    bgSubtle: Color(0xFF252521),
    bgWash: Color(0xFF2E2D28),
    fgPrimary: Color(0xFFF2F1EC),
    fgSecondary: Color(0xFF8B8980),
    fgTertiary: Color(0xFF5C5A55),
    fgDisabled: Color(0xFF3A3935),
    fgInverse: Color(0xFF1C1B18),
    accent: Color(0xFF6BA87A),
    accentHover: Color(0xFF7FBA8D),
    accentMuted: Color(0xFF4A7C59),
    accentLight: Color(0xFF1A2B1E),
    accentFg: Color(0xFF0E1F13),
    statusPlanned: Color(0xFF5C5A55),
    statusDone: Color(0xFF6BA87A),
    statusRest: Color(0xFF3A3935),
    statusActive: Color(0xFF6BA87A),
    statusPlannedBg: Color(0xFF252521),
    statusDoneBg: Color(0xFF1A2B1E),
    statusRestBg: Color(0xFF1E1E1B),
    border: Color(0xFF2E2D28),
    borderSubtle: Color(0xFF252521),
    borderStrong: Color(0xFF3A3935),
    scrim: Color(0x99000000),
  );

  @override
  KadenceColors copyWith({
    Color? bgBase,
    Color? bgElevated,
    Color? bgSubtle,
    Color? bgWash,
    Color? fgPrimary,
    Color? fgSecondary,
    Color? fgTertiary,
    Color? fgDisabled,
    Color? fgInverse,
    Color? accent,
    Color? accentHover,
    Color? accentMuted,
    Color? accentLight,
    Color? accentFg,
    Color? statusPlanned,
    Color? statusDone,
    Color? statusRest,
    Color? statusActive,
    Color? statusPlannedBg,
    Color? statusDoneBg,
    Color? statusRestBg,
    Color? border,
    Color? borderSubtle,
    Color? borderStrong,
    Color? scrim,
  }) {
    return KadenceColors(
      bgBase: bgBase ?? this.bgBase,
      bgElevated: bgElevated ?? this.bgElevated,
      bgSubtle: bgSubtle ?? this.bgSubtle,
      bgWash: bgWash ?? this.bgWash,
      fgPrimary: fgPrimary ?? this.fgPrimary,
      fgSecondary: fgSecondary ?? this.fgSecondary,
      fgTertiary: fgTertiary ?? this.fgTertiary,
      fgDisabled: fgDisabled ?? this.fgDisabled,
      fgInverse: fgInverse ?? this.fgInverse,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentMuted: accentMuted ?? this.accentMuted,
      accentLight: accentLight ?? this.accentLight,
      accentFg: accentFg ?? this.accentFg,
      statusPlanned: statusPlanned ?? this.statusPlanned,
      statusDone: statusDone ?? this.statusDone,
      statusRest: statusRest ?? this.statusRest,
      statusActive: statusActive ?? this.statusActive,
      statusPlannedBg: statusPlannedBg ?? this.statusPlannedBg,
      statusDoneBg: statusDoneBg ?? this.statusDoneBg,
      statusRestBg: statusRestBg ?? this.statusRestBg,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStrong: borderStrong ?? this.borderStrong,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  KadenceColors lerp(ThemeExtension<KadenceColors>? other, double t) {
    if (other is! KadenceColors) return this;
    return KadenceColors(
      bgBase: Color.lerp(bgBase, other.bgBase, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      bgSubtle: Color.lerp(bgSubtle, other.bgSubtle, t)!,
      bgWash: Color.lerp(bgWash, other.bgWash, t)!,
      fgPrimary: Color.lerp(fgPrimary, other.fgPrimary, t)!,
      fgSecondary: Color.lerp(fgSecondary, other.fgSecondary, t)!,
      fgTertiary: Color.lerp(fgTertiary, other.fgTertiary, t)!,
      fgDisabled: Color.lerp(fgDisabled, other.fgDisabled, t)!,
      fgInverse: Color.lerp(fgInverse, other.fgInverse, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      accentFg: Color.lerp(accentFg, other.accentFg, t)!,
      statusPlanned: Color.lerp(statusPlanned, other.statusPlanned, t)!,
      statusDone: Color.lerp(statusDone, other.statusDone, t)!,
      statusRest: Color.lerp(statusRest, other.statusRest, t)!,
      statusActive: Color.lerp(statusActive, other.statusActive, t)!,
      statusPlannedBg: Color.lerp(statusPlannedBg, other.statusPlannedBg, t)!,
      statusDoneBg: Color.lerp(statusDoneBg, other.statusDoneBg, t)!,
      statusRestBg: Color.lerp(statusRestBg, other.statusRestBg, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

extension KadenceColorsX on BuildContext {
  KadenceColors get colors => Theme.of(this).extension<KadenceColors>()!;
}

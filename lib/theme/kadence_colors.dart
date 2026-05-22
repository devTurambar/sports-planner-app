import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../state/type_color_controller.dart';

@immutable
class ActivityTypeColors {
  const ActivityTypeColors({required this.tint, required this.bg});

  final Color tint;
  final Color bg;

  static ActivityTypeColors lerp(
    ActivityTypeColors a,
    ActivityTypeColors b,
    double t,
  ) {
    return ActivityTypeColors(
      tint: Color.lerp(a.tint, b.tint, t)!,
      bg: Color.lerp(a.bg, b.bg, t)!,
    );
  }
}

@immutable
class KadenceColors extends ThemeExtension<KadenceColors> {
  const KadenceColors({
    required this.bgBase,
    required this.bgCard,
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
    required this.border,
    required this.borderSubtle,
    required this.borderStrong,
    required this.scrim,
    required this.heatEmpty,
    required this.typeRun,
    required this.typeCycle,
    required this.typeGym,
    required this.typeYoga,
    required this.typeSwim,
    required this.typeWalk,
    required this.typeOther,
  });

  final Color bgBase;
  final Color bgCard;
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

  final Color border;
  final Color borderSubtle;
  final Color borderStrong;

  final Color scrim;
  final Color heatEmpty;

  final ActivityTypeColors typeRun;
  final ActivityTypeColors typeCycle;
  final ActivityTypeColors typeGym;
  final ActivityTypeColors typeYoga;
  final ActivityTypeColors typeSwim;
  final ActivityTypeColors typeWalk;
  final ActivityTypeColors typeOther;

  static const _defaultTypeColorMap = <ActivityType, int>{
    ActivityType.run: 0,
    ActivityType.trailRun: 0,
    ActivityType.hike: 5,
    ActivityType.walk: 5,
    ActivityType.cycle: 1,
    ActivityType.mtb: 1,
    ActivityType.swim: 4,
    ActivityType.gym: 2,
    ActivityType.yoga: 3,
    ActivityType.hiit: 2,
    ActivityType.row: 4,
    ActivityType.ski: 4,
    ActivityType.surf: 4,
    ActivityType.climb: 6,
    ActivityType.tennis: 3,
    ActivityType.padel: 3,
    ActivityType.dance: 3,
    ActivityType.combat: 2,
    ActivityType.elliptical: 6,
    ActivityType.other: 6,
  };

  List<ActivityTypeColors> get _palette =>
      [typeRun, typeCycle, typeGym, typeYoga, typeSwim, typeWalk, typeOther];

  static int defaultIndexFor(ActivityType type) =>
      _defaultTypeColorMap[type] ?? 6;

  ActivityTypeColors paletteColor(int index) => _palette[index.clamp(0, 6)];

  ActivityTypeColors typeColors(ActivityType? type) {
    if (type == null) return typeOther;
    final idx = _defaultTypeColorMap[type] ?? 6;
    return _palette[idx];
  }

  Color heatLevel(Color tint, int level) {
    const intensities = [0.0, 0.28, 0.55, 0.78, 1.0];
    final i = level.clamp(0, 4);
    if (i == 0) return heatEmpty;
    return Color.lerp(bgCard, tint, intensities[i])!;
  }

  // --- Legacy aliases for gradual migration ---
  Color get statusPlanned => fgTertiary;
  Color get statusDone => typeRun.tint;
  Color get statusRest => fgDisabled;
  Color get statusActive => typeRun.tint;
  Color get statusPlannedBg => bgSubtle;
  Color get statusDoneBg => typeRun.bg;
  Color get statusRestBg => bgElevated;

  static const KadenceColors light = KadenceColors(
    bgBase: Color(0xFFF8F7F4),
    bgCard: Color(0xFFFFFFFF),
    bgElevated: Color(0xFFFFFFFF),
    bgSubtle: Color(0xFFF0EEE9),
    bgWash: Color(0xFFE8E6DF),
    fgPrimary: Color(0xFF1C1B18),
    fgSecondary: Color(0xFF6B6860),
    fgTertiary: Color(0xFF9A968D),
    fgDisabled: Color(0xFFC8C5BF),
    fgInverse: Color(0xFFF8F7F4),
    accent: Color(0xFFE85F2C),
    accentHover: Color(0xFFD04E1F),
    accentMuted: Color(0xFFBF7A5C),
    accentLight: Color(0xFFFFF1EA),
    accentFg: Color(0xFFFFFFFF),
    border: Color(0xFFE5E3DC),
    borderSubtle: Color(0xFFEEECE6),
    borderStrong: Color(0xFFC8C5BF),
    scrim: Color(0x521C1B18),
    heatEmpty: Color(0xFFEFEDE6),
    typeRun: ActivityTypeColors(tint: Color(0xFFE85F2C), bg: Color(0xFFFFF1EA)),
    typeCycle: ActivityTypeColors(tint: Color(0xFF2563EB), bg: Color(0xFFEAF1FF)),
    typeGym: ActivityTypeColors(tint: Color(0xFFE11D48), bg: Color(0xFFFFEDF1)),
    typeYoga: ActivityTypeColors(tint: Color(0xFF9333EA), bg: Color(0xFFF5EBFF)),
    typeSwim: ActivityTypeColors(tint: Color(0xFF0891B2), bg: Color(0xFFE5F6FA)),
    typeWalk: ActivityTypeColors(tint: Color(0xFF059669), bg: Color(0xFFE5F5EE)),
    typeOther: ActivityTypeColors(tint: Color(0xFFD97706), bg: Color(0xFFFFF4E0)),
  );

  static const KadenceColors dark = KadenceColors(
    bgBase: Color(0xFF0E0E0C),
    bgCard: Color(0xFF1A1A17),
    bgElevated: Color(0xFF1E1E1B),
    bgSubtle: Color(0xFF232320),
    bgWash: Color(0xFF2A2A26),
    fgPrimary: Color(0xFFF4F2EC),
    fgSecondary: Color(0xFF8A8880),
    fgTertiary: Color(0xFF5C5A55),
    fgDisabled: Color(0xFF3A3934),
    fgInverse: Color(0xFF0E0E0C),
    accent: Color(0xFFFF7A45),
    accentHover: Color(0xFFFF9060),
    accentMuted: Color(0xFFB06840),
    accentLight: Color(0xFF2A1612),
    accentFg: Color(0xFF0E0E0C),
    border: Color(0xFF25241F),
    borderSubtle: Color(0xFF1E1D1A),
    borderStrong: Color(0xFF34332E),
    scrim: Color(0x99000000),
    heatEmpty: Color(0xFF1A1A17),
    typeRun: ActivityTypeColors(tint: Color(0xFFFF7A45), bg: Color(0xFF2A1612)),
    typeCycle: ActivityTypeColors(tint: Color(0xFF3B82F6), bg: Color(0xFF0F1A2E)),
    typeGym: ActivityTypeColors(tint: Color(0xFFF43F5E), bg: Color(0xFF2A1018)),
    typeYoga: ActivityTypeColors(tint: Color(0xFFB16CF4), bg: Color(0xFF1F1430)),
    typeSwim: ActivityTypeColors(tint: Color(0xFF22B8D9), bg: Color(0xFF0E222A)),
    typeWalk: ActivityTypeColors(tint: Color(0xFF34C77B), bg: Color(0xFF0F2419)),
    typeOther: ActivityTypeColors(tint: Color(0xFFF0B43A), bg: Color(0xFF251D0E)),
  );

  @override
  KadenceColors copyWith({
    Color? bgBase,
    Color? bgCard,
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
    Color? border,
    Color? borderSubtle,
    Color? borderStrong,
    Color? scrim,
    Color? heatEmpty,
    ActivityTypeColors? typeRun,
    ActivityTypeColors? typeCycle,
    ActivityTypeColors? typeGym,
    ActivityTypeColors? typeYoga,
    ActivityTypeColors? typeSwim,
    ActivityTypeColors? typeWalk,
    ActivityTypeColors? typeOther,
  }) {
    return KadenceColors(
      bgBase: bgBase ?? this.bgBase,
      bgCard: bgCard ?? this.bgCard,
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
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStrong: borderStrong ?? this.borderStrong,
      scrim: scrim ?? this.scrim,
      heatEmpty: heatEmpty ?? this.heatEmpty,
      typeRun: typeRun ?? this.typeRun,
      typeCycle: typeCycle ?? this.typeCycle,
      typeGym: typeGym ?? this.typeGym,
      typeYoga: typeYoga ?? this.typeYoga,
      typeSwim: typeSwim ?? this.typeSwim,
      typeWalk: typeWalk ?? this.typeWalk,
      typeOther: typeOther ?? this.typeOther,
    );
  }

  @override
  KadenceColors lerp(ThemeExtension<KadenceColors>? other, double t) {
    if (other is! KadenceColors) return this;
    return KadenceColors(
      bgBase: Color.lerp(bgBase, other.bgBase, t)!,
      bgCard: Color.lerp(bgCard, other.bgCard, t)!,
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
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      heatEmpty: Color.lerp(heatEmpty, other.heatEmpty, t)!,
      typeRun: ActivityTypeColors.lerp(typeRun, other.typeRun, t),
      typeCycle: ActivityTypeColors.lerp(typeCycle, other.typeCycle, t),
      typeGym: ActivityTypeColors.lerp(typeGym, other.typeGym, t),
      typeYoga: ActivityTypeColors.lerp(typeYoga, other.typeYoga, t),
      typeSwim: ActivityTypeColors.lerp(typeSwim, other.typeSwim, t),
      typeWalk: ActivityTypeColors.lerp(typeWalk, other.typeWalk, t),
      typeOther: ActivityTypeColors.lerp(typeOther, other.typeOther, t),
    );
  }
}

extension KadenceColorsX on BuildContext {
  KadenceColors get colors => Theme.of(this).extension<KadenceColors>()!;

  ActivityTypeColors typeColor(ActivityType? type) {
    return watch<TypeColorController>().resolve(colors, type);
  }
}

import 'package:flutter/foundation.dart';

import '../l10n/generated/app_localizations.dart';

/// The planning status of a given day.
///
/// A day is always in exactly one state. `today` is a convenience flag used
/// by the week view — it means "active day not yet done" and lives
/// alongside `planned` to highlight where the user currently stands.
enum DayStatus { empty, planned, today, done }

/// Sport / activity category. The values match the design bundle's pills
/// so copy stays aligned end-to-end.
enum ActivityType {
  run,
  trailRun,
  hike,
  walk,
  cycle,
  mtb,
  swim,
  gym,
  yoga,
  hiit,
  row,
  ski,
  surf,
  climb,
  tennis,
  padel,
  dance,
  combat,
  elliptical,
  other,
}

extension ActivityTypeLabel on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.run:
        return 'Run';
      case ActivityType.trailRun:
        return 'Trail Run';
      case ActivityType.hike:
        return 'Hike';
      case ActivityType.walk:
        return 'Walk';
      case ActivityType.cycle:
        return 'Cycle';
      case ActivityType.mtb:
        return 'MTB';
      case ActivityType.swim:
        return 'Swim';
      case ActivityType.gym:
        return 'Gym';
      case ActivityType.yoga:
        return 'Yoga';
      case ActivityType.hiit:
        return 'HIIT';
      case ActivityType.row:
        return 'Row';
      case ActivityType.ski:
        return 'Ski';
      case ActivityType.surf:
        return 'Surf';
      case ActivityType.climb:
        return 'Climb';
      case ActivityType.tennis:
        return 'Tennis';
      case ActivityType.padel:
        return 'Padel';
      case ActivityType.dance:
        return 'Dance';
      case ActivityType.combat:
        return 'Combat';
      case ActivityType.elliptical:
        return 'Elliptical';
      case ActivityType.other:
        return 'Other';
    }
  }

  /// Locale-aware label for use in any UI surface that has a
  /// `BuildContext`. Prefer this over [label] (which is English-only).
  String localized(AppLocalizations loc) {
    switch (this) {
      case ActivityType.run:
        return loc.typeRun;
      case ActivityType.trailRun:
        return loc.typeTrailRun;
      case ActivityType.hike:
        return loc.typeHike;
      case ActivityType.walk:
        return loc.typeWalk;
      case ActivityType.cycle:
        return loc.typeCycle;
      case ActivityType.mtb:
        return loc.typeMtb;
      case ActivityType.swim:
        return loc.typeSwim;
      case ActivityType.gym:
        return loc.typeGym;
      case ActivityType.yoga:
        return loc.typeYoga;
      case ActivityType.hiit:
        return loc.typeHiit;
      case ActivityType.row:
        return loc.typeRow;
      case ActivityType.ski:
        return loc.typeSki;
      case ActivityType.surf:
        return loc.typeSurf;
      case ActivityType.climb:
        return loc.typeClimb;
      case ActivityType.tennis:
        return loc.typeTennis;
      case ActivityType.padel:
        return loc.typePadel;
      case ActivityType.dance:
        return loc.typeDance;
      case ActivityType.combat:
        return loc.typeCombat;
      case ActivityType.elliptical:
        return loc.typeElliptical;
      case ActivityType.other:
        return loc.typeOther;
    }
  }

  String get dbKey => name;

  static ActivityType? fromDbKey(String? key) {
    if (key == null) return null;
    for (final t in ActivityType.values) {
      if (t.name == key) return t;
    }
    return null;
  }
}

/// Maps a stored English sub-type key (e.g. "Crossfit", "Alpine Ski")
/// to its localized display label. Unknown values fall through
/// unchanged so legacy data and custom strings still render.
String localizedSubType(String key, AppLocalizations loc) {
  switch (key) {
    case 'Alpine Ski':
      return loc.subtypeAlpineSki;
    case 'Badminton':
      return loc.subtypeBadminton;
    case 'Canoeing':
      return loc.subtypeCanoeing;
    case 'Crossfit':
      return loc.subtypeCrossfit;
    case 'E-Bike Ride':
      return loc.subtypeEbikeRide;
    case 'Fencing':
      return loc.subtypeFencing;
    case 'Golf':
      return loc.subtypeGolf;
    case 'Handball':
      return loc.subtypeHandball;
    case 'Ice Skate':
      return loc.subtypeIceSkate;
    case 'Inline Skate':
      return loc.subtypeInlineSkate;
    case 'Kayaking':
      return loc.subtypeKayaking;
    case 'Kitesurf':
      return loc.subtypeKitesurf;
    case 'Martial Arts':
      return loc.subtypeMartialArts;
    case 'Pilates':
      return loc.subtypePilates;
    case 'Pickleball':
      return loc.subtypePickleball;
    case 'Racquetball':
      return loc.subtypeRacquetball;
    case 'Rock Climbing':
      return loc.subtypeRockClimbing;
    case 'Roller Ski':
      return loc.subtypeRollerSki;
    case 'Rowing':
      return loc.subtypeRowing;
    case 'Rugby':
      return loc.subtypeRugby;
    case 'Sailing':
      return loc.subtypeSailing;
    case 'Skateboarding':
      return loc.subtypeSkateboarding;
    case 'Snowboard':
      return loc.subtypeSnowboard;
    case 'Snowshoe':
      return loc.subtypeSnowshoe;
    case 'Soccer':
      return loc.subtypeSoccer;
    case 'Squash':
      return loc.subtypeSquash;
    case 'Stair Stepper':
      return loc.subtypeStairStepper;
    case 'Stand Up Paddling':
      return loc.subtypeStandUpPaddling;
    case 'Swimming':
      return loc.subtypeSwimming;
    case 'Table Tennis':
      return loc.subtypeTableTennis;
    case 'Trail Run':
      return loc.subtypeTrailRun;
    case 'Velomobile':
      return loc.subtypeVelomobile;
    case 'Virtual Ride':
      return loc.subtypeVirtualRide;
    case 'Virtual Row':
      return loc.subtypeVirtualRow;
    case 'Virtual Run':
      return loc.subtypeVirtualRun;
    case 'Volleyball':
      return loc.subtypeVolleyball;
    case 'Weightlifting':
      return loc.subtypeWeightlifting;
    case 'Wheelchair':
      return loc.subtypeWheelchair;
    case 'Windsurf':
      return loc.subtypeWindsurf;
    case 'Workout':
      return loc.subtypeWorkout;
    case 'Yoga':
      return loc.subtypeYoga;
    default:
      return key;
  }
}

/// A single session planned for a specific date.
@immutable
class Activity {
  const Activity({
    required this.id,
    required this.date,
    required this.status,
    this.name,
    this.type,
    this.subType,
    this.duration,
    this.timeOfDay,
    this.notes,
    this.calendarEventId,
  });

  final String id;
  final DateTime date;
  final DayStatus status;
  final String? name;
  final ActivityType? type;
  final String? subType;
  final String? duration;
  final String? timeOfDay;
  final String? notes;
  final String? calendarEventId;

  String? get meta => formattedMeta(false);

  String? formattedMeta(bool use24h) {
    final parts = <String>[
      if (timeOfDay != null && timeOfDay!.isNotEmpty)
        use24h ? timeOfDay! : _to12h(timeOfDay!),
      if (duration != null && duration!.isNotEmpty) duration!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  static String _to12h(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts[1];
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m $period';
  }

  String get typeLabel {
    if (type == ActivityType.other && subType != null) return subType!;
    return type?.label ?? 'Other';
  }

  /// Locale-aware version of [typeLabel]. Handles both core types
  /// (run, hike, ...) and the Strava-style sub-types stored as English
  /// strings (Crossfit, Soccer, ...).
  String localizedTypeLabel(AppLocalizations loc) {
    if (type == ActivityType.other && subType != null) {
      return localizedSubType(subType!, loc);
    }
    return type?.localized(loc) ?? loc.typeOther;
  }

  Activity copyWith({
    DayStatus? status,
    String? name,
    ActivityType? type,
    String? subType,
    String? duration,
    String? timeOfDay,
    String? notes,
    String? calendarEventId,
  }) {
    return Activity(
      id: id,
      date: date,
      status: status ?? this.status,
      name: name ?? this.name,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      duration: duration ?? this.duration,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      notes: notes ?? this.notes,
      calendarEventId: calendarEventId ?? this.calendarEventId,
    );
  }
}

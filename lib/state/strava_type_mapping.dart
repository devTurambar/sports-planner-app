import '../models/activity.dart';

/// A Strava sport mapped onto Kadence's type system. Sub-types use the
/// canonical English keys from `sub_type_sheet.dart` so they localize.
class StravaMappedType {
  const StravaMappedType(this.type, {this.subType});

  final ActivityType type;
  final String? subType;

  String get label => subType ?? type.label;
}

const _core = <String, ActivityType>{
  'Run': ActivityType.run,
  'TrailRun': ActivityType.trailRun,
  'Hike': ActivityType.hike,
  'Walk': ActivityType.walk,
  'Ride': ActivityType.cycle,
  'MountainBikeRide': ActivityType.mtb,
  'GravelRide': ActivityType.mtb,
  'EMountainBikeRide': ActivityType.mtb,
  'Swim': ActivityType.swim,
  'WeightTraining': ActivityType.gym,
  'Yoga': ActivityType.yoga,
  'HighIntensityIntervalTraining': ActivityType.hiit,
  'Rowing': ActivityType.row,
  'AlpineSki': ActivityType.ski,
  'NordicSki': ActivityType.ski,
  'BackcountrySki': ActivityType.ski,
  'Surfing': ActivityType.surf,
  'RockClimbing': ActivityType.climb,
  'Tennis': ActivityType.tennis,
  'Padel': ActivityType.padel,
  'Dance': ActivityType.dance,
  'Elliptical': ActivityType.elliptical,
};

const _sub = <String, String>{
  'Crossfit': 'Crossfit',
  'Pickleball': 'Pickleball',
  'EBikeRide': 'E-Bike Ride',
  'VirtualRide': 'Virtual Ride',
  'VirtualRun': 'Virtual Run',
  'VirtualRow': 'Virtual Row',
  'Canoeing': 'Canoeing',
  'Kayaking': 'Kayaking',
  'Golf': 'Golf',
  'Handball': 'Handball',
  'Soccer': 'Soccer',
  'Rugby': 'Rugby',
  'Volleyball': 'Volleyball',
  'Badminton': 'Badminton',
  'Squash': 'Squash',
  'Racquetball': 'Racquetball',
  'TableTennis': 'Table Tennis',
  'Skateboard': 'Skateboarding',
  'InlineSkate': 'Inline Skate',
  'IceSkate': 'Ice Skate',
  'RollerSki': 'Roller Ski',
  'Snowboard': 'Snowboard',
  'Snowshoe': 'Snowshoe',
  'StandUpPaddling': 'Stand Up Paddling',
  'Sailing': 'Sailing',
  'Windsurf': 'Windsurf',
  'Kitesurf': 'Kitesurf',
  'Velomobile': 'Velomobile',
  'Wheelchair': 'Wheelchair',
  'Handcycle': 'Wheelchair',
  'StairStepper': 'Stair Stepper',
  'Workout': 'Workout',
  'Pilates': 'Pilates',
};

/// Maps a Strava `sport_type` (or legacy `type`) to a Kadence type.
/// Unknown sports become `other` with a de-camel-cased sub-type label.
StravaMappedType mapStravaSport(String sport) {
  final core = _core[sport];
  if (core != null) return StravaMappedType(core);
  final sub = _sub[sport] ??
      sport.replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z])'), (_) => ' ');
  return StravaMappedType(
    ActivityType.other,
    subType: sub.isEmpty ? null : sub,
  );
}

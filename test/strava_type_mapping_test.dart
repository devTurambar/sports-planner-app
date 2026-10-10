import 'package:flutter_test/flutter_test.dart';
import 'package:kadence/models/activity.dart';
import 'package:kadence/state/strava_type_mapping.dart';

void main() {
  test('core Strava sports map to core types', () {
    expect(mapStravaSport('Run').type, ActivityType.run);
    expect(mapStravaSport('TrailRun').type, ActivityType.trailRun);
    expect(mapStravaSport('GravelRide').type, ActivityType.mtb);
    expect(mapStravaSport('WeightTraining').type, ActivityType.gym);
    expect(mapStravaSport('Run').subType, isNull);
  });

  test('known sub-types use canonical keys so they localize', () {
    final m = mapStravaSport('TableTennis');
    expect(m.type, ActivityType.other);
    expect(m.subType, 'Table Tennis');
  });

  test('unknown sports are de-camel-cased under other', () {
    final m = mapStravaSport('BeachVolleyball');
    expect(m.type, ActivityType.other);
    expect(m.subType, 'Beach Volleyball');
  });
}

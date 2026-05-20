import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kadence/state/review_service.dart';

void main() {
  late SharedPreferences prefs;

  final installDate = DateTime(2026, 1, 1);

  Future<ReviewService> createService({
    required DateTime now,
    int dismissCount = 0,
    int? lastAskedMs,
  }) async {
    final values = <String, Object>{
      ReviewService.keyFirstLaunch: installDate.millisecondsSinceEpoch,
    };
    if (dismissCount > 0) {
      values[ReviewService.keyDismissCount] = dismissCount;
    }
    if (lastAskedMs != null) {
      values[ReviewService.keyLastAsked] = lastAskedMs;
    }
    SharedPreferences.setMockInitialValues(values);
    prefs = await SharedPreferences.getInstance();
    return ReviewService.createForTest(prefs, clock: () => now);
  }

  group('eligibility', () {
    test('eligible when all conditions met', () async {
      final svc = await createService(
        now: installDate.add(const Duration(days: 10)),
      );
      expect(svc.isEligible(5), isTrue);
    });

    test('not eligible when too few activities', () async {
      final svc = await createService(
        now: installDate.add(const Duration(days: 10)),
      );
      expect(svc.isEligible(2), isFalse);
    });

    test('not eligible when app too new', () async {
      final svc = await createService(
        now: installDate.add(const Duration(days: 3)),
      );
      expect(svc.isEligible(5), isFalse);
    });

    test('eligible at exactly 5 days', () async {
      final svc = await createService(
        now: installDate.add(const Duration(days: 5)),
      );
      expect(svc.isEligible(3), isTrue);
    });

    test('not eligible at exactly 3 activities threshold minus one', () async {
      final svc = await createService(
        now: installDate.add(const Duration(days: 10)),
      );
      expect(svc.isEligible(2), isFalse);
    });

    test('not eligible when no first launch timestamp', () async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      final svc = ReviewService.createForTest(
        prefs,
        clock: () => DateTime(2026, 2, 1),
      );
      expect(svc.isEligible(5), isFalse);
    });
  });

  group('dismiss count', () {
    test('not eligible after 3 dismissals', () async {
      final svc = await createService(
        now: installDate.add(const Duration(days: 100)),
        dismissCount: 3,
      );
      expect(svc.isEligible(10), isFalse);
    });

    test('still eligible after 2 dismissals with enough cooldown', () async {
      final lastAsked = installDate.add(const Duration(days: 50));
      final svc = await createService(
        now: lastAsked.add(const Duration(days: 91)),
        dismissCount: 2,
        lastAskedMs: lastAsked.millisecondsSinceEpoch,
      );
      expect(svc.isEligible(10), isTrue);
    });
  });

  group('cooldown', () {
    test('30-day cooldown after 1st dismiss', () async {
      final lastAsked = installDate.add(const Duration(days: 10));
      final svc = await createService(
        now: lastAsked.add(const Duration(days: 29)),
        dismissCount: 1,
        lastAskedMs: lastAsked.millisecondsSinceEpoch,
      );
      expect(svc.isEligible(5), isFalse);
    });

    test('eligible after 30-day cooldown from 1st dismiss', () async {
      final lastAsked = installDate.add(const Duration(days: 10));
      final svc = await createService(
        now: lastAsked.add(const Duration(days: 30)),
        dismissCount: 1,
        lastAskedMs: lastAsked.millisecondsSinceEpoch,
      );
      expect(svc.isEligible(5), isTrue);
    });

    test('90-day cooldown after 2nd dismiss', () async {
      final lastAsked = installDate.add(const Duration(days: 50));
      final svc = await createService(
        now: lastAsked.add(const Duration(days: 89)),
        dismissCount: 2,
        lastAskedMs: lastAsked.millisecondsSinceEpoch,
      );
      expect(svc.isEligible(5), isFalse);
    });

    test('eligible after 90-day cooldown from 2nd dismiss', () async {
      final lastAsked = installDate.add(const Duration(days: 50));
      final svc = await createService(
        now: lastAsked.add(const Duration(days: 90)),
        dismissCount: 2,
        lastAskedMs: lastAsked.millisecondsSinceEpoch,
      );
      expect(svc.isEligible(5), isTrue);
    });
  });

  group('cooldownForDismiss', () {
    test('0 days for first prompt', () {
      expect(ReviewService.cooldownForDismiss(0), 0);
    });

    test('30 days after 1st dismiss', () {
      expect(ReviewService.cooldownForDismiss(1), 30);
    });

    test('90 days after 2nd dismiss', () {
      expect(ReviewService.cooldownForDismiss(2), 90);
    });
  });
}

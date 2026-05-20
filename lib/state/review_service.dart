import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  ReviewService._(this._prefs, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  static ReviewService? _instance;
  final SharedPreferences _prefs;
  final DateTime Function() _clock;

  static const keyFirstLaunch = 'kadence.first_launch';
  static const keyLastAsked = 'kadence.review_last_asked';
  static const keyDismissCount = 'kadence.review_dismiss_count';

  static const minDaysInstalled = 5;
  static const minActivities = 3;
  static const maxDismissals = 3;

  static void init(SharedPreferences prefs) {
    _instance = ReviewService._(prefs);
    if (prefs.getInt(keyFirstLaunch) == null) {
      prefs.setInt(keyFirstLaunch, DateTime.now().millisecondsSinceEpoch);
    }
  }

  @visibleForTesting
  static ReviewService createForTest(
    SharedPreferences prefs, {
    required DateTime Function() clock,
  }) {
    return ReviewService._(prefs, clock: clock);
  }

  static void tryRequestReview({required int totalActivities}) {
    _instance?._tryRequest(totalActivities);
  }

  void _tryRequest(int totalActivities) {
    if (!isEligible(totalActivities)) return;

    final inAppReview = InAppReview.instance;
    inAppReview.isAvailable().then((available) {
      if (!available) return;
      inAppReview.requestReview();
      final now = _clock();
      _prefs.setInt(keyLastAsked, now.millisecondsSinceEpoch);
      _prefs.setInt(keyDismissCount, (_prefs.getInt(keyDismissCount) ?? 0) + 1);
    });
  }

  @visibleForTesting
  bool isEligible(int totalActivities) {
    final dismissCount = _prefs.getInt(keyDismissCount) ?? 0;
    if (dismissCount >= maxDismissals) return false;

    if (totalActivities < minActivities) return false;

    final firstLaunch = _prefs.getInt(keyFirstLaunch);
    if (firstLaunch == null) return false;
    final daysSinceInstall = _clock()
        .difference(DateTime.fromMillisecondsSinceEpoch(firstLaunch))
        .inDays;
    if (daysSinceInstall < minDaysInstalled) return false;

    final lastAsked = _prefs.getInt(keyLastAsked);
    if (lastAsked != null) {
      final daysSinceLastAsk = _clock()
          .difference(DateTime.fromMillisecondsSinceEpoch(lastAsked))
          .inDays;
      final cooldown = cooldownForDismiss(dismissCount);
      if (daysSinceLastAsk < cooldown) return false;
    }

    return true;
  }

  @visibleForTesting
  static int cooldownForDismiss(int dismissCount) {
    switch (dismissCount) {
      case 1:
        return 30;
      case 2:
        return 90;
      default:
        return 0;
    }
  }
}

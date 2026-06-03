// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsSectionApp => 'App';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsWeekStartsOn => 'Week starts on';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get settingsWeeklyGoal => 'Weekly goal';

  @override
  String weeklyGoalSessions(int count) {
    return '$count sessions';
  }

  @override
  String get weeklyGoalOff => 'Off';

  @override
  String get weeklyGoalPrompt =>
      'How many sessions per week do you want to complete?';

  @override
  String get settingsThemeColor => 'Theme color';

  @override
  String get settingsCalendarSync => 'Calendar sync';

  @override
  String get settingsCalendars => 'Calendars';

  @override
  String get calendarsAll => 'All calendars';

  @override
  String calendarsCount(int count) {
    return '$count calendars';
  }

  @override
  String get calendarsFallback => 'Calendar';

  @override
  String get calendarsOff => 'Off';

  @override
  String get calendarsLoading => '…';

  @override
  String get calendarsChooseTitle => 'Choose calendars';

  @override
  String get settingsTypeColors => 'Type colors';

  @override
  String get settingsTypeColorsValue => 'Customize';

  @override
  String get typeColorsResetAll => 'Reset all';

  @override
  String get settingsExportData => 'Export data';

  @override
  String get settingsExportValue => 'Share';

  @override
  String get settingsImportData => 'Import data';

  @override
  String get settingsImportValue => 'Load';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get importReplaceTitle => 'Replace all data?';

  @override
  String importReplaceBody(int count) {
    return 'This will replace all your current data with the imported data ($count activities).';
  }

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionReplace => 'Replace';

  @override
  String get actionDone => 'Done';

  @override
  String importedActivities(int count) {
    return 'Imported $count activities';
  }

  @override
  String get calendarSyncPromptTitle => 'Sync to calendar?';

  @override
  String get calendarSyncPromptBody =>
      'Add the imported activities to your device calendar? Existing matching events will be skipped.';

  @override
  String get actionNoThanks => 'No thanks';

  @override
  String get actionSync => 'Sync';

  @override
  String calendarSyncedAll(int synced) {
    return 'Synced $synced events to calendar';
  }

  @override
  String calendarSyncedWithSkipped(int synced, int skipped) {
    return 'Synced $synced events ($skipped already on calendar)';
  }

  @override
  String get settingsRedoOnboarding => 'Redo onboarding';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsRateKadence => 'Rate Kadence';

  @override
  String settingsVersion(String version) {
    return 'Kadence · v$version';
  }

  @override
  String get accountSignInToSync => 'Sign in to sync';

  @override
  String get accountSignInSubtitle => 'Back up and access your data anywhere';

  @override
  String get accountSignedInFallback => 'Signed in';

  @override
  String get accountSyncingEnabled => 'Syncing enabled';

  @override
  String get accountSignOut => 'Sign out';

  @override
  String get signInSheetSubtitle =>
      'Back up your data and access it from any device.';

  @override
  String get proCardSubtitle => 'Premium features coming soon';

  @override
  String get proBadge => 'PRO';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português (Portugal)';

  @override
  String get languagePortugueseBR => 'Português (Brasil)';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get actionBack => 'Back';

  @override
  String get actionContinue => 'Continue';

  @override
  String get onboardingWelcomeTagline => 'Plan, track & move.';

  @override
  String get onboardingWelcomeFeature1 => 'A simple weekly activity tracker';

  @override
  String get onboardingWelcomeFeature2 => 'Check off sessions as you go';

  @override
  String get onboardingWelcomeFeature3 => 'No guilt for rest days';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingCalendarTitle => 'Calendar sync';

  @override
  String get onboardingCalendarBody =>
      'Your planned sessions automatically sync with your device calendar so everything stays in one place.';

  @override
  String get onboardingCalendarFeature1 => 'Activities appear on your calendar';

  @override
  String get onboardingCalendarFeature2 => 'Edits and deletions stay in sync';

  @override
  String get onboardingCalendarFeature3 => 'Choose your calendar in Settings';

  @override
  String get onboardingSignInTitle => 'Keep your data safe';

  @override
  String get onboardingSignInBody =>
      'Choose how you\'d like to back up your sessions.\nYou can change this anytime in Settings.';

  @override
  String get onboardingManualTitle => 'Manual backup';

  @override
  String get onboardingManualBody =>
      'Export and import your data as a file from Settings whenever you want.';

  @override
  String get onboardingContinueWithoutAccount => 'Continue without account';

  @override
  String get onboardingCloudTitle => 'Cloud sync';

  @override
  String get onboardingCloudBody =>
      'Sign in with your account to sync across devices automatically.';

  @override
  String get navWeek => 'Week';

  @override
  String get navMonth => 'Month';

  @override
  String get navStats => 'Stats';

  @override
  String get navSettings => 'Settings';

  @override
  String get weekThisWeek => 'This week';

  @override
  String weekSummaryCaption(int percent) {
    return 'sessions done · $percent% on track';
  }

  @override
  String weekSummaryGoal(int done, int goal) {
    return '$done/$goal weekly goal';
  }

  @override
  String get dayEmptyPast => 'Rest day';

  @override
  String get dayEmptyFuture => 'No session';

  @override
  String dayMoreBadge(int count) {
    return '+$count more';
  }

  @override
  String get tipSwipeTitle => 'Swipe to browse weeks';

  @override
  String get tipSwipeBody =>
      'Slide left or right to see past and upcoming weeks';

  @override
  String get tipDoubleTapTitle => 'Double-tap to check off';

  @override
  String get tipDoubleTapBody =>
      'Quickly mark a day\'s sessions as done with a double-tap';

  @override
  String get tipLongPressTitle => 'Long-press to delete';

  @override
  String get tipLongPressBody =>
      'Press and hold a day to remove all its sessions';

  @override
  String get tipTitleNavTitle => 'Tap the title to go back';

  @override
  String tipTitleNavBody(String label) {
    return 'Tap \"$label\" at the top to jump back to the current week';
  }

  @override
  String get deleteDayTitle => 'Delete all sessions?';

  @override
  String get deleteDayBody =>
      'Every session on this day will be removed. This can\'t be undone.';

  @override
  String get actionDelete => 'Delete';

  @override
  String get statsDone => 'Done';

  @override
  String get statsPlanned => 'Planned';

  @override
  String get statsOnTrack => 'On track';

  @override
  String get deleteSessionTitle => 'Delete session?';

  @override
  String get deleteSessionBody => 'This can\'t be undone.';

  @override
  String get selectedDayEmpty => 'Nothing planned';

  @override
  String get selectedDayAdd => 'Add';

  @override
  String get tipMonthTitleNavBody =>
      'Tap the title at the top to jump back to the current month';

  @override
  String get sheetAddTitle => 'Add session';

  @override
  String get sheetEditTitle => 'Edit session';

  @override
  String get activityNameLabel => 'Activity name';

  @override
  String get activityNamePlaceholder => 'e.g. Morning run';

  @override
  String get notesLabel => 'Notes';

  @override
  String get notesPlaceholder => 'Any extra details…';

  @override
  String get fieldOptionalSuffix => '  (optional)';

  @override
  String get actionSaveSession => 'Save session';

  @override
  String get actionDeleteSession => 'Delete session';

  @override
  String get addAnotherActivity => 'Add another activity';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get recurrenceLabel => 'Repeats';

  @override
  String get recurrenceOnce => 'Once';

  @override
  String get recurrenceDaily => 'Daily';

  @override
  String get recurrenceWeekly => 'Weekly';

  @override
  String get recurrenceWeekdays => 'Weekdays';

  @override
  String get recurrenceWeekends => 'Weekends';

  @override
  String get repeatForLabel => 'Repeat for';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String get durationLabel => 'Duration';

  @override
  String get durationPlaceholder => 'Set duration';

  @override
  String durationHoursWheel(int count) {
    return '$count h';
  }

  @override
  String durationMinutesWheel(int count) {
    return '$count min';
  }

  @override
  String get timeLabel => 'Time';

  @override
  String get timePlaceholder => 'Set time';

  @override
  String get typeLabel => 'Type';

  @override
  String get typeMore => 'More…';

  @override
  String get subTypeTitle => 'Choose activity type';

  @override
  String get subTypeSearchPlaceholder => 'Search…';

  @override
  String get subTypeNoResults => 'No results';

  @override
  String get typeRun => 'Run';

  @override
  String get typeTrailRun => 'Trail Run';

  @override
  String get typeHike => 'Hike';

  @override
  String get typeWalk => 'Walk';

  @override
  String get typeCycle => 'Cycle';

  @override
  String get typeMtb => 'MTB';

  @override
  String get typeSwim => 'Swim';

  @override
  String get typeGym => 'Gym';

  @override
  String get typeYoga => 'Yoga';

  @override
  String get typeHiit => 'HIIT';

  @override
  String get typeRow => 'Row';

  @override
  String get typeSki => 'Ski';

  @override
  String get typeSurf => 'Surf';

  @override
  String get typeClimb => 'Climb';

  @override
  String get typeTennis => 'Tennis';

  @override
  String get typePadel => 'Padel';

  @override
  String get typeDance => 'Dance';

  @override
  String get typeCombat => 'Combat';

  @override
  String get typeElliptical => 'Elliptical';

  @override
  String get typeOther => 'Other';

  @override
  String get statusDone => 'Done';

  @override
  String get statusToday => 'Today';

  @override
  String get statusPlanned => 'Planned';

  @override
  String get statusOpen => 'Open';

  @override
  String get activityNameFallback => 'Session';

  @override
  String get oauthContinueGoogle => 'Continue with Google';

  @override
  String get oauthContinueApple => 'Continue with Apple';

  @override
  String get themeLightTooltip => 'Light mode';

  @override
  String get themeDarkTooltip => 'Dark mode';

  @override
  String get tipDismissHint => 'Tap anywhere to continue';

  @override
  String get loginTagline => 'Plan your week. Move your body.';

  @override
  String get loginTerms => 'By continuing you agree to our Terms of Service';

  @override
  String get emptyStateTitle => 'Nothing planned yet';

  @override
  String get emptyStateBody => 'Tap + to add your first session for the week.';

  @override
  String get emptyStateAddCta => 'Add activity';

  @override
  String get paywallComingSoonBadge => 'Coming soon';

  @override
  String get paywallBannerTitle => 'Premium features are\non the way';

  @override
  String get paywallBannerBody =>
      'We\'re building something special.\nStay tuned for Kadence Pro.';

  @override
  String get paywallFeaturesHeader => 'Here\'s what\'s coming:';

  @override
  String get paywallStravaTitle => 'Strava integration';

  @override
  String get paywallStravaBody =>
      'Import your history and auto-mark sessions as done';

  @override
  String get paywallStatsTitle => 'Advanced stats';

  @override
  String get paywallStatsBody =>
      'Full-year heatmap, insights, and shareable recaps';

  @override
  String get paywallDateFilterTitle => 'Date filtering';

  @override
  String get paywallDateFilterBody =>
      'Filter all stats by any custom date range';

  @override
  String get paywallCloudTitle => 'Cloud sync';

  @override
  String get paywallCloudBody => 'Back up and access your data from any device';

  @override
  String get paywallCustomColorsTitle => 'Custom colors';

  @override
  String get paywallCustomColorsBody =>
      'Personalize activity type and theme colors';

  @override
  String get paywallSupportTitle => 'Support an indie developer';

  @override
  String get paywallSupportBody => 'Your purchase helps keep Kadence alive';

  @override
  String get statsKpiSessions => 'Done';

  @override
  String get statsKpiStreak => 'Streak';

  @override
  String get statsKpiAverage => 'Average';

  @override
  String get statsWeekSuffix => 'wk';

  @override
  String get statsPerWeekSuffix => '/wk';

  @override
  String get statsProSection => 'Pro Stats';

  @override
  String statsHeatmapTitle(int count) {
    return '$count-week activity';
  }

  @override
  String statsHeatmapFilteredTo(String type) {
    return 'Filtered to $type';
  }

  @override
  String get statsHeatmapTinted => 'Tinted by primary activity';

  @override
  String get statsByActivity => 'By activity';

  @override
  String get statsAllTime => 'All time';

  @override
  String get statsNoSessionsYet => 'No sessions yet';

  @override
  String get actionClear => 'Clear';

  @override
  String get statsEmptyTitle => 'No stats yet';

  @override
  String get statsEmptyBody =>
      'Complete your first session to start tracking your progress.';

  @override
  String get statsTipFilterTitle => 'Filter by activity';

  @override
  String get statsTipFilterBody =>
      'Tap any activity type in \"By activity\" to highlight only that type on the heatmap';

  @override
  String get statsPersonalRecordsTitle => 'Personal records';

  @override
  String get statsBestStreak => 'Best streak';

  @override
  String get statsBestWeek => 'Best week';

  @override
  String get statsBestDay => 'Best day';

  @override
  String get statsWeeklyActivityTitle => 'Weekly activity';

  @override
  String get statsAvg => 'Avg';

  @override
  String get statsBestDayOfWeekTitle => 'Best day of week';

  @override
  String get statsDoneSessions => 'Done sessions';

  @override
  String get statsCompletionRateTitle => 'Completion rate';

  @override
  String get statsPlannedVsDone => 'Planned vs done';

  @override
  String get statsMissed => 'Missed';

  @override
  String get statsMonthlyTrendsTitle => 'Monthly trends';

  @override
  String get statsActivityVarietyTitle => 'Activity variety';

  @override
  String get statsLongestGapTitle => 'Longest gap';

  @override
  String get statsBetweenSessions => 'Between sessions';

  @override
  String get statsNoData => 'No data';

  @override
  String get statsMonthVsMonthTitle => 'Month vs month';

  @override
  String get statsMostConsistentTitle => 'Most consistent';

  @override
  String get statsCompletionByType => 'Completion by type';

  @override
  String get statsWeeklyPatternsTitle => 'Weekly patterns';

  @override
  String get statsWhenYouDo => 'When you do each activity';

  @override
  String get statsActiveDays => 'Active days';

  @override
  String get statsBestMonth => 'Best month';

  @override
  String get statsTopActivity => 'Top activity';

  @override
  String get statsPeriodBreakdownTitle => 'Period breakdown';

  @override
  String get statsPeriodNoSessions => 'No sessions in this period';

  @override
  String get statsAvgPerWeek => 'Avg / wk';

  @override
  String get statsConsistency => 'Consistency';

  @override
  String get statsPeakWeek => 'Peak week';

  @override
  String get statsTrendingUp => 'Trending up vs earlier in period';

  @override
  String get statsTrendingDown => 'Trending down vs earlier in period';

  @override
  String get statsSteadyPace => 'Steady pace';

  @override
  String get statsNoDataYet => 'No data yet';

  @override
  String get statsPeriodAll => 'All';

  @override
  String get statsInsightsTitle => 'Insights';

  @override
  String insightFavoriteDay(String day, int count) {
    return 'You train most on ${day}s — $count sessions total.';
  }

  @override
  String insightAboveAvg(int percent) {
    return 'This month is $percent% above your average. Keep it up!';
  }

  @override
  String get insightBelowAvg =>
      'This month is quieter than usual. Still time to catch up!';

  @override
  String insightVariety(int count) {
    return 'Great variety! You did $count different activities in the last 30 days.';
  }

  @override
  String insightFocused(String type) {
    return 'You\'ve been focused on $type lately. Try mixing it up!';
  }

  @override
  String insightStreakStrong(int weeks) {
    return '$weeks-week streak! That\'s serious consistency.';
  }

  @override
  String get insightStreakNew => 'New streak started! Keep it going this week.';

  @override
  String insightBestMonth(int count) {
    return 'Best month ever with $count sessions so far!';
  }

  @override
  String get recapTitle => 'Share your progress';

  @override
  String get recapSubtitle =>
      'Generate a summary card and share it with friends.';

  @override
  String get recapThisMonth => 'This month';

  @override
  String get recapThisYear => 'This year';

  @override
  String get recapPreview => 'Preview';

  @override
  String get recapShare => 'Share';

  @override
  String get recapActivity => 'Activity';

  @override
  String recapTopActivity(String label) {
    return 'Top activity: $label';
  }

  @override
  String recapStreakBadge(int count) {
    return '$count wk';
  }

  @override
  String recapYearInReviewTitle(int year) {
    return '$year Year in Review';
  }

  @override
  String get recapMonthGettingStarted => 'Getting started!';

  @override
  String get recapMonthUnstoppable => 'Unstoppable month!';

  @override
  String get recapMonthCrushing => 'Crushing it!';

  @override
  String get recapMonthConsistency => 'Incredible consistency!';

  @override
  String get recapMonthStrong => 'Strong month!';

  @override
  String get recapMonthMomentum => 'Building momentum!';

  @override
  String get recapYearBegins => 'The journey begins!';

  @override
  String get recapYearLegendary => 'Legendary year!';

  @override
  String get recapYearTripleDigits => 'Triple digits!';

  @override
  String get recapYearStreakMachine => 'Streak machine!';

  @override
  String get recapYearHalfHundred => 'Half a hundred!';

  @override
  String get recapYearGoingStrong => 'Going strong!';

  @override
  String get recapYearHabit => 'Building the habit!';

  @override
  String get statsLast12Months => 'Last 12 months';

  @override
  String get statsLast12Weeks => 'Last 12 weeks';

  @override
  String statsTypesAllTime(int count) {
    return '$count types all time';
  }

  @override
  String get statsDifferentTypesPerWeek =>
      'Different types per week (last 12 weeks)';

  @override
  String get statsNeedAtLeast2 => 'Need at least 2 sessions';

  @override
  String statsDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String statsDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String statsSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sessions',
      one: 'session',
    );
    return '$_temp0';
  }

  @override
  String statsTypesCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count types',
      one: '1 type',
    );
    return '$_temp0';
  }

  @override
  String statsYearInReviewTitle(int year) {
    return '$year in review';
  }

  @override
  String statsYearHeatmapTitle(int year) {
    return '$year heatmap';
  }

  @override
  String statsActiveDaysCount(int count) {
    return '$count active days';
  }

  @override
  String statsTriedTypes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count different activities',
      one: '1 different activity',
    );
    return 'You tried $_temp0 this year';
  }

  @override
  String get subtypeAlpineSki => 'Alpine Ski';

  @override
  String get subtypeBadminton => 'Badminton';

  @override
  String get subtypeCanoeing => 'Canoeing';

  @override
  String get subtypeCrossfit => 'Crossfit';

  @override
  String get subtypeEbikeRide => 'E-Bike Ride';

  @override
  String get subtypeFencing => 'Fencing';

  @override
  String get subtypeGolf => 'Golf';

  @override
  String get subtypeHandball => 'Handball';

  @override
  String get subtypeIceSkate => 'Ice Skate';

  @override
  String get subtypeInlineSkate => 'Inline Skate';

  @override
  String get subtypeKayaking => 'Kayaking';

  @override
  String get subtypeKitesurf => 'Kitesurf';

  @override
  String get subtypeMartialArts => 'Martial Arts';

  @override
  String get subtypePilates => 'Pilates';

  @override
  String get subtypePickleball => 'Pickleball';

  @override
  String get subtypeRacquetball => 'Racquetball';

  @override
  String get subtypeRockClimbing => 'Rock Climbing';

  @override
  String get subtypeRollerSki => 'Roller Ski';

  @override
  String get subtypeRowing => 'Rowing';

  @override
  String get subtypeRugby => 'Rugby';

  @override
  String get subtypeSailing => 'Sailing';

  @override
  String get subtypeSkateboarding => 'Skateboarding';

  @override
  String get subtypeSnowboard => 'Snowboard';

  @override
  String get subtypeSnowshoe => 'Snowshoe';

  @override
  String get subtypeSoccer => 'Soccer';

  @override
  String get subtypeSquash => 'Squash';

  @override
  String get subtypeStairStepper => 'Stair Stepper';

  @override
  String get subtypeStandUpPaddling => 'Stand Up Paddling';

  @override
  String get subtypeSwimming => 'Swimming';

  @override
  String get subtypeTableTennis => 'Table Tennis';

  @override
  String get subtypeTrailRun => 'Trail Run';

  @override
  String get subtypeVelomobile => 'Velomobile';

  @override
  String get subtypeVirtualRide => 'Virtual Ride';

  @override
  String get subtypeVirtualRow => 'Virtual Row';

  @override
  String get subtypeVirtualRun => 'Virtual Run';

  @override
  String get subtypeVolleyball => 'Volleyball';

  @override
  String get subtypeWeightlifting => 'Weightlifting';

  @override
  String get subtypeWheelchair => 'Wheelchair';

  @override
  String get subtypeWindsurf => 'Windsurf';

  @override
  String get subtypeWorkout => 'Workout';

  @override
  String get subtypeYoga => 'Yoga';
}

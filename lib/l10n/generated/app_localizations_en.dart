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
}

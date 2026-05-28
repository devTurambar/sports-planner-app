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
}

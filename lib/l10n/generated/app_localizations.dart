import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// Settings section header for app preferences
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsSectionApp;

  /// Settings section header for backup/export
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// Settings section header for legal/info rows
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsWeekStartsOn.
  ///
  /// In en, this message translates to:
  /// **'Week starts on'**
  String get settingsWeekStartsOn;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @settingsWeeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal'**
  String get settingsWeeklyGoal;

  /// Trailing value on the weekly-goal row, e.g. '5 sessions'
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String weeklyGoalSessions(int count);

  /// No description provided for @weeklyGoalOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get weeklyGoalOff;

  /// No description provided for @weeklyGoalPrompt.
  ///
  /// In en, this message translates to:
  /// **'How many sessions per week do you want to complete?'**
  String get weeklyGoalPrompt;

  /// No description provided for @settingsThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get settingsThemeColor;

  /// No description provided for @settingsCalendarSync.
  ///
  /// In en, this message translates to:
  /// **'Calendar sync'**
  String get settingsCalendarSync;

  /// No description provided for @settingsCalendars.
  ///
  /// In en, this message translates to:
  /// **'Calendars'**
  String get settingsCalendars;

  /// No description provided for @calendarsAll.
  ///
  /// In en, this message translates to:
  /// **'All calendars'**
  String get calendarsAll;

  /// Trailing label showing how many calendars are selected
  ///
  /// In en, this message translates to:
  /// **'{count} calendars'**
  String calendarsCount(int count);

  /// No description provided for @calendarsFallback.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarsFallback;

  /// No description provided for @calendarsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get calendarsOff;

  /// No description provided for @calendarsLoading.
  ///
  /// In en, this message translates to:
  /// **'…'**
  String get calendarsLoading;

  /// No description provided for @calendarsChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose calendars'**
  String get calendarsChooseTitle;

  /// No description provided for @settingsTypeColors.
  ///
  /// In en, this message translates to:
  /// **'Type colors'**
  String get settingsTypeColors;

  /// No description provided for @settingsTypeColorsValue.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get settingsTypeColorsValue;

  /// No description provided for @typeColorsResetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get typeColorsResetAll;

  /// No description provided for @settingsExportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get settingsExportData;

  /// No description provided for @settingsExportValue.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get settingsExportValue;

  /// No description provided for @settingsImportData.
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get settingsImportData;

  /// No description provided for @settingsImportValue.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get settingsImportValue;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @importReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get importReplaceTitle;

  /// No description provided for @importReplaceBody.
  ///
  /// In en, this message translates to:
  /// **'This will replace all your current data with the imported data ({count} activities).'**
  String importReplaceBody(int count);

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get actionReplace;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @importedActivities.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} activities'**
  String importedActivities(int count);

  /// No description provided for @calendarSyncPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync to calendar?'**
  String get calendarSyncPromptTitle;

  /// No description provided for @calendarSyncPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Add the imported activities to your device calendar? Existing matching events will be skipped.'**
  String get calendarSyncPromptBody;

  /// No description provided for @actionNoThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get actionNoThanks;

  /// No description provided for @actionSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get actionSync;

  /// No description provided for @calendarSyncedAll.
  ///
  /// In en, this message translates to:
  /// **'Synced {synced} events to calendar'**
  String calendarSyncedAll(int synced);

  /// No description provided for @calendarSyncedWithSkipped.
  ///
  /// In en, this message translates to:
  /// **'Synced {synced} events ({skipped} already on calendar)'**
  String calendarSyncedWithSkipped(int synced, int skipped);

  /// No description provided for @settingsRedoOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Redo onboarding'**
  String get settingsRedoOnboarding;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsRateKadence.
  ///
  /// In en, this message translates to:
  /// **'Rate Kadence'**
  String get settingsRateKadence;

  /// App version row at the bottom of Settings
  ///
  /// In en, this message translates to:
  /// **'Kadence · v{version}'**
  String settingsVersion(String version);

  /// No description provided for @accountSignInToSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync'**
  String get accountSignInToSync;

  /// No description provided for @accountSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Back up and access your data anywhere'**
  String get accountSignInSubtitle;

  /// No description provided for @accountSignedInFallback.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get accountSignedInFallback;

  /// No description provided for @accountSyncingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Syncing enabled'**
  String get accountSyncingEnabled;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountSignOut;

  /// No description provided for @signInSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Back up your data and access it from any device.'**
  String get signInSheetSubtitle;

  /// No description provided for @proCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Premium features coming soon'**
  String get proCardSubtitle;

  /// No description provided for @proBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proBadge;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português (Portugal)'**
  String get languagePortuguese;

  /// No description provided for @languagePortugueseBR.
  ///
  /// In en, this message translates to:
  /// **'Português (Brasil)'**
  String get languagePortugueseBR;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @onboardingWelcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Plan, track & move.'**
  String get onboardingWelcomeTagline;

  /// No description provided for @onboardingWelcomeFeature1.
  ///
  /// In en, this message translates to:
  /// **'A simple weekly activity tracker'**
  String get onboardingWelcomeFeature1;

  /// No description provided for @onboardingWelcomeFeature2.
  ///
  /// In en, this message translates to:
  /// **'Check off sessions as you go'**
  String get onboardingWelcomeFeature2;

  /// No description provided for @onboardingWelcomeFeature3.
  ///
  /// In en, this message translates to:
  /// **'No guilt for rest days'**
  String get onboardingWelcomeFeature3;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar sync'**
  String get onboardingCalendarTitle;

  /// No description provided for @onboardingCalendarBody.
  ///
  /// In en, this message translates to:
  /// **'Your planned sessions automatically sync with your device calendar so everything stays in one place.'**
  String get onboardingCalendarBody;

  /// No description provided for @onboardingCalendarFeature1.
  ///
  /// In en, this message translates to:
  /// **'Activities appear on your calendar'**
  String get onboardingCalendarFeature1;

  /// No description provided for @onboardingCalendarFeature2.
  ///
  /// In en, this message translates to:
  /// **'Edits and deletions stay in sync'**
  String get onboardingCalendarFeature2;

  /// No description provided for @onboardingCalendarFeature3.
  ///
  /// In en, this message translates to:
  /// **'Choose your calendar in Settings'**
  String get onboardingCalendarFeature3;

  /// No description provided for @onboardingSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your data safe'**
  String get onboardingSignInTitle;

  /// No description provided for @onboardingSignInBody.
  ///
  /// In en, this message translates to:
  /// **'Choose how you\'d like to back up your sessions.\nYou can change this anytime in Settings.'**
  String get onboardingSignInBody;

  /// No description provided for @onboardingManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual backup'**
  String get onboardingManualTitle;

  /// No description provided for @onboardingManualBody.
  ///
  /// In en, this message translates to:
  /// **'Export and import your data as a file from Settings whenever you want.'**
  String get onboardingManualBody;

  /// No description provided for @onboardingContinueWithoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get onboardingContinueWithoutAccount;

  /// No description provided for @onboardingCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get onboardingCloudTitle;

  /// No description provided for @onboardingCloudBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your account to sync across devices automatically.'**
  String get onboardingCloudBody;

  /// No description provided for @navWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get navWeek;

  /// No description provided for @navMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get navMonth;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @weekThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get weekThisWeek;

  /// Caption under the done/planned count on the week summary card.
  ///
  /// In en, this message translates to:
  /// **'sessions done · {percent}% on track'**
  String weekSummaryCaption(int percent);

  /// No description provided for @weekSummaryGoal.
  ///
  /// In en, this message translates to:
  /// **'{done}/{goal} weekly goal'**
  String weekSummaryGoal(int done, int goal);

  /// No description provided for @dayEmptyPast.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get dayEmptyPast;

  /// No description provided for @dayEmptyFuture.
  ///
  /// In en, this message translates to:
  /// **'No session'**
  String get dayEmptyFuture;

  /// Trailing badge on a day card showing how many extra sessions exist beyond the primary one.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String dayMoreBadge(int count);

  /// No description provided for @tipSwipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Swipe to browse weeks'**
  String get tipSwipeTitle;

  /// No description provided for @tipSwipeBody.
  ///
  /// In en, this message translates to:
  /// **'Slide left or right to see past and upcoming weeks'**
  String get tipSwipeBody;

  /// No description provided for @tipDoubleTapTitle.
  ///
  /// In en, this message translates to:
  /// **'Double-tap to check off'**
  String get tipDoubleTapTitle;

  /// No description provided for @tipDoubleTapBody.
  ///
  /// In en, this message translates to:
  /// **'Quickly mark a day\'s sessions as done with a double-tap'**
  String get tipDoubleTapBody;

  /// No description provided for @tipLongPressTitle.
  ///
  /// In en, this message translates to:
  /// **'Long-press to delete'**
  String get tipLongPressTitle;

  /// No description provided for @tipLongPressBody.
  ///
  /// In en, this message translates to:
  /// **'Press and hold a day to remove all its sessions'**
  String get tipLongPressBody;

  /// No description provided for @tipTitleNavTitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the title to go back'**
  String get tipTitleNavTitle;

  /// No description provided for @tipTitleNavBody.
  ///
  /// In en, this message translates to:
  /// **'Tap \"{label}\" at the top to jump back to the current week'**
  String tipTitleNavBody(String label);

  /// No description provided for @deleteDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all sessions?'**
  String get deleteDayTitle;

  /// No description provided for @deleteDayBody.
  ///
  /// In en, this message translates to:
  /// **'Every session on this day will be removed. This can\'t be undone.'**
  String get deleteDayBody;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @statsDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statsDone;

  /// No description provided for @statsPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get statsPlanned;

  /// No description provided for @statsOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get statsOnTrack;

  /// No description provided for @deleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete session?'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get deleteSessionBody;

  /// No description provided for @selectedDayEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned'**
  String get selectedDayEmpty;

  /// No description provided for @selectedDayAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get selectedDayAdd;

  /// No description provided for @tipMonthTitleNavBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the title at the top to jump back to the current month'**
  String get tipMonthTitleNavBody;

  /// No description provided for @sheetAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add session'**
  String get sheetAddTitle;

  /// No description provided for @sheetEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit session'**
  String get sheetEditTitle;

  /// No description provided for @activityNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity name'**
  String get activityNameLabel;

  /// No description provided for @activityNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Morning run'**
  String get activityNamePlaceholder;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Any extra details…'**
  String get notesPlaceholder;

  /// No description provided for @fieldOptionalSuffix.
  ///
  /// In en, this message translates to:
  /// **'  (optional)'**
  String get fieldOptionalSuffix;

  /// No description provided for @actionSaveSession.
  ///
  /// In en, this message translates to:
  /// **'Save session'**
  String get actionSaveSession;

  /// No description provided for @actionDeleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get actionDeleteSession;

  /// No description provided for @addAnotherActivity.
  ///
  /// In en, this message translates to:
  /// **'Add another activity'**
  String get addAnotherActivity;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String sessionsCount(int count);

  /// No description provided for @recurrenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get recurrenceLabel;

  /// No description provided for @recurrenceOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get recurrenceOnce;

  /// No description provided for @recurrenceDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get recurrenceDaily;

  /// No description provided for @recurrenceWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurrenceWeekly;

  /// No description provided for @recurrenceWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get recurrenceWeekdays;

  /// No description provided for @recurrenceWeekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get recurrenceWeekends;

  /// No description provided for @repeatForLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat for'**
  String get repeatForLabel;

  /// No description provided for @weeksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week} other{{count} weeks}}'**
  String weeksCount(int count);

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @durationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Set duration'**
  String get durationPlaceholder;

  /// No description provided for @durationHoursWheel.
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String durationHoursWheel(int count);

  /// No description provided for @durationMinutesWheel.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String durationMinutesWheel(int count);

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @timePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Set time'**
  String get timePlaceholder;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @typeMore.
  ///
  /// In en, this message translates to:
  /// **'More…'**
  String get typeMore;

  /// No description provided for @subTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose activity type'**
  String get subTypeTitle;

  /// No description provided for @subTypeSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get subTypeSearchPlaceholder;

  /// No description provided for @subTypeNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get subTypeNoResults;

  /// No description provided for @typeRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get typeRun;

  /// No description provided for @typeTrailRun.
  ///
  /// In en, this message translates to:
  /// **'Trail Run'**
  String get typeTrailRun;

  /// No description provided for @typeHike.
  ///
  /// In en, this message translates to:
  /// **'Hike'**
  String get typeHike;

  /// No description provided for @typeWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get typeWalk;

  /// No description provided for @typeCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get typeCycle;

  /// No description provided for @typeMtb.
  ///
  /// In en, this message translates to:
  /// **'MTB'**
  String get typeMtb;

  /// No description provided for @typeSwim.
  ///
  /// In en, this message translates to:
  /// **'Swim'**
  String get typeSwim;

  /// No description provided for @typeGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get typeGym;

  /// No description provided for @typeYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get typeYoga;

  /// No description provided for @typeHiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get typeHiit;

  /// No description provided for @typeRow.
  ///
  /// In en, this message translates to:
  /// **'Row'**
  String get typeRow;

  /// No description provided for @typeSki.
  ///
  /// In en, this message translates to:
  /// **'Ski'**
  String get typeSki;

  /// No description provided for @typeSurf.
  ///
  /// In en, this message translates to:
  /// **'Surf'**
  String get typeSurf;

  /// No description provided for @typeClimb.
  ///
  /// In en, this message translates to:
  /// **'Climb'**
  String get typeClimb;

  /// No description provided for @typeTennis.
  ///
  /// In en, this message translates to:
  /// **'Tennis'**
  String get typeTennis;

  /// No description provided for @typePadel.
  ///
  /// In en, this message translates to:
  /// **'Padel'**
  String get typePadel;

  /// No description provided for @typeDance.
  ///
  /// In en, this message translates to:
  /// **'Dance'**
  String get typeDance;

  /// No description provided for @typeCombat.
  ///
  /// In en, this message translates to:
  /// **'Combat'**
  String get typeCombat;

  /// No description provided for @typeElliptical.
  ///
  /// In en, this message translates to:
  /// **'Elliptical'**
  String get typeElliptical;

  /// No description provided for @typeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get typeOther;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @statusToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statusToday;

  /// No description provided for @statusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get statusPlanned;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @activityNameFallback.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get activityNameFallback;

  /// No description provided for @oauthContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get oauthContinueGoogle;

  /// No description provided for @oauthContinueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get oauthContinueApple;

  /// No description provided for @themeLightTooltip.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get themeLightTooltip;

  /// No description provided for @themeDarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get themeDarkTooltip;

  /// No description provided for @tipDismissHint.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to continue'**
  String get tipDismissHint;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Plan your week. Move your body.'**
  String get loginTagline;

  /// No description provided for @loginTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms of Service'**
  String get loginTerms;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned yet'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateBody.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first session for the week.'**
  String get emptyStateBody;

  /// No description provided for @emptyStateAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get emptyStateAddCta;

  /// No description provided for @paywallComingSoonBadge.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get paywallComingSoonBadge;

  /// No description provided for @paywallBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium features are\non the way'**
  String get paywallBannerTitle;

  /// No description provided for @paywallBannerBody.
  ///
  /// In en, this message translates to:
  /// **'We\'re building something special.\nStay tuned for Kadence Pro.'**
  String get paywallBannerBody;

  /// No description provided for @paywallFeaturesHeader.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s coming:'**
  String get paywallFeaturesHeader;

  /// No description provided for @paywallStravaTitle.
  ///
  /// In en, this message translates to:
  /// **'Strava integration'**
  String get paywallStravaTitle;

  /// No description provided for @paywallStravaBody.
  ///
  /// In en, this message translates to:
  /// **'Import your history and auto-mark sessions as done'**
  String get paywallStravaBody;

  /// No description provided for @paywallStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced stats'**
  String get paywallStatsTitle;

  /// No description provided for @paywallStatsBody.
  ///
  /// In en, this message translates to:
  /// **'Full-year heatmap, insights, and shareable recaps'**
  String get paywallStatsBody;

  /// No description provided for @paywallDateFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Date filtering'**
  String get paywallDateFilterTitle;

  /// No description provided for @paywallDateFilterBody.
  ///
  /// In en, this message translates to:
  /// **'Filter all stats by any custom date range'**
  String get paywallDateFilterBody;

  /// No description provided for @paywallCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get paywallCloudTitle;

  /// No description provided for @paywallCloudBody.
  ///
  /// In en, this message translates to:
  /// **'Back up and access your data from any device'**
  String get paywallCloudBody;

  /// No description provided for @paywallCustomColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom colors'**
  String get paywallCustomColorsTitle;

  /// No description provided for @paywallCustomColorsBody.
  ///
  /// In en, this message translates to:
  /// **'Personalize activity type and theme colors'**
  String get paywallCustomColorsBody;

  /// No description provided for @paywallSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support an indie developer'**
  String get paywallSupportTitle;

  /// No description provided for @paywallSupportBody.
  ///
  /// In en, this message translates to:
  /// **'Your purchase helps keep Kadence alive'**
  String get paywallSupportBody;

  /// No description provided for @statsKpiSessions.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statsKpiSessions;

  /// No description provided for @statsKpiStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get statsKpiStreak;

  /// No description provided for @statsKpiAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get statsKpiAverage;

  /// No description provided for @statsWeekSuffix.
  ///
  /// In en, this message translates to:
  /// **'wk'**
  String get statsWeekSuffix;

  /// No description provided for @statsPerWeekSuffix.
  ///
  /// In en, this message translates to:
  /// **'/wk'**
  String get statsPerWeekSuffix;

  /// No description provided for @statsProSection.
  ///
  /// In en, this message translates to:
  /// **'Pro Stats'**
  String get statsProSection;

  /// No description provided for @statsHeatmapTitle.
  ///
  /// In en, this message translates to:
  /// **'{count}-week activity'**
  String statsHeatmapTitle(int count);

  /// No description provided for @statsHeatmapFilteredTo.
  ///
  /// In en, this message translates to:
  /// **'Filtered to {type}'**
  String statsHeatmapFilteredTo(String type);

  /// No description provided for @statsHeatmapTinted.
  ///
  /// In en, this message translates to:
  /// **'Tinted by primary activity'**
  String get statsHeatmapTinted;

  /// No description provided for @statsByActivity.
  ///
  /// In en, this message translates to:
  /// **'By activity'**
  String get statsByActivity;

  /// No description provided for @statsAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get statsAllTime;

  /// No description provided for @statsNoSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get statsNoSessionsYet;

  /// No description provided for @actionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// No description provided for @statsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No stats yet'**
  String get statsEmptyTitle;

  /// No description provided for @statsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Complete your first session to start tracking your progress.'**
  String get statsEmptyBody;

  /// No description provided for @statsTipFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter by activity'**
  String get statsTipFilterTitle;

  /// No description provided for @statsTipFilterBody.
  ///
  /// In en, this message translates to:
  /// **'Tap any activity type in \"By activity\" to highlight only that type on the heatmap'**
  String get statsTipFilterBody;

  /// No description provided for @statsPersonalRecordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get statsPersonalRecordsTitle;

  /// No description provided for @statsBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get statsBestStreak;

  /// No description provided for @statsBestWeek.
  ///
  /// In en, this message translates to:
  /// **'Best week'**
  String get statsBestWeek;

  /// No description provided for @statsBestDay.
  ///
  /// In en, this message translates to:
  /// **'Best day'**
  String get statsBestDay;

  /// No description provided for @statsWeeklyActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly activity'**
  String get statsWeeklyActivityTitle;

  /// No description provided for @statsAvg.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get statsAvg;

  /// No description provided for @statsBestDayOfWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Best day of week'**
  String get statsBestDayOfWeekTitle;

  /// No description provided for @statsDoneSessions.
  ///
  /// In en, this message translates to:
  /// **'Done sessions'**
  String get statsDoneSessions;

  /// No description provided for @statsCompletionRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Completion rate'**
  String get statsCompletionRateTitle;

  /// No description provided for @statsPlannedVsDone.
  ///
  /// In en, this message translates to:
  /// **'Planned vs done'**
  String get statsPlannedVsDone;

  /// No description provided for @statsMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statsMissed;

  /// No description provided for @statsMonthlyTrendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly trends'**
  String get statsMonthlyTrendsTitle;

  /// No description provided for @statsActivityVarietyTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity variety'**
  String get statsActivityVarietyTitle;

  /// No description provided for @statsLongestGapTitle.
  ///
  /// In en, this message translates to:
  /// **'Longest gap'**
  String get statsLongestGapTitle;

  /// No description provided for @statsBetweenSessions.
  ///
  /// In en, this message translates to:
  /// **'Between sessions'**
  String get statsBetweenSessions;

  /// No description provided for @statsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get statsNoData;

  /// No description provided for @statsMonthVsMonthTitle.
  ///
  /// In en, this message translates to:
  /// **'Month vs month'**
  String get statsMonthVsMonthTitle;

  /// No description provided for @statsMostConsistentTitle.
  ///
  /// In en, this message translates to:
  /// **'Most consistent'**
  String get statsMostConsistentTitle;

  /// No description provided for @statsCompletionByType.
  ///
  /// In en, this message translates to:
  /// **'Completion by type'**
  String get statsCompletionByType;

  /// No description provided for @statsWeeklyPatternsTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly patterns'**
  String get statsWeeklyPatternsTitle;

  /// No description provided for @statsWhenYouDo.
  ///
  /// In en, this message translates to:
  /// **'When you do each activity'**
  String get statsWhenYouDo;

  /// No description provided for @statsActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get statsActiveDays;

  /// No description provided for @statsBestMonth.
  ///
  /// In en, this message translates to:
  /// **'Best month'**
  String get statsBestMonth;

  /// No description provided for @statsTopActivity.
  ///
  /// In en, this message translates to:
  /// **'Top activity'**
  String get statsTopActivity;

  /// No description provided for @statsPeriodBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Period breakdown'**
  String get statsPeriodBreakdownTitle;

  /// No description provided for @statsPeriodNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions in this period'**
  String get statsPeriodNoSessions;

  /// No description provided for @statsAvgPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Avg / wk'**
  String get statsAvgPerWeek;

  /// No description provided for @statsConsistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get statsConsistency;

  /// No description provided for @statsPeakWeek.
  ///
  /// In en, this message translates to:
  /// **'Peak week'**
  String get statsPeakWeek;

  /// No description provided for @statsTrendingUp.
  ///
  /// In en, this message translates to:
  /// **'Trending up vs earlier in period'**
  String get statsTrendingUp;

  /// No description provided for @statsTrendingDown.
  ///
  /// In en, this message translates to:
  /// **'Trending down vs earlier in period'**
  String get statsTrendingDown;

  /// No description provided for @statsSteadyPace.
  ///
  /// In en, this message translates to:
  /// **'Steady pace'**
  String get statsSteadyPace;

  /// No description provided for @statsNoDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get statsNoDataYet;

  /// No description provided for @statsPeriodAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get statsPeriodAll;

  /// No description provided for @statsInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get statsInsightsTitle;

  /// No description provided for @insightFavoriteDay.
  ///
  /// In en, this message translates to:
  /// **'You train most on {day}s — {count} sessions total.'**
  String insightFavoriteDay(String day, int count);

  /// No description provided for @insightAboveAvg.
  ///
  /// In en, this message translates to:
  /// **'This month is {percent}% above your average. Keep it up!'**
  String insightAboveAvg(int percent);

  /// No description provided for @insightBelowAvg.
  ///
  /// In en, this message translates to:
  /// **'This month is quieter than usual. Still time to catch up!'**
  String get insightBelowAvg;

  /// No description provided for @insightVariety.
  ///
  /// In en, this message translates to:
  /// **'Great variety! You did {count} different activities in the last 30 days.'**
  String insightVariety(int count);

  /// No description provided for @insightFocused.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been focused on {type} lately. Try mixing it up!'**
  String insightFocused(String type);

  /// No description provided for @insightStreakStrong.
  ///
  /// In en, this message translates to:
  /// **'{weeks}-week streak! That\'s serious consistency.'**
  String insightStreakStrong(int weeks);

  /// No description provided for @insightStreakNew.
  ///
  /// In en, this message translates to:
  /// **'New streak started! Keep it going this week.'**
  String get insightStreakNew;

  /// No description provided for @insightBestMonth.
  ///
  /// In en, this message translates to:
  /// **'Best month ever with {count} sessions so far!'**
  String insightBestMonth(int count);

  /// No description provided for @recapTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your progress'**
  String get recapTitle;

  /// No description provided for @recapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate a summary card and share it with friends.'**
  String get recapSubtitle;

  /// No description provided for @recapThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get recapThisMonth;

  /// No description provided for @recapThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get recapThisYear;

  /// No description provided for @recapPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get recapPreview;

  /// No description provided for @recapShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get recapShare;

  /// No description provided for @recapActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get recapActivity;

  /// No description provided for @recapTopActivity.
  ///
  /// In en, this message translates to:
  /// **'Top activity: {label}'**
  String recapTopActivity(String label);

  /// No description provided for @recapStreakBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} wk'**
  String recapStreakBadge(int count);

  /// No description provided for @recapYearInReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'{year} Year in Review'**
  String recapYearInReviewTitle(int year);

  /// No description provided for @recapMonthGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting started!'**
  String get recapMonthGettingStarted;

  /// No description provided for @recapMonthUnstoppable.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable month!'**
  String get recapMonthUnstoppable;

  /// No description provided for @recapMonthCrushing.
  ///
  /// In en, this message translates to:
  /// **'Crushing it!'**
  String get recapMonthCrushing;

  /// No description provided for @recapMonthConsistency.
  ///
  /// In en, this message translates to:
  /// **'Incredible consistency!'**
  String get recapMonthConsistency;

  /// No description provided for @recapMonthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong month!'**
  String get recapMonthStrong;

  /// No description provided for @recapMonthMomentum.
  ///
  /// In en, this message translates to:
  /// **'Building momentum!'**
  String get recapMonthMomentum;

  /// No description provided for @recapYearBegins.
  ///
  /// In en, this message translates to:
  /// **'The journey begins!'**
  String get recapYearBegins;

  /// No description provided for @recapYearLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary year!'**
  String get recapYearLegendary;

  /// No description provided for @recapYearTripleDigits.
  ///
  /// In en, this message translates to:
  /// **'Triple digits!'**
  String get recapYearTripleDigits;

  /// No description provided for @recapYearStreakMachine.
  ///
  /// In en, this message translates to:
  /// **'Streak machine!'**
  String get recapYearStreakMachine;

  /// No description provided for @recapYearHalfHundred.
  ///
  /// In en, this message translates to:
  /// **'Half a hundred!'**
  String get recapYearHalfHundred;

  /// No description provided for @recapYearGoingStrong.
  ///
  /// In en, this message translates to:
  /// **'Going strong!'**
  String get recapYearGoingStrong;

  /// No description provided for @recapYearHabit.
  ///
  /// In en, this message translates to:
  /// **'Building the habit!'**
  String get recapYearHabit;

  /// No description provided for @statsLast12Months.
  ///
  /// In en, this message translates to:
  /// **'Last 12 months'**
  String get statsLast12Months;

  /// No description provided for @statsLast12Weeks.
  ///
  /// In en, this message translates to:
  /// **'Last 12 weeks'**
  String get statsLast12Weeks;

  /// No description provided for @statsTypesAllTime.
  ///
  /// In en, this message translates to:
  /// **'{count} types all time'**
  String statsTypesAllTime(int count);

  /// No description provided for @statsDifferentTypesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Different types per week (last 12 weeks)'**
  String get statsDifferentTypesPerWeek;

  /// No description provided for @statsNeedAtLeast2.
  ///
  /// In en, this message translates to:
  /// **'Need at least 2 sessions'**
  String get statsNeedAtLeast2;

  /// No description provided for @statsDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String statsDaysCount(int count);

  /// No description provided for @statsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today} =1{1 day ago} other{{count} days ago}}'**
  String statsDaysAgo(int count);

  /// No description provided for @statsSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{session} other{sessions}}'**
  String statsSessionsCount(int count);

  /// No description provided for @statsTypesCountShort.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 type} other{{count} types}}'**
  String statsTypesCountShort(int count);

  /// No description provided for @statsYearInReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'{year} in review'**
  String statsYearInReviewTitle(int year);

  /// No description provided for @statsYearHeatmapTitle.
  ///
  /// In en, this message translates to:
  /// **'{year} heatmap'**
  String statsYearHeatmapTitle(int year);

  /// No description provided for @statsActiveDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active days'**
  String statsActiveDaysCount(int count);

  /// No description provided for @statsTriedTypes.
  ///
  /// In en, this message translates to:
  /// **'You tried {count, plural, =1{1 different activity} other{{count} different activities}} this year'**
  String statsTriedTypes(int count);

  /// No description provided for @subtypeAlpineSki.
  ///
  /// In en, this message translates to:
  /// **'Alpine Ski'**
  String get subtypeAlpineSki;

  /// No description provided for @subtypeBadminton.
  ///
  /// In en, this message translates to:
  /// **'Badminton'**
  String get subtypeBadminton;

  /// No description provided for @subtypeCanoeing.
  ///
  /// In en, this message translates to:
  /// **'Canoeing'**
  String get subtypeCanoeing;

  /// No description provided for @subtypeCrossfit.
  ///
  /// In en, this message translates to:
  /// **'Crossfit'**
  String get subtypeCrossfit;

  /// No description provided for @subtypeEbikeRide.
  ///
  /// In en, this message translates to:
  /// **'E-Bike Ride'**
  String get subtypeEbikeRide;

  /// No description provided for @subtypeFencing.
  ///
  /// In en, this message translates to:
  /// **'Fencing'**
  String get subtypeFencing;

  /// No description provided for @subtypeGolf.
  ///
  /// In en, this message translates to:
  /// **'Golf'**
  String get subtypeGolf;

  /// No description provided for @subtypeHandball.
  ///
  /// In en, this message translates to:
  /// **'Handball'**
  String get subtypeHandball;

  /// No description provided for @subtypeIceSkate.
  ///
  /// In en, this message translates to:
  /// **'Ice Skate'**
  String get subtypeIceSkate;

  /// No description provided for @subtypeInlineSkate.
  ///
  /// In en, this message translates to:
  /// **'Inline Skate'**
  String get subtypeInlineSkate;

  /// No description provided for @subtypeKayaking.
  ///
  /// In en, this message translates to:
  /// **'Kayaking'**
  String get subtypeKayaking;

  /// No description provided for @subtypeKitesurf.
  ///
  /// In en, this message translates to:
  /// **'Kitesurf'**
  String get subtypeKitesurf;

  /// No description provided for @subtypeMartialArts.
  ///
  /// In en, this message translates to:
  /// **'Martial Arts'**
  String get subtypeMartialArts;

  /// No description provided for @subtypePilates.
  ///
  /// In en, this message translates to:
  /// **'Pilates'**
  String get subtypePilates;

  /// No description provided for @subtypePickleball.
  ///
  /// In en, this message translates to:
  /// **'Pickleball'**
  String get subtypePickleball;

  /// No description provided for @subtypeRacquetball.
  ///
  /// In en, this message translates to:
  /// **'Racquetball'**
  String get subtypeRacquetball;

  /// No description provided for @subtypeRockClimbing.
  ///
  /// In en, this message translates to:
  /// **'Rock Climbing'**
  String get subtypeRockClimbing;

  /// No description provided for @subtypeRollerSki.
  ///
  /// In en, this message translates to:
  /// **'Roller Ski'**
  String get subtypeRollerSki;

  /// No description provided for @subtypeRowing.
  ///
  /// In en, this message translates to:
  /// **'Rowing'**
  String get subtypeRowing;

  /// No description provided for @subtypeRugby.
  ///
  /// In en, this message translates to:
  /// **'Rugby'**
  String get subtypeRugby;

  /// No description provided for @subtypeSailing.
  ///
  /// In en, this message translates to:
  /// **'Sailing'**
  String get subtypeSailing;

  /// No description provided for @subtypeSkateboarding.
  ///
  /// In en, this message translates to:
  /// **'Skateboarding'**
  String get subtypeSkateboarding;

  /// No description provided for @subtypeSnowboard.
  ///
  /// In en, this message translates to:
  /// **'Snowboard'**
  String get subtypeSnowboard;

  /// No description provided for @subtypeSnowshoe.
  ///
  /// In en, this message translates to:
  /// **'Snowshoe'**
  String get subtypeSnowshoe;

  /// No description provided for @subtypeSoccer.
  ///
  /// In en, this message translates to:
  /// **'Soccer'**
  String get subtypeSoccer;

  /// No description provided for @subtypeSquash.
  ///
  /// In en, this message translates to:
  /// **'Squash'**
  String get subtypeSquash;

  /// No description provided for @subtypeStairStepper.
  ///
  /// In en, this message translates to:
  /// **'Stair Stepper'**
  String get subtypeStairStepper;

  /// No description provided for @subtypeStandUpPaddling.
  ///
  /// In en, this message translates to:
  /// **'Stand Up Paddling'**
  String get subtypeStandUpPaddling;

  /// No description provided for @subtypeSwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get subtypeSwimming;

  /// No description provided for @subtypeTableTennis.
  ///
  /// In en, this message translates to:
  /// **'Table Tennis'**
  String get subtypeTableTennis;

  /// No description provided for @subtypeTrailRun.
  ///
  /// In en, this message translates to:
  /// **'Trail Run'**
  String get subtypeTrailRun;

  /// No description provided for @subtypeVelomobile.
  ///
  /// In en, this message translates to:
  /// **'Velomobile'**
  String get subtypeVelomobile;

  /// No description provided for @subtypeVirtualRide.
  ///
  /// In en, this message translates to:
  /// **'Virtual Ride'**
  String get subtypeVirtualRide;

  /// No description provided for @subtypeVirtualRow.
  ///
  /// In en, this message translates to:
  /// **'Virtual Row'**
  String get subtypeVirtualRow;

  /// No description provided for @subtypeVirtualRun.
  ///
  /// In en, this message translates to:
  /// **'Virtual Run'**
  String get subtypeVirtualRun;

  /// No description provided for @subtypeVolleyball.
  ///
  /// In en, this message translates to:
  /// **'Volleyball'**
  String get subtypeVolleyball;

  /// No description provided for @subtypeWeightlifting.
  ///
  /// In en, this message translates to:
  /// **'Weightlifting'**
  String get subtypeWeightlifting;

  /// No description provided for @subtypeWheelchair.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair'**
  String get subtypeWheelchair;

  /// No description provided for @subtypeWindsurf.
  ///
  /// In en, this message translates to:
  /// **'Windsurf'**
  String get subtypeWindsurf;

  /// No description provided for @subtypeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get subtypeWorkout;

  /// No description provided for @subtypeYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get subtypeYoga;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

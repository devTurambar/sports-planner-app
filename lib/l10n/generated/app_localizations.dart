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

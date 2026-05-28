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

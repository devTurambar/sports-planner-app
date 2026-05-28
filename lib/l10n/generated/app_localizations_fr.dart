// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settingsSectionApp => 'Application';

  @override
  String get settingsSectionData => 'Données';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsDarkMode => 'Mode sombre';

  @override
  String get settingsWeekStartsOn => 'La semaine commence le';

  @override
  String get weekdaySunday => 'Dimanche';

  @override
  String get weekdayMonday => 'Lundi';

  @override
  String get settingsWeeklyGoal => 'Objectif hebdomadaire';

  @override
  String weeklyGoalSessions(int count) {
    return '$count séances';
  }

  @override
  String get weeklyGoalOff => 'Désactivé';

  @override
  String get weeklyGoalPrompt =>
      'Combien de séances par semaine veux-tu réaliser ?';

  @override
  String get settingsThemeColor => 'Couleur du thème';

  @override
  String get settingsCalendarSync => 'Synchronisation du calendrier';

  @override
  String get settingsCalendars => 'Calendriers';

  @override
  String get calendarsAll => 'Tous les calendriers';

  @override
  String calendarsCount(int count) {
    return '$count calendriers';
  }

  @override
  String get calendarsFallback => 'Calendrier';

  @override
  String get calendarsOff => 'Désactivée';

  @override
  String get calendarsLoading => '…';

  @override
  String get calendarsChooseTitle => 'Choisir les calendriers';

  @override
  String get settingsTypeColors => 'Couleurs par type';

  @override
  String get settingsTypeColorsValue => 'Personnaliser';

  @override
  String get typeColorsResetAll => 'Tout réinitialiser';

  @override
  String get settingsExportData => 'Exporter les données';

  @override
  String get settingsExportValue => 'Partager';

  @override
  String get settingsImportData => 'Importer des données';

  @override
  String get settingsImportValue => 'Charger';

  @override
  String get exportFailed => 'Échec de l’export';

  @override
  String get importReplaceTitle => 'Remplacer toutes les données ?';

  @override
  String importReplaceBody(int count) {
    return 'Cela remplacera toutes tes données actuelles par les données importées ($count activités).';
  }

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionReplace => 'Remplacer';

  @override
  String get actionDone => 'Terminé';

  @override
  String importedActivities(int count) {
    return '$count activités importées';
  }

  @override
  String get calendarSyncPromptTitle => 'Synchroniser avec le calendrier ?';

  @override
  String get calendarSyncPromptBody =>
      'Ajouter les activités importées au calendrier de l’appareil ? Les événements correspondants existants seront ignorés.';

  @override
  String get actionNoThanks => 'Non merci';

  @override
  String get actionSync => 'Synchroniser';

  @override
  String calendarSyncedAll(int synced) {
    return '$synced événements synchronisés dans le calendrier';
  }

  @override
  String calendarSyncedWithSkipped(int synced, int skipped) {
    return '$synced événements synchronisés ($skipped déjà dans le calendrier)';
  }

  @override
  String get settingsRedoOnboarding => 'Refaire l’introduction';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsRateKadence => 'Noter Kadence';

  @override
  String settingsVersion(String version) {
    return 'Kadence · v$version';
  }

  @override
  String get accountSignInToSync => 'Connecte-toi pour synchroniser';

  @override
  String get accountSignInSubtitle =>
      'Sauvegarde et retrouve tes données partout';

  @override
  String get accountSignedInFallback => 'Connecté';

  @override
  String get accountSyncingEnabled => 'Synchronisation active';

  @override
  String get accountSignOut => 'Se déconnecter';

  @override
  String get signInSheetSubtitle =>
      'Sauvegarde tes données et retrouve-les sur n’importe quel appareil.';

  @override
  String get proCardSubtitle => 'Fonctionnalités premium bientôt disponibles';

  @override
  String get proBadge => 'PRO';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get languageSystem => 'Par défaut du système';

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

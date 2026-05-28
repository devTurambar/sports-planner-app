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

  @override
  String get actionBack => 'Retour';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get onboardingWelcomeTagline => 'Planifie, suis et bouge.';

  @override
  String get onboardingWelcomeFeature1 =>
      'Un suivi hebdomadaire simple de tes activités';

  @override
  String get onboardingWelcomeFeature2 =>
      'Coche tes séances au fur et à mesure';

  @override
  String get onboardingWelcomeFeature3 =>
      'Aucune culpabilité pour les jours de repos';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingCalendarTitle => 'Synchronisation du calendrier';

  @override
  String get onboardingCalendarBody =>
      'Tes séances planifiées se synchronisent automatiquement avec le calendrier de ton appareil pour que tout reste au même endroit.';

  @override
  String get onboardingCalendarFeature1 =>
      'Les activités apparaissent sur ton calendrier';

  @override
  String get onboardingCalendarFeature2 =>
      'Les modifications et suppressions restent synchronisées';

  @override
  String get onboardingCalendarFeature3 =>
      'Choisis ton calendrier dans les Paramètres';

  @override
  String get onboardingSignInTitle => 'Garde tes données en sécurité';

  @override
  String get onboardingSignInBody =>
      'Choisis comment sauvegarder tes séances.\nTu peux changer cela à tout moment dans les Paramètres.';

  @override
  String get onboardingManualTitle => 'Sauvegarde manuelle';

  @override
  String get onboardingManualBody =>
      'Exporte et importe tes données sous forme de fichier depuis les Paramètres quand tu veux.';

  @override
  String get onboardingContinueWithoutAccount => 'Continuer sans compte';

  @override
  String get onboardingCloudTitle => 'Synchronisation cloud';

  @override
  String get onboardingCloudBody =>
      'Connecte-toi avec ton compte pour synchroniser automatiquement entre appareils.';

  @override
  String get navWeek => 'Semaine';

  @override
  String get navMonth => 'Mois';

  @override
  String get navStats => 'Stats';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get weekThisWeek => 'Cette semaine';

  @override
  String weekSummaryCaption(int percent) {
    return 'séances faites · $percent% dans les temps';
  }

  @override
  String weekSummaryGoal(int done, int goal) {
    return '$done/$goal objectif hebdo';
  }

  @override
  String get dayEmptyPast => 'Jour de repos';

  @override
  String get dayEmptyFuture => 'Aucune séance';

  @override
  String dayMoreBadge(int count) {
    return '+$count';
  }

  @override
  String get tipSwipeTitle => 'Glisse pour naviguer entre les semaines';

  @override
  String get tipSwipeBody =>
      'Glisse vers la gauche ou la droite pour voir les semaines passées et à venir';

  @override
  String get tipDoubleTapTitle => 'Double-tape pour cocher';

  @override
  String get tipDoubleTapBody =>
      'Marque rapidement les séances du jour comme faites en double-tapant';

  @override
  String get tipLongPressTitle => 'Appui long pour supprimer';

  @override
  String get tipLongPressBody =>
      'Appuie longuement sur un jour pour supprimer toutes ses séances';

  @override
  String get tipTitleNavTitle => 'Tape le titre pour revenir';

  @override
  String tipTitleNavBody(String label) {
    return 'Tape \"$label\" en haut pour revenir à la semaine actuelle';
  }

  @override
  String get deleteDayTitle => 'Supprimer toutes les séances ?';

  @override
  String get deleteDayBody =>
      'Toutes les séances de ce jour seront supprimées. Cette action est irréversible.';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get statsDone => 'Faites';

  @override
  String get statsPlanned => 'Prévues';

  @override
  String get statsOnTrack => 'Dans les temps';

  @override
  String get deleteSessionTitle => 'Supprimer la séance ?';

  @override
  String get deleteSessionBody => 'Cette action est irréversible.';

  @override
  String get selectedDayEmpty => 'Rien de prévu';

  @override
  String get selectedDayAdd => 'Ajouter';

  @override
  String get tipMonthTitleNavBody =>
      'Tape le titre en haut pour revenir au mois actuel';

  @override
  String get sheetAddTitle => 'Ajouter une séance';

  @override
  String get sheetEditTitle => 'Modifier la séance';

  @override
  String get activityNameLabel => 'Nom de l’activité';

  @override
  String get activityNamePlaceholder => 'ex : Course du matin';

  @override
  String get notesLabel => 'Notes';

  @override
  String get notesPlaceholder => 'Détails supplémentaires…';

  @override
  String get fieldOptionalSuffix => '  (facultatif)';

  @override
  String get actionSaveSession => 'Enregistrer';

  @override
  String get actionDeleteSession => 'Supprimer la séance';

  @override
  String get addAnotherActivity => 'Ajouter une autre activité';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séances',
      one: '1 séance',
    );
    return '$_temp0';
  }

  @override
  String get recurrenceLabel => 'Répétition';

  @override
  String get recurrenceOnce => 'Une fois';

  @override
  String get recurrenceDaily => 'Quotidien';

  @override
  String get recurrenceWeekly => 'Hebdomadaire';

  @override
  String get recurrenceWeekdays => 'Jours ouvrés';

  @override
  String get recurrenceWeekends => 'Week-ends';

  @override
  String get repeatForLabel => 'Répéter pendant';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semaines',
      one: '1 semaine',
    );
    return '$_temp0';
  }

  @override
  String get durationLabel => 'Durée';

  @override
  String get durationPlaceholder => 'Définir la durée';

  @override
  String durationHoursWheel(int count) {
    return '$count h';
  }

  @override
  String durationMinutesWheel(int count) {
    return '$count min';
  }

  @override
  String get timeLabel => 'Heure';

  @override
  String get timePlaceholder => 'Définir l’heure';

  @override
  String get typeLabel => 'Type';

  @override
  String get typeMore => 'Plus…';

  @override
  String get subTypeTitle => 'Choisis le type d’activité';

  @override
  String get subTypeSearchPlaceholder => 'Rechercher…';

  @override
  String get subTypeNoResults => 'Aucun résultat';

  @override
  String get typeRun => 'Course';

  @override
  String get typeTrailRun => 'Trail';

  @override
  String get typeHike => 'Randonnée';

  @override
  String get typeWalk => 'Marche';

  @override
  String get typeCycle => 'Vélo';

  @override
  String get typeMtb => 'VTT';

  @override
  String get typeSwim => 'Natation';

  @override
  String get typeGym => 'Salle';

  @override
  String get typeYoga => 'Yoga';

  @override
  String get typeHiit => 'HIIT';

  @override
  String get typeRow => 'Aviron';

  @override
  String get typeSki => 'Ski';

  @override
  String get typeSurf => 'Surf';

  @override
  String get typeClimb => 'Escalade';

  @override
  String get typeTennis => 'Tennis';

  @override
  String get typePadel => 'Padel';

  @override
  String get typeDance => 'Danse';

  @override
  String get typeCombat => 'Combat';

  @override
  String get typeElliptical => 'Elliptique';

  @override
  String get typeOther => 'Autre';

  @override
  String get statusDone => 'Faite';

  @override
  String get statusToday => 'Aujourd’hui';

  @override
  String get statusPlanned => 'Prévue';

  @override
  String get statusOpen => 'Ouverte';

  @override
  String get activityNameFallback => 'Séance';
}

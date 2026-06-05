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
  String get settingsTypeColorsValue => 'Modifier';

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

  @override
  String get oauthContinueGoogle => 'Continuer avec Google';

  @override
  String get oauthContinueApple => 'Continuer avec Apple';

  @override
  String get themeLightTooltip => 'Mode clair';

  @override
  String get themeDarkTooltip => 'Mode sombre';

  @override
  String get tipDismissHint => 'Tape n’importe où pour continuer';

  @override
  String get loginTagline => 'Planifie ta semaine. Bouge ton corps.';

  @override
  String get loginTerms =>
      'En continuant, tu acceptes nos Conditions d’utilisation';

  @override
  String get emptyStateTitle => 'Rien de prévu pour l’instant';

  @override
  String get emptyStateBody =>
      'Tape sur + pour ajouter ta première séance de la semaine.';

  @override
  String get emptyStateAddCta => 'Ajouter une activité';

  @override
  String get paywallComingSoonBadge => 'Bientôt';

  @override
  String get paywallBannerTitle => 'Les fonctionnalités premium\narrivent';

  @override
  String get paywallBannerBody =>
      'Nous préparons quelque chose de spécial.\nReste à l’écoute pour Kadence Pro.';

  @override
  String get paywallFeaturesHeader => 'Voici ce qui arrive :';

  @override
  String get paywallStravaTitle => 'Intégration Strava';

  @override
  String get paywallStravaBody =>
      'Importe ton historique et marque les séances comme faites automatiquement';

  @override
  String get paywallStatsTitle => 'Statistiques avancées';

  @override
  String get paywallStatsBody =>
      'Carte thermique annuelle, insights et cartes à partager';

  @override
  String get paywallDateFilterTitle => 'Filtres par date';

  @override
  String get paywallDateFilterBody =>
      'Filtre toutes les stats par n’importe quelle plage de dates';

  @override
  String get paywallCloudTitle => 'Synchronisation cloud';

  @override
  String get paywallCloudBody =>
      'Sauvegarde et retrouve tes données sur n’importe quel appareil';

  @override
  String get paywallCustomColorsTitle => 'Couleurs personnalisées';

  @override
  String get paywallCustomColorsBody =>
      'Personnalise les couleurs des types d’activité et du thème';

  @override
  String get paywallSupportTitle => 'Soutiens un développeur indépendant';

  @override
  String get paywallSupportBody => 'Ton achat aide à maintenir Kadence en vie';

  @override
  String get statsKpiSessions => 'Terminées';

  @override
  String get statsKpiStreak => 'Série';

  @override
  String get statsKpiAverage => 'Moyenne';

  @override
  String get statsWeekSuffix => 'sem';

  @override
  String get statsPerWeekSuffix => '/sem';

  @override
  String get statsProSection => 'Stats Pro';

  @override
  String statsHeatmapTitle(int count) {
    return 'Activité sur $count semaines';
  }

  @override
  String statsHeatmapFilteredTo(String type) {
    return 'Filtré sur $type';
  }

  @override
  String get statsHeatmapTinted => 'Couleur de l’activité principale';

  @override
  String get statsByActivity => 'Par activité';

  @override
  String get statsAllTime => 'Tout';

  @override
  String get statsNoSessionsYet => 'Aucune séance pour l’instant';

  @override
  String get actionClear => 'Effacer';

  @override
  String get statsEmptyTitle => 'Aucune stat pour l’instant';

  @override
  String get statsEmptyBody =>
      'Termine ta première séance pour suivre tes progrès.';

  @override
  String get statsTipFilterTitle => 'Filtrer par activité';

  @override
  String get statsTipFilterBody =>
      'Tape un type d’activité dans \"Par activité\" pour le mettre en évidence sur la carte thermique';

  @override
  String get statsPersonalRecordsTitle => 'Records personnels';

  @override
  String get statsBestStreak => 'Meilleure série';

  @override
  String get statsBestWeek => 'Meilleure semaine';

  @override
  String get statsBestDay => 'Meilleur jour';

  @override
  String get statsWeeklyActivityTitle => 'Activité hebdo';

  @override
  String get statsAvg => 'Moy';

  @override
  String get statsBestDayOfWeekTitle => 'Meilleur jour de la semaine';

  @override
  String get statsDoneSessions => 'Séances faites';

  @override
  String get statsCompletionRateTitle => 'Taux de réussite';

  @override
  String get statsPlannedVsDone => 'Prévues vs faites';

  @override
  String get statsMissed => 'Manquées';

  @override
  String get statsMonthlyTrendsTitle => 'Tendances mensuelles';

  @override
  String get statsActivityVarietyTitle => 'Variété d’activités';

  @override
  String get statsLongestGapTitle => 'Plus grande pause';

  @override
  String get statsBetweenSessions => 'Entre séances';

  @override
  String get statsNoData => 'Pas de données';

  @override
  String get statsMonthVsMonthTitle => 'Mois vs mois';

  @override
  String get statsMostConsistentTitle => 'Plus régulières';

  @override
  String get statsCompletionByType => 'Réussite par type';

  @override
  String get statsWeeklyPatternsTitle => 'Habitudes hebdo';

  @override
  String get statsWhenYouDo => 'Quand tu fais chaque activité';

  @override
  String get statsActiveDays => 'Jours actifs';

  @override
  String get statsBestMonth => 'Meilleur mois';

  @override
  String get statsTopActivity => 'Top activité';

  @override
  String get statsPeriodBreakdownTitle => 'Analyse par période';

  @override
  String get statsPeriodNoSessions => 'Aucune séance sur cette période';

  @override
  String get statsAvgPerWeek => 'Moy / sem';

  @override
  String get statsConsistency => 'Régularité';

  @override
  String get statsPeakWeek => 'Semaine record';

  @override
  String get statsTrendingUp => 'En hausse vs début de période';

  @override
  String get statsTrendingDown => 'En baisse vs début de période';

  @override
  String get statsSteadyPace => 'Rythme régulier';

  @override
  String get statsNoDataYet => 'Pas encore de données';

  @override
  String get statsPeriodAll => 'Tout';

  @override
  String get statsInsightsTitle => 'Insights';

  @override
  String insightFavoriteDay(String day, int count) {
    return 'Tu t’entraînes surtout le $day — $count séances au total.';
  }

  @override
  String insightAboveAvg(int percent) {
    return 'Ce mois est $percent% au-dessus de ta moyenne. Continue !';
  }

  @override
  String get insightBelowAvg =>
      'Ce mois est plus calme que d’habitude. Il reste du temps !';

  @override
  String insightVariety(int count) {
    return 'Belle variété ! Tu as fait $count activités différentes ces 30 derniers jours.';
  }

  @override
  String insightFocused(String type) {
    return 'Tu te concentres sur $type en ce moment. Essaie autre chose !';
  }

  @override
  String insightStreakStrong(int weeks) {
    return 'Série de $weeks semaines ! Belle régularité.';
  }

  @override
  String get insightStreakNew =>
      'Nouvelle série ! Garde le rythme cette semaine.';

  @override
  String insightBestMonth(int count) {
    return 'Meilleur mois de tous les temps avec $count séances jusqu’ici !';
  }

  @override
  String get recapTitle => 'Partage tes progrès';

  @override
  String get recapSubtitle =>
      'Génère une carte récap et partage-la avec tes amis.';

  @override
  String get recapThisMonth => 'Ce mois';

  @override
  String get recapThisYear => 'Cette année';

  @override
  String get recapPreview => 'Aperçu';

  @override
  String get recapShare => 'Partager';

  @override
  String get recapActivity => 'Activité';

  @override
  String recapTopActivity(String label) {
    return 'Top activité : $label';
  }

  @override
  String recapStreakBadge(int count) {
    return '$count sem';
  }

  @override
  String recapYearInReviewTitle(int year) {
    return 'Bilan $year';
  }

  @override
  String get recapMonthGettingStarted => 'On démarre !';

  @override
  String get recapMonthUnstoppable => 'Mois imparable !';

  @override
  String get recapMonthCrushing => 'Tu déchires !';

  @override
  String get recapMonthConsistency => 'Régularité incroyable !';

  @override
  String get recapMonthStrong => 'Mois solide !';

  @override
  String get recapMonthMomentum => 'On prend de l’élan !';

  @override
  String get recapYearBegins => 'Le voyage commence !';

  @override
  String get recapYearLegendary => 'Année légendaire !';

  @override
  String get recapYearTripleDigits => 'Trois chiffres !';

  @override
  String get recapYearStreakMachine => 'Machine à séries !';

  @override
  String get recapYearHalfHundred => 'Une demi-centaine !';

  @override
  String get recapYearGoingStrong => 'On continue !';

  @override
  String get recapYearHabit => 'L’habitude se forge !';

  @override
  String get statsLast12Months => '12 derniers mois';

  @override
  String get statsLast12Weeks => '12 dernières semaines';

  @override
  String statsTypesAllTime(int count) {
    return '$count types au total';
  }

  @override
  String get statsDifferentTypesPerWeek =>
      'Types différents par semaine (12 dernières)';

  @override
  String get statsNeedAtLeast2 => 'Au moins 2 séances';

  @override
  String statsDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String statsDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
      zero: 'Aujourd’hui',
    );
    return '$_temp0';
  }

  @override
  String statsSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'séances',
      one: 'séance',
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
    return 'Bilan $year';
  }

  @override
  String statsYearHeatmapTitle(int year) {
    return 'Carte thermique $year';
  }

  @override
  String statsActiveDaysCount(int count) {
    return '$count jours actifs';
  }

  @override
  String statsTriedTypes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activités différentes',
      one: '1 activité différente',
    );
    return 'Tu as essayé $_temp0 cette année';
  }

  @override
  String get subtypeAlpineSki => 'Ski Alpin';

  @override
  String get subtypeBadminton => 'Badminton';

  @override
  String get subtypeCanoeing => 'Canoë';

  @override
  String get subtypeCrossfit => 'Crossfit';

  @override
  String get subtypeEbikeRide => 'Vélo Électrique';

  @override
  String get subtypeFencing => 'Escrime';

  @override
  String get subtypeGolf => 'Golf';

  @override
  String get subtypeHandball => 'Handball';

  @override
  String get subtypeIceSkate => 'Patinage sur Glace';

  @override
  String get subtypeInlineSkate => 'Roller';

  @override
  String get subtypeKayaking => 'Kayak';

  @override
  String get subtypeKitesurf => 'Kitesurf';

  @override
  String get subtypeMartialArts => 'Arts Martiaux';

  @override
  String get subtypePilates => 'Pilates';

  @override
  String get subtypePickleball => 'Pickleball';

  @override
  String get subtypeRacquetball => 'Racquetball';

  @override
  String get subtypeRockClimbing => 'Escalade';

  @override
  String get subtypeRollerSki => 'Ski à Roulettes';

  @override
  String get subtypeRowing => 'Aviron';

  @override
  String get subtypeRugby => 'Rugby';

  @override
  String get subtypeSailing => 'Voile';

  @override
  String get subtypeSkateboarding => 'Skateboard';

  @override
  String get subtypeSnowboard => 'Snowboard';

  @override
  String get subtypeSnowshoe => 'Raquettes';

  @override
  String get subtypeSoccer => 'Football';

  @override
  String get subtypeSquash => 'Squash';

  @override
  String get subtypeStairStepper => 'Stepper';

  @override
  String get subtypeStandUpPaddling => 'Stand Up Paddle';

  @override
  String get subtypeSwimming => 'Natation';

  @override
  String get subtypeTableTennis => 'Tennis de Table';

  @override
  String get subtypeTrailRun => 'Trail';

  @override
  String get subtypeVelomobile => 'Vélomobile';

  @override
  String get subtypeVirtualRide => 'Vélo Virtuel';

  @override
  String get subtypeVirtualRow => 'Aviron Virtuel';

  @override
  String get subtypeVirtualRun => 'Course Virtuelle';

  @override
  String get subtypeVolleyball => 'Volleyball';

  @override
  String get subtypeWeightlifting => 'Musculation';

  @override
  String get subtypeWheelchair => 'Fauteuil Roulant';

  @override
  String get subtypeWindsurf => 'Windsurf';

  @override
  String get subtypeWorkout => 'Entraînement';

  @override
  String get subtypeYoga => 'Yoga';
}

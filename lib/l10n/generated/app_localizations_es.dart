// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsSectionApp => 'Aplicación';

  @override
  String get settingsSectionData => 'Datos';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsDarkMode => 'Modo oscuro';

  @override
  String get settingsWeekStartsOn => 'La semana empieza el';

  @override
  String get weekdaySunday => 'Domingo';

  @override
  String get weekdayMonday => 'Lunes';

  @override
  String get settingsWeeklyGoal => 'Objetivo semanal';

  @override
  String weeklyGoalSessions(int count) {
    return '$count sesiones';
  }

  @override
  String get weeklyGoalOff => 'Desactivado';

  @override
  String get weeklyGoalPrompt =>
      '¿Cuántas sesiones por semana quieres completar?';

  @override
  String get settingsThemeColor => 'Color del tema';

  @override
  String get settingsCalendarSync => 'Sincronizar calendario';

  @override
  String get settingsCalendars => 'Calendarios';

  @override
  String get calendarsAll => 'Todos los calendarios';

  @override
  String calendarsCount(int count) {
    return '$count calendarios';
  }

  @override
  String get calendarsFallback => 'Calendario';

  @override
  String get calendarsOff => 'Desactivado';

  @override
  String get calendarsLoading => '…';

  @override
  String get calendarsChooseTitle => 'Elegir calendarios';

  @override
  String get settingsTypeColors => 'Colores por tipo';

  @override
  String get settingsTypeColorsValue => 'Personalizar';

  @override
  String get typeColorsResetAll => 'Restablecer todo';

  @override
  String get settingsExportData => 'Exportar datos';

  @override
  String get settingsExportValue => 'Compartir';

  @override
  String get settingsImportData => 'Importar datos';

  @override
  String get settingsImportValue => 'Cargar';

  @override
  String get exportFailed => 'Error al exportar';

  @override
  String get importReplaceTitle => '¿Reemplazar todos los datos?';

  @override
  String importReplaceBody(int count) {
    return 'Esto reemplazará todos tus datos actuales por los datos importados ($count actividades).';
  }

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionReplace => 'Reemplazar';

  @override
  String get actionDone => 'Hecho';

  @override
  String importedActivities(int count) {
    return 'Se han importado $count actividades';
  }

  @override
  String get calendarSyncPromptTitle => '¿Sincronizar con el calendario?';

  @override
  String get calendarSyncPromptBody =>
      '¿Añadir las actividades importadas al calendario del dispositivo? Los eventos coincidentes existentes se omitirán.';

  @override
  String get actionNoThanks => 'No, gracias';

  @override
  String get actionSync => 'Sincronizar';

  @override
  String calendarSyncedAll(int synced) {
    return 'Se sincronizaron $synced eventos en el calendario';
  }

  @override
  String calendarSyncedWithSkipped(int synced, int skipped) {
    return 'Se sincronizaron $synced eventos ($skipped ya en el calendario)';
  }

  @override
  String get settingsRedoOnboarding => 'Rehacer introducción';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsRateKadence => 'Valorar Kadence';

  @override
  String settingsVersion(String version) {
    return 'Kadence · v$version';
  }

  @override
  String get accountSignInToSync => 'Inicia sesión para sincronizar';

  @override
  String get accountSignInSubtitle =>
      'Haz copia de seguridad y accede a tus datos donde quieras';

  @override
  String get accountSignedInFallback => 'Sesión iniciada';

  @override
  String get accountSyncingEnabled => 'Sincronización activa';

  @override
  String get accountSignOut => 'Cerrar sesión';

  @override
  String get signInSheetSubtitle =>
      'Haz copia de seguridad de tus datos y accede a ellos desde cualquier dispositivo.';

  @override
  String get proCardSubtitle => 'Funciones premium próximamente';

  @override
  String get proBadge => 'PRO';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

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
  String get actionBack => 'Atrás';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get onboardingWelcomeTagline => 'Planifica, registra y muévete.';

  @override
  String get onboardingWelcomeFeature1 =>
      'Un registro semanal sencillo de tus actividades';

  @override
  String get onboardingWelcomeFeature2 =>
      'Marca las sesiones a medida que las haces';

  @override
  String get onboardingWelcomeFeature3 => 'Sin culpa en los días de descanso';

  @override
  String get onboardingGetStarted => 'Empezar';

  @override
  String get onboardingCalendarTitle => 'Sincronización de calendario';

  @override
  String get onboardingCalendarBody =>
      'Tus sesiones planificadas se sincronizan automáticamente con el calendario de tu dispositivo para que todo esté en un solo lugar.';

  @override
  String get onboardingCalendarFeature1 =>
      'Las actividades aparecen en tu calendario';

  @override
  String get onboardingCalendarFeature2 =>
      'Las ediciones y eliminaciones se mantienen sincronizadas';

  @override
  String get onboardingCalendarFeature3 => 'Elige tu calendario en Ajustes';

  @override
  String get onboardingSignInTitle => 'Mantén tus datos seguros';

  @override
  String get onboardingSignInBody =>
      'Elige cómo quieres hacer copia de seguridad de tus sesiones.\nPuedes cambiarlo en cualquier momento en Ajustes.';

  @override
  String get onboardingManualTitle => 'Copia de seguridad manual';

  @override
  String get onboardingManualBody =>
      'Exporta e importa tus datos como archivo desde Ajustes cuando quieras.';

  @override
  String get onboardingContinueWithoutAccount => 'Continuar sin cuenta';

  @override
  String get onboardingCloudTitle => 'Sincronización en la nube';

  @override
  String get onboardingCloudBody =>
      'Inicia sesión con tu cuenta para sincronizar entre dispositivos automáticamente.';

  @override
  String get navWeek => 'Semana';

  @override
  String get navMonth => 'Mes';

  @override
  String get navStats => 'Estadísticas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get weekThisWeek => 'Esta semana';

  @override
  String weekSummaryCaption(int percent) {
    return 'sesiones hechas · $percent% en plan';
  }

  @override
  String weekSummaryGoal(int done, int goal) {
    return '$done/$goal objetivo semanal';
  }

  @override
  String get dayEmptyPast => 'Día de descanso';

  @override
  String get dayEmptyFuture => 'Sin sesión';

  @override
  String dayMoreBadge(int count) {
    return '+$count';
  }

  @override
  String get tipSwipeTitle => 'Desliza para cambiar de semana';

  @override
  String get tipSwipeBody =>
      'Desliza a la izquierda o derecha para ver semanas pasadas y futuras';

  @override
  String get tipDoubleTapTitle => 'Toca dos veces para marcar';

  @override
  String get tipDoubleTapBody =>
      'Marca rápidamente las sesiones del día como hechas con un doble toque';

  @override
  String get tipLongPressTitle => 'Mantén pulsado para eliminar';

  @override
  String get tipLongPressBody =>
      'Mantén pulsado un día para eliminar todas sus sesiones';

  @override
  String get tipTitleNavTitle => 'Toca el título para volver';

  @override
  String tipTitleNavBody(String label) {
    return 'Toca \"$label\" arriba para volver a la semana actual';
  }

  @override
  String get deleteDayTitle => '¿Eliminar todas las sesiones?';

  @override
  String get deleteDayBody =>
      'Todas las sesiones de este día se eliminarán. Esta acción no se puede deshacer.';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get statsDone => 'Hechas';

  @override
  String get statsPlanned => 'Planeadas';

  @override
  String get statsOnTrack => 'En plan';

  @override
  String get deleteSessionTitle => '¿Eliminar sesión?';

  @override
  String get deleteSessionBody => 'Esta acción no se puede deshacer.';

  @override
  String get selectedDayEmpty => 'Nada planeado';

  @override
  String get selectedDayAdd => 'Añadir';

  @override
  String get tipMonthTitleNavBody =>
      'Toca el título arriba para volver al mes actual';

  @override
  String get sheetAddTitle => 'Añadir sesión';

  @override
  String get sheetEditTitle => 'Editar sesión';

  @override
  String get activityNameLabel => 'Nombre de la actividad';

  @override
  String get activityNamePlaceholder => 'ej: Carrera matinal';

  @override
  String get notesLabel => 'Notas';

  @override
  String get notesPlaceholder => 'Detalles adicionales…';

  @override
  String get fieldOptionalSuffix => '  (opcional)';

  @override
  String get actionSaveSession => 'Guardar sesión';

  @override
  String get actionDeleteSession => 'Eliminar sesión';

  @override
  String get addAnotherActivity => 'Añadir otra actividad';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones',
      one: '1 sesión',
    );
    return '$_temp0';
  }

  @override
  String get recurrenceLabel => 'Se repite';

  @override
  String get recurrenceOnce => 'Una vez';

  @override
  String get recurrenceDaily => 'Diariamente';

  @override
  String get recurrenceWeekly => 'Semanalmente';

  @override
  String get recurrenceWeekdays => 'Días laborables';

  @override
  String get recurrenceWeekends => 'Fines de semana';

  @override
  String get repeatForLabel => 'Repetir durante';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '1 semana',
    );
    return '$_temp0';
  }

  @override
  String get durationLabel => 'Duración';

  @override
  String get durationPlaceholder => 'Definir duración';

  @override
  String durationHoursWheel(int count) {
    return '$count h';
  }

  @override
  String durationMinutesWheel(int count) {
    return '$count min';
  }

  @override
  String get timeLabel => 'Hora';

  @override
  String get timePlaceholder => 'Definir hora';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get typeMore => 'Más…';

  @override
  String get subTypeTitle => 'Elige el tipo de actividad';

  @override
  String get subTypeSearchPlaceholder => 'Buscar…';

  @override
  String get subTypeNoResults => 'Sin resultados';

  @override
  String get typeRun => 'Carrera';

  @override
  String get typeTrailRun => 'Trail';

  @override
  String get typeHike => 'Senderismo';

  @override
  String get typeWalk => 'Caminar';

  @override
  String get typeCycle => 'Ciclismo';

  @override
  String get typeMtb => 'BTT';

  @override
  String get typeSwim => 'Natación';

  @override
  String get typeGym => 'Gimnasio';

  @override
  String get typeYoga => 'Yoga';

  @override
  String get typeHiit => 'HIIT';

  @override
  String get typeRow => 'Remo';

  @override
  String get typeSki => 'Esquí';

  @override
  String get typeSurf => 'Surf';

  @override
  String get typeClimb => 'Escalada';

  @override
  String get typeTennis => 'Tenis';

  @override
  String get typePadel => 'Pádel';

  @override
  String get typeDance => 'Baile';

  @override
  String get typeCombat => 'Combate';

  @override
  String get typeElliptical => 'Elíptica';

  @override
  String get typeOther => 'Otro';

  @override
  String get statusDone => 'Hecha';

  @override
  String get statusToday => 'Hoy';

  @override
  String get statusPlanned => 'Planeada';

  @override
  String get statusOpen => 'Abierta';

  @override
  String get activityNameFallback => 'Sesión';

  @override
  String get oauthContinueGoogle => 'Continuar con Google';

  @override
  String get oauthContinueApple => 'Continuar con Apple';

  @override
  String get themeLightTooltip => 'Modo claro';

  @override
  String get themeDarkTooltip => 'Modo oscuro';

  @override
  String get tipDismissHint => 'Toca en cualquier lugar para continuar';

  @override
  String get loginTagline => 'Planifica tu semana. Mueve tu cuerpo.';

  @override
  String get loginTerms =>
      'Al continuar aceptas nuestros Términos del servicio';

  @override
  String get emptyStateTitle => 'Nada planificado todavía';

  @override
  String get emptyStateBody =>
      'Toca + para añadir tu primera sesión de la semana.';

  @override
  String get emptyStateAddCta => 'Añadir actividad';

  @override
  String get paywallComingSoonBadge => 'Próximamente';

  @override
  String get paywallBannerTitle => 'Las funciones premium\nestán en camino';

  @override
  String get paywallBannerBody =>
      'Estamos preparando algo especial.\nNo te pierdas Kadence Pro.';

  @override
  String get paywallFeaturesHeader => 'Esto es lo que viene:';

  @override
  String get paywallStravaTitle => 'Integración con Strava';

  @override
  String get paywallStravaBody =>
      'Importa tu historial y marca sesiones como hechas automáticamente';

  @override
  String get paywallStatsTitle => 'Estadísticas avanzadas';

  @override
  String get paywallStatsBody =>
      'Mapa de calor anual, insights y tarjetas para compartir';

  @override
  String get paywallDateFilterTitle => 'Filtros por fecha';

  @override
  String get paywallDateFilterBody =>
      'Filtra todas las estadísticas por cualquier rango de fechas';

  @override
  String get paywallCloudTitle => 'Sincronización en la nube';

  @override
  String get paywallCloudBody =>
      'Haz copia de seguridad y accede a tus datos en cualquier dispositivo';

  @override
  String get paywallCustomColorsTitle => 'Colores personalizados';

  @override
  String get paywallCustomColorsBody =>
      'Personaliza los colores de los tipos de actividad y del tema';

  @override
  String get paywallSupportTitle => 'Apoya a un desarrollador independiente';

  @override
  String get paywallSupportBody => 'Tu compra ayuda a mantener Kadence vivo';

  @override
  String get statsKpiSessions => 'Hechas';

  @override
  String get statsKpiStreak => 'Racha';

  @override
  String get statsKpiAverage => 'Promedio';

  @override
  String get statsWeekSuffix => 'sem';

  @override
  String get statsPerWeekSuffix => '/sem';

  @override
  String get statsProSection => 'Estadísticas Pro';

  @override
  String statsHeatmapTitle(int count) {
    return 'Actividad de $count semanas';
  }

  @override
  String statsHeatmapFilteredTo(String type) {
    return 'Filtrado por $type';
  }

  @override
  String get statsHeatmapTinted => 'Color de la actividad principal';

  @override
  String get statsByActivity => 'Por actividad';

  @override
  String get statsAllTime => 'Total';

  @override
  String get statsNoSessionsYet => 'Aún sin sesiones';

  @override
  String get actionClear => 'Limpiar';

  @override
  String get statsEmptyTitle => 'Aún sin estadísticas';

  @override
  String get statsEmptyBody =>
      'Completa tu primera sesión para empezar a seguir tu progreso.';

  @override
  String get statsTipFilterTitle => 'Filtrar por actividad';

  @override
  String get statsTipFilterBody =>
      'Toca cualquier tipo de actividad en \"Por actividad\" para resaltar solo ese tipo en el mapa de calor';

  @override
  String get statsPersonalRecordsTitle => 'Récords personales';

  @override
  String get statsBestStreak => 'Mejor racha';

  @override
  String get statsBestWeek => 'Mejor semana';

  @override
  String get statsBestDay => 'Mejor día';

  @override
  String get statsWeeklyActivityTitle => 'Actividad semanal';

  @override
  String get statsAvg => 'Med';

  @override
  String get statsBestDayOfWeekTitle => 'Mejor día de la semana';

  @override
  String get statsDoneSessions => 'Sesiones hechas';

  @override
  String get statsCompletionRateTitle => 'Tasa de finalización';

  @override
  String get statsPlannedVsDone => 'Planeadas vs hechas';

  @override
  String get statsMissed => 'Perdidas';

  @override
  String get statsMonthlyTrendsTitle => 'Tendencias mensuales';

  @override
  String get statsActivityVarietyTitle => 'Variedad de actividades';

  @override
  String get statsLongestGapTitle => 'Mayor pausa';

  @override
  String get statsBetweenSessions => 'Entre sesiones';

  @override
  String get statsNoData => 'Sin datos';

  @override
  String get statsMonthVsMonthTitle => 'Mes vs mes';

  @override
  String get statsMostConsistentTitle => 'Más consistentes';

  @override
  String get statsCompletionByType => 'Finalización por tipo';

  @override
  String get statsWeeklyPatternsTitle => 'Patrones semanales';

  @override
  String get statsWhenYouDo => 'Cuándo haces cada actividad';

  @override
  String get statsActiveDays => 'Días activos';

  @override
  String get statsBestMonth => 'Mejor mes';

  @override
  String get statsTopActivity => 'Top actividad';

  @override
  String get statsPeriodBreakdownTitle => 'Desglose por período';

  @override
  String get statsPeriodNoSessions => 'Sin sesiones en este período';

  @override
  String get statsAvgPerWeek => 'Med / sem';

  @override
  String get statsConsistency => 'Consistencia';

  @override
  String get statsPeakWeek => 'Semana pico';

  @override
  String get statsTrendingUp => 'Subiendo vs inicio del período';

  @override
  String get statsTrendingDown => 'Bajando vs inicio del período';

  @override
  String get statsSteadyPace => 'Ritmo estable';

  @override
  String get statsNoDataYet => 'Sin datos todavía';

  @override
  String get statsPeriodAll => 'Todo';

  @override
  String get statsInsightsTitle => 'Insights';

  @override
  String insightFavoriteDay(String day, int count) {
    return 'Entrenas más los ${day}s — $count sesiones en total.';
  }

  @override
  String insightAboveAvg(int percent) {
    return 'Este mes está $percent% por encima de tu promedio. ¡Sigue así!';
  }

  @override
  String get insightBelowAvg =>
      'Este mes está más tranquilo de lo habitual. ¡Aún hay tiempo!';

  @override
  String insightVariety(int count) {
    return '¡Qué variedad! Hiciste $count actividades distintas en los últimos 30 días.';
  }

  @override
  String insightFocused(String type) {
    return 'Has estado enfocado en $type últimamente. ¡Prueba algo nuevo!';
  }

  @override
  String insightStreakStrong(int weeks) {
    return '¡Racha de $weeks semanas! Eso es consistencia de verdad.';
  }

  @override
  String get insightStreakNew => '¡Nueva racha! Mantenla esta semana.';

  @override
  String insightBestMonth(int count) {
    return '¡Mejor mes de la historia con $count sesiones hasta ahora!';
  }

  @override
  String get recapTitle => 'Comparte tu progreso';

  @override
  String get recapSubtitle =>
      'Genera una tarjeta resumen y compártela con amigos.';

  @override
  String get recapThisMonth => 'Este mes';

  @override
  String get recapThisYear => 'Este año';

  @override
  String get recapPreview => 'Vista previa';

  @override
  String get recapShare => 'Compartir';

  @override
  String get recapActivity => 'Actividad';

  @override
  String recapTopActivity(String label) {
    return 'Top actividad: $label';
  }

  @override
  String recapStreakBadge(int count) {
    return '$count sem';
  }

  @override
  String recapYearInReviewTitle(int year) {
    return 'Resumen de $year';
  }

  @override
  String get recapMonthGettingStarted => '¡Empezando!';

  @override
  String get recapMonthUnstoppable => '¡Mes imparable!';

  @override
  String get recapMonthCrushing => '¡Arrasando!';

  @override
  String get recapMonthConsistency => '¡Consistencia increíble!';

  @override
  String get recapMonthStrong => '¡Mes fuerte!';

  @override
  String get recapMonthMomentum => '¡Tomando impulso!';

  @override
  String get recapYearBegins => '¡El viaje comienza!';

  @override
  String get recapYearLegendary => '¡Año legendario!';

  @override
  String get recapYearTripleDigits => '¡Tres dígitos!';

  @override
  String get recapYearStreakMachine => '¡Máquina de rachas!';

  @override
  String get recapYearHalfHundred => '¡Media centena!';

  @override
  String get recapYearGoingStrong => '¡A toda máquina!';

  @override
  String get recapYearHabit => '¡Construyendo el hábito!';

  @override
  String get statsLast12Months => 'Últimos 12 meses';

  @override
  String get statsLast12Weeks => 'Últimas 12 semanas';

  @override
  String statsTypesAllTime(int count) {
    return '$count tipos en total';
  }

  @override
  String get statsDifferentTypesPerWeek =>
      'Tipos distintos por semana (últimas 12 semanas)';

  @override
  String get statsNeedAtLeast2 => 'Al menos 2 sesiones';

  @override
  String statsDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String statsDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count días',
      one: 'Hace 1 día',
      zero: 'Hoy',
    );
    return '$_temp0';
  }

  @override
  String statsSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sesiones',
      one: 'sesión',
    );
    return '$_temp0';
  }

  @override
  String statsTypesCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tipos',
      one: '1 tipo',
    );
    return '$_temp0';
  }

  @override
  String statsYearInReviewTitle(int year) {
    return 'Resumen de $year';
  }

  @override
  String statsYearHeatmapTitle(int year) {
    return 'Mapa de calor $year';
  }

  @override
  String statsActiveDaysCount(int count) {
    return '$count días activos';
  }

  @override
  String statsTriedTypes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actividades distintas',
      one: '1 actividad distinta',
    );
    return 'Probaste $_temp0 este año';
  }

  @override
  String get subtypeAlpineSki => 'Esquí Alpino';

  @override
  String get subtypeBadminton => 'Bádminton';

  @override
  String get subtypeCanoeing => 'Piragüismo';

  @override
  String get subtypeCrossfit => 'Crossfit';

  @override
  String get subtypeEbikeRide => 'Bici Eléctrica';

  @override
  String get subtypeFencing => 'Esgrima';

  @override
  String get subtypeGolf => 'Golf';

  @override
  String get subtypeHandball => 'Balonmano';

  @override
  String get subtypeIceSkate => 'Patinaje sobre Hielo';

  @override
  String get subtypeInlineSkate => 'Patinaje en Línea';

  @override
  String get subtypeKayaking => 'Kayak';

  @override
  String get subtypeKitesurf => 'Kitesurf';

  @override
  String get subtypeMartialArts => 'Artes Marciales';

  @override
  String get subtypePilates => 'Pilates';

  @override
  String get subtypePickleball => 'Pickleball';

  @override
  String get subtypeRacquetball => 'Ráquetbol';

  @override
  String get subtypeRockClimbing => 'Escalada';

  @override
  String get subtypeRollerSki => 'Esquí con Ruedas';

  @override
  String get subtypeRowing => 'Remo';

  @override
  String get subtypeRugby => 'Rugby';

  @override
  String get subtypeSailing => 'Vela';

  @override
  String get subtypeSkateboarding => 'Skate';

  @override
  String get subtypeSnowboard => 'Snowboard';

  @override
  String get subtypeSnowshoe => 'Raquetas de Nieve';

  @override
  String get subtypeSoccer => 'Fútbol';

  @override
  String get subtypeSquash => 'Squash';

  @override
  String get subtypeStairStepper => 'Escaladora';

  @override
  String get subtypeStandUpPaddling => 'Stand Up Paddle';

  @override
  String get subtypeSwimming => 'Natación';

  @override
  String get subtypeTableTennis => 'Tenis de Mesa';

  @override
  String get subtypeTrailRun => 'Trail Running';

  @override
  String get subtypeVelomobile => 'Velomóvil';

  @override
  String get subtypeVirtualRide => 'Ciclismo Virtual';

  @override
  String get subtypeVirtualRow => 'Remo Virtual';

  @override
  String get subtypeVirtualRun => 'Carrera Virtual';

  @override
  String get subtypeVolleyball => 'Voleibol';

  @override
  String get subtypeWeightlifting => 'Pesas';

  @override
  String get subtypeWheelchair => 'Silla de Ruedas';

  @override
  String get subtypeWindsurf => 'Windsurf';

  @override
  String get subtypeWorkout => 'Entrenamiento';

  @override
  String get subtypeYoga => 'Yoga';
}

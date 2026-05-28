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
}

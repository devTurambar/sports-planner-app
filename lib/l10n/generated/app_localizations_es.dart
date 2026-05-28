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
}

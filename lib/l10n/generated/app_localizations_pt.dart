// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get settingsSectionApp => 'Aplicação';

  @override
  String get settingsSectionData => 'Dados';

  @override
  String get settingsSectionAbout => 'Acerca';

  @override
  String get settingsDarkMode => 'Modo escuro';

  @override
  String get settingsWeekStartsOn => 'Semana começa em';

  @override
  String get weekdaySunday => 'Domingo';

  @override
  String get weekdayMonday => 'Segunda-feira';

  @override
  String get settingsWeeklyGoal => 'Meta semanal';

  @override
  String weeklyGoalSessions(int count) {
    return '$count sessões';
  }

  @override
  String get weeklyGoalOff => 'Desativada';

  @override
  String get weeklyGoalPrompt => 'Quantas sessões por semana queres completar?';

  @override
  String get settingsThemeColor => 'Cor do tema';

  @override
  String get settingsCalendarSync => 'Sincronizar calendário';

  @override
  String get settingsCalendars => 'Calendários';

  @override
  String get calendarsAll => 'Todos os calendários';

  @override
  String calendarsCount(int count) {
    return '$count calendários';
  }

  @override
  String get calendarsFallback => 'Calendário';

  @override
  String get calendarsOff => 'Desativado';

  @override
  String get calendarsLoading => '…';

  @override
  String get calendarsChooseTitle => 'Escolher calendários';

  @override
  String get settingsTypeColors => 'Cores por tipo';

  @override
  String get settingsTypeColorsValue => 'Personalizar';

  @override
  String get typeColorsResetAll => 'Repor todas';

  @override
  String get settingsExportData => 'Exportar dados';

  @override
  String get settingsExportValue => 'Partilhar';

  @override
  String get settingsImportData => 'Importar dados';

  @override
  String get settingsImportValue => 'Carregar';

  @override
  String get exportFailed => 'Falha ao exportar';

  @override
  String get importReplaceTitle => 'Substituir todos os dados?';

  @override
  String importReplaceBody(int count) {
    return 'Isto vai substituir todos os teus dados atuais pelos dados importados ($count atividades).';
  }

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionReplace => 'Substituir';

  @override
  String get actionDone => 'Concluído';

  @override
  String importedActivities(int count) {
    return 'Foram importadas $count atividades';
  }

  @override
  String get calendarSyncPromptTitle => 'Sincronizar com o calendário?';

  @override
  String get calendarSyncPromptBody =>
      'Adicionar as atividades importadas ao calendário do dispositivo? Eventos já existentes serão ignorados.';

  @override
  String get actionNoThanks => 'Não, obrigado';

  @override
  String get actionSync => 'Sincronizar';

  @override
  String calendarSyncedAll(int synced) {
    return 'Sincronizados $synced eventos no calendário';
  }

  @override
  String calendarSyncedWithSkipped(int synced, int skipped) {
    return 'Sincronizados $synced eventos ($skipped já no calendário)';
  }

  @override
  String get settingsRedoOnboarding => 'Refazer introdução';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String get settingsRateKadence => 'Avaliar o Kadence';

  @override
  String settingsVersion(String version) {
    return 'Kadence · v$version';
  }

  @override
  String get accountSignInToSync => 'Inicia sessão para sincronizar';

  @override
  String get accountSignInSubtitle =>
      'Faz cópia de segurança e acede aos dados em qualquer lado';

  @override
  String get accountSignedInFallback => 'Sessão iniciada';

  @override
  String get accountSyncingEnabled => 'Sincronização ativa';

  @override
  String get accountSignOut => 'Terminar sessão';

  @override
  String get signInSheetSubtitle =>
      'Faz cópia de segurança e acede aos dados em qualquer dispositivo.';

  @override
  String get proCardSubtitle => 'Funcionalidades premium em breve';

  @override
  String get proBadge => 'PRO';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

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

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get settingsSectionApp => 'Aplicativo';

  @override
  String get settingsSectionData => 'Dados';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsDarkMode => 'Modo escuro';

  @override
  String get settingsWeekStartsOn => 'Semana começa em';

  @override
  String get weekdaySunday => 'Domingo';

  @override
  String get weekdayMonday => 'Segunda-feira';

  @override
  String get settingsWeeklyGoal => 'Meta semanal';

  @override
  String weeklyGoalSessions(int count) {
    return '$count sessões';
  }

  @override
  String get weeklyGoalOff => 'Desativada';

  @override
  String get weeklyGoalPrompt =>
      'Quantas sessões por semana você quer completar?';

  @override
  String get settingsThemeColor => 'Cor do tema';

  @override
  String get settingsCalendarSync => 'Sincronizar calendário';

  @override
  String get settingsCalendars => 'Calendários';

  @override
  String get calendarsAll => 'Todos os calendários';

  @override
  String calendarsCount(int count) {
    return '$count calendários';
  }

  @override
  String get calendarsFallback => 'Calendário';

  @override
  String get calendarsOff => 'Desativado';

  @override
  String get calendarsLoading => '…';

  @override
  String get calendarsChooseTitle => 'Escolher calendários';

  @override
  String get settingsTypeColors => 'Cores por tipo';

  @override
  String get settingsTypeColorsValue => 'Personalizar';

  @override
  String get typeColorsResetAll => 'Redefinir tudo';

  @override
  String get settingsExportData => 'Exportar dados';

  @override
  String get settingsExportValue => 'Compartilhar';

  @override
  String get settingsImportData => 'Importar dados';

  @override
  String get settingsImportValue => 'Carregar';

  @override
  String get exportFailed => 'Falha ao exportar';

  @override
  String get importReplaceTitle => 'Substituir todos os dados?';

  @override
  String importReplaceBody(int count) {
    return 'Isso vai substituir todos os seus dados atuais pelos dados importados ($count atividades).';
  }

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionReplace => 'Substituir';

  @override
  String get actionDone => 'Concluído';

  @override
  String importedActivities(int count) {
    return '$count atividades importadas';
  }

  @override
  String get calendarSyncPromptTitle => 'Sincronizar com o calendário?';

  @override
  String get calendarSyncPromptBody =>
      'Adicionar as atividades importadas ao calendário do dispositivo? Eventos correspondentes existentes serão ignorados.';

  @override
  String get actionNoThanks => 'Não, obrigado';

  @override
  String get actionSync => 'Sincronizar';

  @override
  String calendarSyncedAll(int synced) {
    return '$synced eventos sincronizados no calendário';
  }

  @override
  String calendarSyncedWithSkipped(int synced, int skipped) {
    return '$synced eventos sincronizados ($skipped já no calendário)';
  }

  @override
  String get settingsRedoOnboarding => 'Refazer apresentação';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String get settingsRateKadence => 'Avaliar o Kadence';

  @override
  String settingsVersion(String version) {
    return 'Kadence · v$version';
  }

  @override
  String get accountSignInToSync => 'Faça login para sincronizar';

  @override
  String get accountSignInSubtitle =>
      'Faça backup e acesse seus dados em qualquer lugar';

  @override
  String get accountSignedInFallback => 'Conectado';

  @override
  String get accountSyncingEnabled => 'Sincronização ativa';

  @override
  String get accountSignOut => 'Sair';

  @override
  String get signInSheetSubtitle =>
      'Faça backup dos seus dados e acesse-os de qualquer dispositivo.';

  @override
  String get proCardSubtitle => 'Recursos premium em breve';

  @override
  String get proBadge => 'PRO';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

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

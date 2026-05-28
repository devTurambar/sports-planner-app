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

  @override
  String get actionBack => 'Voltar';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get onboardingWelcomeTagline => 'Planeia, regista e move-te.';

  @override
  String get onboardingWelcomeFeature1 =>
      'Um registo semanal simples das tuas atividades';

  @override
  String get onboardingWelcomeFeature2 =>
      'Marca as sessões à medida que as fazes';

  @override
  String get onboardingWelcomeFeature3 => 'Sem culpa nos dias de descanso';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String get onboardingCalendarTitle => 'Sincronização de calendário';

  @override
  String get onboardingCalendarBody =>
      'As sessões planeadas são sincronizadas automaticamente com o calendário do dispositivo para que tudo fique num só sítio.';

  @override
  String get onboardingCalendarFeature1 =>
      'As atividades aparecem no teu calendário';

  @override
  String get onboardingCalendarFeature2 =>
      'Edições e eliminações ficam sincronizadas';

  @override
  String get onboardingCalendarFeature3 =>
      'Escolhe o teu calendário nas Definições';

  @override
  String get onboardingSignInTitle => 'Mantém os teus dados seguros';

  @override
  String get onboardingSignInBody =>
      'Escolhe como queres fazer cópia de segurança das tuas sessões.\nPodes alterar esta opção a qualquer momento nas Definições.';

  @override
  String get onboardingManualTitle => 'Cópia de segurança manual';

  @override
  String get onboardingManualBody =>
      'Exporta e importa os teus dados como ficheiro nas Definições, sempre que quiseres.';

  @override
  String get onboardingContinueWithoutAccount => 'Continuar sem conta';

  @override
  String get onboardingCloudTitle => 'Sincronização na nuvem';

  @override
  String get onboardingCloudBody =>
      'Inicia sessão com a tua conta para sincronizar entre dispositivos automaticamente.';

  @override
  String get navWeek => 'Semana';

  @override
  String get navMonth => 'Mês';

  @override
  String get navStats => 'Estatísticas';

  @override
  String get navSettings => 'Definições';

  @override
  String get weekThisWeek => 'Esta semana';

  @override
  String weekSummaryCaption(int percent) {
    return 'sessões feitas · $percent% no plano';
  }

  @override
  String weekSummaryGoal(int done, int goal) {
    return '$done/$goal meta semanal';
  }

  @override
  String get dayEmptyPast => 'Dia de descanso';

  @override
  String get dayEmptyFuture => 'Sem sessão';

  @override
  String dayMoreBadge(int count) {
    return '+$count';
  }

  @override
  String get tipSwipeTitle => 'Desliza para mudar de semana';

  @override
  String get tipSwipeBody =>
      'Desliza para a esquerda ou direita para ver semanas passadas e próximas';

  @override
  String get tipDoubleTapTitle => 'Toca duas vezes para concluir';

  @override
  String get tipDoubleTapBody =>
      'Marca rapidamente as sessões do dia como feitas com um duplo toque';

  @override
  String get tipLongPressTitle => 'Pressiona para eliminar';

  @override
  String get tipLongPressBody =>
      'Pressiona um dia para remover todas as sessões';

  @override
  String get tipTitleNavTitle => 'Toca no título para voltar';

  @override
  String tipTitleNavBody(String label) {
    return 'Toca em \"$label\" no topo para voltar à semana atual';
  }

  @override
  String get deleteDayTitle => 'Eliminar todas as sessões?';

  @override
  String get deleteDayBody =>
      'Todas as sessões deste dia serão removidas. Esta ação não pode ser anulada.';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get statsDone => 'Feitas';

  @override
  String get statsPlanned => 'Planeadas';

  @override
  String get statsOnTrack => 'No plano';

  @override
  String get deleteSessionTitle => 'Eliminar sessão?';

  @override
  String get deleteSessionBody => 'Esta ação não pode ser anulada.';

  @override
  String get selectedDayEmpty => 'Nada planeado';

  @override
  String get selectedDayAdd => 'Adicionar';

  @override
  String get tipMonthTitleNavBody =>
      'Toca no título no topo para voltar ao mês atual';
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

  @override
  String get actionBack => 'Voltar';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get onboardingWelcomeTagline => 'Planeje, acompanhe e movimente-se.';

  @override
  String get onboardingWelcomeFeature1 =>
      'Um registro semanal simples das suas atividades';

  @override
  String get onboardingWelcomeFeature2 =>
      'Marque as sessões conforme você completa';

  @override
  String get onboardingWelcomeFeature3 => 'Sem culpa nos dias de descanso';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String get onboardingCalendarTitle => 'Sincronização de calendário';

  @override
  String get onboardingCalendarBody =>
      'As sessões planejadas são sincronizadas automaticamente com o calendário do seu dispositivo para que tudo fique em um só lugar.';

  @override
  String get onboardingCalendarFeature1 =>
      'As atividades aparecem no seu calendário';

  @override
  String get onboardingCalendarFeature2 =>
      'Edições e exclusões ficam sincronizadas';

  @override
  String get onboardingCalendarFeature3 =>
      'Escolha seu calendário nas Configurações';

  @override
  String get onboardingSignInTitle => 'Mantenha seus dados seguros';

  @override
  String get onboardingSignInBody =>
      'Escolha como você quer fazer backup das suas sessões.\nVocê pode alterar isso a qualquer momento nas Configurações.';

  @override
  String get onboardingManualTitle => 'Backup manual';

  @override
  String get onboardingManualBody =>
      'Exporte e importe seus dados como arquivo nas Configurações sempre que quiser.';

  @override
  String get onboardingContinueWithoutAccount => 'Continuar sem conta';

  @override
  String get onboardingCloudTitle => 'Sincronização na nuvem';

  @override
  String get onboardingCloudBody =>
      'Faça login com sua conta para sincronizar entre dispositivos automaticamente.';

  @override
  String get navWeek => 'Semana';

  @override
  String get navMonth => 'Mês';

  @override
  String get navStats => 'Estatísticas';

  @override
  String get navSettings => 'Configurações';

  @override
  String get weekThisWeek => 'Esta semana';

  @override
  String weekSummaryCaption(int percent) {
    return 'sessões feitas · $percent% no plano';
  }

  @override
  String weekSummaryGoal(int done, int goal) {
    return '$done/$goal meta semanal';
  }

  @override
  String get dayEmptyPast => 'Dia de descanso';

  @override
  String get dayEmptyFuture => 'Sem sessão';

  @override
  String dayMoreBadge(int count) {
    return '+$count';
  }

  @override
  String get tipSwipeTitle => 'Deslize para navegar entre semanas';

  @override
  String get tipSwipeBody =>
      'Deslize para a esquerda ou direita para ver semanas passadas e futuras';

  @override
  String get tipDoubleTapTitle => 'Toque duas vezes para concluir';

  @override
  String get tipDoubleTapBody =>
      'Marque rapidamente as sessões do dia como feitas com um toque duplo';

  @override
  String get tipLongPressTitle => 'Pressione para excluir';

  @override
  String get tipLongPressBody =>
      'Pressione e segure um dia para remover todas as sessões';

  @override
  String get tipTitleNavTitle => 'Toque no título para voltar';

  @override
  String tipTitleNavBody(String label) {
    return 'Toque em \"$label\" no topo para voltar à semana atual';
  }

  @override
  String get deleteDayTitle => 'Excluir todas as sessões?';

  @override
  String get deleteDayBody =>
      'Todas as sessões deste dia serão removidas. Essa ação não pode ser desfeita.';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get statsDone => 'Feitas';

  @override
  String get statsPlanned => 'Planejadas';

  @override
  String get statsOnTrack => 'No plano';

  @override
  String get deleteSessionTitle => 'Excluir sessão?';

  @override
  String get deleteSessionBody => 'Essa ação não pode ser desfeita.';

  @override
  String get selectedDayEmpty => 'Nada planejado';

  @override
  String get selectedDayAdd => 'Adicionar';

  @override
  String get tipMonthTitleNavBody =>
      'Toque no título no topo para voltar ao mês atual';
}

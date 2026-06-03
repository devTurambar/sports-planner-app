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

  @override
  String get sheetAddTitle => 'Adicionar sessão';

  @override
  String get sheetEditTitle => 'Editar sessão';

  @override
  String get activityNameLabel => 'Nome da atividade';

  @override
  String get activityNamePlaceholder => 'ex: Corrida matinal';

  @override
  String get notesLabel => 'Notas';

  @override
  String get notesPlaceholder => 'Mais detalhes…';

  @override
  String get fieldOptionalSuffix => '  (opcional)';

  @override
  String get actionSaveSession => 'Guardar sessão';

  @override
  String get actionDeleteSession => 'Eliminar sessão';

  @override
  String get addAnotherActivity => 'Adicionar outra atividade';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessões',
      one: '1 sessão',
    );
    return '$_temp0';
  }

  @override
  String get recurrenceLabel => 'Repete';

  @override
  String get recurrenceOnce => 'Uma vez';

  @override
  String get recurrenceDaily => 'Diariamente';

  @override
  String get recurrenceWeekly => 'Semanalmente';

  @override
  String get recurrenceWeekdays => 'Dias úteis';

  @override
  String get recurrenceWeekends => 'Fins de semana';

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
  String get durationLabel => 'Duração';

  @override
  String get durationPlaceholder => 'Definir duração';

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
  String get typeMore => 'Mais…';

  @override
  String get subTypeTitle => 'Escolhe o tipo de atividade';

  @override
  String get subTypeSearchPlaceholder => 'Pesquisar…';

  @override
  String get subTypeNoResults => 'Sem resultados';

  @override
  String get typeRun => 'Corrida';

  @override
  String get typeTrailRun => 'Trail';

  @override
  String get typeHike => 'Caminhada';

  @override
  String get typeWalk => 'Andar';

  @override
  String get typeCycle => 'Ciclismo';

  @override
  String get typeMtb => 'BTT';

  @override
  String get typeSwim => 'Natação';

  @override
  String get typeGym => 'Ginásio';

  @override
  String get typeYoga => 'Yoga';

  @override
  String get typeHiit => 'HIIT';

  @override
  String get typeRow => 'Remo';

  @override
  String get typeSki => 'Esqui';

  @override
  String get typeSurf => 'Surf';

  @override
  String get typeClimb => 'Escalada';

  @override
  String get typeTennis => 'Ténis';

  @override
  String get typePadel => 'Padel';

  @override
  String get typeDance => 'Dança';

  @override
  String get typeCombat => 'Combate';

  @override
  String get typeElliptical => 'Elíptica';

  @override
  String get typeOther => 'Outro';

  @override
  String get statusDone => 'Feita';

  @override
  String get statusToday => 'Hoje';

  @override
  String get statusPlanned => 'Planeada';

  @override
  String get statusOpen => 'Aberta';

  @override
  String get activityNameFallback => 'Sessão';

  @override
  String get oauthContinueGoogle => 'Continuar com Google';

  @override
  String get oauthContinueApple => 'Continuar com Apple';

  @override
  String get themeLightTooltip => 'Modo claro';

  @override
  String get themeDarkTooltip => 'Modo escuro';

  @override
  String get tipDismissHint => 'Toca em qualquer lado para continuar';

  @override
  String get loginTagline => 'Planeia a tua semana. Move o teu corpo.';

  @override
  String get loginTerms =>
      'Ao continuar concordas com os nossos Termos de Serviço';

  @override
  String get emptyStateTitle => 'Nada planeado ainda';

  @override
  String get emptyStateBody =>
      'Toca em + para adicionar a primeira sessão da semana.';

  @override
  String get emptyStateAddCta => 'Adicionar atividade';

  @override
  String get paywallComingSoonBadge => 'Em breve';

  @override
  String get paywallBannerTitle => 'Funcionalidades premium\na caminho';

  @override
  String get paywallBannerBody =>
      'Estamos a preparar algo especial.\nFica atento ao Kadence Pro.';

  @override
  String get paywallFeaturesHeader => 'Eis o que está a chegar:';

  @override
  String get paywallStravaTitle => 'Integração com Strava';

  @override
  String get paywallStravaBody =>
      'Importa o teu histórico e marca as sessões como feitas automaticamente';

  @override
  String get paywallStatsTitle => 'Estatísticas avançadas';

  @override
  String get paywallStatsBody =>
      'Mapa de calor anual, insights e cartões partilháveis';

  @override
  String get paywallDateFilterTitle => 'Filtros por data';

  @override
  String get paywallDateFilterBody =>
      'Filtra todas as estatísticas por qualquer intervalo de datas';

  @override
  String get paywallCloudTitle => 'Sincronização na nuvem';

  @override
  String get paywallCloudBody =>
      'Faz cópia de segurança e acede aos dados em qualquer dispositivo';

  @override
  String get paywallCustomColorsTitle => 'Cores personalizadas';

  @override
  String get paywallCustomColorsBody =>
      'Personaliza as cores dos tipos de atividade e do tema';

  @override
  String get paywallSupportTitle => 'Apoia um programador independente';

  @override
  String get paywallSupportBody => 'A tua compra ajuda a manter o Kadence vivo';

  @override
  String get statsKpiSessions => 'Feitas';

  @override
  String get statsKpiStreak => 'Série';

  @override
  String get statsKpiAverage => 'Média';

  @override
  String get statsWeekSuffix => 'sem';

  @override
  String get statsPerWeekSuffix => '/sem';

  @override
  String get statsProSection => 'Estatísticas Pro';

  @override
  String statsHeatmapTitle(int count) {
    return 'Atividade de $count semanas';
  }

  @override
  String statsHeatmapFilteredTo(String type) {
    return 'Filtrado por $type';
  }

  @override
  String get statsHeatmapTinted => 'Cor da atividade principal';

  @override
  String get statsByActivity => 'Por atividade';

  @override
  String get statsAllTime => 'Total';

  @override
  String get statsNoSessionsYet => 'Ainda sem sessões';

  @override
  String get actionClear => 'Limpar';

  @override
  String get statsEmptyTitle => 'Ainda sem estatísticas';

  @override
  String get statsEmptyBody =>
      'Completa a primeira sessão para começares a acompanhar o teu progresso.';

  @override
  String get statsTipFilterTitle => 'Filtrar por atividade';

  @override
  String get statsTipFilterBody =>
      'Toca num tipo de atividade em \"Por atividade\" para destacar apenas esse tipo no mapa de calor';

  @override
  String get statsPersonalRecordsTitle => 'Recordes pessoais';

  @override
  String get statsBestStreak => 'Melhor série';

  @override
  String get statsBestWeek => 'Melhor semana';

  @override
  String get statsBestDay => 'Melhor dia';

  @override
  String get statsWeeklyActivityTitle => 'Atividade semanal';

  @override
  String get statsAvg => 'Média';

  @override
  String get statsBestDayOfWeekTitle => 'Melhor dia da semana';

  @override
  String get statsDoneSessions => 'Sessões feitas';

  @override
  String get statsCompletionRateTitle => 'Taxa de conclusão';

  @override
  String get statsPlannedVsDone => 'Planeadas vs feitas';

  @override
  String get statsMissed => 'Falhadas';

  @override
  String get statsMonthlyTrendsTitle => 'Tendências mensais';

  @override
  String get statsActivityVarietyTitle => 'Variedade de atividades';

  @override
  String get statsLongestGapTitle => 'Maior pausa';

  @override
  String get statsBetweenSessions => 'Entre sessões';

  @override
  String get statsNoData => 'Sem dados';

  @override
  String get statsMonthVsMonthTitle => 'Mês vs mês';

  @override
  String get statsMostConsistentTitle => 'Mais consistentes';

  @override
  String get statsCompletionByType => 'Conclusão por tipo';

  @override
  String get statsWeeklyPatternsTitle => 'Padrões semanais';

  @override
  String get statsWhenYouDo => 'Quando fazes cada atividade';

  @override
  String get statsActiveDays => 'Dias ativos';

  @override
  String get statsBestMonth => 'Melhor mês';

  @override
  String get statsTopActivity => 'Top atividade';

  @override
  String get statsPeriodBreakdownTitle => 'Análise por período';

  @override
  String get statsPeriodNoSessions => 'Sem sessões neste período';

  @override
  String get statsAvgPerWeek => 'Média / sem';

  @override
  String get statsConsistency => 'Consistência';

  @override
  String get statsPeakWeek => 'Semana pico';

  @override
  String get statsTrendingUp => 'A subir vs início do período';

  @override
  String get statsTrendingDown => 'A descer vs início do período';

  @override
  String get statsSteadyPace => 'Ritmo estável';

  @override
  String get statsNoDataYet => 'Sem dados ainda';

  @override
  String get statsPeriodAll => 'Tudo';

  @override
  String get statsInsightsTitle => 'Insights';

  @override
  String insightFavoriteDay(String day, int count) {
    return 'Treinas mais a ${day}s — $count sessões no total.';
  }

  @override
  String insightAboveAvg(int percent) {
    return 'Este mês está $percent% acima da tua média. Continua assim!';
  }

  @override
  String get insightBelowAvg =>
      'Este mês está mais calmo do que o habitual. Ainda há tempo!';

  @override
  String insightVariety(int count) {
    return 'Que variedade! Fizeste $count atividades diferentes nos últimos 30 dias.';
  }

  @override
  String insightFocused(String type) {
    return 'Tens-te focado em $type ultimamente. Experimenta variar!';
  }

  @override
  String insightStreakStrong(int weeks) {
    return 'Série de $weeks semanas! Isto é consistência a sério.';
  }

  @override
  String get insightStreakNew => 'Nova série começou! Continua esta semana.';

  @override
  String insightBestMonth(int count) {
    return 'Melhor mês de sempre com $count sessões até agora!';
  }

  @override
  String get recapTitle => 'Partilha o teu progresso';

  @override
  String get recapSubtitle => 'Gera um cartão resumo e partilha com amigos.';

  @override
  String get recapThisMonth => 'Este mês';

  @override
  String get recapThisYear => 'Este ano';

  @override
  String get recapPreview => 'Pré-visualização';

  @override
  String get recapShare => 'Partilhar';

  @override
  String get recapActivity => 'Atividade';

  @override
  String recapTopActivity(String label) {
    return 'Top atividade: $label';
  }

  @override
  String recapStreakBadge(int count) {
    return '$count sem';
  }

  @override
  String recapYearInReviewTitle(int year) {
    return 'Retrospetiva $year';
  }

  @override
  String get recapMonthGettingStarted => 'A começar!';

  @override
  String get recapMonthUnstoppable => 'Mês imparável!';

  @override
  String get recapMonthCrushing => 'A arrasar!';

  @override
  String get recapMonthConsistency => 'Consistência incrível!';

  @override
  String get recapMonthStrong => 'Mês forte!';

  @override
  String get recapMonthMomentum => 'A ganhar ritmo!';

  @override
  String get recapYearBegins => 'A jornada começa!';

  @override
  String get recapYearLegendary => 'Ano lendário!';

  @override
  String get recapYearTripleDigits => 'Três dígitos!';

  @override
  String get recapYearStreakMachine => 'Máquina de séries!';

  @override
  String get recapYearHalfHundred => 'Meia centena!';

  @override
  String get recapYearGoingStrong => 'A todo o vapor!';

  @override
  String get recapYearHabit => 'A criar o hábito!';

  @override
  String get statsLast12Months => 'Últimos 12 meses';

  @override
  String get statsLast12Weeks => 'Últimas 12 semanas';

  @override
  String statsTypesAllTime(int count) {
    return '$count tipos no total';
  }

  @override
  String get statsDifferentTypesPerWeek =>
      'Tipos diferentes por semana (últimas 12 semanas)';

  @override
  String get statsNeedAtLeast2 => 'Pelo menos 2 sessões';

  @override
  String statsDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String statsDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Há $count dias',
      one: 'Há 1 dia',
      zero: 'Hoje',
    );
    return '$_temp0';
  }

  @override
  String statsSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sessões',
      one: 'sessão',
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
    return 'Retrospetiva $year';
  }

  @override
  String statsYearHeatmapTitle(int year) {
    return 'Mapa de calor $year';
  }

  @override
  String statsActiveDaysCount(int count) {
    return '$count dias ativos';
  }

  @override
  String statsTriedTypes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count atividades diferentes',
      one: '1 atividade diferente',
    );
    return 'Experimentaste $_temp0 este ano';
  }

  @override
  String get subtypeAlpineSki => 'Esqui Alpino';

  @override
  String get subtypeBadminton => 'Badminton';

  @override
  String get subtypeCanoeing => 'Canoagem';

  @override
  String get subtypeCrossfit => 'Crossfit';

  @override
  String get subtypeEbikeRide => 'Bicicleta Elétrica';

  @override
  String get subtypeFencing => 'Esgrima';

  @override
  String get subtypeGolf => 'Golfe';

  @override
  String get subtypeHandball => 'Andebol';

  @override
  String get subtypeIceSkate => 'Patinagem no Gelo';

  @override
  String get subtypeInlineSkate => 'Patinagem em Linha';

  @override
  String get subtypeKayaking => 'Caiaque';

  @override
  String get subtypeKitesurf => 'Kitesurf';

  @override
  String get subtypeMartialArts => 'Artes Marciais';

  @override
  String get subtypePilates => 'Pilates';

  @override
  String get subtypePickleball => 'Pickleball';

  @override
  String get subtypeRacquetball => 'Raquetebol';

  @override
  String get subtypeRockClimbing => 'Escalada';

  @override
  String get subtypeRollerSki => 'Esqui de Rodas';

  @override
  String get subtypeRowing => 'Remo';

  @override
  String get subtypeRugby => 'Râguebi';

  @override
  String get subtypeSailing => 'Vela';

  @override
  String get subtypeSkateboarding => 'Skate';

  @override
  String get subtypeSnowboard => 'Snowboard';

  @override
  String get subtypeSnowshoe => 'Raquetas de Neve';

  @override
  String get subtypeSoccer => 'Futebol';

  @override
  String get subtypeSquash => 'Squash';

  @override
  String get subtypeStairStepper => 'Step';

  @override
  String get subtypeStandUpPaddling => 'Stand Up Paddle';

  @override
  String get subtypeSwimming => 'Natação';

  @override
  String get subtypeTableTennis => 'Ténis de Mesa';

  @override
  String get subtypeTrailRun => 'Trail';

  @override
  String get subtypeVelomobile => 'Velomobile';

  @override
  String get subtypeVirtualRide => 'Ciclismo Virtual';

  @override
  String get subtypeVirtualRow => 'Remo Virtual';

  @override
  String get subtypeVirtualRun => 'Corrida Virtual';

  @override
  String get subtypeVolleyball => 'Voleibol';

  @override
  String get subtypeWeightlifting => 'Musculação';

  @override
  String get subtypeWheelchair => 'Cadeira de Rodas';

  @override
  String get subtypeWindsurf => 'Windsurf';

  @override
  String get subtypeWorkout => 'Treino';

  @override
  String get subtypeYoga => 'Yoga';
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

  @override
  String get sheetAddTitle => 'Adicionar sessão';

  @override
  String get sheetEditTitle => 'Editar sessão';

  @override
  String get activityNameLabel => 'Nome da atividade';

  @override
  String get activityNamePlaceholder => 'ex: Corrida matinal';

  @override
  String get notesLabel => 'Notas';

  @override
  String get notesPlaceholder => 'Mais detalhes…';

  @override
  String get fieldOptionalSuffix => '  (opcional)';

  @override
  String get actionSaveSession => 'Salvar sessão';

  @override
  String get actionDeleteSession => 'Excluir sessão';

  @override
  String get addAnotherActivity => 'Adicionar outra atividade';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessões',
      one: '1 sessão',
    );
    return '$_temp0';
  }

  @override
  String get recurrenceLabel => 'Repete';

  @override
  String get recurrenceOnce => 'Uma vez';

  @override
  String get recurrenceDaily => 'Diariamente';

  @override
  String get recurrenceWeekly => 'Semanalmente';

  @override
  String get recurrenceWeekdays => 'Dias de semana';

  @override
  String get recurrenceWeekends => 'Fins de semana';

  @override
  String get repeatForLabel => 'Repetir por';

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
  String get durationLabel => 'Duração';

  @override
  String get durationPlaceholder => 'Definir duração';

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
  String get typeMore => 'Mais…';

  @override
  String get subTypeTitle => 'Escolha o tipo de atividade';

  @override
  String get subTypeSearchPlaceholder => 'Buscar…';

  @override
  String get subTypeNoResults => 'Sem resultados';

  @override
  String get typeRun => 'Corrida';

  @override
  String get typeTrailRun => 'Trail Running';

  @override
  String get typeHike => 'Trilha';

  @override
  String get typeWalk => 'Caminhada';

  @override
  String get typeCycle => 'Ciclismo';

  @override
  String get typeMtb => 'Mountain Bike';

  @override
  String get typeSwim => 'Natação';

  @override
  String get typeGym => 'Academia';

  @override
  String get typeYoga => 'Yoga';

  @override
  String get typeHiit => 'HIIT';

  @override
  String get typeRow => 'Remo';

  @override
  String get typeSki => 'Esqui';

  @override
  String get typeSurf => 'Surf';

  @override
  String get typeClimb => 'Escalada';

  @override
  String get typeTennis => 'Tênis';

  @override
  String get typePadel => 'Padel';

  @override
  String get typeDance => 'Dança';

  @override
  String get typeCombat => 'Combate';

  @override
  String get typeElliptical => 'Elíptica';

  @override
  String get typeOther => 'Outro';

  @override
  String get statusDone => 'Feita';

  @override
  String get statusToday => 'Hoje';

  @override
  String get statusPlanned => 'Planejada';

  @override
  String get statusOpen => 'Aberta';

  @override
  String get activityNameFallback => 'Sessão';

  @override
  String get oauthContinueGoogle => 'Continuar com Google';

  @override
  String get oauthContinueApple => 'Continuar com Apple';

  @override
  String get themeLightTooltip => 'Modo claro';

  @override
  String get themeDarkTooltip => 'Modo escuro';

  @override
  String get tipDismissHint => 'Toque em qualquer lugar para continuar';

  @override
  String get loginTagline => 'Planeje sua semana. Mova seu corpo.';

  @override
  String get loginTerms =>
      'Ao continuar você concorda com nossos Termos de Serviço';

  @override
  String get emptyStateTitle => 'Nada planejado ainda';

  @override
  String get emptyStateBody =>
      'Toque em + para adicionar a primeira sessão da semana.';

  @override
  String get emptyStateAddCta => 'Adicionar atividade';

  @override
  String get paywallComingSoonBadge => 'Em breve';

  @override
  String get paywallBannerTitle => 'Recursos premium\na caminho';

  @override
  String get paywallBannerBody =>
      'Estamos preparando algo especial.\nFique de olho no Kadence Pro.';

  @override
  String get paywallFeaturesHeader => 'Veja o que vem por aí:';

  @override
  String get paywallStravaTitle => 'Integração com Strava';

  @override
  String get paywallStravaBody =>
      'Importe seu histórico e marque sessões como feitas automaticamente';

  @override
  String get paywallStatsTitle => 'Estatísticas avançadas';

  @override
  String get paywallStatsBody =>
      'Mapa de calor anual, insights e cards compartilháveis';

  @override
  String get paywallDateFilterTitle => 'Filtros por data';

  @override
  String get paywallDateFilterBody =>
      'Filtre todas as estatísticas por qualquer intervalo de datas';

  @override
  String get paywallCloudTitle => 'Sincronização na nuvem';

  @override
  String get paywallCloudBody =>
      'Faça backup e acesse seus dados em qualquer dispositivo';

  @override
  String get paywallCustomColorsTitle => 'Cores personalizadas';

  @override
  String get paywallCustomColorsBody =>
      'Personalize as cores dos tipos de atividade e do tema';

  @override
  String get paywallSupportTitle => 'Apoie um desenvolvedor independente';

  @override
  String get paywallSupportBody => 'Sua compra ajuda a manter o Kadence vivo';

  @override
  String get statsKpiSessions => 'Feitas';

  @override
  String get statsKpiStreak => 'Sequência';

  @override
  String get statsKpiAverage => 'Média';

  @override
  String get statsWeekSuffix => 'sem';

  @override
  String get statsPerWeekSuffix => '/sem';

  @override
  String get statsProSection => 'Estatísticas Pro';

  @override
  String statsHeatmapTitle(int count) {
    return 'Atividade de $count semanas';
  }

  @override
  String statsHeatmapFilteredTo(String type) {
    return 'Filtrado por $type';
  }

  @override
  String get statsHeatmapTinted => 'Cor da atividade principal';

  @override
  String get statsByActivity => 'Por atividade';

  @override
  String get statsAllTime => 'Total';

  @override
  String get statsNoSessionsYet => 'Ainda sem sessões';

  @override
  String get actionClear => 'Limpar';

  @override
  String get statsEmptyTitle => 'Ainda sem estatísticas';

  @override
  String get statsEmptyBody =>
      'Conclua a primeira sessão para começar a acompanhar seu progresso.';

  @override
  String get statsTipFilterTitle => 'Filtrar por atividade';

  @override
  String get statsTipFilterBody =>
      'Toque em um tipo de atividade em \"Por atividade\" para destacar apenas esse tipo no mapa de calor';

  @override
  String get statsPersonalRecordsTitle => 'Recordes pessoais';

  @override
  String get statsBestStreak => 'Melhor sequência';

  @override
  String get statsBestWeek => 'Melhor semana';

  @override
  String get statsBestDay => 'Melhor dia';

  @override
  String get statsWeeklyActivityTitle => 'Atividade semanal';

  @override
  String get statsAvg => 'Média';

  @override
  String get statsBestDayOfWeekTitle => 'Melhor dia da semana';

  @override
  String get statsDoneSessions => 'Sessões feitas';

  @override
  String get statsCompletionRateTitle => 'Taxa de conclusão';

  @override
  String get statsPlannedVsDone => 'Planejadas vs feitas';

  @override
  String get statsMissed => 'Perdidas';

  @override
  String get statsMonthlyTrendsTitle => 'Tendências mensais';

  @override
  String get statsActivityVarietyTitle => 'Variedade de atividades';

  @override
  String get statsLongestGapTitle => 'Maior intervalo';

  @override
  String get statsBetweenSessions => 'Entre sessões';

  @override
  String get statsNoData => 'Sem dados';

  @override
  String get statsMonthVsMonthTitle => 'Mês vs mês';

  @override
  String get statsMostConsistentTitle => 'Mais consistentes';

  @override
  String get statsCompletionByType => 'Conclusão por tipo';

  @override
  String get statsWeeklyPatternsTitle => 'Padrões semanais';

  @override
  String get statsWhenYouDo => 'Quando você faz cada atividade';

  @override
  String get statsActiveDays => 'Dias ativos';

  @override
  String get statsBestMonth => 'Melhor mês';

  @override
  String get statsTopActivity => 'Top atividade';

  @override
  String get statsPeriodBreakdownTitle => 'Análise por período';

  @override
  String get statsPeriodNoSessions => 'Sem sessões neste período';

  @override
  String get statsAvgPerWeek => 'Média / sem';

  @override
  String get statsConsistency => 'Consistência';

  @override
  String get statsPeakWeek => 'Semana pico';

  @override
  String get statsTrendingUp => 'Subindo vs início do período';

  @override
  String get statsTrendingDown => 'Caindo vs início do período';

  @override
  String get statsSteadyPace => 'Ritmo estável';

  @override
  String get statsNoDataYet => 'Sem dados ainda';

  @override
  String get statsPeriodAll => 'Tudo';

  @override
  String get statsInsightsTitle => 'Insights';

  @override
  String insightFavoriteDay(String day, int count) {
    return 'Você treina mais nas ${day}s — $count sessões no total.';
  }

  @override
  String insightAboveAvg(int percent) {
    return 'Este mês está $percent% acima da sua média. Continue assim!';
  }

  @override
  String get insightBelowAvg =>
      'Este mês está mais calmo do que o normal. Ainda dá tempo!';

  @override
  String insightVariety(int count) {
    return 'Que variedade! Você fez $count atividades diferentes nos últimos 30 dias.';
  }

  @override
  String insightFocused(String type) {
    return 'Você tem focado em $type ultimamente. Experimente variar!';
  }

  @override
  String insightStreakStrong(int weeks) {
    return 'Sequência de $weeks semanas! Isso é consistência de verdade.';
  }

  @override
  String get insightStreakNew =>
      'Nova sequência começou! Continue esta semana.';

  @override
  String insightBestMonth(int count) {
    return 'Melhor mês de todos com $count sessões até agora!';
  }

  @override
  String get recapTitle => 'Compartilhe seu progresso';

  @override
  String get recapSubtitle =>
      'Gere um card de resumo e compartilhe com os amigos.';

  @override
  String get recapThisMonth => 'Este mês';

  @override
  String get recapThisYear => 'Este ano';

  @override
  String get recapPreview => 'Pré-visualização';

  @override
  String get recapShare => 'Compartilhar';

  @override
  String get recapActivity => 'Atividade';

  @override
  String recapTopActivity(String label) {
    return 'Top atividade: $label';
  }

  @override
  String recapStreakBadge(int count) {
    return '$count sem';
  }

  @override
  String recapYearInReviewTitle(int year) {
    return 'Retrospectiva $year';
  }

  @override
  String get recapMonthGettingStarted => 'Começando!';

  @override
  String get recapMonthUnstoppable => 'Mês imparável!';

  @override
  String get recapMonthCrushing => 'Arrasando!';

  @override
  String get recapMonthConsistency => 'Consistência incrível!';

  @override
  String get recapMonthStrong => 'Mês forte!';

  @override
  String get recapMonthMomentum => 'Ganhando ritmo!';

  @override
  String get recapYearBegins => 'A jornada começa!';

  @override
  String get recapYearLegendary => 'Ano lendário!';

  @override
  String get recapYearTripleDigits => 'Três dígitos!';

  @override
  String get recapYearStreakMachine => 'Máquina de sequências!';

  @override
  String get recapYearHalfHundred => 'Meia centena!';

  @override
  String get recapYearGoingStrong => 'Indo forte!';

  @override
  String get recapYearHabit => 'Criando o hábito!';

  @override
  String get statsLast12Months => 'Últimos 12 meses';

  @override
  String get statsLast12Weeks => 'Últimas 12 semanas';

  @override
  String statsTypesAllTime(int count) {
    return '$count tipos no total';
  }

  @override
  String get statsDifferentTypesPerWeek =>
      'Tipos diferentes por semana (últimas 12 semanas)';

  @override
  String get statsNeedAtLeast2 => 'Pelo menos 2 sessões';

  @override
  String statsDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String statsDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Há $count dias',
      one: 'Há 1 dia',
      zero: 'Hoje',
    );
    return '$_temp0';
  }

  @override
  String statsSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sessões',
      one: 'sessão',
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
    return 'Retrospectiva $year';
  }

  @override
  String statsYearHeatmapTitle(int year) {
    return 'Mapa de calor $year';
  }

  @override
  String statsActiveDaysCount(int count) {
    return '$count dias ativos';
  }

  @override
  String statsTriedTypes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count atividades diferentes',
      one: '1 atividade diferente',
    );
    return 'Você experimentou $_temp0 este ano';
  }

  @override
  String get subtypeAlpineSki => 'Esqui Alpino';

  @override
  String get subtypeBadminton => 'Badminton';

  @override
  String get subtypeCanoeing => 'Canoagem';

  @override
  String get subtypeCrossfit => 'Crossfit';

  @override
  String get subtypeEbikeRide => 'Bicicleta Elétrica';

  @override
  String get subtypeFencing => 'Esgrima';

  @override
  String get subtypeGolf => 'Golfe';

  @override
  String get subtypeHandball => 'Handebol';

  @override
  String get subtypeIceSkate => 'Patinação no Gelo';

  @override
  String get subtypeInlineSkate => 'Patins';

  @override
  String get subtypeKayaking => 'Caiaque';

  @override
  String get subtypeKitesurf => 'Kitesurf';

  @override
  String get subtypeMartialArts => 'Artes Marciais';

  @override
  String get subtypePilates => 'Pilates';

  @override
  String get subtypePickleball => 'Pickleball';

  @override
  String get subtypeRacquetball => 'Raquetebol';

  @override
  String get subtypeRockClimbing => 'Escalada';

  @override
  String get subtypeRollerSki => 'Roller Ski';

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
  String get subtypeSnowshoe => 'Raquete de Neve';

  @override
  String get subtypeSoccer => 'Futebol';

  @override
  String get subtypeSquash => 'Squash';

  @override
  String get subtypeStairStepper => 'Escada';

  @override
  String get subtypeStandUpPaddling => 'Stand Up Paddle';

  @override
  String get subtypeSwimming => 'Natação';

  @override
  String get subtypeTableTennis => 'Tênis de Mesa';

  @override
  String get subtypeTrailRun => 'Trail Running';

  @override
  String get subtypeVelomobile => 'Velomóvel';

  @override
  String get subtypeVirtualRide => 'Ciclismo Virtual';

  @override
  String get subtypeVirtualRow => 'Remo Virtual';

  @override
  String get subtypeVirtualRun => 'Corrida Virtual';

  @override
  String get subtypeVolleyball => 'Vôlei';

  @override
  String get subtypeWeightlifting => 'Musculação';

  @override
  String get subtypeWheelchair => 'Cadeira de Rodas';

  @override
  String get subtypeWindsurf => 'Windsurf';

  @override
  String get subtypeWorkout => 'Treino';

  @override
  String get subtypeYoga => 'Yoga';
}

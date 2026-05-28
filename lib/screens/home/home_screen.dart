import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../state/plan_controller.dart';
import '../../state/type_color_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../utils/date_utils.dart';
import '../../widgets/k_bottom_nav.dart';
import '../../widgets/k_top_bar.dart';
import '../day_detail/day_detail_sheet.dart';
import '../month/month_view.dart';
import '../settings/settings_screen.dart';
import '../stats/stats_view.dart';
import '../week/week_view.dart';

/// App shell with four tabs (Week / Month / Stats / Settings), a
/// floating action button that opens the add-session sheet, and a top
/// bar that swaps title and leading based on the active tab.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _tab = HomeTab.week;
  final GlobalKey<WeekViewState> _weekKey = GlobalKey<WeekViewState>();
  final GlobalKey<MonthViewState> _monthKey = GlobalKey<MonthViewState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final today = TodayScope.of(context);
    final typeColors = context.watch<TypeColorController>();
    final accentTint = typeColors.accentTint(colors);
    final loc = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toLanguageTag();

    final String title = switch (_tab) {
      HomeTab.week => loc.weekThisWeek,
      HomeTab.month => DateFormat.yMMMM(localeName).format(today),
      HomeTab.stats => loc.navStats,
      HomeTab.settings => loc.navSettings,
    };

    final Color? accentColor = _tab == HomeTab.settings ? null : accentTint;

    return Scaffold(
      backgroundColor: colors.bgBase,
      appBar: KTopBar(
        title: title,
        accentColor: accentColor,
        actions: const <Widget>[KDarkModeToggle()],
        onTitleTap: switch (_tab) {
          HomeTab.week => () => _weekKey.currentState?.jumpToToday(),
          HomeTab.month => () => _monthKey.currentState?.jumpToToday(),
          _ => null,
        },
      ),
      body: IndexedStack(
        index: _tab.index,
        children: <Widget>[
          WeekView(key: _weekKey),
          MonthView(key: _monthKey),
          StatsView(isActive: _tab == HomeTab.stats),
          const SettingsScreen(),
        ],
      ),
      floatingActionButton:
          _tab == HomeTab.settings || _tab == HomeTab.stats
          ? null
          : _KadenceFab(
              accentColor: accentColor,
              onPressed: () => showDayDetailSheet(
                context: context,
                date: context.read<PlanController>().today,
              ),
            ),
      bottomNavigationBar: KBottomNav(
        current: _tab,
        onSelect: (tab) => setState(() => _tab = tab),
        accentColor: accentColor,
      ),
    );
  }
}

class _KadenceFab extends StatelessWidget {
  const _KadenceFab({required this.onPressed, this.accentColor});

  final VoidCallback onPressed;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final bg = accentColor ?? context.colors.typeRun.tint;
    const fg = Color(0xFF0E0E0C);

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 4,
      highlightElevation: 6,
      splashColor: Colors.white24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: const Icon(LucideIcons.plus, color: fg),
    );
  }
}

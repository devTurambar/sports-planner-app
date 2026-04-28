import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/plan_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';
import '../../widgets/k_bottom_nav.dart';
import '../../widgets/k_top_bar.dart';
import '../day_detail/day_detail_sheet.dart';
import '../month/month_view.dart';
import '../settings/settings_screen.dart';
import '../week/week_view.dart';

/// App shell with three tabs (Week / Month / Settings), a floating
/// action button that opens the add-session sheet, and a top bar that
/// swaps title and leading based on the active tab.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _tab = HomeTab.week;
  final GlobalKey<WeekViewState> _weekKey = GlobalKey<WeekViewState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final today = TodayScope.of(context);

    final String title = switch (_tab) {
      HomeTab.week => '${today.shortMonth} ${today.year}',
      HomeTab.month => '${today.fullMonth} ${today.year}',
      HomeTab.settings => 'Settings',
    };

    final Widget? leading = _tab == HomeTab.week
        ? TextButton(
            onPressed: () => _weekKey.currentState?.jumpToToday(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: colors.accent,
            ),
            child: Text(
              'Today',
              style: KText.bodySm.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.accent,
              ),
            ),
          )
        : null;

    return Scaffold(
      backgroundColor: colors.bgBase,
      appBar: KTopBar(
        title: title,
        leading: leading,
        actions: const <Widget>[KDarkModeToggle()],
      ),
      body: IndexedStack(
        index: _tab.index,
        children: <Widget>[
          WeekView(key: _weekKey),
          const MonthView(),
          const SettingsScreen(),
        ],
      ),
      floatingActionButton: _tab == HomeTab.settings
          ? null
          : _KadenceFab(
              onPressed: () => showDayDetailSheet(
                context: context,
                date: context.read<PlanController>().today,
              ),
            ),
      bottomNavigationBar: KBottomNav(
        current: _tab,
        onSelect: (tab) => setState(() => _tab = tab),
      ),
    );
  }
}

class _KadenceFab extends StatelessWidget {
  const _KadenceFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: colors.accent,
      foregroundColor: colors.accentFg,
      elevation: 0,
      highlightElevation: 0,
      splashColor: Colors.white24,
      shape: const CircleBorder(),
      child: Icon(LucideIcons.plus, color: colors.accentFg),
    );
  }
}

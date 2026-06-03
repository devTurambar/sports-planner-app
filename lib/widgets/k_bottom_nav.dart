import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_text_styles.dart';

/// The four main home destinations.
enum HomeTab { week, month, stats, settings }

/// Bottom nav bar for the app shell.
class KBottomNav extends StatelessWidget {
  const KBottomNav({
    required this.current,
    required this.onSelect,
    this.accentColor,
    super.key,
  });

  final HomeTab current;
  final ValueChanged<HomeTab> onSelect;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            _NavItem(
              tab: HomeTab.week,
              label: loc.navWeek,
              icon: LucideIcons.calendarDays,
              current: current,
              onSelect: onSelect,
              accentColor: accentColor,
            ),
            _NavItem(
              tab: HomeTab.month,
              label: loc.navMonth,
              icon: LucideIcons.layoutGrid,
              current: current,
              onSelect: onSelect,
              accentColor: accentColor,
            ),
            _NavItem(
              tab: HomeTab.stats,
              label: loc.navStats,
              icon: LucideIcons.chartColumn,
              current: current,
              onSelect: onSelect,
              accentColor: accentColor,
            ),
            _NavItem(
              tab: HomeTab.settings,
              label: loc.navSettings,
              icon: LucideIcons.settings,
              current: current,
              onSelect: onSelect,
              accentColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.label,
    required this.icon,
    required this.current,
    required this.onSelect,
    this.accentColor,
  });

  final HomeTab tab;
  final String label;
  final IconData icon;
  final HomeTab current;
  final ValueChanged<HomeTab> onSelect;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = current == tab;
    final color = active ? (accentColor ?? colors.accent) : colors.fgTertiary;
    return Expanded(
      child: InkWell(
        onTap: () => onSelect(tab),
        splashColor: colors.bgSubtle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 10, 4, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: KText.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

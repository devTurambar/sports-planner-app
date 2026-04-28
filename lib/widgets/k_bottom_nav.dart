import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/kadence_colors.dart';
import '../theme/kadence_text_styles.dart';

/// The three main home destinations.
enum HomeTab { week, month, settings }

/// Bottom nav bar for the app shell.
class KBottomNav extends StatelessWidget {
  const KBottomNav({
    required this.current,
    required this.onSelect,
    super.key,
  });

  final HomeTab current;
  final ValueChanged<HomeTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
              label: 'Week',
              icon: LucideIcons.calendarDays,
              current: current,
              onSelect: onSelect,
            ),
            _NavItem(
              tab: HomeTab.month,
              label: 'Month',
              icon: LucideIcons.layoutGrid,
              current: current,
              onSelect: onSelect,
            ),
            _NavItem(
              tab: HomeTab.settings,
              label: 'Settings',
              icon: LucideIcons.settings,
              current: current,
              onSelect: onSelect,
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
  });

  final HomeTab tab;
  final String label;
  final IconData icon;
  final HomeTab current;
  final ValueChanged<HomeTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = current == tab;
    final color = active ? colors.accent : colors.fgTertiary;
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

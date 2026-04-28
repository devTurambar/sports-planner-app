import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../state/theme_controller.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_text_styles.dart';

/// Title bar used across the home scaffold. Left and right slots accept
/// any widget so screens can drop a "Today" button or extra actions.
class KTopBar extends StatelessWidget implements PreferredSizeWidget {
  const KTopBar({required this.title, this.leading, this.actions, super.key});

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.bgBase,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              children: <Widget>[
                SizedBox(width: 56, child: leading ?? const SizedBox()),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: KText.h3.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.fgPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions ?? const <Widget>[],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A round icon button for [KTopBar] actions.
class KCircleIconButton extends StatelessWidget {
  const KCircleIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final button = Material(
      color: colors.bgSubtle,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: colors.fgSecondary, size: 16),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// Light/dark toggle rendered as a sun or moon icon in a round button.
class KDarkModeToggle extends StatelessWidget {
  const KDarkModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();
    final isDark = controller.isDark;
    return KCircleIconButton(
      icon: isDark ? LucideIcons.sun : LucideIcons.moon,
      tooltip: isDark ? 'Light mode' : 'Dark mode',
      onPressed: controller.toggleDark,
    );
  }
}

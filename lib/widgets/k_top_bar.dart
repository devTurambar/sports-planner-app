import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../state/theme_controller.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_text_styles.dart';

class KTopBar extends StatelessWidget implements PreferredSizeWidget {
  const KTopBar({
    required this.title,
    this.accentColor,
    this.leading,
    this.actions,
    super.key,
  });

  final String title;
  final Color? accentColor;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = accentColor ?? colors.fgPrimary;

    return Material(
      color: colors.bgBase,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: title),
                            TextSpan(
                              text: '.',
                              style: TextStyle(color: tint),
                            ),
                          ],
                        ),
                        style: KText.h2.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colors.fgPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    if (actions != null) ...actions!,
                    if (leading != null) ...[
                      const SizedBox(width: 8),
                      leading!,
                    ],
                  ],
                ),
              ),
            ),
            if (accentColor != null)
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [
                      tint.withValues(alpha: 0.55),
                      tint.withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.35, 1.0],
                  ),
                ),
              )
            else
              const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

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
      color: colors.bgCard,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.borderSubtle),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: colors.fgSecondary, size: 16),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

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

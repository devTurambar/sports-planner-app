import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../screens/paywall/paywall_screen.dart';
import '../state/pro_controller.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_spacing.dart';
import '../theme/kadence_text_styles.dart';

/// Wraps a child widget with a blurred lock overlay when the user
/// does not have Kadence Pro. Tapping the overlay navigates to the
/// paywall.
///
/// When the user is Pro, the child is rendered normally with zero
/// overhead.
class KProLock extends StatelessWidget {
  const KProLock({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<ProController>().isPro;
    if (isPro) return child;

    return ClipRRect(
      borderRadius: BorderRadius.circular(KRadius.lg + 4),
      child: Stack(
        children: [
          // Show the real widget underneath (blurred).
          IgnorePointer(child: child),

          // Blur + tint overlay.
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: const SizedBox.expand(),
            ),
          ),

          // Tap target with lock badge.
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => PaywallScreen.show(context),
                borderRadius: BorderRadius.circular(KRadius.lg + 4),
                child: _LockBadge(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: KSpace.s4,
          vertical: KSpace.s2,
        ),
        decoration: BoxDecoration(
          color: colors.bgElevated.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(KRadius.full),
          border: Border.all(
            color: colors.accent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.lock, size: 14, color: colors.accent),
            const SizedBox(width: 6),
            Text(
              loc.proBadge,
              style: KText.bodySm.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.accent,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

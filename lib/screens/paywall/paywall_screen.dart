import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PaywallScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgBase,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          KSpace.s5,
          MediaQuery.paddingOf(context).top + KSpace.s2,
          KSpace.s5,
          KSpace.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _TopBar(onBack: () => Navigator.of(context).pop()),
          const SizedBox(height: KSpace.s6),
          const _ComingSoonBanner(),
          const SizedBox(height: KSpace.s8),
          Text(
            "Here's what's coming:",
            style: KText.bodySm.copyWith(color: colors.fgSecondary),
          ),
          const SizedBox(height: KSpace.s4),
          const _FeatureRow(
            icon: LucideIcons.flame,
            color: _FeatureColor.coral,
            title: 'Strava integration',
            subtitle: 'Import your history and auto-mark sessions as done',
          ),
          const _FeatureRow(
            icon: LucideIcons.chartColumn,
            color: _FeatureColor.blue,
            title: 'Advanced stats',
            subtitle: 'Full-year heatmap, insights, and shareable recaps',
          ),
          const _FeatureRow(
            icon: LucideIcons.calendarRange,
            color: _FeatureColor.purple,
            title: 'Date filtering',
            subtitle: 'Filter all stats by any custom date range',
          ),
          const _FeatureRow(
            icon: LucideIcons.cloudUpload,
            color: _FeatureColor.teal,
            title: 'Cloud sync',
            subtitle: 'Back up and access your data from any device',
          ),
          const _FeatureRow(
            icon: LucideIcons.palette,
            color: _FeatureColor.green,
            title: 'Custom colors',
            subtitle: 'Personalize activity type and theme colors',
          ),
          const _FeatureRow(
            icon: LucideIcons.star,
            color: _FeatureColor.amber,
            title: 'Support an indie developer',
            subtitle: 'Your purchase helps keep Kadence alive',
          ),
        ],
      ),
    );
  }
}

// ── top bar ─────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(KSpace.s1),
            child: Icon(
              LucideIcons.chevronLeft,
              size: 22,
              color: colors.fgSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Kadence ',
                  style: KText.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                  ),
                ),
                TextSpan(
                  text: 'Pro',
                  style: KText.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.accent,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }
}

// ── coming soon banner ──────────────────────────────────────────────────

class _ComingSoonBanner extends StatelessWidget {
  const _ComingSoonBanner();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: KSpace.s5,
        vertical: KSpace.s6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.accent.withValues(alpha: 0.12),
            colors.accent.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: colors.accent.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(KRadius.lg + 4),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: KSpace.s3,
              vertical: KSpace.s1,
            ),
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
            child: Text(
              'Coming soon',
              style: KText.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.accent,
              ),
            ),
          ),
          const SizedBox(height: KSpace.s3),
          Text(
            'Premium features are\non the way',
            style: KText.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.fgPrimary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: KSpace.s2),
          Text(
            "We're building something special.\nStay tuned for Kadence Pro.",
            style: KText.bodySm.copyWith(
              color: colors.fgSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── feature list ────────────────────────────────────────────────────────

enum _FeatureColor { coral, blue, purple, teal, green, amber }

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final _FeatureColor color;
  final String title;
  final String subtitle;

  Color _tint(KadenceColors colors) {
    switch (color) {
      case _FeatureColor.coral:
        return colors.typeRun.tint;
      case _FeatureColor.blue:
        return colors.typeCycle.tint;
      case _FeatureColor.purple:
        return colors.typeYoga.tint;
      case _FeatureColor.teal:
        return colors.typeSwim.tint;
      case _FeatureColor.green:
        return colors.typeWalk.tint;
      case _FeatureColor.amber:
        return colors.typeOther.tint;
    }
  }

  Color _bg(KadenceColors colors) {
    switch (color) {
      case _FeatureColor.coral:
        return colors.typeRun.bg;
      case _FeatureColor.blue:
        return colors.typeCycle.bg;
      case _FeatureColor.purple:
        return colors.typeYoga.bg;
      case _FeatureColor.teal:
        return colors.typeSwim.bg;
      case _FeatureColor.green:
        return colors.typeWalk.bg;
      case _FeatureColor.amber:
        return colors.typeOther.bg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: KSpace.s5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _bg(colors),
              borderRadius: BorderRadius.circular(KRadius.md),
            ),
            child: Icon(icon, size: 20, color: _tint(colors)),
          ),
          const SizedBox(width: KSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: KText.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _tint(colors),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: KText.bodySm.copyWith(
                    color: colors.fgSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

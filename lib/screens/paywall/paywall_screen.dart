import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../widgets/k_button.dart';

enum _Tier { monthly, annual, lifetime }

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PaywallScreen()),
    );
  }

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  _Tier _selected = _Tier.annual;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: colors.bgBase,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                KSpace.s5,
                MediaQuery.paddingOf(context).top + KSpace.s2,
                KSpace.s5,
                KSpace.s4,
              ),
              children: [
                _TopBar(onBack: () => Navigator.of(context).pop()),
                const SizedBox(height: KSpace.s6),
                _TierCard(
                  tier: _Tier.monthly,
                  selected: _selected == _Tier.monthly,
                  onTap: () => setState(() => _selected = _Tier.monthly),
                ),
                const SizedBox(height: KSpace.s3),
                _TierCard(
                  tier: _Tier.annual,
                  selected: _selected == _Tier.annual,
                  onTap: () => setState(() => _selected = _Tier.annual),
                ),
                const SizedBox(height: KSpace.s2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KSpace.s1),
                  child: Text(
                    'Recurring payment. Cancel anytime.',
                    style: KText.caption.copyWith(
                      color: colors.fgTertiary,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: KSpace.s4),
                Center(
                  child: Text(
                    'or',
                    style: KText.bodySm.copyWith(color: colors.fgTertiary),
                  ),
                ),
                const SizedBox(height: KSpace.s4),
                _TierCard(
                  tier: _Tier.lifetime,
                  selected: _selected == _Tier.lifetime,
                  onTap: () => setState(() => _selected = _Tier.lifetime),
                ),
                const SizedBox(height: KSpace.s2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KSpace.s1),
                  child: Text(
                    'Pay once. Unlimited access forever.',
                    style: KText.caption.copyWith(
                      color: colors.fgTertiary,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: KSpace.s4),
                Center(
                  child: GestureDetector(
                    onTap: _restorePurchases,
                    child: Text(
                      'Already subscribed? Restore your purchase',
                      style: KText.bodySm.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: KSpace.s8),
                Text(
                  'Unlock with your subscription:',
                  style: KText.bodySm.copyWith(
                    color: colors.fgSecondary,
                  ),
                ),
                const SizedBox(height: KSpace.s4),
                const _FeatureRow(
                  icon: LucideIcons.chartColumn,
                  color: _FeatureColor.coral,
                  title: 'Advanced stats',
                  subtitle:
                      'Trends, personal records, and deeper insights',
                ),
                const _FeatureRow(
                  icon: LucideIcons.cloudUpload,
                  color: _FeatureColor.blue,
                  title: 'Cloud sync',
                  subtitle:
                      'Back up and access your data from any device',
                ),
                const _FeatureRow(
                  icon: LucideIcons.palette,
                  color: _FeatureColor.purple,
                  title: 'Custom colors',
                  subtitle:
                      'Personalize activity type and accent colors',
                ),
                const _FeatureRow(
                  icon: LucideIcons.upload,
                  color: _FeatureColor.teal,
                  title: 'Export your data',
                  subtitle:
                      'Generate a file with your activities',
                ),
                const _FeatureRow(
                  icon: LucideIcons.download,
                  color: _FeatureColor.green,
                  title: 'Import your data',
                  subtitle:
                      'Restore previously exported activities',
                ),
                const _FeatureRow(
                  icon: LucideIcons.star,
                  color: _FeatureColor.amber,
                  title: 'Support an indie developer',
                  subtitle:
                      'Your purchase supports independent development',
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              KSpace.s5,
              KSpace.s3,
              KSpace.s5,
              KSpace.s4 + bottomSafe,
            ),
            child: KButton(
              label: 'Continue',
              onPressed: _handlePurchase,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePurchase() {
    // TODO: integrate with in_app_purchase / RevenueCat
  }

  void _restorePurchases() {
    // TODO: integrate with in_app_purchase / RevenueCat
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

// ── pricing tier card ───────────────────────────────────────────────────

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.tier,
    required this.selected,
    required this.onTap,
  });

  final _Tier tier;
  final bool selected;
  final VoidCallback onTap;

  String get _label {
    switch (tier) {
      case _Tier.monthly:
        return 'Monthly';
      case _Tier.annual:
        return 'Annual';
      case _Tier.lifetime:
        return 'Lifetime';
    }
  }

  String get _price {
    switch (tier) {
      case _Tier.monthly:
        return '0.99';
      case _Tier.annual:
        return '4.99';
      case _Tier.lifetime:
        return '12.99';
    }
  }

  String get _period {
    switch (tier) {
      case _Tier.monthly:
        return '/ month';
      case _Tier.annual:
        return '/ year';
      case _Tier.lifetime:
        return '';
    }
  }

  String? get _badge {
    if (tier == _Tier.annual) return '-58%';
    return null;
  }

  String? get _strikethrough {
    if (tier == _Tier.annual) return '11.88';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accentColor = colors.accent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: KMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: KSpace.s4,
          vertical: KSpace.s4,
        ),
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius: BorderRadius.circular(KRadius.lg + 4),
          border: Border.all(
            color: selected ? accentColor : colors.borderSubtle,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            _Radio(selected: selected),
            const SizedBox(width: KSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _label,
                    style: KText.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: colors.fgPrimary,
                    ),
                  ),
                  if (_strikethrough != null)
                    Row(
                      children: [
                        Text(
                          _strikethrough!,
                          style: KText.caption.copyWith(
                            color: colors.fgTertiary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          ' → $_price',
                          style: KText.caption.copyWith(
                            color: colors.fgSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (_badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(KRadius.full),
                ),
                child: Text(
                  _badge!,
                  style: KText.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.accentFg,
                  ),
                ),
              ),
              const SizedBox(width: KSpace.s3),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$_price €',
                  style: KText.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                  ),
                ),
                if (_period.isNotEmpty)
                  Text(
                    _period,
                    style: KText.caption.copyWith(
                      fontSize: 11,
                      color: colors.fgTertiary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: KMotion.fast,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colors.accent : colors.border,
          width: selected ? 6 : 2,
        ),
        color: selected ? colors.bgCard : Colors.transparent,
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

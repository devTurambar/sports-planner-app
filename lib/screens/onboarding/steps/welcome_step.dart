import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_button.dart';
import '../widgets/progress_dots.dart';

/// First onboarding screen: app name, value prop, and three feature hints.
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, KSpace.s8),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(child: _LogoMark(color: colors.accent)),
                const SizedBox(height: KSpace.s5),
                Text(
                  'kadence',
                  textAlign: TextAlign.center,
                  style: KText.h1.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: KSpace.s2),
                Text(
                  'Plan your week.\nMove your body.',
                  textAlign: TextAlign.center,
                  style: KText.body.copyWith(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w300,
                    color: colors.fgSecondary,
                  ),
                ),
                const SizedBox(height: KSpace.s6),
                const _FeatureRow(
                  icon: LucideIcons.circleDashed,
                  text: 'Plan sessions before the week starts',
                ),
                const SizedBox(height: KSpace.s2 + 2),
                const _FeatureRow(
                  icon: LucideIcons.check,
                  text: 'Check off as you go',
                ),
                const SizedBox(height: KSpace.s2 + 2),
                const _FeatureRow(
                  icon: LucideIcons.minus,
                  text: 'No guilt for rest days',
                ),
              ],
            ),
          ),
          const ProgressDots(total: 6, current: 0),
          const SizedBox(height: KSpace.s1 + 2),
          KButton(label: 'Get started', onPressed: onNext),
        ],
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(KRadius.xl),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            offset: const Offset(0, 8),
            blurRadius: 32,
          ),
        ],
      ),
      child: CustomPaint(size: const Size(72, 72), painter: _KGlyphPainter()),
    );
  }
}

/// Paints the "K" monogram in white strokes inside the accent square.
class _KGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final mid = size.height / 2;
    final left = size.width * 0.31;
    final right = size.width * 0.72;
    final top = size.height * 0.20;
    final bottom = size.height * 0.80;

    canvas
      ..drawLine(Offset(left, top), Offset(left, bottom), paint)
      ..drawLine(Offset(left, mid), Offset(right, top), paint)
      ..drawLine(Offset(left, mid), Offset(right, bottom), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: colors.accentLight,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 14, color: colors.accent),
        ),
        const SizedBox(width: KSpace.s2 + 2),
        Expanded(
          child: Text(
            text,
            style: KText.bodySm.copyWith(color: colors.fgSecondary),
          ),
        ),
      ],
    );
  }
}

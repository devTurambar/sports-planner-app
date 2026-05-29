import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_spacing.dart';
import '../theme/kadence_text_styles.dart';

enum TutorialGesture { swipe, doubleTap, longPress, tap, titleTap }

class KTutorialOverlay extends StatefulWidget {
  const KTutorialOverlay({
    required this.gesture,
    required this.title,
    required this.subtitle,
    required this.onDismiss,
    this.animationHint,
    super.key,
  });

  final TutorialGesture gesture;
  final String title;
  final String subtitle;
  final VoidCallback onDismiss;
  final String? animationHint;

  static void show({
    required BuildContext context,
    required TutorialGesture gesture,
    required String title,
    required String subtitle,
    required VoidCallback onDismiss,
    String? animationHint,
  }) {
    final entry = OverlayEntry(builder: (_) => const SizedBox.shrink());
    late final OverlayEntry realEntry;
    realEntry = OverlayEntry(
      builder: (_) => KTutorialOverlay(
        gesture: gesture,
        title: title,
        subtitle: subtitle,
        animationHint: animationHint,
        onDismiss: () {
          realEntry.remove();
          onDismiss();
        },
      ),
    );
    entry.remove;
    Overlay.of(context).insert(realEntry);
  }

  @override
  State<KTutorialOverlay> createState() => _KTutorialOverlayState();
}

class _KTutorialOverlayState extends State<KTutorialOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _fadeCtrl,
    curve: Curves.easeOut,
  );

  late final AnimationController _gestureCtrl = AnimationController(
    vsync: this,
    duration: _gestureDuration,
  );

  Duration get _gestureDuration => switch (widget.gesture) {
        TutorialGesture.swipe => const Duration(milliseconds: 1800),
        TutorialGesture.doubleTap => const Duration(milliseconds: 1400),
        TutorialGesture.longPress => const Duration(milliseconds: 2000),
        TutorialGesture.tap => const Duration(milliseconds: 1200),
        TutorialGesture.titleTap => const Duration(milliseconds: 2200),
      };

  @override
  void initState() {
    super.initState();
    _fadeCtrl.forward();
    _gestureCtrl.repeat();
  }

  void _dismiss() {
    _fadeCtrl.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _gestureCtrl.dispose();
    super.dispose();
  }

  Widget _buildDefault(BuildContext context, KadenceColors colors) {
    return Container(
      color: colors.bgBase.withValues(alpha: 0.88),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            SizedBox(
              height: 160,
              width: 240,
              child: _GestureAnimation(
                gesture: widget.gesture,
                controller: _gestureCtrl,
                hint: widget.animationHint,
              ),
            ),
            const SizedBox(height: KSpace.s8),
            _tutorialText(colors),
            const Spacer(flex: 2),
            _dismissHint(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleTap(BuildContext context, KadenceColors colors) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final screenH = mq.size.height;
    final screenW = mq.size.width;

    // Real title origin: SafeArea top + KTopBar padding
    final originY = topPad + 6.0 + 4.0; // top pad + bar padding + vertical centering
    const originX = 16.0;

    // Meet point: center of screen, shifted up a bit
    final meetY = screenH * 0.38;
    final meetX = (screenW - 160) / 2; // roughly center the pill

    // Finger start: below center
    final fingerStartY = screenH * 0.62;
    final fingerStartX = screenW / 2;

    final titleText =
        widget.animationHint ?? AppLocalizations.of(context)!.weekThisWeek;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: colors.bgBase.withValues(alpha: 0.88)),
        ),
        // Animated title clone + finger
        AnimatedBuilder(
          animation: _gestureCtrl,
          builder: (_, __) {
            final t = _gestureCtrl.value;

            // Phases:
            // 0.00–0.10  pause
            // 0.10–0.40  slide in (title from origin → meet, finger up)
            // 0.40–0.50  tap press
            // 0.50–0.70  ripple + glow hold
            // 0.70–0.90  slide out (both return)
            // 0.90–1.00  pause

            double titleX, titleY, fingerX, fingerY;
            double fingerScale, titleGlow, rippleOp, rippleS;

            if (t < 0.10) {
              titleX = originX;
              titleY = originY;
              fingerX = fingerStartX;
              fingerY = fingerStartY;
              fingerScale = 1.0;
              titleGlow = 0;
              rippleOp = 0;
              rippleS = 0;
            } else if (t < 0.40) {
              final mt = Curves.easeOutCubic.transform((t - 0.10) / 0.30);
              titleX = originX + (meetX - originX) * mt;
              titleY = originY + (meetY - originY) * mt;
              fingerX = fingerStartX + (screenW / 2 - fingerStartX) * mt;
              fingerY = fingerStartY + (meetY + 48 - fingerStartY) * mt;
              fingerScale = 1.0;
              titleGlow = 0;
              rippleOp = 0;
              rippleS = 0;
            } else if (t < 0.50) {
              final tt = Curves.easeIn.transform((t - 0.40) / 0.10);
              titleX = meetX;
              titleY = meetY;
              fingerX = screenW / 2;
              fingerY = meetY + 48;
              fingerScale = 1.0 - tt * 0.15;
              titleGlow = tt;
              rippleOp = 0;
              rippleS = 0;
            } else if (t < 0.70) {
              final rt = (t - 0.50) / 0.20;
              titleX = meetX;
              titleY = meetY;
              fingerX = screenW / 2;
              fingerY = meetY + 48;
              fingerScale = 0.85 +
                  Curves.easeOut.transform(math.min(rt * 2, 1.0)) * 0.15;
              titleGlow = 1.0 - rt;
              rippleOp = (1 - rt) * 0.5;
              rippleS = 0.4 + rt * 1.2;
            } else if (t < 0.90) {
              final mt = Curves.easeInCubic.transform((t - 0.70) / 0.20);
              titleX = meetX + (originX - meetX) * mt;
              titleY = meetY + (originY - meetY) * mt;
              fingerX = screenW / 2 + (fingerStartX - screenW / 2) * mt;
              fingerY = (meetY + 48) + (fingerStartY - meetY - 48) * mt;
              fingerScale = 1.0;
              titleGlow = 0;
              rippleOp = 0;
              rippleS = 0;
            } else {
              titleX = originX;
              titleY = originY;
              fingerX = fingerStartX;
              fingerY = fingerStartY;
              fingerScale = 1.0;
              titleGlow = 0;
              rippleOp = 0;
              rippleS = 0;
            }

            return Stack(
              children: [
                // Title clone pill
                Positioned(
                  left: titleX,
                  top: titleY,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: colors.bgCard.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: titleGlow > 0
                            ? colors.accent
                                .withValues(alpha: titleGlow * 0.7)
                            : colors.borderSubtle
                                .withValues(alpha: 0.5),
                        width: titleGlow > 0 ? 1.5 : 1,
                      ),
                      boxShadow: titleGlow > 0
                          ? [
                              BoxShadow(
                                color: colors.accent
                                    .withValues(alpha: titleGlow * 0.3),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: titleText,
                            style: KText.h2.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: colors.fgPrimary,
                              letterSpacing: -0.4,
                            ),
                          ),
                          TextSpan(
                            text: '.',
                            style: KText.h2.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: colors.accent,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Ripple at meet point
                if (rippleOp > 0)
                  Positioned(
                    left: screenW / 2 - 30 * rippleS,
                    top: meetY + 24 - 30 * rippleS,
                    child: Container(
                      width: 60 * rippleS,
                      height: 60 * rippleS,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.accent
                              .withValues(alpha: rippleOp),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                // Finger
                Positioned(
                  left: fingerX - 18,
                  top: fingerY - 18,
                  child: Transform.scale(
                    scale: fingerScale,
                    child: _FingerDot(color: colors.accent, size: 36),
                  ),
                ),
              ],
            );
          },
        ),
        // Text content
        Positioned.fill(
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                _tutorialText(colors),
                const Spacer(flex: 2),
                _dismissHint(colors),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tutorialText(KadenceColors colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: KSpace.s8),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: KText.h3.copyWith(
              color: colors.fgPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: KSpace.s2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: KSpace.s10),
          child: Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: KText.bodySm.copyWith(
              color: colors.fgSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dismissHint(KadenceColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KSpace.s8),
      child: Text(
        AppLocalizations.of(context)!.tipDismissHint,
        style: KText.caption.copyWith(
          color: colors.fgTertiary,
          fontSize: 11,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isTitleTap = widget.gesture == TutorialGesture.titleTap;

    return FadeTransition(
      opacity: _fade,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: _dismiss,
          behavior: HitTestBehavior.opaque,
          child: isTitleTap
              ? _buildTitleTap(context, colors)
              : _buildDefault(context, colors),
        ),
      ),
    );
  }
}

class _GestureAnimation extends StatelessWidget {
  const _GestureAnimation({
    required this.gesture,
    required this.controller,
    this.hint,
  });

  final TutorialGesture gesture;
  final AnimationController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return switch (gesture) {
      TutorialGesture.swipe => _SwipeAnimation(controller: controller),
      TutorialGesture.doubleTap => _DoubleTapAnimation(controller: controller),
      TutorialGesture.longPress =>
        _LongPressAnimation(controller: controller),
      TutorialGesture.tap => _TapAnimation(controller: controller),
      TutorialGesture.titleTap => const SizedBox.shrink(),
    };
  }
}

class _SwipeAnimation extends AnimatedWidget {
  const _SwipeAnimation({required AnimationController controller})
      : super(listenable: controller);

  AnimationController get _ctrl => listenable as AnimationController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = _ctrl.value;

    // Hand slides right (0→0.45), pauses, then slides left (0.55→1.0)
    final double dx;
    if (t < 0.45) {
      dx = Curves.easeInOut.transform(t / 0.45) * 60;
    } else if (t < 0.55) {
      dx = 60;
    } else {
      dx = (1 - Curves.easeInOut.transform((t - 0.55) / 0.45)) * 60;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Trail dots
        for (var i = 0; i < 5; i++)
          Positioned(
            left: 60 + i * 15.0,
            top: 75,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.fgTertiary
                    .withValues(alpha: 0.15 + (i * 0.05)),
              ),
            ),
          ),
        // Finger dot
        Transform.translate(
          offset: Offset(dx - 30, 0),
          child: _FingerDot(color: colors.accent, size: 48),
        ),
      ],
    );
  }
}

class _DoubleTapAnimation extends AnimatedWidget {
  const _DoubleTapAnimation({required AnimationController controller})
      : super(listenable: controller);

  AnimationController get _ctrl => listenable as AnimationController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = _ctrl.value;

    // First tap: 0.0–0.3, pause: 0.3–0.4, second tap: 0.4–0.7, pause: 0.7–1
    final double scale;
    final double rippleOpacity;
    final double rippleScale;

    if (t < 0.15) {
      // First tap down
      scale = 1.0 - Curves.easeIn.transform(t / 0.15) * 0.15;
      rippleOpacity = 0;
      rippleScale = 0;
    } else if (t < 0.3) {
      // First tap up + ripple
      final rt = (t - 0.15) / 0.15;
      scale = 0.85 + Curves.easeOut.transform(rt) * 0.15;
      rippleOpacity = (1 - rt) * 0.4;
      rippleScale = 0.6 + rt * 0.8;
    } else if (t < 0.4) {
      scale = 1.0;
      rippleOpacity = 0;
      rippleScale = 0;
    } else if (t < 0.55) {
      // Second tap down
      scale = 1.0 - Curves.easeIn.transform((t - 0.4) / 0.15) * 0.15;
      rippleOpacity = 0;
      rippleScale = 0;
    } else if (t < 0.7) {
      // Second tap up + ripple
      final rt = (t - 0.55) / 0.15;
      scale = 0.85 + Curves.easeOut.transform(rt) * 0.15;
      rippleOpacity = (1 - rt) * 0.4;
      rippleScale = 0.6 + rt * 0.8;
    } else {
      scale = 1.0;
      rippleOpacity = 0;
      rippleScale = 0;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ripple
        if (rippleOpacity > 0)
          Transform.scale(
            scale: rippleScale,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.accent.withValues(alpha: rippleOpacity),
                  width: 2,
                ),
              ),
            ),
          ),
        // Finger
        Transform.scale(
          scale: scale,
          child: _FingerDot(color: colors.accent, size: 48),
        ),
        // "×2" label
        Positioned(
          bottom: 20,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.bgElevated,
              borderRadius: BorderRadius.circular(KRadius.full),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Text(
              '×2',
              style: KText.label.copyWith(
                color: colors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LongPressAnimation extends AnimatedWidget {
  const _LongPressAnimation({required AnimationController controller})
      : super(listenable: controller);

  AnimationController get _ctrl => listenable as AnimationController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = _ctrl.value;

    // Press down: 0–0.15, hold: 0.15–0.7, release: 0.7–0.85, pause: 0.85–1
    final double scale;
    final double ringProgress;
    final double ringOpacity;

    if (t < 0.15) {
      scale = 1.0 - Curves.easeIn.transform(t / 0.15) * 0.12;
      ringProgress = 0;
      ringOpacity = 0;
    } else if (t < 0.7) {
      scale = 0.88;
      final ht = (t - 0.15) / 0.55;
      ringProgress = Curves.easeOut.transform(ht);
      ringOpacity = 0.6;
    } else if (t < 0.85) {
      final rt = (t - 0.7) / 0.15;
      scale = 0.88 + Curves.easeOut.transform(rt) * 0.12;
      ringProgress = 1.0;
      ringOpacity = (1 - rt) * 0.6;
    } else {
      scale = 1.0;
      ringProgress = 0;
      ringOpacity = 0;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Progress ring
        if (ringOpacity > 0)
          SizedBox(
            width: 72,
            height: 72,
            child: CustomPaint(
              painter: _ArcPainter(
                progress: ringProgress,
                color: colors.accent.withValues(alpha: ringOpacity),
                strokeWidth: 3,
              ),
            ),
          ),
        // Finger
        Transform.scale(
          scale: scale,
          child: _FingerDot(color: colors.accent, size: 48),
        ),
      ],
    );
  }
}

class _TapAnimation extends AnimatedWidget {
  const _TapAnimation({required AnimationController controller})
      : super(listenable: controller);

  AnimationController get _ctrl => listenable as AnimationController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = _ctrl.value;

    // Tap: 0–0.3, ripple: 0.3–0.6, pause: 0.6–1
    final double scale;
    final double rippleOpacity;
    final double rippleScale;

    if (t < 0.15) {
      scale = 1.0 - Curves.easeIn.transform(t / 0.15) * 0.15;
      rippleOpacity = 0;
      rippleScale = 0;
    } else if (t < 0.5) {
      final rt = (t - 0.15) / 0.35;
      scale = 0.85 + Curves.easeOut.transform(math.min(rt * 2, 1.0)) * 0.15;
      rippleOpacity = (1 - rt) * 0.5;
      rippleScale = 0.5 + rt * 1.2;
    } else {
      scale = 1.0;
      rippleOpacity = 0;
      rippleScale = 0;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (rippleOpacity > 0)
          Transform.scale(
            scale: rippleScale,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.accent.withValues(alpha: rippleOpacity),
                  width: 2,
                ),
              ),
            ),
          ),
        Transform.scale(
          scale: scale,
          child: _FingerDot(color: colors.accent, size: 48),
        ),
      ],
    );
  }
}


class _FingerDot extends StatelessWidget {
  const _FingerDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0.6),
          ],
          stops: const [0.4, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - strokeWidth;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress || old.color != color;
}

import 'package:flutter/material.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';

/// Animated progress indicator. The current step renders as a pill; the
/// rest as dots.
class ProgressDots extends StatelessWidget {
  const ProgressDots({required this.total, required this.current, super.key});

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KSpace.s2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(total, (i) {
          final active = i == current;
          return Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 5),
            child: AnimatedContainer(
              duration: KMotion.slow,
              curve: Curves.easeOutCubic,
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? colors.accent : colors.border,
                borderRadius: BorderRadius.circular(KRadius.full),
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/kadence_text_styles.dart';

class KTypeChip extends StatelessWidget {
  const KTypeChip({
    super.key,
    required this.label,
    required this.tint,
    required this.bg,
  });

  final String label;
  final Color tint;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(shape: BoxShape.circle, color: tint),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: KText.caption.copyWith(
              color: tint,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

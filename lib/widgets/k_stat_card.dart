import 'package:flutter/material.dart';

import '../theme/kadence_colors.dart';
import '../theme/kadence_spacing.dart';
import '../theme/kadence_text_styles.dart';

/// Summary tile used in the week and month headers. A value on top and a
/// short label underneath. Pass [accent] true for the highlighted variant.
class KStatCard extends StatelessWidget {
  const KStatCard({
    required this.value,
    required this.label,
    this.accent = false,
    super.key,
  });

  final String value;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = accent ? colors.accent : colors.fgPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent ? colors.accentLight : colors.bgElevated,
        borderRadius: BorderRadius.circular(KRadius.md),
        border: Border.all(
          color: accent
              ? colors.accent.withValues(alpha: 0.15)
              : colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: KText.h2.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: fg,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: KText.caption.copyWith(
              fontSize: 11,
              color: fg.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

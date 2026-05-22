import 'package:flutter/material.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';

class ProStatCard extends StatelessWidget {
  const ProStatCard({
    required this.title,
    this.subtitle,
    required this.child,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(KSpace.s4),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(KRadius.lg + 4),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: KText.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.fgPrimary,
                  ),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: KText.caption.copyWith(
                    fontSize: 10,
                    color: colors.fgTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: KSpace.s3),
          child,
        ],
      ),
    );
  }
}

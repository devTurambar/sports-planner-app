import 'package:flutter/material.dart';

import '../theme/kadence_colors.dart';
import '../theme/kadence_spacing.dart';
import '../theme/kadence_text_styles.dart';

enum KButtonVariant { primary, ghost, secondary }

/// A Kadence-styled button. Picks colors from [KadenceColors] so the same
/// widget renders correctly in both themes.
class KButton extends StatelessWidget {
  const KButton({
    required this.label,
    required this.onPressed,
    this.variant = KButtonVariant.primary,
    this.leading,
    this.expanded = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final KButtonVariant variant;
  final Widget? leading;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;

    Color bg;
    Color fg;
    TextStyle style = KText.button;
    double vPad = 14;
    final double hPad = variant == KButtonVariant.ghost ? KSpace.s3 : KSpace.s6;
    BoxBorder? border;

    switch (variant) {
      case KButtonVariant.primary:
        bg = enabled ? colors.accent : colors.fgDisabled;
        fg = enabled ? colors.accentFg : colors.bgSubtle;
        break;
      case KButtonVariant.secondary:
        bg = colors.bgSubtle;
        fg = colors.fgPrimary;
        border = Border.all(color: colors.border);
        break;
      case KButtonVariant.ghost:
        bg = Colors.transparent;
        fg = colors.fgTertiary;
        style = KText.bodySm.copyWith(fontWeight: FontWeight.w500);
        vPad = 12;
        break;
    }

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (leading != null) ...[
          leading!,
          const SizedBox(width: KSpace.s2),
        ],
        Text(label, style: style.copyWith(color: fg)),
      ],
    );

    final button = AnimatedContainer(
      duration: KMotion.fast,
      padding: EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(KRadius.lg),
        border: border,
      ),
      alignment: Alignment.center,
      child: child,
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(KRadius.lg),
          splashColor: colors.bgSubtle.withValues(alpha: 0.4),
          highlightColor: colors.bgSubtle.withValues(alpha: 0.2),
          child: expanded
              ? SizedBox(width: double.infinity, child: button)
              : button,
        ),
      ),
    );
  }
}

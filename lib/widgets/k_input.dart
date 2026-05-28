import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/kadence_colors.dart';
import '../theme/kadence_spacing.dart';
import '../theme/kadence_text_styles.dart';

/// Labelled text field matching the bottom-sheet input style.
class KInputField extends StatelessWidget {
  const KInputField({
    required this.label,
    required this.controller,
    this.placeholder,
    this.optional = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.onChanged,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? placeholder;
  final bool optional;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: KText.caption.copyWith(
              color: colors.fgSecondary,
              fontWeight: FontWeight.w500,
            ),
            children: <InlineSpan>[
              TextSpan(text: label),
              if (optional)
                TextSpan(
                  text: loc.fieldOptionalSuffix,
                  style: KText.caption.copyWith(
                    color: colors.fgDisabled,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: KSpace.s1 + 1),
        _KTextField(
          controller: controller,
          placeholder: placeholder,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _KTextField extends StatefulWidget {
  const _KTextField({
    required this.controller,
    this.placeholder,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? placeholder;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  State<_KTextField> createState() => _KTextFieldState();
}

class _KTextFieldState extends State<_KTextField> {
  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocus);
    widget.controller.addListener(_onText);
  }

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    _node.dispose();
    widget.controller.removeListener(_onText);
    super.dispose();
  }

  void _onFocus() => setState(() {});
  void _onText() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filled = widget.controller.text.isNotEmpty;
    final focused = _node.hasFocus;
    final highlight = focused || filled;

    return AnimatedContainer(
      duration: KMotion.base,
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: BorderRadius.circular(KRadius.md),
        border: Border.all(
          color: highlight ? colors.accent : colors.border,
          width: 1.5,
        ),
        boxShadow: highlight
            ? <BoxShadow>[
                BoxShadow(
                  color: colors.accentLight,
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: TextField(
        controller: widget.controller,
        focusNode: _node,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        cursorColor: colors.accent,
        style: KText.body.copyWith(color: colors.fgPrimary),
        decoration: InputDecoration.collapsed(
          hintText: widget.placeholder,
          hintStyle: KText.body.copyWith(color: colors.fgTertiary),
        ),
      ),
    );
  }
}

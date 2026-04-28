import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_button.dart';
import '../widgets/progress_dots.dart';
import '../widgets/selectable_tile.dart';

/// Reminder opt-in screen.
class NotifyStep extends StatefulWidget {
  const NotifyStep({
    required this.initialValue,
    required this.onNext,
    super.key,
  });

  final bool? initialValue;
  final ValueChanged<bool> onNext;

  @override
  State<NotifyStep> createState() => _NotifyStepState();
}

class _NotifyStepState extends State<NotifyStep> {
  late bool? _choice = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, KSpace.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colors.accentLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      LucideIcons.bell,
                      size: 28,
                      color: colors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: KSpace.s6),
                Text(
                  'Reminders',
                  textAlign: TextAlign.center,
                  style: KText.h2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                    letterSpacing: -0.44,
                  ),
                ),
                const SizedBox(height: KSpace.s2),
                Text(
                  'Get a nudge before each planned session. Useful if you '
                  'need a prompt to get out the door.',
                  textAlign: TextAlign.center,
                  style: KText.bodySm.copyWith(
                    color: colors.fgSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: KSpace.s6),
                SelectableTile(
                  title: 'Yes, remind me',
                  subtitle: '30 min before each session',
                  selected: _choice == true,
                  onTap: () => setState(() => _choice = true),
                ),
                const SizedBox(height: KSpace.s2),
                SelectableTile(
                  title: 'No thanks',
                  subtitle: "I'll check the app myself",
                  selected: _choice == false,
                  onTap: () => setState(() => _choice = false),
                ),
              ],
            ),
          ),
          const ProgressDots(total: 5, current: 3),
          const SizedBox(height: KSpace.s1 + 2),
          KButton(
            label: 'Continue',
            onPressed:
                _choice == null ? null : () => widget.onNext(_choice!),
          ),
        ],
      ),
    );
  }
}

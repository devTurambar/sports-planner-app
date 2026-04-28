import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/onboarding_controller.dart';
import '../../state/theme_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';

/// Minimal settings list: a dark-mode toggle plus a few single-value rows
/// for app-wide defaults. Rows are mostly placeholders at this stage —
/// tapping one opens a lightweight picker.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = context.watch<ThemeController>();
    final onboarding = context.watch<OnboardingController>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KSpace.s4,
        KSpace.s2,
        KSpace.s4,
        KSpace.s16,
      ),
      children: <Widget>[
        _Group(
          rows: <Widget>[
            _ToggleRow(
              label: 'Dark mode',
              value: theme.isDark,
              onChanged: (_) => theme.toggleDark(),
            ),
            _StaticRow(
              label: 'Default view',
              value: 'Week',
              onTap: () {},
            ),
            _StaticRow(
              label: 'Week starts on',
              value: 'Monday',
              onTap: () {},
            ),
            _StaticRow(
              label: 'Reminders',
              value: onboarding.remindersEnabled ? 'On' : 'Off',
              onTap: () => onboarding.setReminders(
                enabled: !onboarding.remindersEnabled,
              ),
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: KSpace.s3),
        _Group(
          rows: <Widget>[
            _StaticRow(
              label: 'Redo onboarding',
              value: 'Start',
              onTap: () async {
                await onboarding.reset();
              },
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: KSpace.s4),
        Text(
          'Kadence · v1.0',
          textAlign: TextAlign.center,
          style: KText.caption.copyWith(
            fontSize: 11,
            color: colors.fgDisabled,
          ),
        ),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(KRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: rows,
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderSubtle, width: 1),
        ),
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: KSpace.s4, vertical: 13),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: KText.body.copyWith(color: colors.fgPrimary),
            ),
          ),
          _Toggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _StaticRow extends StatelessWidget {
  const _StaticRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.isLast = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom:
                        BorderSide(color: colors.borderSubtle, width: 1),
                  ),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: KSpace.s4, vertical: 13),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: KText.body.copyWith(color: colors.fgPrimary),
                ),
              ),
              Text(
                value,
                style:
                    KText.bodySm.copyWith(color: colors.fgTertiary, fontSize: 14),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronRight,
                size: 14,
                color: colors.fgTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: KMotion.base,
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: value ? colors.accent : colors.border,
          borderRadius: BorderRadius.circular(KRadius.full),
        ),
        padding: const EdgeInsets.all(3),
        child: AnimatedAlign(
          duration: KMotion.base,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.easeOutCubic,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

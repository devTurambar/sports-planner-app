import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';

enum RecurrenceRule { none, daily, weekly, weekdays, weekends }

extension RecurrenceRuleX on RecurrenceRule {
  String get label => switch (this) {
        RecurrenceRule.none => 'Once',
        RecurrenceRule.daily => 'Daily',
        RecurrenceRule.weekly => 'Weekly',
        RecurrenceRule.weekdays => 'Weekdays',
        RecurrenceRule.weekends => 'Weekends',
      };

  List<DateTime> expand(DateTime base, int weeks) {
    final start = KDate.startOfDay(base);
    if (this == RecurrenceRule.none) return <DateTime>[start];
    if (this == RecurrenceRule.weekly) {
      return List<DateTime>.generate(
        weeks,
        (i) => start.add(Duration(days: 7 * i)),
      );
    }

    final totalDays = weeks * 7;
    final all = List<DateTime>.generate(
      totalDays,
      (i) => start.add(Duration(days: i)),
    );
    return switch (this) {
      RecurrenceRule.daily => all,
      RecurrenceRule.weekdays => all
          .where((d) =>
              d.weekday >= DateTime.monday && d.weekday <= DateTime.friday)
          .toList(growable: false),
      RecurrenceRule.weekends => <DateTime>[
          start,
          ...all.skip(1).where(
                (d) =>
                    d.weekday == DateTime.saturday ||
                    d.weekday == DateTime.sunday,
              ),
        ],
      RecurrenceRule.none || RecurrenceRule.weekly => <DateTime>[start],
    };
  }
}

class RecurrenceSelector extends StatelessWidget {
  const RecurrenceSelector(
      {required this.value, required this.onChanged, super.key});

  final RecurrenceRule value;
  final ValueChanged<RecurrenceRule> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Repeats',
          style: KText.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.fgSecondary,
          ),
        ),
        const SizedBox(height: 7),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: RecurrenceRule.values
              .map((r) => _RecurrenceChip(
                    rule: r,
                    selected: value == r,
                    onTap: () => onChanged(r),
                  ))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _RecurrenceChip extends StatelessWidget {
  const _RecurrenceChip({
    required this.rule,
    required this.selected,
    required this.onTap,
  });

  final RecurrenceRule rule;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.accentLight : colors.bgSubtle,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: KMotion.fast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? colors.accent : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            rule.label,
            style: KText.bodySm.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? colors.accent : colors.fgSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class WeeksStepper extends StatelessWidget {
  const WeeksStepper(
      {required this.value, required this.onChanged, super.key});

  final int value;
  final ValueChanged<int> onChanged;

  static const int _min = 1;
  static const int _max = 12;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Repeat for',
            style: KText.body.copyWith(color: colors.fgPrimary),
          ),
        ),
        _StepperButton(
          icon: LucideIcons.minus,
          onPressed: value > _min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 64,
          child: Text(
            value == 1 ? '1 week' : '$value weeks',
            textAlign: TextAlign.center,
            style: KText.body.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.fgPrimary,
            ),
          ),
        ),
        _StepperButton(
          icon: LucideIcons.plus,
          onPressed: value < _max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;
    return Material(
      color: colors.bgSubtle,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            icon,
            size: 14,
            color: enabled ? colors.fgSecondary : colors.fgDisabled,
          ),
        ),
      ),
    );
  }
}

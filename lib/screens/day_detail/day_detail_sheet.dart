import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';
import '../../widgets/k_button.dart';
import '../../widgets/k_input.dart';

/// Opens the add/edit bottom sheet. [existing] is null for a brand-new
/// session; pass the current activity to prefill the form for editing.
Future<void> showDayDetailSheet({
  required BuildContext context,
  required DateTime date,
  Activity? existing,
}) {
  final colors = context.colors;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: colors.scrim,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => DayDetailSheet(date: date, existing: existing),
  );
}

class DayDetailSheet extends StatefulWidget {
  const DayDetailSheet({required this.date, this.existing, super.key});

  final DateTime date;
  final Activity? existing;

  @override
  State<DayDetailSheet> createState() => _DayDetailSheetState();
}

class _DayDetailSheetState extends State<DayDetailSheet> {
  late final TextEditingController _name =
      TextEditingController(text: _isEditable ? widget.existing?.name : '');
  late final TextEditingController _duration =
      TextEditingController(text: widget.existing?.duration ?? '');
  late final TextEditingController _intensity =
      TextEditingController(text: widget.existing?.intensity ?? '');
  late final TextEditingController _notes =
      TextEditingController(text: widget.existing?.notes ?? '');

  late ActivityType _type =
      widget.existing?.type ?? ActivityType.run;

  RecurrenceRule _recurrence = RecurrenceRule.none;
  int _weeks = 4;

  bool get _isEditable =>
      widget.existing != null && widget.existing!.status != DayStatus.empty;

  bool get _hasName => _name.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _duration.dispose();
    _intensity.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _confirmDelete() {
    final colors = context.colors;
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KRadius.md),
        ),
        title: Text(
          'Delete session?',
          style: KText.h3.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colors.fgPrimary,
          ),
        ),
        content: Text(
          'This can\'t be undone.',
          style: KText.bodySm.copyWith(color: colors.fgSecondary),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: KText.bodySm.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.fgSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Delete',
              style: KText.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB5443A),
              ),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context.read<PlanController>().delete(
              date: widget.date,
              id: widget.existing!.id,
            );
        Navigator.of(context).pop();
      }
    });
  }

  void _save() {
    if (!_hasName) return;
    final plan = context.read<PlanController>();
    final duration =
        _duration.text.trim().isEmpty ? null : _duration.text.trim();
    final intensity =
        _intensity.text.trim().isEmpty ? null : _intensity.text.trim();
    final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();

    if (_isEditable) {
      plan.save(
        date: widget.date,
        id: widget.existing!.id,
        name: _name.text,
        type: _type,
        duration: duration,
        intensity: intensity,
        notes: notes,
      );
    } else {
      final dates = _recurrence.expand(widget.date, _weeks);
      for (final date in dates) {
        plan.save(
          date: date,
          name: _name.text,
          type: _type,
          duration: duration,
          intensity: intensity,
          notes: notes,
        );
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = _isEditable ? 'Edit session' : 'Add session';
    final subtitle =
        '${widget.date.shortWeekday} · ${widget.date.shortMonth} ${widget.date.day}';

    final viewInsets = MediaQuery.viewInsetsOf(context);
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgElevated,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(KRadius.xl),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, -2),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(KRadius.full),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: KText.h3.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: colors.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          subtitle,
                          style: KText.caption.copyWith(
                            color: colors.fgTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _CloseButton(onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Divider(height: 1, color: colors.borderSubtle),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  KSpace.s4,
                  20,
                  KSpace.s4 + bottomSafe,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    KInputField(
                      label: 'Activity name',
                      controller: _name,
                      placeholder: 'e.g. Morning run',
                    ),
                    const SizedBox(height: KSpace.s3 + 2),
                    _TypeSelector(
                      value: _type,
                      onChanged: (v) => setState(() => _type = v),
                    ),
                    const SizedBox(height: KSpace.s3 + 2),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: KInputField(
                            label: 'Duration',
                            controller: _duration,
                            placeholder: '45 min',
                          ),
                        ),
                        const SizedBox(width: KSpace.s2 + 2),
                        Expanded(
                          child: KInputField(
                            label: 'Intensity',
                            controller: _intensity,
                            placeholder: 'Zone 2',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KSpace.s3 + 2),
                    KInputField(
                      label: 'Notes',
                      controller: _notes,
                      placeholder: 'Any extra details…',
                      optional: true,
                      maxLines: 4,
                      minLines: 3,
                    ),
                    if (!_isEditable) ...<Widget>[
                      const SizedBox(height: KSpace.s3 + 2),
                      _RecurrenceSelector(
                        value: _recurrence,
                        onChanged: (v) => setState(() => _recurrence = v),
                      ),
                      if (_recurrence != RecurrenceRule.none) ...<Widget>[
                        const SizedBox(height: KSpace.s3),
                        _WeeksStepper(
                          value: _weeks,
                          onChanged: (v) => setState(() => _weeks = v),
                        ),
                      ],
                    ],
                    const SizedBox(height: KSpace.s4),
                    KButton(
                      label: 'Save session',
                      onPressed: _hasName ? _save : null,
                    ),
                    if (_isEditable) ...<Widget>[
                      const SizedBox(height: KSpace.s2),
                      Center(
                        child: TextButton(
                          onPressed: _confirmDelete,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFB5443A),
                          ),
                          child: Text(
                            'Delete session',
                            style: KText.bodySm.copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFB5443A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.bgSubtle,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(LucideIcons.x, size: 14, color: colors.fgSecondary),
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.value, required this.onChanged});

  final ActivityType value;
  final ValueChanged<ActivityType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Type',
          style: KText.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.fgSecondary,
          ),
        ),
        const SizedBox(height: 7),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: ActivityType.values
              .map((t) => _TypeChip(
                    type: t,
                    selected: value == t,
                    onTap: () => onChanged(t),
                  ))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final ActivityType type;
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
            type.label,
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

enum RecurrenceRule { none, daily, weekly, weekdays, weekends }

extension RecurrenceRuleX on RecurrenceRule {
  String get label => switch (this) {
        RecurrenceRule.none => 'Once',
        RecurrenceRule.daily => 'Daily',
        RecurrenceRule.weekly => 'Weekly',
        RecurrenceRule.weekdays => 'Weekdays',
        RecurrenceRule.weekends => 'Weekends',
      };

  /// Returns every date that should receive this session given a starting
  /// [base] date and a duration in [weeks]. The [base] date is always
  /// included (even if the rule would normally skip it).
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

class _RecurrenceSelector extends StatelessWidget {
  const _RecurrenceSelector({required this.value, required this.onChanged});

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

class _WeeksStepper extends StatelessWidget {
  const _WeeksStepper({required this.value, required this.onChanged});

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

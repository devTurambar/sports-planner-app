import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../state/tip_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';
import '../../widgets/k_button.dart';
import '../../widgets/k_input.dart';
import 'widgets/close_button.dart';
import 'widgets/duration_picker.dart';
import 'widgets/recurrence_selector.dart';
import 'widgets/time_picker_field.dart';
import 'widgets/type_selector.dart';

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
  late final TextEditingController _notes =
      TextEditingController(text: widget.existing?.notes ?? '');

  late ActivityType? _type = widget.existing?.type;
  late String? _subType = widget.existing?.subType;
  late TimeOfDay? _selectedTime = _parseTimeOfDay(widget.existing?.timeOfDay);
  late int? _durationMinutes = _parseDuration(widget.existing?.duration);

  RecurrenceRule _recurrence = RecurrenceRule.none;
  int _weeks = 4;

  static TimeOfDay? _parseTimeOfDay(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final m = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(raw);
    if (m == null) return null;
    return TimeOfDay(
      hour: int.parse(m.group(1)!),
      minute: int.parse(m.group(2)!),
    );
  }

  String _formatTimeForStorage(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static int? _parseDuration(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final digits = RegExp(r'\d+').firstMatch(raw)?.group(0);
    if (digits == null) return null;
    final n = int.tryParse(digits);
    return (n != null && n > 0) ? n : null;
  }

  static String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return '$h h';
    return '$h h $m min';
  }

  static String _formatDurationForStorage(int minutes) => '$minutes min';

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

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _pickDuration() async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DurationPickerSheet(
        initialMinutes: _durationMinutes ?? 45,
      ),
    );
    if (picked != null) setState(() => _durationMinutes = picked);
  }

  void _save() {
    if (!_hasName) return;
    final plan = context.read<PlanController>();
    final timeOfDay =
        _selectedTime != null ? _formatTimeForStorage(_selectedTime!) : null;
    final duration = _durationMinutes != null
        ? _formatDurationForStorage(_durationMinutes!)
        : null;
    final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();

    if (_isEditable) {
      plan.save(
        date: widget.date,
        id: widget.existing!.id,
        name: _name.text,
        type: _type,
        subType: _type == ActivityType.other ? _subType : null,
        duration: duration,
        timeOfDay: timeOfDay,
        notes: notes,
      );
    } else {
      context.read<TipController>().onActivityCreated();
      final dates = _recurrence.expand(widget.date, _weeks);
      for (final date in dates) {
        plan.save(
          date: date,
          name: _name.text,
          type: _type,
          subType: _type == ActivityType.other ? _subType : null,
          duration: duration,
          timeOfDay: timeOfDay,
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
                  SheetCloseButton(
                      onPressed: () => Navigator.of(context).pop()),
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
                    TypeSelector(
                      value: _type,
                      subType: _subType,
                      onChanged: (v) => setState(() {
                        if (v == _type && v != ActivityType.other) {
                          _type = null;
                          _subType = null;
                        } else {
                          _type = v;
                          if (v != ActivityType.other) _subType = null;
                        }
                      }),
                      onSubTypeChanged: (v) =>
                          setState(() => _subType = v),
                    ),
                    const SizedBox(height: KSpace.s3 + 2),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TimePickerField(
                            value: _selectedTime,
                            onTap: _pickTime,
                            onClear: _selectedTime != null
                                ? () => setState(() => _selectedTime = null)
                                : null,
                          ),
                        ),
                        const SizedBox(width: KSpace.s2 + 2),
                        Expanded(
                          child: DurationPickerField(
                            value: _durationMinutes,
                            formatDuration: _formatDuration,
                            onTap: _pickDuration,
                            onClear: _durationMinutes != null
                                ? () =>
                                    setState(() => _durationMinutes = null)
                                : null,
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
                      RecurrenceSelector(
                        value: _recurrence,
                        onChanged: (v) => setState(() => _recurrence = v),
                      ),
                      if (_recurrence != RecurrenceRule.none) ...<Widget>[
                        const SizedBox(height: KSpace.s3),
                        WeeksStepper(
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

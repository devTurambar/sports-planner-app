import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_button.dart';
import 'close_button.dart';

class DurationPickerField extends StatelessWidget {
  const DurationPickerField({
    required this.value,
    required this.formatDuration,
    required this.onTap,
    this.onClear,
    super.key,
  });

  final int? value;
  final String Function(int) formatDuration;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final hasValue = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          loc.durationLabel,
          style: KText.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.fgSecondary,
          ),
        ),
        const SizedBox(height: KSpace.s1 + 1),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(KRadius.md),
            child: AnimatedContainer(
              duration: KMotion.base,
              decoration: BoxDecoration(
                color: colors.bgElevated,
                borderRadius: BorderRadius.circular(KRadius.md),
                border: Border.all(
                  color: hasValue ? colors.accent : colors.border,
                  width: 1.5,
                ),
                boxShadow: hasValue
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
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      hasValue ? formatDuration(value!) : loc.durationPlaceholder,
                      style: KText.body.copyWith(
                        color: hasValue ? colors.fgPrimary : colors.fgTertiary,
                      ),
                    ),
                  ),
                  if (hasValue)
                    GestureDetector(
                      onTap: onClear,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          LucideIcons.x,
                          size: 14,
                          color: colors.fgTertiary,
                        ),
                      ),
                    )
                  else
                    Icon(
                      LucideIcons.timer,
                      size: 16,
                      color: colors.fgTertiary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DurationPickerSheet extends StatefulWidget {
  const DurationPickerSheet({required this.initialMinutes, super.key});

  final int initialMinutes;

  @override
  State<DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<DurationPickerSheet> {
  static const _hours = [0, 1, 2, 3, 4];
  static const _minutes = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

  late int _hourIndex;
  late int _minIndex;

  @override
  void initState() {
    super.initState();
    final h = (widget.initialMinutes ~/ 60).clamp(0, _hours.last);
    final m = widget.initialMinutes % 60;
    _hourIndex = _hours.indexOf(h);
    final closestMin = _minutes.reduce(
      (a, b) => (a - m).abs() <= (b - m).abs() ? a : b,
    );
    _minIndex = _minutes.indexOf(closestMin);
  }

  int get _totalMinutes => _hours[_hourIndex] * 60 + _minutes[_minIndex];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomSafe),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    loc.durationLabel,
                    style: KText.h3.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.fgPrimary,
                    ),
                  ),
                ),
                SheetCloseButton(
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.borderSubtle),
          SizedBox(
            height: 200,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _hourIndex,
                    ),
                    itemExtent: 40,
                    selectionOverlay: Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: colors.border,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                    onSelectedItemChanged: (i) =>
                        setState(() => _hourIndex = i),
                    children: [
                      for (var i = 0; i < _hours.length; i++)
                        Center(
                          child: Text(
                            loc.durationHoursWheel(_hours[i]),
                            style: KText.body.copyWith(
                              fontSize: 18,
                              fontWeight: i == _hourIndex
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: i == _hourIndex
                                  ? colors.accent
                                  : colors.fgTertiary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _minIndex,
                    ),
                    itemExtent: 40,
                    selectionOverlay: Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: colors.border,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                    onSelectedItemChanged: (i) =>
                        setState(() => _minIndex = i),
                    children: [
                      for (var i = 0; i < _minutes.length; i++)
                        Center(
                          child: Text(
                            loc.durationMinutesWheel(_minutes[i]),
                            style: KText.body.copyWith(
                              fontSize: 18,
                              fontWeight: i == _minIndex
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: i == _minIndex
                                  ? colors.accent
                                  : colors.fgTertiary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: KButton(
              label: loc.actionDone,
              onPressed: () {
                final total = _totalMinutes;
                Navigator.of(context).pop(total > 0 ? total : null);
              },
            ),
          ),
        ],
      ),
    );
  }
}

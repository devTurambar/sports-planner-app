import 'package:flutter/material.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/k_button.dart';
import '../widgets/progress_dots.dart';
import '../widgets/selectable_tile.dart';

/// "When do you train?" — weekday multi-select.
class DaysStep extends StatefulWidget {
  const DaysStep({
    required this.initialSelection,
    required this.onNext,
    super.key,
  });

  final List<String> initialSelection;
  final ValueChanged<List<String>> onNext;

  @override
  State<DaysStep> createState() => _DaysStepState();
}

class _DaysStepState extends State<DaysStep> {
  late final Set<String> _selected = <String>{...widget.initialSelection};

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, KSpace.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(KSpace.s2, 4, KSpace.s2, KSpace.s5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'When do you train?',
                  style: KText.h2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                    letterSpacing: -0.44,
                  ),
                ),
                const SizedBox(height: KSpace.s1 + 2),
                Text(
                  'Pick your usual days. Kadence will use these as a '
                  'starting template each week.',
                  style: KText.bodySm.copyWith(color: colors.fgSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: KSpace.s2),
              itemCount: KDate.shortWeekdays.length,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: KSpace.s2),
              itemBuilder: (_, i) {
                final day = KDate.shortWeekdays[i];
                return SelectableTile(
                  title: day,
                  selected: _selected.contains(day),
                  onTap: () => setState(() {
                    if (_selected.contains(day)) {
                      _selected.remove(day);
                    } else {
                      _selected.add(day);
                    }
                  }),
                );
              },
            ),
          ),
          const SizedBox(height: KSpace.s4),
          const ProgressDots(total: 5, current: 2),
          const SizedBox(height: KSpace.s1 + 2),
          KButton(
            label: 'Continue',
            onPressed: _selected.isEmpty
                ? null
                : () => widget.onNext(_selected.toList()),
          ),
          KButton(
            label: "I'll set this up later",
            variant: KButtonVariant.ghost,
            onPressed: () => widget.onNext(widget.initialSelection),
          ),
        ],
      ),
    );
  }
}

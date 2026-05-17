import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_button.dart';
import '../widgets/progress_dots.dart';

/// "What do you do?" — multi-select sport picker.
class SportStep extends StatefulWidget {
  const SportStep({
    required this.initialSelection,
    required this.onNext,
    super.key,
  });

  final List<String> initialSelection;
  final ValueChanged<List<String>> onNext;

  @override
  State<SportStep> createState() => _SportStepState();
}

class _SportStepState extends State<SportStep> {
  static const List<_Sport> _sports = <_Sport>[
    _Sport('run', 'Run', LucideIcons.activity, 'Road, trail, track'),
    _Sport('cycle', 'Cycle', LucideIcons.bike, 'Road, MTB, indoor'),
    _Sport('gym', 'Gym', LucideIcons.dumbbell, 'Weights, CrossFit'),
    _Sport('yoga', 'Yoga', LucideIcons.flower, 'Yoga, Pilates, stretch'),
    _Sport('swim', 'Swim', LucideIcons.waves, 'Pool, open water'),
    _Sport('mix', 'Mix', LucideIcons.shuffle, 'A bit of everything'),
  ];

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
                  'What do you do?',
                  style: KText.h2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                    letterSpacing: -0.44,
                  ),
                ),
                const SizedBox(height: KSpace.s1 + 2),
                Text(
                  'Pick one or more. You can always add others later.',
                  style: KText.bodySm.copyWith(color: colors.fgSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: KSpace.s2),
              crossAxisCount: 2,
              mainAxisSpacing: KSpace.s2,
              crossAxisSpacing: KSpace.s2,
              childAspectRatio: 1.1,
              physics: const BouncingScrollPhysics(),
              children: _sports.map(_buildTile).toList(growable: false),
            ),
          ),
          const SizedBox(height: KSpace.s4),
          const ProgressDots(total: 6, current: 1),
          const SizedBox(height: KSpace.s1 + 2),
          KButton(
            label: 'Continue',
            onPressed: _selected.isEmpty
                ? null
                : () => widget.onNext(_selected.toList()),
          ),
          KButton(
            label: 'Skip for now',
            variant: KButtonVariant.ghost,
            onPressed: () => widget.onNext(const <String>[]),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(_Sport sport) {
    final colors = context.colors;
    final selected = _selected.contains(sport.id);
    return AnimatedContainer(
      duration: KMotion.fast,
      decoration: BoxDecoration(
        color: selected ? colors.accentLight : colors.bgElevated,
        border: Border.all(
          color: selected ? colors.accent : colors.border,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(KRadius.lg),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(KRadius.lg),
          onTap: () => setState(() {
            if (selected) {
              _selected.remove(sport.id);
            } else {
              _selected.add(sport.id);
            }
          }),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              KSpace.s3,
              KSpace.s3 + 2,
              KSpace.s3,
              KSpace.s3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  sport.icon,
                  size: 22,
                  color: selected ? colors.accent : colors.fgTertiary,
                ),
                const SizedBox(height: KSpace.s2),
                Text(
                  sport.label,
                  style: KText.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected ? colors.accent : colors.fgPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sport.description,
                  style: KText.caption.copyWith(
                    color: selected ? colors.accentMuted : colors.fgTertiary,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                AnimatedOpacity(
                  duration: KMotion.fast,
                  opacity: selected ? 1 : 0,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        LucideIcons.check,
                        size: 10,
                        color: colors.accentFg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Sport {
  const _Sport(this.id, this.label, this.icon, this.description);

  final String id;
  final String label;
  final IconData icon;
  final String description;
}

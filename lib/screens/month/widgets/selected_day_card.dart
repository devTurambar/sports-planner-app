import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/k_activity_card.dart';

/// Expandable detail card that appears below the grid when the user taps a
/// day. Lists every activity planned for that date plus an Add button.
class SelectedDayCard extends StatelessWidget {
  const SelectedDayCard({
    required this.date,
    required this.activities,
    required this.onClose,
    required this.onEditActivity,
    required this.onToggleActivity,
    required this.onAdd,
    super.key,
  });

  final DateTime date;
  final List<Activity> activities;
  final VoidCallback onClose;
  final ValueChanged<Activity> onEditActivity;
  final ValueChanged<Activity> onToggleActivity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        borderRadius: BorderRadius.circular(KRadius.lg),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Header(date: date, onClose: onClose),
          const SizedBox(height: 8),
          _Body(
            activities: activities,
            onEditActivity: onEditActivity,
            onToggleActivity: onToggleActivity,
            onAdd: onAdd,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.date, required this.onClose});

  final DateTime date;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label =
        '${date.shortWeekday.toUpperCase()} · ${date.shortMonth} ${date.day}';
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: KText.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.fgTertiary,
              letterSpacing: 0.6,
            ),
          ),
        ),
        InkWell(
          onTap: onClose,
          customBorder: const CircleBorder(),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: colors.bgElevated,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(LucideIcons.x, size: 12, color: colors.fgTertiary),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.activities,
    required this.onEditActivity,
    required this.onToggleActivity,
    required this.onAdd,
  });

  final List<Activity> activities;
  final ValueChanged<Activity> onEditActivity;
  final ValueChanged<Activity> onToggleActivity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (activities.isEmpty) {
      return Row(
        children: <Widget>[
          _PlusIcon(background: colors.bgElevated, color: colors.fgDisabled),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Nothing planned',
              style: KText.caption.copyWith(
                color: colors.fgTertiary,
                fontSize: 13,
              ),
            ),
          ),
          _AddButton(onPressed: onAdd),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (var i = 0; i < activities.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: 6),
          KActivityCard(
            activity: activities[i],
            onTap: () => onEditActivity(activities[i]),
            onCheckTap: () => onToggleActivity(activities[i]),
          ),
        ],
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: _AddButton(onPressed: onAdd),
        ),
      ],
    );
  }
}

class _PlusIcon extends StatelessWidget {
  const _PlusIcon({required this.color, required this.background});
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: colors.border, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Icon(LucideIcons.plus, color: color, size: 16),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.accent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'Add',
            style: KText.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.accentFg,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';
import '../../widgets/k_activity_card.dart';
import '../../widgets/k_button.dart';
import 'day_detail_sheet.dart';

/// Opens a sheet that lists every activity planned for [date] and offers
/// an Add button. Tapping an activity opens the edit form on top.
Future<void> showDayOverviewSheet({
  required BuildContext context,
  required DateTime date,
}) {
  final colors = context.colors;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: colors.scrim,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => DayOverviewSheet(date: date),
  );
}

class DayOverviewSheet extends StatelessWidget {
  const DayOverviewSheet({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final plan = context.watch<PlanController>();
    final activities = plan.activitiesFor(date);
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Container(
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
                        '${date.fullMonth} ${date.day}',
                        style: KText.h3.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: colors.fgPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${date.shortWeekday} · '
                        '${activities.length} '
                        '${activities.length == 1 ? "session" : "sessions"}',
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
                KSpace.s3,
                20,
                KSpace.s3 + bottomSafe,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (var i = 0; i < activities.length; i++) ...<Widget>[
                    if (i > 0) const SizedBox(height: 8),
                    KActivityCard(
                      activity: activities[i],
                      onTap: () => _editActivity(context, activities[i]),
                      onCheckTap: () =>
                          plan.toggleDone(date, id: activities[i].id),
                    ),
                  ],
                  const SizedBox(height: KSpace.s3),
                  KButton(
                    label: 'Add session',
                    leading: const Icon(LucideIcons.plus, size: 16),
                    onPressed: () => _addActivity(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editActivity(BuildContext context, Activity activity) {
    showDayDetailSheet(
      context: context,
      date: date,
      existing: activity,
    );
  }

  void _addActivity(BuildContext context) {
    showDayDetailSheet(
      context: context,
      date: date,
      existing: null,
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


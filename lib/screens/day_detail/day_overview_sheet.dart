import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../widgets/k_activity_card.dart';
import '../../widgets/k_type_chip.dart';
import 'day_detail_sheet.dart';

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
    final loc = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final plan = context.watch<PlanController>();
    final activities = plan.activitiesFor(date);
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final primaryType = activities.isNotEmpty ? activities.first.type : null;
    final tc = primaryType != null ? context.typeColor(primaryType) : null;
    final tint = tc?.tint ?? colors.fgPrimary;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgBase,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(22),
        ),
        border: Border(top: BorderSide(color: colors.borderSubtle)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: const Offset(0, -20),
            blurRadius: 40,
            spreadRadius: -12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 8),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: colors.borderStrong,
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: DateFormat.EEEE(localeName).format(date),
                              style: KText.h2.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: colors.fgPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: '.',
                              style: KText.h2.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: tint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat.MMMd(localeName).format(date),
                        style: KText.caption.copyWith(
                          fontSize: 12,
                          color: colors.fgSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (activities.isNotEmpty)
                  KTypeChip(
                    label: loc.sessionsCount(activities.length),
                    tint: tint,
                    bg: tc?.bg ?? colors.bgSubtle,
                  ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                14,
                0,
                14,
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
                      onLongPress: () =>
                          _confirmDelete(context, activities[i]),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _AddSessionButton(onPressed: () => _addActivity(context)),
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

  void _confirmDelete(BuildContext context, Activity activity) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KRadius.md),
        ),
        title: Text(
          loc.deleteSessionTitle,
          style: KText.h3.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colors.fgPrimary,
          ),
        ),
        content: Text(
          loc.deleteSessionBody,
          style: KText.bodySm.copyWith(color: colors.fgSecondary),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              loc.actionCancel,
              style: KText.bodySm.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.fgSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              loc.actionDelete,
              style: KText.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB5443A),
              ),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed != true) return;
      if (!context.mounted) return;
      context.read<PlanController>().delete(date: date, id: activity.id);
    });
  }
}

class _AddSessionButton extends StatelessWidget {
  const _AddSessionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: colors.borderStrong,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.plus, size: 16, color: colors.fgSecondary),
              const SizedBox(width: 6),
              Text(
                loc.addAnotherActivity,
                style: KText.bodySm.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.fgSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

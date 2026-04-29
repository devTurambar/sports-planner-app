import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';
import '../../widgets/k_stat_card.dart';
import '../day_detail/day_detail_sheet.dart';
import '../day_detail/day_overview_sheet.dart';
import '../empty/empty_state_view.dart';
import 'widgets/day_card.dart';

/// Week view — the default home screen.
class WeekView extends StatefulWidget {
  const WeekView({super.key});

  @override
  State<WeekView> createState() => WeekViewState();
}

class WeekViewState extends State<WeekView> {
  DateTime? _cursor;

  /// Reset the visible week to the one containing today. Called from
  /// the parent shell when the user taps the "Today" action.
  void jumpToToday() {
    setState(() => _cursor = null);
  }

  void _shiftWeek(int days) {
    final today = TodayScope.of(context);
    final base = _cursor ?? today;
    setState(() => _cursor = base.add(Duration(days: days)));
  }

  @override
  Widget build(BuildContext context) {
    final today = TodayScope.of(context);
    final plan = context.watch<PlanController>();
    final cursor = _cursor ?? today;
    final week = plan.weekFor(cursor);

    final isCurrentWeek = KDate.isSameDay(
      KDate.mondayOfWeek(cursor),
      KDate.mondayOfWeek(today),
    );

    final countable =
        week.where((a) => a.status != DayStatus.empty).length;
    final done = week.where((a) => a.status == DayStatus.done).length;
    final planned = week
        .where((a) =>
            a.status == DayStatus.planned || a.status == DayStatus.today)
        .length;

    if (isCurrentWeek && countable == 0 && done == 0) {
      // Current week is fully empty — show the empty state.
      return EmptyStateView(
        onAdd: () =>
            showDayDetailSheet(context: context, date: today, existing: null),
      );
    }

    final onTrack = countable == 0
        ? 0
        : ((done / countable) * 100).round().clamp(0, 100);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KSpace.s4,
        4,
        KSpace.s4,
        KSpace.s16,
      ),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        _WeekNav(
          monday: KDate.mondayOfWeek(cursor),
          isCurrent: isCurrentWeek,
          onPrev: () => _shiftWeek(-7),
          onNext: () => _shiftWeek(7),
        ),
        const SizedBox(height: KSpace.s2),
        Row(
          children: <Widget>[
            Expanded(
              child: KStatCard(value: done.toString(), label: 'Done'),
            ),
            const SizedBox(width: KSpace.s2),
            Expanded(
              child:
                  KStatCard(value: planned.toString(), label: 'Planned'),
            ),
            const SizedBox(width: KSpace.s2),
            Expanded(
              child: KStatCard(
                value: '$onTrack%',
                label: 'On track',
                accent: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: KSpace.s3 + 2),
        for (final item in week) ...<Widget>[
          DayCard(
            activity: item,
            extras: plan.extrasFor(item.date),
            onTap: () => _handleRowTap(context, item),
            onCheckTap: () => _handleCheck(context, item),
          ),
          const SizedBox(height: KSpace.s2),
        ],
      ],
    );
  }

  void _handleRowTap(BuildContext context, Activity item) {
    if (item.status == DayStatus.empty) {
      // Empty day: skip the overview, go straight to the add form.
      showDayDetailSheet(context: context, date: item.date, existing: null);
    } else {
      showDayOverviewSheet(context: context, date: item.date);
    }
  }

  void _handleCheck(BuildContext context, Activity item) {
    final plan = context.read<PlanController>();
    switch (item.status) {
      case DayStatus.planned:
      case DayStatus.today:
      case DayStatus.done:
        plan.toggleAllDone(item.date);
        break;
      case DayStatus.empty:
        showDayDetailSheet(
          context: context,
          date: item.date,
          existing: null,
        );
        break;
    }
  }
}

class _WeekNav extends StatelessWidget {
  const _WeekNav({
    required this.monday,
    required this.isCurrent,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime monday;
  final bool isCurrent;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sunday = monday.add(const Duration(days: 6));
    final label = _formatRange(monday, sunday);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Row(
        children: <Widget>[
          _NavButton(icon: LucideIcons.chevronLeft, onPressed: onPrev),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KSpace.s2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    label,
                    style: KText.body.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.fgPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (isCurrent) ...<Widget>[
                    const SizedBox(height: 1),
                    Text(
                      'This week',
                      style: KText.caption.copyWith(
                        fontSize: 10,
                        color: colors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          _NavButton(icon: LucideIcons.chevronRight, onPressed: onNext),
        ],
      ),
    );
  }

  String _formatRange(DateTime monday, DateTime sunday) {
    if (monday.month == sunday.month) {
      return '${monday.shortMonth} ${monday.day} – ${sunday.day}';
    }
    return '${monday.shortMonth} ${monday.day} – '
        '${sunday.shortMonth} ${sunday.day}';
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.bgSubtle,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(icon, size: 16, color: colors.fgSecondary),
        ),
      ),
    );
  }
}

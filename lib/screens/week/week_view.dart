import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../state/theme_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';
import '../day_detail/day_detail_sheet.dart';
import '../day_detail/day_overview_sheet.dart';
import 'widgets/day_card.dart';

class WeekView extends StatefulWidget {
  const WeekView({super.key});

  @override
  State<WeekView> createState() => WeekViewState();
}

class WeekViewState extends State<WeekView> {
  static const _initialPage = 5200;
  late final PageController _pageCtrl =
      PageController(initialPage: _initialPage);
  int _currentPage = _initialPage;

  void jumpToToday() {
    _pageCtrl.animateToPage(
      _initialPage,
      duration: KMotion.base,
      curve: Curves.easeInOut,
    );
  }

  void _shiftWeek(int delta) {
    final target = _currentPage + delta;
    _pageCtrl.animateToPage(
      target,
      duration: KMotion.base,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  DateTime _cursorForPage(int page, DateTime today) {
    final offset = page - _initialPage;
    return today.add(Duration(days: offset * 7));
  }

  @override
  Widget build(BuildContext context) {
    final today = TodayScope.of(context);
    final plan = context.watch<PlanController>();
    final startDay = context.watch<ThemeController>().weekStartDay;

    return PageView.builder(
      controller: _pageCtrl,
      onPageChanged: (page) => setState(() => _currentPage = page),
      itemBuilder: (context, page) {
        final cursor = _cursorForPage(page, today);
        final week = plan.weekFor(cursor, startDay);

        final isCurrentWeek = KDate.isSameDay(
          KDate.startOfWeek(cursor, startDay),
          KDate.startOfWeek(today, startDay),
        );

        var planned = 0;
        var done = 0;
        for (final item in week) {
          for (final a in plan.activitiesFor(item.date)) {
            planned++;
            if (a.status == DayStatus.done) done++;
          }
        }

        final onTrack = planned == 0
            ? 0
            : ((done / planned) * 100).round().clamp(0, 100);

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
              weekStart: KDate.startOfWeek(cursor, startDay),
              isCurrent: isCurrentWeek,
              onPrev: () => _shiftWeek(-1),
              onNext: () => _shiftWeek(1),
            ),
            const SizedBox(height: KSpace.s2),
            _WeekSummaryCard(
              week: week,
              plan: plan,
              done: done,
              planned: planned,
              onTrack: onTrack,
              today: today,
            ),
            const SizedBox(height: KSpace.s3 + 2),
            for (final item in week) ...<Widget>[
              DayCard(
                activity: item,
                extras: plan.extrasFor(item.date),
                secondaryType: _secondaryType(plan, item.date),
                onTap: () => _handleRowTap(context, item),
                onCheckTap: () => _handleCheck(context, item),
                onLongPress: item.status != DayStatus.empty
                    ? () => _confirmClearDay(context, item.date)
                    : null,
              ),
              const SizedBox(height: KSpace.s2),
            ],
          ],
        );
      },
    );
  }

  ActivityType? _secondaryType(PlanController plan, DateTime date) {
    final all = plan.activitiesFor(date);
    if (all.length < 2) return null;
    return all[1].type;
  }

  void _handleRowTap(BuildContext context, Activity item) {
    if (item.status == DayStatus.empty) {
      showDayDetailSheet(context: context, date: item.date, existing: null);
    } else {
      showDayOverviewSheet(context: context, date: item.date);
    }
  }

  void _confirmClearDay(BuildContext context, DateTime date) {
    final plan = context.read<PlanController>();
    final colors = context.colors;
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bgElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KRadius.md),
        ),
        title: Text(
          'Delete all sessions?',
          style: KText.h3.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colors.fgPrimary,
          ),
        ),
        content: Text(
          'Every session on this day will be removed. This can\'t be undone.',
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
      if (confirmed != true || !mounted) return;
      plan.clear(date);
    });
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

class _WeekSummaryCard extends StatelessWidget {
  const _WeekSummaryCard({
    required this.week,
    required this.plan,
    required this.done,
    required this.planned,
    required this.onTrack,
    required this.today,
  });

  final List<Activity> week;
  final PlanController plan;
  final int done;
  final int planned;
  final int onTrack;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(KRadius.lg + 4),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: done.toString(),
                        style: KText.h2.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colors.fgPrimary,
                          height: 1,
                        ),
                      ),
                      TextSpan(
                        text: '/$planned',
                        style: KText.h2.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: colors.fgTertiary,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'sessions done · $onTrack% on track',
                  style: KText.caption.copyWith(
                    fontSize: 11,
                    color: colors.fgSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < week.length; i++) ...[
                if (i > 0) const SizedBox(width: 3),
                _WeekDotCell(
                  activity: week[i],
                  plan: plan,
                  today: today,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekDotCell extends StatelessWidget {
  const _WeekDotCell({
    required this.activity,
    required this.plan,
    required this.today,
  });

  final Activity activity;
  final PlanController plan;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = activity.type;
    final status = activity.status;
    final isToday = KDate.isSameDay(activity.date, today);
    final isEmpty = status == DayStatus.empty;
    final tc = type != null ? context.typeColor(type) : null;
    final tint = tc?.tint ?? colors.fgTertiary;

    final int level;
    if (status == DayStatus.done) {
      level = 4;
    } else if (status == DayStatus.today) {
      level = 2;
    } else if (status == DayStatus.planned) {
      level = 1;
    } else {
      level = 0;
    }

    final all = plan.activitiesFor(activity.date);
    final secondaryType = all.length > 1 ? all[1].type : null;

    final startDay = context.watch<ThemeController>().weekStartDay;
    final dayLabels = startDay == DateTime.sunday
        ? const ['S', 'M', 'T', 'W', 'T', 'F', 'S']
        : const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final dayIndex = (activity.date.weekday - startDay + 7) % 7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isEmpty
                ? colors.bgCard
                : colors.heatLevel(tint, level),
            borderRadius: BorderRadius.circular(4),
            border: isToday
                ? Border.all(color: colors.fgPrimary, width: 1.5)
                : null,
          ),
          child: secondaryType != null
              ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: context.typeColor(secondaryType).tint,
                      borderRadius: BorderRadius.circular(1.5),
                      boxShadow: [
                        BoxShadow(
                          color: colors.bgBase,
                          spreadRadius: 1.5,
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          dayLabels[dayIndex],
          style: KText.caption.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: colors.fgTertiary,
          ),
        ),
      ],
    );
  }
}

class _WeekNav extends StatelessWidget {
  const _WeekNav({
    required this.weekStart,
    required this.isCurrent,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime weekStart;
  final bool isCurrent;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weekEnd = weekStart.add(const Duration(days: 6));
    final label = _formatRange(weekStart, weekEnd);

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
                        color: colors.fgSecondary,
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

  String _formatRange(DateTime start, DateTime end) {
    if (start.month == end.month) {
      return '${start.shortMonth} ${start.day} – ${end.day}';
    }
    return '${start.shortMonth} ${start.day} – '
        '${end.shortMonth} ${end.day}';
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

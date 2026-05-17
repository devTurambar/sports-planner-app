import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/plan_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../utils/date_utils.dart';
import '../day_detail/day_detail_sheet.dart';
import 'widgets/day_cell.dart';
import 'widgets/selected_day_card.dart';

class MonthView extends StatefulWidget {
  const MonthView({super.key});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  static const _initialPage = 5200;
  late final PageController _pageCtrl =
      PageController(initialPage: _initialPage);
  int _currentPage = _initialPage;
  DateTime? _selected;
  final GlobalKey _detailKey = GlobalKey();

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _shiftMonth(int delta) {
    final target = _currentPage + delta;
    _pageCtrl.animateToPage(
      target,
      duration: KMotion.base,
      curve: Curves.easeInOut,
    );
  }

  DateTime _cursorForPage(int page) {
    final today = KDate.startOfDay(DateTime.now());
    final offset = page - _initialPage;
    return DateTime(today.year, today.month + offset);
  }

  void _select(DateTime date) {
    setState(() {
      _selected = _selected != null && KDate.isSameDay(_selected!, date)
          ? null
          : date;
    });
    if (_selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _detailKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: KMotion.base,
            curve: Curves.easeOutCubic,
            alignment: 0.9,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final today = TodayScope.of(context);
    final plan = context.watch<PlanController>();

    return PageView.builder(
      controller: _pageCtrl,
      onPageChanged: (page) => setState(() {
        _currentPage = page;
        _selected = null;
      }),
      itemBuilder: (context, page) {
        final cursor = _cursorForPage(page);
        final firstOfMonth = DateTime(cursor.year, cursor.month);
        final offset = (firstOfMonth.weekday - DateTime.monday) % 7;
        final totalDays = KDate.daysInMonth(cursor.year, cursor.month);

        final cells = <Widget>[
          for (var i = 0; i < offset; i++) const SizedBox.shrink(),
          for (var d = 1; d <= totalDays; d++)
            Builder(builder: (ctx) {
              final date = DateTime(cursor.year, cursor.month, d);
              final activities = plan.activitiesFor(date);
              final primary = plan.forDate(date);
              final effective = KDate.isSameDay(date, today) &&
                      primary.status == DayStatus.empty
                  ? DayStatus.today
                  : primary.status;
              final secondaryType =
                  activities.length > 1 ? activities[1].type : null;
              return MonthDayCell(
                day: d,
                status: effective,
                type: primary.type,
                secondaryType: secondaryType,
                sessionCount: activities.length,
                selected:
                    _selected != null && KDate.isSameDay(_selected!, date),
                onTap: () => _select(date),
              );
            }),
        ];

        var doneCount = 0;
        var plannedCount = 0;
        for (var i = 1; i <= totalDays; i++) {
          final d = DateTime(cursor.year, cursor.month, i);
          for (final a in plan.activitiesFor(d)) {
            plannedCount++;
            if (a.status == DayStatus.done) doneCount++;
          }
        }
        final onTrack = plannedCount == 0
            ? 0
            : ((doneCount / plannedCount) * 100).round().clamp(0, 100);

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            KSpace.s4,
            0,
            KSpace.s4,
            KSpace.s16,
          ),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            _MonthNav(
              cursor: cursor,
              onPrev: () => _shiftMonth(-1),
              onNext: () => _shiftMonth(1),
            ),
            const SizedBox(height: KSpace.s2),
            Row(
              children: <Widget>[
                Expanded(
                  child: _StatTile(
                    value: doneCount.toString(),
                    label: 'Done',
                  ),
                ),
                const SizedBox(width: KSpace.s2),
                Expanded(
                  child: _StatTile(
                    value: plannedCount.toString(),
                    label: 'Planned',
                  ),
                ),
                const SizedBox(width: KSpace.s2),
                Expanded(
                  child: _StatTile(
                    value: '$onTrack%',
                    label: 'On track',
                  ),
                ),
              ],
            ),
            const SizedBox(height: KSpace.s2 + 2),
            _WeekdayHeader(colors: colors),
            const SizedBox(height: 4),
            GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.05,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: cells,
            ),
            if (_selected != null) ...<Widget>[
              const SizedBox(height: KSpace.s3 + 2),
              KeyedSubtree(
                key: _detailKey,
                child: _AnimatedDetail(
                  child: SelectedDayCard(
                    date: _selected!,
                    activities: plan.activitiesFor(_selected!),
                    onClose: () => setState(() => _selected = null),
                    onEditActivity: (activity) => showDayDetailSheet(
                      context: context,
                      date: _selected!,
                      existing: activity,
                    ),
                    onToggleActivity: (activity) =>
                        plan.toggleDone(_selected!, id: activity.id),
                    onAdd: () => showDayDetailSheet(
                      context: context,
                      date: _selected!,
                      existing: null,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: KText.h2.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colors.fgPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: KText.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: colors.fgTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthNav extends StatelessWidget {
  const _MonthNav({
    required this.cursor,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime cursor;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Row(
        children: <Widget>[
          _NavButton(icon: LucideIcons.chevronLeft, onPressed: onPrev),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KSpace.s2),
              child: Text(
                '${cursor.fullMonth} ${cursor.year}',
                style: KText.body.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.fgPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          _NavButton(icon: LucideIcons.chevronRight, onPressed: onNext),
        ],
      ),
    );
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

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.colors});

  final KadenceColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(KDate.minWeekdays.length, (i) {
        final isWeekend = i >= 5;
        return Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                KDate.minWeekdays[i],
                style: KText.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isWeekend ? colors.fgDisabled : colors.fgTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _AnimatedDetail extends StatefulWidget {
  const _AnimatedDetail({required this.child});

  final Widget child;

  @override
  State<_AnimatedDetail> createState() => _AnimatedDetailState();
}

class _AnimatedDetailState extends State<_AnimatedDetail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: KMotion.base,
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic)),
        child: widget.child,
      ),
    );
  }
}

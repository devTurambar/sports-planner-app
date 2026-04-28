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
import 'widgets/day_cell.dart';
import 'widgets/selected_day_card.dart';

/// Month view — a 7-column grid with day-status indicators, plus stats
/// and a selectable detail card below.
class MonthView extends StatefulWidget {
  const MonthView({super.key});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  late DateTime _cursor;
  DateTime? _selected;
  final ScrollController _scroll = ScrollController();
  final GlobalKey _detailKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final today = KDate.startOfDay(DateTime.now());
    _cursor = DateTime(today.year, today.month);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _shiftMonth(int delta) {
    setState(() {
      _cursor = DateTime(_cursor.year, _cursor.month + delta);
      _selected = null;
    });
  }

  void _select(DateTime date) {
    setState(() {
      _selected = _selected != null && KDate.isSameDay(_selected!, date)
          ? null
          : date;
    });
    if (_selected != null) {
      // After layout, scroll the detail card into view.
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

    // Build the grid: (monday-index offset) leading blanks, then 1..n.
    final firstOfMonth = DateTime(_cursor.year, _cursor.month);
    final offset = (firstOfMonth.weekday - DateTime.monday) % 7;
    final totalDays = KDate.daysInMonth(_cursor.year, _cursor.month);

    final cells = <Widget>[
      for (var i = 0; i < offset; i++) const SizedBox.shrink(),
      for (var d = 1; d <= totalDays; d++)
        Builder(builder: (ctx) {
          final date = DateTime(_cursor.year, _cursor.month, d);
          final activity = plan.forDate(date);
          // An empty day that happens to be today should still visually
          // anchor the grid, so promote it to the `today` status.
          final effective = KDate.isSameDay(date, today) &&
                  activity.status == DayStatus.empty
              ? DayStatus.today
              : activity.status;
          return MonthDayCell(
            day: d,
            status: effective,
            selected:
                _selected != null && KDate.isSameDay(_selected!, date),
            onTap: () => _select(date),
          );
        }),
    ];

    final monthStatuses = List<DayStatus>.generate(totalDays, (i) {
      final d = DateTime(_cursor.year, _cursor.month, i + 1);
      return plan.forDate(d).status;
    });
    final doneCount =
        monthStatuses.where((s) => s == DayStatus.done).length;
    final plannedCount = monthStatuses
        .where((s) => s == DayStatus.planned || s == DayStatus.today)
        .length;
    final restCount =
        monthStatuses.where((s) => s == DayStatus.rest).length;

    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(
        KSpace.s4,
        0,
        KSpace.s4,
        KSpace.s16,
      ),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        _MonthNav(
          cursor: _cursor,
          onPrev: () => _shiftMonth(-1),
          onNext: () => _shiftMonth(1),
        ),
        const SizedBox(height: KSpace.s2),
        Row(
          children: <Widget>[
            Expanded(
              child: KStatCard(
                value: doneCount.toString(),
                label: 'Done',
                accent: true,
              ),
            ),
            const SizedBox(width: KSpace.s1 + 2),
            Expanded(
              child: KStatCard(
                value: plannedCount.toString(),
                label: 'Planned',
              ),
            ),
            const SizedBox(width: KSpace.s1 + 2),
            Expanded(
              child: KStatCard(value: restCount.toString(), label: 'Rest'),
            ),
          ],
        ),
        const SizedBox(height: KSpace.s2 + 2),
        _WeekdayHeader(colors: colors),
        const SizedBox(height: 4),
        GridView.count(
          crossAxisCount: 7,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
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
                activity: plan.forDate(_selected!),
                onClose: () => setState(() => _selected = null),
                onEdit: () => showDayDetailSheet(
                  context: context,
                  date: _selected!,
                  existing: plan.forDate(_selected!),
                ),
                onAdd: () => showDayDetailSheet(
                  context: context,
                  date: _selected!,
                  existing: null,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: KSpace.s3),
        _Legend(),
      ],
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

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final items = <Widget>[
      _LegendItem(
        label: 'Done',
        icon: _ShapeDot(color: colors.accent),
      ),
      _LegendItem(
        label: 'Planned',
        icon: _ShapeDot(color: colors.fgTertiary, filled: false),
      ),
      _LegendItem(
        label: 'Today',
        icon: Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: colors.accent,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
      _LegendItem(
        label: 'Rest',
        icon: Container(
          width: 11,
          height: 2,
          decoration: BoxDecoration(
            color: colors.fgDisabled,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: items,
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.icon});

  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon,
        const SizedBox(width: 5),
        Text(
          label,
          style: KText.caption.copyWith(fontSize: 10, color: colors.fgSecondary),
        ),
      ],
    );
  }
}

class _ShapeDot extends StatelessWidget {
  const _ShapeDot({required this.color, this.filled = true});

  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : Colors.transparent,
        border: filled ? null : Border.all(color: color, width: 1.5),
      ),
    );
  }
}

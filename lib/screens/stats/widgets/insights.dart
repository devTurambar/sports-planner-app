import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class Insights extends StatelessWidget {
  const Insights({required this.data, required this.startDay, super.key});

  final StatsData data;
  final int startDay;

  @override
  Widget build(BuildContext context) {
    final insights = _generate();

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return ProStatCard(
      title: 'Insights',
      child: Column(
        children: [
          for (var i = 0; i < insights.length; i++) ...[
            _InsightRow(insight: insights[i]),
            if (i < insights.length - 1) const SizedBox(height: KSpace.s3),
          ],
        ],
      ),
    );
  }

  List<_Insight> _generate() {
    final insights = <_Insight>[];
    final done = data.allDone;
    if (done.isEmpty) return insights;

    // 1. Favorite day of week
    final dayCounts = List<int>.filled(7, 0);
    for (final a in done) {
      final idx = startDay == DateTime.sunday
          ? (a.date.weekday % 7)
          : (a.date.weekday - 1);
      dayCounts[idx]++;
    }
    final maxDayCount = dayCounts.fold<int>(0, (m, v) => v > m ? v : m);
    if (maxDayCount > 2) {
      final bestIdx = dayCounts.indexOf(maxDayCount);
      final dayName = startDay == DateTime.sunday
          ? ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][bestIdx]
          : KDate.fullWeekdays[bestIdx];
      insights.add(_Insight(
        icon: LucideIcons.calendar,
        text: 'You train most on ${dayName}s — $maxDayCount sessions total.',
        color: _InsightColor.blue,
      ));
    }

    // 2. Current month vs avg
    final now = DateTime.now();
    final thisMonthDone = done
        .where((a) => a.date.year == now.year && a.date.month == now.month)
        .length;
    final monthCounts = <String, int>{};
    for (final a in done) {
      final key = '${a.date.year}-${a.date.month}';
      monthCounts[key] = (monthCounts[key] ?? 0) + 1;
    }
    if (monthCounts.length > 1) {
      final avg = monthCounts.values.fold<int>(0, (s, v) => s + v) /
          monthCounts.length;
      if (thisMonthDone > avg * 1.2) {
        insights.add(_Insight(
          icon: LucideIcons.trendingUp,
          text:
              'This month is ${((thisMonthDone / avg - 1) * 100).round()}% above your average. Keep it up!',
          color: _InsightColor.green,
        ));
      } else if (thisMonthDone < avg * 0.5 && now.day > 15) {
        insights.add(_Insight(
          icon: LucideIcons.trendingDown,
          text: 'This month is quieter than usual. Still time to catch up!',
          color: _InsightColor.amber,
        ));
      }
    }

    // 3. Variety insight
    final recentDone = done
        .where((a) =>
            a.date.isAfter(now.subtract(const Duration(days: 30))) &&
            a.type != null)
        .toList();
    final recentTypeLabels = recentDone.map((a) => a.typeLabel).toSet();
    if (recentTypeLabels.length >= 4) {
      insights.add(_Insight(
        icon: LucideIcons.shuffle,
        text:
            'Great variety! You did ${recentTypeLabels.length} different activities in the last 30 days.',
        color: _InsightColor.purple,
      ));
    } else if (recentTypeLabels.length == 1 && done.length > 5) {
      insights.add(_Insight(
        icon: LucideIcons.repeat,
        text:
            'You\'ve been focused on ${recentTypeLabels.first} lately. Try mixing it up!',
        color: _InsightColor.coral,
      ));
    }

    // 4. Streak encouragement
    if (data.currentStreak > 0) {
      if (data.currentStreak >= 4) {
        insights.add(_Insight(
          icon: LucideIcons.flame,
          text:
              '${data.currentStreak}-week streak! That\'s serious consistency.',
          color: _InsightColor.coral,
        ));
      } else if (data.currentStreak == 1) {
        insights.add(_Insight(
          icon: LucideIcons.sparkles,
          text: 'New streak started! Keep it going this week.',
          color: _InsightColor.amber,
        ));
      }
    }

    // 5. Best month ever
    if (monthCounts.isNotEmpty) {
      final currentKey = '${now.year}-${now.month}';
      final bestMonth =
          monthCounts.entries.reduce((a, b) => a.value >= b.value ? a : b);
      if (bestMonth.key == currentKey && thisMonthDone > 0 && now.day > 7) {
        insights.add(_Insight(
          icon: LucideIcons.trophy,
          text: 'Best month ever with $thisMonthDone sessions so far!',
          color: _InsightColor.green,
        ));
      }
    }

    return insights.take(4).toList();
  }
}

enum _InsightColor { coral, blue, green, purple, amber }

class _Insight {
  const _Insight({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final _InsightColor color;
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight});

  final _Insight insight;

  Color _tint(KadenceColors colors) {
    switch (insight.color) {
      case _InsightColor.coral:
        return colors.typeRun.tint;
      case _InsightColor.blue:
        return colors.typeCycle.tint;
      case _InsightColor.green:
        return colors.typeWalk.tint;
      case _InsightColor.purple:
        return colors.typeYoga.tint;
      case _InsightColor.amber:
        return colors.typeOther.tint;
    }
  }

  Color _bg(KadenceColors colors) {
    switch (insight.color) {
      case _InsightColor.coral:
        return colors.typeRun.bg;
      case _InsightColor.blue:
        return colors.typeCycle.bg;
      case _InsightColor.green:
        return colors.typeWalk.bg;
      case _InsightColor.purple:
        return colors.typeYoga.bg;
      case _InsightColor.amber:
        return colors.typeOther.bg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _bg(colors),
            borderRadius: BorderRadius.circular(KRadius.sm),
          ),
          child: Icon(insight.icon, size: 16, color: _tint(colors)),
        ),
        const SizedBox(width: KSpace.s3),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              insight.text,
              style: KText.bodySm.copyWith(
                color: colors.fgSecondary,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

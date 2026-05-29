import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class PersonalRecords extends StatelessWidget {
  const PersonalRecords({required this.data, super.key});

  final StatsData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final records = _compute();

    return ProStatCard(
      title: loc.statsPersonalRecordsTitle,
      subtitle: loc.statsAllTime,
      child: Row(
        children: [
          Expanded(
            child: _RecordTile(
              icon: LucideIcons.flame,
              iconColor: colors.typeRun.tint,
              value: '${records.longestStreak}',
              suffix: loc.statsWeekSuffix,
              label: loc.statsBestStreak,
            ),
          ),
          const SizedBox(width: KSpace.s2),
          Expanded(
            child: _RecordTile(
              icon: LucideIcons.trophy,
              iconColor: colors.typeOther.tint,
              value: '${records.busiestWeek}',
              label: loc.statsBestWeek,
            ),
          ),
          const SizedBox(width: KSpace.s2),
          Expanded(
            child: _RecordTile(
              icon: LucideIcons.zap,
              iconColor: colors.typeYoga.tint,
              value: '${records.busiestDay}',
              label: loc.statsBestDay,
            ),
          ),
        ],
      ),
    );
  }

  _Records _compute() {
    final done = data.allDone;
    if (done.isEmpty) {
      return const _Records(longestStreak: 0, busiestWeek: 0, busiestDay: 0);
    }

    // Longest streak (consecutive weeks with at least 1 done session)
    final weekCounts = <String, int>{};
    for (final a in done) {
      final ws = KDate.startOfWeek(a.date, DateTime.monday);
      final key = KDate.keyFor(ws);
      weekCounts[key] = (weekCounts[key] ?? 0) + 1;
    }
    final sortedWeeks = weekCounts.keys.toList()..sort();
    var longestStreak = 0;
    var current = 0;
    DateTime? prev;
    for (final key in sortedWeeks) {
      final date = DateTime.parse(key);
      if (prev != null && date.difference(prev).inDays == 7) {
        current++;
      } else {
        current = 1;
      }
      if (current > longestStreak) longestStreak = current;
      prev = date;
    }

    // Busiest week
    final busiestWeek =
        weekCounts.values.fold<int>(0, (m, v) => v > m ? v : m);

    // Busiest day
    final dayCounts = <String, int>{};
    for (final a in done) {
      final key = KDate.keyFor(a.date);
      dayCounts[key] = (dayCounts[key] ?? 0) + 1;
    }
    final busiestDay =
        dayCounts.values.fold<int>(0, (m, v) => v > m ? v : m);

    return _Records(
      longestStreak: longestStreak,
      busiestWeek: busiestWeek,
      busiestDay: busiestDay,
    );
  }
}

class _Records {
  const _Records({
    required this.longestStreak,
    required this.busiestWeek,
    required this.busiestDay,
  });

  final int longestStreak;
  final int busiestWeek;
  final int busiestDay;
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.suffix,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(KSpace.s3),
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        borderRadius: BorderRadius.circular(KRadius.md),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: value,
                style: KText.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.fgPrimary,
                ),
              ),
              if (suffix != null)
                TextSpan(
                  text: ' $suffix',
                  style: KText.caption.copyWith(
                    color: colors.fgTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: KText.caption.copyWith(
              fontSize: 10,
              color: colors.fgTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

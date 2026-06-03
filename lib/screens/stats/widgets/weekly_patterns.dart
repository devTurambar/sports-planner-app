import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class WeeklyPatterns extends StatelessWidget {
  const WeeklyPatterns({
    required this.data,
    required this.startDay,
    super.key,
  });

  final StatsData data;
  final int startDay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final patterns = _compute(loc);
    final narrowFmt = DateFormat('EEEEE', localeName);
    final monday = DateTime(2024, 1, 1);
    final labels = List<String>.generate(7, (i) {
      final weekday = (startDay - 1 + i) % 7 + 1;
      final offset = (weekday - DateTime.monday + 7) % 7;
      return narrowFmt.format(monday.add(Duration(days: offset))).toUpperCase();
    });

    if (patterns.isEmpty) {
      return ProStatCard(
        title: loc.statsWeeklyPatternsTitle,
        subtitle: loc.statsWhenYouDo,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: KSpace.s3),
            child: Text(
              loc.statsNoDataYet,
              style: KText.bodySm.copyWith(color: colors.fgTertiary),
            ),
          ),
        ),
      );
    }

    return ProStatCard(
      title: loc.statsWeeklyPatternsTitle,
      subtitle: loc.statsWhenYouDo,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 52),
              ...List.generate(7, (i) => Expanded(
                child: Center(
                  child: Text(
                    labels[i],
                    style: KText.caption.copyWith(
                      fontSize: 9,
                      color: colors.fgTertiary,
                    ),
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 6),
          for (final p in patterns) ...[
            _PatternRow(
              pattern: p,
              startDay: startDay,
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }

  List<_TypePattern> _compute(AppLocalizations loc) {
    final typeMap = <(ActivityType, String?), List<int>>{};
    final labels = <(ActivityType, String?), String>{};

    for (final a in data.allDone) {
      if (a.type == null) continue;
      final key = (a.type!, a.type == ActivityType.other ? a.subType : null);
      typeMap.putIfAbsent(key, () => List<int>.filled(7, 0));
      labels[key] = a.type == ActivityType.other && a.subType != null
          ? localizedSubType(a.subType!, loc)
          : a.type!.localized(loc);
      final dayIndex = startDay == DateTime.sunday
          ? (a.date.weekday % 7)
          : (a.date.weekday - 1);
      typeMap[key]![dayIndex]++;
    }

    final patterns = typeMap.entries.map((e) {
      final total = e.value.fold<int>(0, (s, v) => s + v);
      return _TypePattern(
          type: e.key.$1, label: labels[e.key]!, counts: e.value, total: total);
    }).toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    return patterns.take(6).toList();
  }
}

class _TypePattern {
  const _TypePattern({
    required this.type,
    required this.label,
    required this.counts,
    required this.total,
  });

  final ActivityType type;
  final String label;
  final List<int> counts;
  final int total;
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({
    required this.pattern,
    required this.startDay,
  });

  final _TypePattern pattern;
  final int startDay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tc = context.typeColor(pattern.type);
    final max = pattern.counts.fold<int>(0, (m, v) => v > m ? v : m);

    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            pattern.label,
            style: KText.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colors.fgSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        ...List.generate(7, (i) {
          final count = pattern.counts[i];
          final intensity = max == 0 ? 0.0 : count / max;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                height: 18,
                decoration: BoxDecoration(
                  color: count == 0
                      ? colors.fgTertiary.withValues(alpha: 0.06)
                      : tc.tint.withValues(alpha: 0.15 + intensity * 0.85),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

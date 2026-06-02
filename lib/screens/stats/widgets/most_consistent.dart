import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/activity.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class MostConsistent extends StatelessWidget {
  const MostConsistent({required this.data, super.key});

  final StatsData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final rankings = _compute(loc);

    if (rankings.isEmpty) {
      return ProStatCard(
        title: loc.statsMostConsistentTitle,
        subtitle: loc.statsCompletionByType,
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
      title: loc.statsMostConsistentTitle,
      subtitle: loc.statsCompletionByType,
      child: Column(
        children: [
          for (var i = 0; i < rankings.length; i++) ...[
            _ConsistencyRow(
              rank: i + 1,
              entry: rankings[i],
            ),
            if (i < rankings.length - 1) const SizedBox(height: KSpace.s2),
          ],
        ],
      ),
    );
  }

  List<_ConsistencyEntry> _compute(AppLocalizations loc) {
    final all = data.allActivities
        .where((a) => a.status != DayStatus.empty && a.type != null);

    final planned = <(ActivityType, String?), int>{};
    final done = <(ActivityType, String?), int>{};
    final labels = <(ActivityType, String?), String>{};

    for (final a in all) {
      final key = (a.type!, a.type == ActivityType.other ? a.subType : null);
      planned[key] = (planned[key] ?? 0) + 1;
      labels[key] = a.type == ActivityType.other && a.subType != null
          ? localizedSubType(a.subType!, loc)
          : a.type!.localized(loc);
      if (a.status == DayStatus.done) {
        done[key] = (done[key] ?? 0) + 1;
      }
    }

    final entries = planned.entries.map((e) {
      final d = done[e.key] ?? 0;
      return _ConsistencyEntry(
        type: e.key.$1,
        label: labels[e.key]!,
        planned: e.value,
        done: d,
        rate: e.value == 0 ? 0.0 : d / e.value,
      );
    }).toList()
      ..sort((a, b) => b.rate.compareTo(a.rate));

    return entries.take(5).toList();
  }
}

class _ConsistencyEntry {
  const _ConsistencyEntry({
    required this.type,
    required this.label,
    required this.planned,
    required this.done,
    required this.rate,
  });

  final ActivityType type;
  final String label;
  final int planned;
  final int done;
  final double rate;
}

class _ConsistencyRow extends StatelessWidget {
  const _ConsistencyRow({
    required this.rank,
    required this.entry,
  });

  final int rank;
  final _ConsistencyEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tc = context.typeColor(entry.type);
    final pct = (entry.rate * 100).round();

    return Row(
      children: [
        SizedBox(
          width: 18,
          child: Text(
            '$rank',
            style: KText.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: rank == 1 ? colors.accent : colors.fgTertiary,
            ),
          ),
        ),
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: tc.tint,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(
          width: 56,
          child: Text(
            entry.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KText.bodySm.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.fgPrimary,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: entry.rate,
              minHeight: 6,
              backgroundColor: colors.bgSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(tc.tint),
            ),
          ),
        ),
        const SizedBox(width: KSpace.s2),
        SizedBox(
          width: 40,
          child: Text(
            '$pct%',
            textAlign: TextAlign.right,
            style: KText.bodySm.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.fgPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

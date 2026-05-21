import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import 'package:provider/provider.dart';

import '../../../models/activity.dart';
import '../../../state/type_color_controller.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/k_type_tile.dart';
import '../stats_data.dart';
import 'pro_stat_card.dart';

class ShareableRecap extends StatelessWidget {
  const ShareableRecap({required this.data, super.key});

  final StatsData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ProStatCard(
      title: 'Share your progress',
      child: Column(
        children: [
          Text(
            'Generate a summary card and share it with friends.',
            style: KText.bodySm.copyWith(color: colors.fgTertiary),
          ),
          const SizedBox(height: KSpace.s4),
          Row(
            children: [
              Expanded(
                child: _ShareButton(
                  label: 'This month',
                  icon: LucideIcons.calendar,
                  onTap: () => _shareMonthly(context),
                ),
              ),
              const SizedBox(width: KSpace.s3),
              Expanded(
                child: _ShareButton(
                  label: 'This year',
                  icon: LucideIcons.trophy,
                  onTap: () => _shareYearly(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareMonthly(BuildContext context) {
    final now = DateTime.now();
    final monthDone = data.allDone
        .where((a) => a.date.year == now.year && a.date.month == now.month)
        .toList();
    final types = monthDone.map((a) => a.type).where((t) => t != null).toSet();
    final activeDays =
        monthDone.map((a) => KDate.keyFor(a.date)).toSet().length;

    final topType = _topType(monthDone);
    final headline = _monthHeadline(monthDone.length, activeDays);

    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final dayCells = <_MiniCell>[];
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(now.year, now.month, d);
      if (date.isAfter(now)) break;
      final dayDone = monthDone.where((a) => KDate.isSameDay(a.date, date));
      dayCells.add(_MiniCell(
        type: dayDone.isNotEmpty ? dayDone.first.type : null,
        isDone: dayDone.isNotEmpty,
      ));
    }

    _showPreview(
      context,
      period: '${now.fullMonth} ${now.year}',
      headline: headline,
      topType: topType,
      stats: [
        _RecapStat('Sessions', '${monthDone.length}', LucideIcons.activity),
        _RecapStat('Active days', '$activeDays', LucideIcons.calendarCheck),
        _RecapStat('Activities', '${types.length}', LucideIcons.shapes),
      ],
      dayCells: dayCells,
      streak: null,
    );
  }

  void _shareYearly(BuildContext context) {
    final year = DateTime.now().year;
    final now = DateTime.now();
    final yearDone =
        data.allDone.where((a) => a.date.year == year).toList();
    final activeDays =
        yearDone.map((a) => KDate.keyFor(a.date)).toSet().length;
    final types = yearDone.map((a) => a.type).where((t) => t != null).toSet();
    final topType = _topType(yearDone);

    final doneByDate = <String, ActivityType?>{};
    for (final a in yearDone) {
      doneByDate[KDate.keyFor(a.date)] = a.type;
    }

    final dayCells = <_MiniCell>[];
    var date = DateTime(year, 1, 1);
    while (date.year == year && !date.isAfter(now)) {
      final key = KDate.keyFor(date);
      final done = doneByDate.containsKey(key);
      dayCells.add(_MiniCell(
        type: done ? doneByDate[key] : null,
        isDone: done,
      ));
      date = date.add(const Duration(days: 1));
    }

    final headline = _yearHeadline(yearDone.length, data.currentStreak);

    _showPreview(
      context,
      period: '$year Year in Review',
      headline: headline,
      topType: topType,
      stats: [
        _RecapStat('Sessions', '${yearDone.length}', LucideIcons.activity),
        _RecapStat('Active days', '$activeDays', LucideIcons.calendarCheck),
        _RecapStat('Activities', '${types.length}', LucideIcons.shapes),
        _RecapStat('Avg/wk', data.avgPerWeek.toStringAsFixed(1), LucideIcons.trendingUp),
      ],
      dayCells: dayCells,
      streak: data.currentStreak > 0 ? data.currentStreak : null,
    );
  }

  ActivityType? _topType(List<Activity> done) {
    if (done.isEmpty) return null;
    final counts = <ActivityType, int>{};
    for (final a in done) {
      if (a.type != null) counts[a.type!] = (counts[a.type!] ?? 0) + 1;
    }
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  String _monthHeadline(int sessions, int activeDays) {
    if (sessions == 0) return 'Getting started!';
    if (sessions >= 20) return 'Unstoppable month!';
    if (sessions >= 12) return 'Crushing it!';
    if (activeDays >= 15) return 'Incredible consistency!';
    if (sessions >= 6) return 'Strong month!';
    return 'Building momentum!';
  }

  String _yearHeadline(int sessions, int streak) {
    if (sessions == 0) return 'The journey begins!';
    if (sessions >= 200) return 'Legendary year!';
    if (sessions >= 100) return 'Triple digits!';
    if (streak >= 10) return 'Streak machine!';
    if (sessions >= 50) return 'Half a hundred!';
    if (sessions >= 20) return 'Going strong!';
    return 'Building the habit!';
  }

  void _showPreview(
    BuildContext context, {
    required String period,
    required String headline,
    required ActivityType? topType,
    required List<_RecapStat> stats,
    required List<_MiniCell> dayCells,
    required int? streak,
  }) {
    final colors = context.colors;
    final accent = context.read<TypeColorController>().accentTint(colors);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: colors.scrim,
      isScrollControlled: true,
      builder: (_) => _RecapPreviewSheet(
        period: period,
        headline: headline,
        topType: topType,
        stats: stats,
        dayCells: dayCells,
        streak: streak,
        accent: accent,
      ),
    );
  }
}

class _RecapStat {
  const _RecapStat(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

class _MiniCell {
  const _MiniCell({this.type, required this.isDone});

  final ActivityType? type;
  final bool isDone;
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: KSpace.s3,
            horizontal: KSpace.s3,
          ),
          decoration: BoxDecoration(
            color: colors.bgSubtle,
            borderRadius: BorderRadius.circular(KRadius.lg),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                label,
                style: KText.bodySm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.fgPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecapPreviewSheet extends StatefulWidget {
  const _RecapPreviewSheet({
    required this.period,
    required this.headline,
    required this.topType,
    required this.stats,
    required this.dayCells,
    required this.streak,
    required this.accent,
  });

  final String period;
  final String headline;
  final ActivityType? topType;
  final List<_RecapStat> stats;
  final List<_MiniCell> dayCells;
  final int? streak;
  final Color accent;

  @override
  State<_RecapPreviewSheet> createState() => _RecapPreviewSheetState();
}

class _RecapPreviewSheetState extends State<_RecapPreviewSheet> {
  final _repaintKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      await Share.shareXFiles([
        XFile.fromData(
          bytes,
          mimeType: 'image/png',
          name: 'kadence-recap.png',
        ),
      ]);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Preview',
              style: KText.h3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.fgPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RepaintBoundary(
              key: _repaintKey,
              child: _RecapCard(
                period: widget.period,
                headline: widget.headline,
                topType: widget.topType,
                stats: widget.stats,
                dayCells: widget.dayCells,
                streak: widget.streak,
                accent: widget.accent,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, KSpace.s4, 20, KSpace.s4 + bottomSafe),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: widget.accent,
                borderRadius: BorderRadius.circular(KRadius.lg),
                child: InkWell(
                  onTap: _sharing ? null : _share,
                  borderRadius: BorderRadius.circular(KRadius.lg),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_sharing)
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.accentFg,
                            ),
                          )
                        else ...[
                          Icon(
                            LucideIcons.share2,
                            size: 18,
                            color: colors.accentFg,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Share',
                            style: KText.button.copyWith(
                              color: colors.accentFg,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecapCard extends StatelessWidget {
  const _RecapCard({
    required this.period,
    required this.headline,
    required this.topType,
    required this.stats,
    required this.dayCells,
    required this.streak,
    required this.accent,
  });

  final String period;
  final String headline;
  final ActivityType? topType;
  final List<_RecapStat> stats;
  final List<_MiniCell> dayCells;
  final int? streak;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.bgBase,
        borderRadius: BorderRadius.circular(KRadius.xl),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        children: [
          // Header with gradient accent band
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent,
                  accent.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kadence',
                      style: KText.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.accentFg,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (streak != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(KRadius.full),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.flame,
                              size: 14,
                              color: colors.accentFg,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$streak wk',
                              style: KText.caption.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colors.accentFg,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  headline,
                  style: KText.h2.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: colors.accentFg,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  period,
                  style: KText.bodySm.copyWith(
                    color: colors.accentFg.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top activity badge
                if (topType != null) ...[
                  _TopActivityBadge(type: topType!),
                  const SizedBox(height: 14),
                ],

                // Stats grid
                _StatsGrid(stats: stats, accent: accent),

                // Mini heatmap strip
                if (dayCells.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _MiniHeatmap(cells: dayCells, accent: accent),
                ],

                const SizedBox(height: 14),

                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: KSpace.s3,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(KRadius.full),
                  ),
                  child: Text(
                    'kadence.app',
                    style: KText.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopActivityBadge extends StatelessWidget {
  const _TopActivityBadge({required this.type});

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tc = context.typeColor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Color.lerp(colors.bgCard, tc.tint, 0.1),
        borderRadius: BorderRadius.circular(KRadius.full),
        border: Border.all(color: tc.tint.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(KTypeTile.iconFor(type), size: 16, color: tc.tint),
          const SizedBox(width: 8),
          Text(
            'Top activity: ${type.label}',
            style: KText.bodySm.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.fgPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats, required this.accent});

  final List<_RecapStat> stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = stats.length <= 3 ? 3 : 2;
        final gap = 8.0;
        final cellWidth = (constraints.maxWidth - (cols - 1) * gap) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats.map((s) {
            return SizedBox(
              width: cellWidth,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: colors.bgCard,
                  borderRadius: BorderRadius.circular(KRadius.md),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Column(
                  children: [
                    Icon(s.icon, size: 16, color: accent),
                    const SizedBox(height: 6),
                    Text(
                      s.value,
                      style: KText.h2.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: colors.fgPrimary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.label,
                      style: KText.caption.copyWith(
                        fontSize: 10,
                        color: colors.fgTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _MiniHeatmap extends StatelessWidget {
  const _MiniHeatmap({required this.cells, required this.accent});

  final List<_MiniCell> cells;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isYear = cells.length > 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity',
          style: KText.caption.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: colors.fgTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        if (isYear)
          _YearGrid(cells: cells, accent: accent)
        else
          _MonthRow(cells: cells, accent: accent),
      ],
    );
  }
}

class _MonthRow extends StatelessWidget {
  const _MonthRow({required this.cells, required this.accent});

  final List<_MiniCell> cells;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = cells.length;
        const gap = 3.0;
        final size = ((constraints.maxWidth - (count - 1) * gap) / count)
            .clamp(4.0, 14.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < cells.length; i++) ...[
              if (i > 0) const SizedBox(width: gap),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: _cellColor(context, colors, cells[i], accent),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _YearGrid extends StatelessWidget {
  const _YearGrid({required this.cells, required this.accent});

  final List<_MiniCell> cells;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const rows = 7;
    final cols = (cells.length / rows).ceil();
    const gap = 2.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = ((constraints.maxWidth - (cols - 1) * gap) / cols)
            .clamp(3.0, 8.0);
        final gridHeight = rows * size + (rows - 1) * gap;

        return SizedBox(
          height: gridHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var col = 0; col < cols; col++) ...[
                if (col > 0) const SizedBox(width: gap),
                Column(
                  children: [
                    for (var row = 0; row < rows; row++) ...[
                      if (row > 0) const SizedBox(height: gap),
                      () {
                        final idx = col * rows + row;
                        return Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color: idx < cells.length
                                ? _cellColor(context, colors, cells[idx], accent)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        );
                      }(),
                    ],
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

Color _cellColor(BuildContext context, KadenceColors colors, _MiniCell cell, Color accent) {
  if (cell.isDone) {
    return cell.type != null
        ? context.typeColor(cell.type!).tint
        : accent;
  }
  return colors.fgTertiary.withValues(alpha: 0.08);
}

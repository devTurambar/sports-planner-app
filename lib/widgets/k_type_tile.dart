import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/activity.dart';
import '../theme/kadence_colors.dart';

class KTypeTile extends StatelessWidget {
  const KTypeTile({
    super.key,
    required this.type,
    this.size = 38,
    this.iconSize = 18,
  });

  final ActivityType type;
  final double size;
  final double iconSize;

  static IconData iconFor(ActivityType type) {
    switch (type) {
      case ActivityType.run:
        return LucideIcons.personStanding;
      case ActivityType.trailRun:
        return LucideIcons.mountain;
      case ActivityType.hike:
        return LucideIcons.treeDeciduous;
      case ActivityType.walk:
        return LucideIcons.footprints;
      case ActivityType.cycle:
        return LucideIcons.bike;
      case ActivityType.mtb:
        return LucideIcons.bike;
      case ActivityType.swim:
        return LucideIcons.waves;
      case ActivityType.gym:
        return LucideIcons.dumbbell;
      case ActivityType.yoga:
        return LucideIcons.accessibility;
      case ActivityType.hiit:
        return LucideIcons.timer;
      case ActivityType.row:
        return LucideIcons.ship;
      case ActivityType.ski:
        return LucideIcons.snowflake;
      case ActivityType.surf:
        return LucideIcons.wind;
      case ActivityType.climb:
        return LucideIcons.triangleAlert;
      case ActivityType.tennis:
        return LucideIcons.circle;
      case ActivityType.padel:
        return LucideIcons.circle;
      case ActivityType.dance:
        return LucideIcons.music;
      case ActivityType.elliptical:
        return LucideIcons.activity;
      case ActivityType.other:
        return LucideIcons.zap;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tc = context.typeColor(type);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color.lerp(context.colors.bgCard, tc.tint, 0.14),
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(
          color: tc.tint.withValues(alpha: 0.22),
        ),
      ),
      child: Icon(iconFor(type), size: iconSize, color: tc.tint),
    );
  }
}

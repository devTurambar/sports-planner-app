import 'package:flutter/foundation.dart';

/// The planning status of a given day.
///
/// A day is always in exactly one state. `today` is a convenience flag used
/// by the week view — it means "active day not yet done" and lives
/// alongside `planned` to highlight where the user currently stands.
enum DayStatus { empty, planned, today, done }

/// Sport / activity category. The values match the design bundle's pills
/// so copy stays aligned end-to-end.
enum ActivityType { run, cycle, gym, yoga, swim, walk, other }

extension ActivityTypeLabel on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.run:
        return 'Run';
      case ActivityType.cycle:
        return 'Cycle';
      case ActivityType.gym:
        return 'Gym';
      case ActivityType.yoga:
        return 'Yoga';
      case ActivityType.swim:
        return 'Swim';
      case ActivityType.walk:
        return 'Walk';
      case ActivityType.other:
        return 'Other';
    }
  }
}

/// A single session planned for a specific date.
@immutable
class Activity {
  const Activity({
    required this.id,
    required this.date,
    required this.status,
    this.name,
    this.type,
    this.duration,
    this.intensity,
    this.notes,
  });

  final String id;
  final DateTime date;
  final DayStatus status;
  final String? name;
  final ActivityType? type;
  final String? duration;
  final String? intensity;
  final String? notes;

  /// Meta string shown in the week card: "45 min · Zone 2".
  String? get meta {
    final parts = <String>[
      if (duration != null && duration!.isNotEmpty) duration!,
      if (intensity != null && intensity!.isNotEmpty) intensity!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  Activity copyWith({
    DayStatus? status,
    String? name,
    ActivityType? type,
    String? duration,
    String? intensity,
    String? notes,
  }) {
    return Activity(
      id: id,
      date: date,
      status: status ?? this.status,
      name: name ?? this.name,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      notes: notes ?? this.notes,
    );
  }
}

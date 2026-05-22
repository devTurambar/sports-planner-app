import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/activity.dart';
import '../utils/date_utils.dart';

class BackupService {
  BackupService._();

  static const _version = 1;

  static Future<void> exportData(
    Map<String, List<Activity>> byDate,
  ) async {
    final activities = <Map<String, Object?>>[];
    for (final entry in byDate.entries) {
      for (final a in entry.value) {
        activities.add(_activityToJson(a));
      }
    }

    final json = jsonEncode({
      'version': _version,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'activities': activities,
    });

    final dir = await getTemporaryDirectory();
    final date = KDate.keyFor(DateTime.now());
    final file = File(p.join(dir.path, 'kadence-backup-$date.json'));
    await file.writeAsString(json);

    await Share.shareXFiles([XFile(file.path)]);
  }

  static Future<List<Activity>?> pickAndParse() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    final content = await File(path).readAsString();
    return parseBackup(content);
  }

  @visibleForTesting
  static List<Activity> parseBackup(String content) {
    final data = jsonDecode(content) as Map<String, dynamic>;

    if (data['version'] is! int) {
      throw const FormatException('Missing or invalid version field');
    }
    if (data['activities'] is! List) {
      throw const FormatException('Missing or invalid activities field');
    }

    final list = data['activities'] as List;
    return list.map((e) => _activityFromJson(e as Map<String, dynamic>)).toList();
  }

  static List<Activity> reassignIds(List<Activity> activities) {
    final rng = Random();
    final prefix = 'i${DateTime.now().millisecondsSinceEpoch}'
        '${rng.nextInt(9000) + 1000}';
    return [
      for (var i = 0; i < activities.length; i++)
        Activity(
          id: '${prefix}_$i',
          date: activities[i].date,
          status: activities[i].status,
          name: activities[i].name,
          type: activities[i].type,
          duration: activities[i].duration,
          timeOfDay: activities[i].timeOfDay,
          notes: activities[i].notes,
        ),
    ];
  }

  static Map<String, List<Activity>> groupByDate(List<Activity> activities) {
    final map = <String, List<Activity>>{};
    for (final a in activities) {
      map.putIfAbsent(KDate.keyFor(a.date), () => <Activity>[]).add(a);
    }
    return map;
  }

  static Map<String, Object?> _activityToJson(Activity a) => {
        'id': a.id,
        'date': KDate.keyFor(a.date),
        'status': a.status.name,
        'name': a.name,
        'type': a.type?.name,
        'sub_type': a.subType,
        'duration': a.duration,
        'time_of_day': a.timeOfDay,
        'notes': a.notes,
      };

  static Activity _activityFromJson(Map<String, dynamic> json) {
    final dateParts = (json['date'] as String).split('-');
    return Activity(
      id: json['id'] as String,
      date: DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      ),
      status: DayStatus.values.byName(json['status'] as String),
      name: json['name'] as String?,
      type: json['type'] != null
          ? ActivityType.values.byName(json['type'] as String)
          : null,
      subType: json['sub_type'] as String?,
      duration: json['duration'] as String?,
      timeOfDay: json['time_of_day'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

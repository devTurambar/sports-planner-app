import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/activity.dart';
import '../utils/date_utils.dart';

class ActivityDb {
  ActivityDb._();

  static Database? _db;

  static bool get _isSupported => !kIsWeb;

  static Future<Database> _open() async {
    if (_db != null) return _db!;
    final dbPath = join(await getDatabasesPath(), 'kadence.db');
    _db = await openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE activities (
            id TEXT PRIMARY KEY,
            date TEXT NOT NULL,
            status TEXT NOT NULL,
            name TEXT,
            type TEXT,
            duration TEXT,
            time_of_day TEXT,
            notes TEXT,
            calendar_event_id TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE activities ADD COLUMN calendar_event_id TEXT',
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE activities ADD COLUMN time_of_day TEXT',
          );
        }
      },
    );
    return _db!;
  }

  static Future<bool> isEmpty() async {
    if (!_isSupported) return true;
    final db = await _open();
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM activities');
    return (result.first['c'] as int) == 0;
  }

  static Future<Map<String, List<Activity>>> loadAll() async {
    if (!_isSupported) return {};
    final db = await _open();
    final rows = await db.query('activities', orderBy: 'date, rowid');
    final map = <String, List<Activity>>{};
    for (final row in rows) {
      final activity = _fromRow(row);
      final key = KDate.keyFor(activity.date);
      map.putIfAbsent(key, () => <Activity>[]).add(activity);
    }
    return map;
  }

  static Future<void> upsert(Activity a) async {
    if (!_isSupported) return;
    final db = await _open();
    await db.insert(
      'activities',
      _toRow(a),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> upsertAll(List<Activity> activities) async {
    if (!_isSupported) return;
    final db = await _open();
    final batch = db.batch();
    for (final a in activities) {
      batch.insert('activities', _toRow(a),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> deleteById(String id) async {
    if (!_isSupported) return;
    final db = await _open();
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteByDate(String dateKey) async {
    if (!_isSupported) return;
    final db = await _open();
    await db.delete('activities', where: 'date = ?', whereArgs: [dateKey]);
  }

  static Future<void> deleteAll() async {
    if (!_isSupported) return;
    final db = await _open();
    await db.delete('activities');
  }

  // ── row mapping ───────────────────────────────────────────────────────

  static Map<String, Object?> _toRow(Activity a) => {
        'id': a.id,
        'date': KDate.keyFor(a.date),
        'status': a.status.name,
        'name': a.name,
        'type': a.type?.name,
        'duration': a.duration,
        'time_of_day': a.timeOfDay,
        'notes': a.notes,
        'calendar_event_id': a.calendarEventId,
      };

  static Activity _fromRow(Map<String, Object?> row) {
    final dateParts = (row['date'] as String).split('-');
    return Activity(
      id: row['id'] as String,
      date: DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      ),
      status: DayStatus.values.byName(row['status'] as String),
      name: row['name'] as String?,
      type: row['type'] != null
          ? ActivityType.values.byName(row['type'] as String)
          : null,
      duration: row['duration'] as String?,
      timeOfDay: row['time_of_day'] as String?,
      notes: row['notes'] as String?,
      calendarEventId: row['calendar_event_id'] as String?,
    );
  }
}

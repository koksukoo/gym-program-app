import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'gym.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE programs(id TEXT PRIMARY KEY, name TEXT, cycles INTEGER, programDays TEXT); ');
        return db.execute('CREATE TABLE sessions(id TEXT PRIMARY KEY, date TEXT, duration INTEGER, programDayId TEXT, programId TEXT, completedExerciseIds TEXT); ');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.db();
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.db();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.db();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}

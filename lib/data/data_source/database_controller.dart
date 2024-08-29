import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
  static Database? _database;
  Future<Database> getDatabase({required tableName}) async {
    if (_database != null) return _database!;
    String dbName = 'items.db';
    String path = await getDatabasesPath();
    // const String path = '/Users/bs00849/Desktop/Dev/db';
    _database = await initDatabase(path, dbName, tableName);
    return _database!;
  }

  Future<Database> initDatabase(
    String path,
    String dbName,
    String tableName,
  ) async {
    return await openDatabase(
      join(path, dbName),
      onCreate: (db, version) async {
        try {
          await db.execute('''
          CREATE TABLE "$tableName" (
            "id" INTEGER PRIMARY KEY,
            "name" TEXT,
            "price" INTEGER,
            "date" TEXT
          )
        ''');
        } catch (e) {
          print('Error creating table: $e');
        }
      },
      version: 1,
    );
  }
}

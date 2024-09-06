import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> openDataBase(
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

  Future<List<Map<String, Object?>>> readData(
    Database database,
    String reportFormat,
  ) async {
    return await database.rawQuery('''
      SELECT 
        strftime('$reportFormat', date) AS date,
        SUM(price) AS price
      FROM 
        items
      GROUP BY 
        strftime('$reportFormat', date);
    ''');
  }

  Future<int> insertData(
    String item,
    int cost,
    DateTime date,
    String tableName,
    Database database,
  ) async {
    return await database.insert(tableName, {
      'name': item,
      'price': cost,
      'date': date.toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>?> getAllData(
    Database database,
  ) async {
    return await database.rawQuery('''
      SELECT 
        name, price, date
      FROM 
        items
    ''');
  }

  Future<void> createTable(
    List<String> fields,
    String tableName,
    Database databse,
  ) async {
    await databse.execute(
      '''
    CREATE TABLE IF NOT EXISTS $tableName(
      ${fields[0]} INTEGER PRIMARY KEY,
      ${fields[1]} TEXT,
      ${fields[2]} INTEGER,
      ${fields[3]} TEXT
    )
    ''',
    );
  }

  Future<void> dropTable(String tableName, Database database) async {
    await database.execute('DROP TABLE IF EXISTS $tableName');
  }
}

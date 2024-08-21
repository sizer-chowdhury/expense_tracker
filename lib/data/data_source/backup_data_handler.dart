import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class BackupDataHandler {
  Future<void> getBackupData() async {
    String path = await getDatabasesPath();
    // const String path = '/Users/bs00849/Desktop/Dev/db';
    const String dbName = 'items.db';
    const String tableName = 'items';
    Database database;
    try {
      database = await DatabaseService().openDataBase(path, dbName, tableName);
      late List<Map<String, dynamic>>? results;

      results = await DatabaseService().getAllData(database);
      if (results != null) {
        File? file = await writeJsonData(results);
        print(file?.path);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> restoreBackupData() async {
    String path = await getDatabasesPath();
    // const String path = '/Users/bs00849/Desktop/Dev/db';
    const String dbName = 'items.db';
    const String tableName = 'items';
    Database database;

    List<dynamic>? data = await readJsonData();
    // print('Read data: $data');
    try {
      database = await DatabaseService().openDataBase(
        path,
        dbName,
        tableName,
      );
      DatabaseService().dropTable(tableName, database);
      DatabaseService().createTable(
        ['id', 'name', 'price', 'date'],
        tableName,
        database,
      );
      print(data?.length);
      for (Map<String, dynamic> jsonData in data!) {
        await DatabaseService().insertData(
          jsonData['Item'],
          jsonData['Cost'],
          DateTime.parse(jsonData['Date']),
          tableName,
          database,
        );
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<File> writeJsonData(List<Map<String, dynamic>> data) async {
    final file = await _getLocalFile('data.json');
    String jsonData = jsonEncode(data);
    return file.writeAsString(jsonData);
  }

  Future<List<dynamic>?> readJsonData() async {
    try {
      final file = await _getLocalFile('data.json');
      String jsonData = await file.readAsString();
      return jsonDecode(jsonData);
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }
}

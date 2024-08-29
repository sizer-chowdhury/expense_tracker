import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_controller.dart';
import 'database_service.dart';

class BackupDataHandler {
  static String? vpath;
  Future<void> getBackupData() async {
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );
      late List<Map<String, dynamic>>? results;

      results = await DatabaseService().getAllData(database);
      if (results != null) {
        File? file = await writeJsonData(results);
        vpath = file.path;
        print(file.path);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> restoreBackupData() async {
    Database database = await DatabaseController().getDatabase(
      tableName: 'items',
    );
    List<dynamic>? data = await readJsonData();

    try {
      DatabaseService().dropTable('items', database);
      DatabaseService().createTable(
        ['id', 'name', 'price', 'date'],
        'items',
        database,
      );
      print(data?.length);
      for (Map<String, dynamic> jsonData in data!) {
        await DatabaseService().insertData(
          jsonData['Item'],
          jsonData['Cost'],
          DateTime.parse(jsonData['Date']),
          'items',
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

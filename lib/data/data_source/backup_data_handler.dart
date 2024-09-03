import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/data/data_source/backup/google_drive_auth.dart';
import 'package:expense_tracker/data/data_source/backup/download_from_google_drive.dart';
import 'package:expense_tracker/data/data_source/backup/upload_to_google_drive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'database_controller.dart';
import 'database_service.dart';

class BackupDataHandler {
  static String? filePath;
  Future<String?> getBackupData() async {
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );
      late List<Map<String, dynamic>>? results;

      results = await DatabaseService().getAllData(database);
      String? res;
      if (results != null) {
        File? file = await writeJsonData(results);
        print(file.path);
        res = await UploadGoogleDrive().uploadFileToGoogleDrive(file);
      }
      return res;
    } on Exception catch (e) {
      print('in backup handler: ${e.toString()}');
      return e.toString();
    }
  }

  Future<String?> restoreBackupData() async {
    Database database = await DatabaseController().getDatabase(
      tableName: 'items',
    );
    String? responseError =
        await DownloadFromGoogleDrive().downloadFileFromGoogleDrive();
    if (responseError != null) return responseError;
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
      return null;
    } on Exception catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<File> writeJsonData(List<Map<String, dynamic>> data) async {
    final file = await _getLocalFile('data.json');
    String jsonData = jsonEncode(data);
    return file.writeAsString(jsonData);
  }

  Future<List<dynamic>?> readJsonData() async {
    try {
      final file = await _getLocalFile('downloaded_data.json');
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

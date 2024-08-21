import 'package:sqflite/sqflite.dart';

import '../model/item_model.dart';
import 'database_service.dart';

class GenerateReportDataSource {
  Future<(List<ItemModel>?, String?)> readDailyItems() async {
    String path = await getDatabasesPath();
    // const String path = '/Users/bs00849/Desktop/Dev/db';
    const String dbName = 'items.db';
    const String reportFormat = '%Y-%m-%d';
    const String tableName = 'items';
    Database database;
    try {
      database = await DatabaseService().openDataBase(path, dbName, tableName);

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);

      List<ItemModel> itemList = [];
      for (var data in results) {
        if (data['day'] != null && data['total_price'] != null) {
          itemList.add(ItemModel.fromJson(data));
        }
      }
      await database.close();
      return (itemList, null);
    } on Exception catch (e) {
      print('Error on read data');
      return (null, e.toString());
    }
  }

  Future<(List<ItemModel>?, String?)> readMonthlyItems() async {
    String path = await getDatabasesPath();
    // const String path = '/Users/bs00849/Desktop/Dev/db';
    const String dbName = 'items.db';
    const String reportFormat = '%Y-%m';
    const String tableName = 'items';

    Database database;
    try {
      database = await DatabaseService().openDataBase(path, dbName, tableName);

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);
      List<ItemModel> list = [];
      // for (var data in results) {
      //   list.add(ItemModel.fromJson(data));
      // }
      for (Map<String, dynamic>? data in results) {
        if (data != null) {
          list.add(ItemModel.fromJson(data));
        }
      }
      await database.close();
      return (list, null);
    } on Exception catch (e) {
      print('Error on monthly data');
      return (null, e.toString());
    }
  }

  Future<(List<ItemModel>?, String?)> readYearlyItems() async {
    String path = await getDatabasesPath();
    // const String path = '/Users/bs00849/Desktop/Dev/db';
    const String dbName = 'items.db';
    const String reportFormat = '%Y';
    const String tableName = 'items';

    Database database;
    try {
      database = await DatabaseService().openDataBase(path, dbName, tableName);

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);
      List<ItemModel> list = [];
      for (var data in results) {
        list.add(ItemModel.fromJson(data));
      }
      await database.close();
      return (list, null);
    } on Exception catch (e) {
      print('Error on yearly data');
      return (null, e.toString());
    }
  }
}

import 'package:expense_tracker/data/data_source/database_controller.dart';
import 'package:sqflite/sqflite.dart';

import '../model/item_model.dart';
import 'database_service.dart';

class GenerateReportDataSource {
  Future<(List<ItemModel>?, String?)> readDailyItems() async {
    const String reportFormat = '%Y-%m-%d';
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );
      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);

      List<ItemModel> itemList = [];
      for (var data in results) {
        if (data['day'] != null && data['total_price'] != null) {
          itemList.add(ItemModel.fromJson(data));
        }
      }
      return (itemList, null);
    } on Exception catch (e) {
      return (null, e.toString());
    }
  }

  Future<(List<ItemModel>?, String?)> readMonthlyItems() async {
    const String reportFormat = '%Y-%m';
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);
      List<ItemModel> list = [];
      for (Map<String, dynamic>? data in results) {
        if (data != null) {
          list.add(ItemModel.fromJson(data));
        }
      }
      return (list, null);
    } on Exception catch (e) {
      return (null, e.toString());
    }
  }

  Future<(List<ItemModel>?, String?)> readYearlyItems() async {
    const String reportFormat = '%Y';
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);
      List<ItemModel> list = [];
      for (var data in results) {
        list.add(ItemModel.fromJson(data));
      }

      return (list, null);
    } on Exception catch (e) {
      return (null, e.toString());
    }
  }
}

import 'package:expense_tracker/data/data_source/database_controller.dart';
import 'package:sqflite/sqflite.dart';

import '../model/expense_details_model.dart';
import 'database_service.dart';

class GenerateReportDataSource {
  Future<(List<ExpenseDetailsModel>?, String?)> readDailyItems() async {
    const String reportFormat = '%Y-%m-%d';
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );
      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);

      List<ExpenseDetailsModel> itemList = [];

      for (var data in results) {
        if (data['date'] != null && data['price'] != null) {
          itemList.add(ExpenseDetailsModel.summary(data));
        }
      }
      return (itemList, null);
    } on Exception catch (e) {
      return (null, e.toString());
    }
  }

  Future<(List<ExpenseDetailsModel>?, String?)> readMonthlyItems() async {
    const String reportFormat = '%Y-%m';
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);
      List<ExpenseDetailsModel> list = [];
      for (Map<String, dynamic>? data in results) {
        if (data != null) {
          list.add(ExpenseDetailsModel.summary(data));
        }
      }
      return (list, null);
    } on Exception catch (e) {
      return (null, e.toString());
    }
  }

  Future<(List<ExpenseDetailsModel>?, String?)> readYearlyItems() async {
    const String reportFormat = '%Y';
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, reportFormat);
      List<ExpenseDetailsModel> list = [];
      for (var data in results) {
        list.add(ExpenseDetailsModel.summary(data));
      }

      return (list, null);
    } on Exception catch (e) {
      return (null, e.toString());
    }
  }
}

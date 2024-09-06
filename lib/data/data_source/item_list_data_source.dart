import 'package:expense_tracker/data/data_source/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../model/expense_details_model.dart';
import 'database_controller.dart';

class ItemListDataSource {
  Future<(List<ExpenseDetailsModel>?, String?)> readItems() async {
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, '%Y-%m-%d');
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

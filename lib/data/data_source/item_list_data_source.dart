import 'package:expense_tracker/data/data_source/database_service.dart';
import 'package:expense_tracker/data/model/item_model.dart';
import 'package:sqflite/sqflite.dart';

import 'database_controller.dart';

class ItemListDataSource {
  Future<(List<ItemModel>?, String?)> readItems() async {
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );

      late List<Map<String, dynamic>> results;

      results = await DatabaseService().readData(database, '%Y-%m-%d');
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

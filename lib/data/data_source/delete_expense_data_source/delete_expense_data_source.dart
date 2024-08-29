import 'package:expense_tracker/data/data_source/fetch_expense_data_source/fetch_expense_database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../database_controller.dart';

class DeleteExpenseDataSource {
  Future<void> deleteItem(int id) async {
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );
      await database.delete(
        'items',
        where: 'id = ?',
        whereArgs: [id],
      );
    } on Exception catch (e) {
      print('Error deleting item: $e');
    }
  }
}

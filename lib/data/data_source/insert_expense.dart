import 'package:sqflite/sqflite.dart';

import 'database_controller.dart';
import 'database_service.dart';

class InsertExpense {
  Future<String?> insertNewExpense(
    String description,
    int price,
    DateTime date,
  ) async {
    try {
      Database database = await DatabaseController().getDatabase(
        tableName: 'items',
      );
      await DatabaseService().insertData(
        description,
        price,
        date,
        'items',
        database,
      );
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }
}

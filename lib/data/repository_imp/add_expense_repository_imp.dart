import 'package:dartz/dartz.dart';
import 'package:expense_tracker/data/data_source/insert_expense.dart';
import '../../domain/repository/add_new_expense_repository.dart';

class AddExpenseRepositoryImp implements AddNewExpenseRepository {
  @override
  Future<Either<String, String>> addNewExpense(
      String description,
      int price,
      DateTime date,
      ) async {
    try {
      InsertExpense insertExpense = InsertExpense();
      await insertExpense.insertNewExpense(description, price, date);
      return Right('Expense added successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }
}

import 'package:dartz/dartz.dart';

abstract class AddNewExpenseRepository {
  Future<Either<String, String>> addNewExpense(String description, int price, DateTime dateTime);
}

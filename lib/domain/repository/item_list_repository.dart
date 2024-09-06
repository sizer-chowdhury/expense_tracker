import '../entity/expense_details_entity.dart';

abstract class ItemListRepository {
  Future<(List<ExpenseDetailsEntity>?, String?)> readItems();
}

import '../../domain/entity/expense_details_entity.dart';
import '../../domain/repository/item_list_repository.dart';
import '../data_source/item_list_data_source.dart';

class ItemListRepositoryImp implements ItemListRepository {
  @override
  Future<(List<ExpenseDetailsEntity>?, String?)> readItems() async {
    ItemListDataSource itemListDataSource = ItemListDataSource();
    return await itemListDataSource.readItems();
  }
}

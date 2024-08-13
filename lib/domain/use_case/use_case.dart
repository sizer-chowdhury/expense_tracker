import 'package:expense_tracker/config/service_locator.dart';
import 'package:expense_tracker/domain/entity/item_entity.dart';
import 'package:expense_tracker/domain/repository/repository.dart';

class UseCase {
  Future<(List<ItemEntity>?, String?)> readItems() {
    return sl<Repository>().readItems();
  }
}
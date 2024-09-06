import 'package:expense_tracker/domain/entity/expense_details_entity.dart';
import 'package:flutter/material.dart';

class ItemListInheritedWidge extends InheritedWidget {
  ItemListInheritedWidge({
    super.key,
    required super.child,
    required this.itemList,
  });
  List<ExpenseDetailsEntity> itemList;

  static ItemListInheritedWidge? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ItemListInheritedWidge>();
  }

  @override
  bool updateShouldNotify(ItemListInheritedWidge oldWidget) {
    return oldWidget.itemList != itemList;
  }
}

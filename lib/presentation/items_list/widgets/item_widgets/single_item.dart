import 'dart:math';

import 'package:expense_tracker/core/application/theme/colors.dart';
import 'package:expense_tracker/presentation/dashboard/bloc/graph_bloc/graph_bloc.dart';
import 'package:expense_tracker/presentation/items_list/page/item_list_page.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entity/expense_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';
import '../../../item_details/page/expense_details.dart';

class SingleItem extends StatelessWidget {
  final List<Color> colorArray = [
    MyColors.primaryDeep.withAlpha(100),
    MyColors.primaryDeep.withAlpha(140),
    MyColors.primaryDeep.withAlpha(170),
    MyColors.primaryDeep.withAlpha(200),
    MyColors.primaryDeep.withAlpha(210),
    MyColors.primaryDeep.withAlpha(240),
    MyColors.primaryDeep.withAlpha(255),
  ];

  SingleItem({
    super.key,
    required this.item,
    required this.graphBloc,
  });

  final ExpenseDetailsEntity? item;
  final GraphBloc graphBloc;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: MyColors.surfaceLight,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: _myListTile(context),
    );
  }

  ListTile _myListTile(BuildContext context) {
    Color randomColor = colorArray[Random().nextInt(colorArray.length)];

    return ListTile(
      contentPadding: const EdgeInsets.all(5),
      leading: _leadingIcon(context, randomColor),
      title: _itemTittle(context),
      subtitle: Text(
        'Total expense \$${item?.price}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      trailing: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: randomColor,
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: MyColors.tertiary),
        ),
        child: Center(
          child: Text(
            '${item?.price}\$',
            style: TextStyle(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
      onTap: () {
        context.push(
          '/${ItemListPage.path}/${ExpenseDetailsPage.path}/${item?.date}',
          extra: graphBloc,
        );
      },
    );
  }

  Container _leadingIcon(BuildContext context, Color randomColor) {
    return Container(
      height: 80,
      width: 60,
      decoration: BoxDecoration(
        color: randomColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.account_balance_wallet,
        // color: Theme.of(context).colorScheme.surface,
        color: MyColors.surface,
      ),
    );
  }

  Text _itemTittle(BuildContext context) {
    final String today = DateTime.now().formattedDate();
    String currentDay = formatDateString(item!.date);
    return Text(
      (currentDay == today) ? 'Today' : formatDateString(item!.date),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        // color: Theme.of(context).colorScheme.primary,
        color: MyColors.darkLight,
      ),
    );
  }

  String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('d MMM, yyyy').format(dateTime);
    return formattedDate;
  }
}

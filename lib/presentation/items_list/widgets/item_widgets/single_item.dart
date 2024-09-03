import 'dart:math';

import 'package:expense_tracker/core/application/theme/colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entity/item_entity.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import '../../../item_details/page/expense_details.dart';

class SingleItem extends StatelessWidget {
  final List<Color> colorArray = [
    MyColors.primary,
    MyColors.secondary,
    MyColors.tertiary,
    MyColors.darkLight,
    MyColors.dark,
  ];
  SingleItem({
    super.key,
    required this.item,
  });

  final ItemEntity? item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
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
      trailing: IconButton(
        onPressed: () {
          context.go(
              "/${ExpenseDetailsPage.path}/${item?.date}?source=secondPage");
        },
        icon: const Icon(
          Icons.arrow_forward_ios,
        ),
        // color: Theme.of(context).colorScheme.primary,
        color: randomColor,
      ),
      onTap: () {},
    );
  }

  Container _leadingIcon(BuildContext context, Color randomColor) {
    return Container(
      height: 100,
      width: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Theme.of(context).colorScheme.primary.withOpacity(1),
            // Theme.of(context).colorScheme.primary.withOpacity(.7),
            randomColor.withOpacity(1),
            randomColor.withOpacity(.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
    String currentDay = item!.date;
    return Text(
      (currentDay == today) ? 'Today' : item!.date,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          // color: Theme.of(context).colorScheme.primary,
          color: MyColors.darkLight),
    );
  }
}

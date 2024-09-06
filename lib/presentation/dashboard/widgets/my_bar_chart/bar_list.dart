import 'package:expense_tracker/presentation/dashboard/bloc/graph_bloc/graph_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/expense_details_entity.dart';
import '../../page/dashboard.dart';
import 'single_bar.dart';

class BarList extends StatelessWidget {
  const BarList({
    super.key,
    required this.items,
    required this.graphType,
    required this.graphBloc,
  });
  final List<ExpenseDetailsEntity> items;
  final GraphType graphType;
  final GraphBloc graphBloc;

  @override
  Widget build(BuildContext context) {
    List<Widget> barList = [];
    double mx = 0;
    for (int i = 0; i < items.length; i++) {
      if (items[i].price > mx) mx = items[i].price.toDouble();
    }
    barList.add(const SizedBox(width: 20));
    for (int i = items.length - 1; i >= 0; i--) {
      barList.add(SingleBar(
        singleEntity: items[i],
        graphType: graphType,
        graphBloc: graphBloc,
        mx: mx,
      ));
      barList.add(const SizedBox(width: 20));
    }
    barList.add(const SizedBox(width: 20));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: barList,
      ),
    );
  }
}

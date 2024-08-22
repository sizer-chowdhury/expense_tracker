import 'package:flutter/material.dart';
import '../../../../domain/entity/item_entity.dart';
import '../../page/dashboard.dart';
import 'line_graph_painter.dart';

class LineGraph extends StatelessWidget {
  const LineGraph({
    super.key,
    required this.items,
    required this.graphType,
  });

  final List<ItemEntity> items;
  final GraphType graphType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(top: 15,bottom: 5,left: 15),
        child: CustomPaint(
          size: Size(items.length * 200.0, 200),
          painter: LineGraphPainter(items, graphType),
        ),
      ),
    );
  }
}

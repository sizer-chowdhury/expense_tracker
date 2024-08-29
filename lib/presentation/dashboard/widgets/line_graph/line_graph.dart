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
        padding: const EdgeInsets.only(top: 15, bottom: 5, left: 15),
        child: items.isEmpty
            ? SizedBox(
                height: 200,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Text(
                    'No data available to view',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : CustomPaint(
                size:
                    Size((items.length < 2 ? 400 : items.length * 200.0), 200),
                painter: LineGraphPainter(items, graphType),
              ),
      ),
    );
  }
}

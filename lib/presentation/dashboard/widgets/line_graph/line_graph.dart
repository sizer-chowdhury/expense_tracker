import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/application/theme/colors.dart';
import '../../../../domain/entity/item_entity.dart';
import '../../page/dashboard.dart';
import 'package:intl/intl.dart';

class LineGraph extends StatefulWidget {
  const LineGraph({
    super.key,
    required this.items,
    required this.graphType,
  });

  final List<ItemEntity> items;
  final GraphType graphType;

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  DateTime _parseDate(String dateString) {
    switch (widget.graphType) {
      case GraphType.daily:
        return DateTime.parse(dateString);
      case GraphType.monthly:
        final parts = dateString.split('-');
        return DateTime(int.parse(parts[0]), int.parse(parts[1]));
      case GraphType.yearly:
        return DateTime(int.parse(dateString));
      default:
        throw const FormatException('Invalid graph type or date format.');
    }
  }

  String _formatXValue(double value) {
    int index = value.toInt() - 1;
    if (index < 0 || index >= widget.items.length) {
      return '';
    }

    ItemEntity item = widget.items[index];
    DateTime date = _parseDate(item.date);

    switch (widget.graphType) {
      case GraphType.daily:
        return DateFormat('d MMM').format(date);
      case GraphType.monthly:
        return DateFormat('MMM yyyy').format(date);
      case GraphType.yearly:
        return DateFormat('yyyy').format(date);
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> flSpots = widget.items.asMap().entries.map((entry) {
      int index = entry.key + 1;
      ItemEntity item = entry.value;
      double yValue = item.price.toDouble();

      return FlSpot(index.toDouble(), yValue);
    }).toList();
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 35, bottom: 15, left: 30, right: 30),
        child: widget.items.isEmpty
            ? SizedBox(
                height: screenWidth * .45,
                width: screenWidth * .9,
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Text(
                    'No data available to view',
                    style: TextStyle(
                      // color: Theme.of(context).colorScheme.secondary,
                      color: MyColors.surface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: screenWidth * .45,
                width: screenWidth * .9,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: flSpots,
                        isCurved: true,
                        belowBarData: BarAreaData(
                          show: true,
                          // color: Theme.of(context).colorScheme.secondary,
                          color: MyColors.tertiary,
                        ),
                      ),
                    ],
                    // minY: 0,
                    gridData: const FlGridData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false, reservedSize: 20),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 15,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              _formatXValue(value),
                              style: TextStyle(
                                // color: Theme.of(context).colorScheme.secondary,
                                color: MyColors.surface,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

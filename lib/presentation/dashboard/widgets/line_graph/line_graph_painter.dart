import 'package:flutter/material.dart';
import '../../../../domain/entity/item_entity.dart';
import '../../page/dashboard.dart';

class LineGraphPainter extends CustomPainter {
  final List<ItemEntity> items;
  final GraphType graphType;

  LineGraphPainter(this.items, this.graphType);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    if (items.isEmpty) return;

    final double maxPrice =
        items.map((e) => e.price.toDouble()).reduce((a, b) => a > b ? a : b);
    final double minPrice =
        items.map((e) => e.price.toDouble()).reduce((a, b) => a < b ? a : b);

    if (maxPrice == minPrice) {
      final double y = size.height / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }

    final double graphWidth = size.width;
    final double graphHeight = size.height;
    final double xStep = graphWidth / (items.length - 1) * 0.2;
    final double yScale = graphHeight / (maxPrice - minPrice);

    for (int i = 0; i < items.length; i++) {
      final double x = i * xStep;
      final double y =
          graphHeight - (items[i].price.toDouble() - minPrice) * yScale;

      if (x.isNaN || y.isNaN) continue;

      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
    }

    canvas.drawPath(linePath, paint);
    _drawAxes(canvas, size);
  }

  void _drawAxes(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), axisPaint);
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

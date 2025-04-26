// lib/core/widgets/cyber_grid_painter.dart

import 'package:flutter/material.dart';

class CyberGridPainter extends CustomPainter {
  final Color color;
  final double gridSpacing;
  final double lineWidth;

  CyberGridPainter({
    required this.color,
    this.gridSpacing = 20,
    this.lineWidth = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CyberGridPainter oldDelegate) =>
      color != oldDelegate.color ||
      gridSpacing != oldDelegate.gridSpacing ||
      lineWidth != oldDelegate.lineWidth;
}
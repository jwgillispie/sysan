// Path: lib/core/widgets/cyber_grid.dart
import 'package:flutter/material.dart';

class CyberGrid extends StatelessWidget {
  final Widget? child;
  final Color? gridColor;
  final double gridSpacing;
  final double lineWidth;

  const CyberGrid({
    super.key,
    this.child,
    this.gridColor,
    this.gridSpacing = 20,
    this.lineWidth = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final color = gridColor ?? Theme.of(context).colorScheme.primary.withOpacity(0.05);
    
    return Stack(
      children: [
        CustomPaint(
          painter: _CyberGridPainter(
            color: color,
            gridSpacing: gridSpacing,
            lineWidth: lineWidth,
          ),
          child: Container(),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class _CyberGridPainter extends CustomPainter {
  final Color color;
  final double gridSpacing;
  final double lineWidth;

  _CyberGridPainter({
    required this.color,
    required this.gridSpacing,
    required this.lineWidth,
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
  bool shouldRepaint(_CyberGridPainter oldDelegate) =>
      color != oldDelegate.color ||
      gridSpacing != oldDelegate.gridSpacing ||
      lineWidth != oldDelegate.lineWidth;
}
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBorderContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Duration duration;
  final double lightSize;
  final Color lightColor;
  final EdgeInsets margin;

  const AnimatedBorderContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.borderColor = Colors.blue,
    this.borderWidth = 2.0,
    this.borderRadius = 16.0,
    this.duration = const Duration(seconds: 2),
    this.lightSize = 4.0,
    this.lightColor = Colors.white,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  State<AnimatedBorderContainer> createState() => _AnimatedBorderContainerState();
}

class _AnimatedBorderContainerState extends State<AnimatedBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: Colors.black,
      ),
      child: CustomPaint(
        foregroundPainter: BorderLightPainter(
          animation: _controller,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          borderRadius: widget.borderRadius,
          lightSize: widget.lightSize,
          lightColor: widget.lightColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.borderWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius - widget.borderWidth),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
class BorderLightPainter extends CustomPainter {
  final Animation<double> animation;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double lightSize;
  final Color lightColor;

  BorderLightPainter({
    required this.animation,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.lightSize,
    required this.lightColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final rect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    // Draw the border
    canvas.drawRRect(rrect, paint);

    // Calculate the position of the light
    final path = Path();
    path.addRRect(rrect);
    final PathMetric pathMetric = path.computeMetrics().first;
    
    final length = pathMetric.length;
    final position = animation.value * length;
    
    final Tangent? tangent = pathMetric.getTangentForOffset(position);

    if (tangent != null) {
      // Draw the glowing light
      final lightPaint = Paint()
        ..color = lightColor
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(tangent.position, lightSize, lightPaint);

      // Add extra glow effect
      final glowPaint = Paint()
        ..color = lightColor.withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(tangent.position, lightSize * 1.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(BorderLightPainter oldDelegate) => true;
}

class CyberGridPainter extends CustomPainter {
  final Color color;

  CyberGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CyberGridPainter oldDelegate) => false;
}
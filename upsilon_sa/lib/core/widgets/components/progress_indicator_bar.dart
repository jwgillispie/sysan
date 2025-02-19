// Path: lib/core/widgets/components/progress_indicator_bar.dart
import 'package:flutter/material.dart';

class ProgressIndicatorBar extends StatelessWidget {
  final double value;
  final Color color;

  const ProgressIndicatorBar({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.white.withOpacity(0.05),
        valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(0.3)),
        minHeight: 2,
      ),
    );
  }
}
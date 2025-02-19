// Path: lib/core/widgets/components/icon_badge.dart
import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const IconBadge({
    Key? key,
    required this.icon,
    required this.color,
    this.size = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}
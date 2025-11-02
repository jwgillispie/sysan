// Path: lib/core/widgets/ui_components.dart

import 'package:flutter/material.dart';

class GlowingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;

  const GlowingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.black, // Text color for contrast
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: child,
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PulsingDot extends StatelessWidget {
  final Color? color;
  final double size;

  const PulsingDot({
    super.key,
    this.color,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = color ?? Theme.of(context).colorScheme.primary;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor.withValues(alpha: value),
            boxShadow: [
              BoxShadow(
                color: dotColor.withValues(alpha: 0.5 * value),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
      onEnd: () {},
    );
  }
}
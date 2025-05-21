// lib/core/widgets/animated_button.dart

import 'package:flutter/material.dart';

/// A custom animated button with hover and press effects
class AnimatedButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color primaryColor;
  final VoidCallback onTap;
  final double width;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.icon,
    required this.primaryColor,
    required this.onTap,
    this.width = 280,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool isHovering = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() {
        isHovering = false;
        isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          padding: const EdgeInsets.symmetric(vertical: 10),
          transform: isPressed 
              ? Matrix4.translationValues(0, 2, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.primaryColor.withOpacity(isPressed ? 1.0 : isHovering ? 0.9 : 0.7),
                widget.primaryColor.withOpacity(isPressed ? 0.8 : isHovering ? 0.6 : 0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.primaryColor,
              width: isHovering ? 2.0 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor.withOpacity(isPressed ? 0.2 : isHovering ? 0.5 : 0.3),
                blurRadius: isPressed ? 4 : isHovering ? 12 : 8,
                spreadRadius: isPressed ? -4 : isHovering ? 0 : -2,
                offset: isPressed ? const Offset(0, 1) : const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.black,
                size: isHovering ? 22 : 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isHovering ? 15 : 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
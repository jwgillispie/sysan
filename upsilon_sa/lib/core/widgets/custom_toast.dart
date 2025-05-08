// lib/core/widgets/custom_toast.dart

import 'package:flutter/material.dart';
import 'dart:async';

/// A custom toast-like notification that displays at the top of the screen
/// This avoids layout conflicts with bottom navigation and floating action buttons
class CustomToast {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  /// Shows a custom toast notification
  /// 
  /// Parameters:
  /// - context: The BuildContext to find the overlay
  /// - message: The message to display
  /// - backgroundColor: Background color of the toast (default: primaryColor)
  /// - textColor: Text color (default: black or white depending on background)
  /// - icon: Optional icon to display before the message
  /// - duration: How long to show the toast (default: 2 seconds)
  static void show({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Get theme colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    backgroundColor ??= primaryColor;
    
    // Automatically determine text color if not provided
    textColor ??= _calculateTextColor(backgroundColor);

    // Hide any existing toast
    hide();

    // Create the overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        backgroundColor: backgroundColor!,
        textColor: textColor!,
        icon: icon,
      ),
    );

    // Show the toast
    Overlay.of(context).insert(_overlayEntry!);

    // Set a timer to remove the toast
    _timer = Timer(duration, () {
      hide();
    });
  }

  /// Shows a success toast with a check icon
  static void showSuccess(BuildContext context, String message) {
    show(
      context: context, 
      message: message,
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icons.check_circle,
    );
  }

  /// Shows an error toast with an error icon
  static void showError(BuildContext context, String message) {
    show(
      context: context, 
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  /// Calculates appropriate text color based on background brightness
  static Color _calculateTextColor(Color backgroundColor) {
    // Use black text on light backgrounds, white on dark backgrounds
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  /// Hides the current toast if one is displayed
  static void hide() {
    _timer?.cancel();
    _timer = null;
    
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

/// The actual toast widget with slide and fade animations
class _ToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const _ToastWidget({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(8.0),
                color: widget.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: widget.textColor),
                        const SizedBox(width: 8.0),
                      ],
                      Flexible(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: widget.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
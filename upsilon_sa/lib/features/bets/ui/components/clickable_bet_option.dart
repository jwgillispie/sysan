// lib/features/bets/ui/components/clickable_bet_option.dart

import 'package:flutter/material.dart';

class ClickableBetOption extends StatefulWidget {
  final String mainValue;
  final String? subValue;
  final String? label;
  final Color? labelColor;
  final bool isSelected;
  final VoidCallback onTap;
  final bool hasSystemApplied;

  const ClickableBetOption({
    super.key,
    required this.mainValue,
    this.subValue,
    this.label,
    this.labelColor,
    required this.onTap,
    this.isSelected = false,
    this.hasSystemApplied = false,
  });

  @override
  State<ClickableBetOption> createState() => _ClickableBetOptionState();
}

class _ClickableBetOptionState extends State<ClickableBetOption> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) {
          _animationController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: widget.isSelected
                      ? Border.all(
                          color: primaryColor,
                          width: 2,
                        )
                      : widget.hasSystemApplied
                          ? Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 1,
                            )
                          : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main value with optional label
                    if (widget.label != null)
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.label!,
                              style: TextStyle(
                                color: widget.labelColor ?? Colors.grey[400],
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.mainValue}',
                              style: TextStyle(
                                color: _isHovered || widget.isSelected
                                    ? primaryColor
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        widget.mainValue,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isHovered || widget.isSelected
                              ? primaryColor
                              : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    
                    // Sub value (odds)
                    if (widget.subValue != null)
                      Text(
                        widget.subValue!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isHovered || widget.isSelected
                              ? primaryColor.withOpacity(0.8)
                              : Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    
                    // System indicator
                    if (widget.hasSystemApplied && !widget.isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
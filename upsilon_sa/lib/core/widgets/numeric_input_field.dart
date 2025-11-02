// lib/core/widgets/numeric_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A numeric input field with increment/decrement buttons
/// 
/// Designed for entering numeric values with proper validation and styling.
/// Supports integers and decimal values.
class NumericInputField extends StatefulWidget {
  /// Current value
  final num value;
  
  /// Callback when value changes
  final ValueChanged<num> onChanged;
  
  /// Label text to display above the field
  final String label;
  
  /// Optional unit text to display (e.g., "%", "points")
  final String? unit;
  
  /// Primary color for styling
  final Color? primaryColor;
  
  /// Minimum allowed value
  final num min;
  
  /// Maximum allowed value
  final num max;
  
  /// Step value for increment/decrement
  final num step;
  
  /// Whether to accept decimal values
  final bool allowDecimals;
  
  /// Field width 
  final double? width;
  
  /// Whether to show the label
  final bool showLabel;
  
  const NumericInputField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.unit,
    this.primaryColor,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.allowDecimals = false,
    this.width,
    this.showLabel = true,
  });

  @override
  State<NumericInputField> createState() => _NumericInputFieldState();
}

class _NumericInputFieldState extends State<NumericInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(NumericInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update the controller if the value has changed and the field doesn't have focus
    if (oldWidget.value != widget.value && !_hasFocus) {
      _controller.text = widget.value.toString();
    }
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
      
      // When losing focus, validate the input
      if (!_hasFocus) {
        _validateAndFormatInput();
      }
    });
  }

  void _validateAndFormatInput() {
    final text = _controller.text;
    num? parsedValue;
    
    if (widget.allowDecimals) {
      parsedValue = double.tryParse(text);
    } else {
      parsedValue = int.tryParse(text);
    }
    
    if (parsedValue == null) {
      // Reset to previous valid value if parsing fails
      _controller.text = widget.value.toString();
      return;
    }
    
    // Apply min/max constraints
    if (parsedValue < widget.min) {
      parsedValue = widget.min;
    } else if (parsedValue > widget.max) {
      parsedValue = widget.max;
    }
    
    // Format the value - remove trailing zeros for decimals
    if (widget.allowDecimals && parsedValue is double) {
      if (parsedValue == parsedValue.truncate()) {
        _controller.text = parsedValue.truncate().toString();
      } else {
        _controller.text = parsedValue.toString();
      }
    } else {
      _controller.text = parsedValue.toString();
    }
    
    // Notify parent of the change if needed
    if (parsedValue != widget.value) {
      widget.onChanged(parsedValue);
    }
  }

  void _increment() {
    num currentValue = widget.value;
    num newValue = currentValue + widget.step;
    
    if (newValue > widget.max) {
      newValue = widget.max;
    }
    
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
  }

  void _decrement() {
    num currentValue = widget.value;
    num newValue = currentValue - widget.step;
    
    if (newValue < widget.min) {
      newValue = widget.min;
    }
    
    _controller.text = newValue.toString();
    widget.onChanged(newValue);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? Theme.of(context).colorScheme.primary;
    
    return Container(
      width: widget.width,
      padding: widget.showLabel 
          ? const EdgeInsets.all(12)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _hasFocus ? primaryColor : primaryColor.withValues(alpha: 0.3),
          width: _hasFocus ? 2 : 1,
        ),
        boxShadow: _hasFocus ? [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label and optional unit - only if showLabel is true
          if (widget.showLabel) 
            Row(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
              ),
              if (widget.unit != null && widget.unit!.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  '(${widget.unit})',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          
          // Input field with +/- buttons
          Row(
            children: [
              // Text input field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: widget.allowDecimals 
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.number,
                  inputFormatters: [
                    // Only allow digits and maybe a decimal point
                    widget.allowDecimals
                        ? FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
                        : FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[900],
                  ),
                  onChanged: (text) {
                    // Try to parse the value
                    num? parsedValue;
                    if (widget.allowDecimals) {
                      parsedValue = double.tryParse(text);
                    } else {
                      parsedValue = int.tryParse(text);
                    }
                    
                    // Only update if parsing successful
                    if (parsedValue != null) {
                      widget.onChanged(parsedValue);
                    }
                  },
                  onSubmitted: (_) => _validateAndFormatInput(),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // +/- buttons
              Column(
                children: [
                  // Increment button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _increment,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.add,
                          color: primaryColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Decrement button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _decrement,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: primaryColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
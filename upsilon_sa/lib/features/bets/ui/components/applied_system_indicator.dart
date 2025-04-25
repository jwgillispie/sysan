
// lib/features/bets/ui/components/applied_system_indicator.dart
import 'package:flutter/material.dart';

class AppliedSystemIndicator extends StatelessWidget {
  final String systemName;
  final VoidCallback onRemove;

  const AppliedSystemIndicator({
    Key? key,
    required this.systemName,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.memory,
                color: primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'SYSTEM APPLIED: $systemName',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.red.withOpacity(0.5),
                ),
              ),
              child: Icon(
                Icons.close,
                color: Colors.red,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
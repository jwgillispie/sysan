// lib/features/bets/ui/components/applied_system_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppliedSystemIndicator extends StatelessWidget {
  final String systemName;
  final VoidCallback onRemove;

  const AppliedSystemIndicator({
    super.key,
    required this.systemName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blue;
    const isWebPlatform = kIsWeb;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16, 
        vertical: isWebPlatform ? 10 : 8
      ),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.memory,
                  color: Colors.blue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'SYSTEM APPLIED: $systemName',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: isWebPlatform ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
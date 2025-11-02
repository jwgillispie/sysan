// lib/features/bets/ui/components/bet_type_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BetTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const BetTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildTypeButton(
            context,
            'moneyline',
            'Moneyline',
            selectedType == 'moneyline',
          ),
          _buildTypeButton(
            context,
            'spread',
            'Spread',
            selectedType == 'spread',
          ),
          _buildTypeButton(
            context,
            'totals',
            'Totals',
            selectedType == 'totals',
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(
    BuildContext context,
    String type,
    String label,
    bool isSelected,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeSelected(type),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: isWebPlatform ? 12 : 10,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? primaryColor.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: primaryColor,
                    width: 1,
                  )
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected 
                  ? primaryColor
                  : Colors.white,
              fontSize: isWebPlatform ? 16 : 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
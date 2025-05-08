// lib/features/bets/ui/components/system_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/features/bets/bloc/bets_bloc.dart';
import 'package:upsilon_sa/features/systems_creation/models/system_model.dart';

class SystemSelector extends StatelessWidget {
  final List<SystemModel> systems;
  final SystemModel? selectedSystem;
  final Function(String) onSystemSelected;

  const SystemSelector({
    super.key,
    required this.systems,
    this.selectedSystem,
    required this.onSystemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT SYSTEM:',
            style: TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (systems.isEmpty)
            _buildEmptySystemsMessage(context)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var system in systems) ...[
                    _buildSystemButton(
                      context,
                      system,
                      selectedSystem?.id == system.id,
                      () => onSystemSelected(system.id),
                    ),
                    const SizedBox(width: 8),
                  ],
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptySystemsMessage(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'No systems found. Create a system in the Systems Creation page.',
        style: TextStyle(
          color: primaryColor.withOpacity(0.7),
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSystemButton(
    BuildContext context,
    SystemModel system,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? primaryColor.withOpacity(0.3) 
            : primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
              ? primaryColor 
              : primaryColor.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.memory,
              color: primaryColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              system.name,
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check_circle,
                color: primaryColor,
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Create system button removed - users now create systems in the systems creation page
}
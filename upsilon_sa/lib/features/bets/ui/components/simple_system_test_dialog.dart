// lib/features/bets/ui/components/simple_system_test_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/scheduler.dart' show WidgetsBinding;
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'package:upsilon_sa/features/systems_creation/models/system_model.dart';

class SimpleSystemTestDialog extends StatelessWidget {
  final Bet bet;
  final SystemModel system;

  const SimpleSystemTestDialog({
    super.key,
    required this.bet,
    required this.system,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    // Generate a simple performance result - either positive or negative percentage
    final performance = _generatePerformanceValue();
    final isPositive = performance > 0;
    final color = isPositive ? Colors.green : Colors.red;
    
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          Icon(
            Icons.analytics_outlined,
            color: primaryColor,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'SYSTEM TEST RESULT',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Game info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                // System name
                Text(
                  system.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Game info
                Text(
                  '${bet.homeTeam} vs ${bet.awayTeam}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Performance result
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.withOpacity(0.5),
              ),
            ),
            child: Column(
              children: [
                Text(
                  isPositive ? 'SYSTEM PERFORMS WELL' : 'SYSTEM UNDERPERFORMS',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: color,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${performance.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isPositive ? ' gain' : ' loss',
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isPositive 
                      ? 'This system has historically performed well on similar bets'
                      : 'This system has historically underperformed on similar bets',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'DISCARD',
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Show a confirmation message with proper positioning
            // Use a post-frame callback to ensure the context is valid when showing the SnackBar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Clear any existing SnackBars first
              ScaffoldMessenger.of(context).clearSnackBars();
              
              // Show the SnackBar with safer positioning
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('System applied to this bet'),
                  backgroundColor: primaryColor,
                  behavior: SnackBarBehavior.fixed, // Changed to fixed behavior
                  duration: const Duration(seconds: 2), // Shorter duration
                ),
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.black,
          ),
          child: const Text(
            'APPLY SYSTEM',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  // Generate a simple performance value between -30% and +30%
  double _generatePerformanceValue() {
    // Using hash code of the bet ID and system ID to generate a consistent value
    final hash = bet.id.hashCode + system.id.hashCode;
    final randomValue = ((hash % 600) - 300) / 10; // Range -30.0 to +30.0
    return randomValue;
  }
}
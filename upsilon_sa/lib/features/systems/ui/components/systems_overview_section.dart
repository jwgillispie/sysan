// Path: lib/features/systems/ui/components/systems_overview_section.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/constants.dart';

class SystemsOverviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> systems;
  final Animation<double> fadeAnimation;

  const SystemsOverviewSection({
    super.key,
    required this.systems,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ACTIVE SYSTEMS',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 15),
            ...systems.map((system) => SystemCard(system: system)),
          ],
        ),
      ),
    );
  }
}

class SystemCard extends StatelessWidget {
  final Map<String, dynamic> system;

  const SystemCard({
    super.key,
    required this.system,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                system['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Win Rate: ${system['winRate']}%',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          PerformanceIndicator(value: system['winRate']),
        ],
      ),
    );
  }
}

class PerformanceIndicator extends StatelessWidget {
  final double value;

  const PerformanceIndicator({
    Key? key,
    required this.value,
  }) : super(key: key);

  Color _getIndicatorColor() {
    if (value >= 80) return Colors.green;
    if (value >= 70) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = _getIndicatorColor();
    
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: indicatorColor.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: indicatorColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            color: indicatorColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
// Path: lib/features/systems/ui/components/performance_metrics_section.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/components/metric_card.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/core/config/constants.dart';

class PerformanceMetricsSection extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const PerformanceMetricsSection({
    Key? key,
    required this.metrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UIConstants.defaultPadding),
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
            'PERFORMANCE METRICS',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          _buildMetricsGrid(),
          const SizedBox(height: 20),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Win Rate',
                value: '${metrics['winRate']}%',
                icon: Icons.trending_up,
                accentColor: Colors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                label: 'ROI',
                value: '+${metrics['roi']}%',
                icon: Icons.analytics,
                accentColor: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Active Bets',
                value: metrics['activeBets'].toString(),
                icon: Icons.sports_basketball,
                accentColor: Colors.orange,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                label: 'Profit',
                value: '\$${metrics['profit']}',
                icon: Icons.attach_money,
                accentColor: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'RECENT ACTIVITY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics['recentActivity'].length,
          itemBuilder: (context, index) {
            final activity = metrics['recentActivity'][index];
            return ActivityListItem(activity: activity);
          },
        ),
      ],
    );
  }
}

class ActivityListItem extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityListItem({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(UIConstants.smallPadding),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          _buildActivityIcon(context),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActivityDetails(),
          ),
          _buildStatusBadge(activity['status']),
        ],
      ),
    );
  }

  Widget _buildActivityIcon(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.sports_basketball,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildActivityDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          activity['title'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          activity['subtitle'],
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          activity['time'],
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final Color statusColor = _getStatusColor(status);
    return StatusBadge(text: status, color: statusColor);
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'WIN':
        return Colors.green;
      case 'LOSS':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

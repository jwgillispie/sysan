// lib/features/datasets/ui/components/team_card.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/datasets/ui/dialogs/team_details_dialog.dart';

class TeamCard extends StatelessWidget {
  final Map<String, dynamic> team;

  const TeamCard({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          child: Icon(
            Icons.group,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          team["name"],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Players: ${(team["roster"] as List).length}',
          style: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.primary,
          size: 16,
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => TeamDetailsDialog(team: team),
        ),
      ),
    );
  }
}
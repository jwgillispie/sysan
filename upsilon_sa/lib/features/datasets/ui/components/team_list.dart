// lib/features/datasets/ui/components/team_list.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_state.dart';

class TeamList extends StatelessWidget {
  final DatasetsState state;
  
  const TeamList({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is TeamsLoadedState) {
      final teams = (state as TeamsLoadedState).teams;
      
      if (teams.isEmpty) {
        return const Center(
          child: Text(
            'No teams found',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return Card(
            color: Colors.black,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: ListTile(
              title: Text(
                team.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${team.players.length} Players',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
                // Show team details if needed
              },
            ),
          );
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
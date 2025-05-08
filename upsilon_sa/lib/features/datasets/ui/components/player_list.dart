// lib/features/datasets/ui/components/player_list.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_state.dart';
import 'package:upsilon_sa/features/datasets/ui/components/player_card.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_bloc.dart';

class PlayerList extends StatelessWidget {
  final DatasetsState state;
  
  const PlayerList({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is PlayersLoadedState) {
      final players = (state as PlayersLoadedState).players;
      
      if (players.isEmpty) {
        return const Center(
          child: Text(
            'No players found',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return PlayerCard(player: player);
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
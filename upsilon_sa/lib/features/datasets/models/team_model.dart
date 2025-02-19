import 'package:upsilon_sa/features/datasets/models/player_model.dart';

class Team {
  final String name;
  final List<Player> players;

  Team({
    required this.name,
    required this.players,
  });
  // from JSON 
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'],
      players: (json['players'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
    );

  }
  // to JSON 
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}

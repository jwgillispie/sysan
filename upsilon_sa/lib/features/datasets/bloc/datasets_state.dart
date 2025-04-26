import 'package:upsilon_sa/features/datasets/models/player_model.dart';
import 'package:upsilon_sa/features/datasets/models/team_model.dart';

abstract class DatasetsState {}

class DatasetsInitialState extends DatasetsState {}

class DatasetsLoadingState extends DatasetsState {}

class PlayersLoadedState extends DatasetsState {
  final List<Player> players;
  final String selectedSport;
  final String selectedTeam;
  final List<String> availableSports;
  final List<String> availableTeams;

  PlayersLoadedState(
    this.players, 
    this.selectedSport, 
    this.selectedTeam, 
    this.availableSports, 
    this.availableTeams
  );
}

class TeamsLoadedState extends DatasetsState {
  final List<Team> teams;
  final String selectedSport;
  final List<String> availableSports;

  TeamsLoadedState(
    this.teams,
    this.selectedSport,
    this.availableSports,
  );
}

class DatasetsErrorState extends DatasetsState {
  final String error;
  DatasetsErrorState(this.error);
}
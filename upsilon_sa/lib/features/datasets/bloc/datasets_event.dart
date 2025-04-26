import 'package:upsilon_sa/features/datasets/models/player_model.dart';
import 'package:upsilon_sa/features/datasets/models/team_model.dart';

abstract class DatasetsEvent {}

class LoadPlayersEvent extends DatasetsEvent {
  final bool isRefresh;
  LoadPlayersEvent({this.isRefresh = false});
}

class LoadTeamsEvent extends DatasetsEvent {
  final bool isRefresh;
  LoadTeamsEvent({this.isRefresh = false});
}

class RefreshDataEvent extends DatasetsEvent {}

class FilterSportChangedEvent extends DatasetsEvent {
  final String sport;
  FilterSportChangedEvent(this.sport);
}

class FilterTeamChangedEvent extends DatasetsEvent {
  final String team;
  FilterTeamChangedEvent(this.team);
}
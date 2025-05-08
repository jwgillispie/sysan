// lib/features/datasets/bloc/datasets_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_event.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_state.dart';
import 'package:upsilon_sa/features/datasets/models/player_model.dart';
import 'package:upsilon_sa/features/datasets/models/team_model.dart';

import '../repos/datasets_repository.dart';



class DatasetsBloc extends Bloc<DatasetsEvent, DatasetsState> {
  final DatasetsRepository repository = DatasetsRepository();
  List<Player> allPlayers = [];
  List<Team> allTeams = [];
  String selectedSport = '';
  String selectedTeam = '';
  List<String> availableSports = [];
  List<String> availableTeams = [];

  DatasetsBloc() : super(DatasetsInitialState()) {
    on<LoadPlayersEvent>(_onLoadPlayers);
    on<LoadTeamsEvent>(_onLoadTeams);
    on<RefreshDataEvent>(_onRefreshData);
    on<FilterSportChangedEvent>(_onSportChanged);
    on<FilterTeamChangedEvent>(_onTeamChanged);

    // Automatically load data when bloc is created
    add(LoadPlayersEvent());
    add(LoadTeamsEvent());
  }

  Future<void> _onLoadPlayers(LoadPlayersEvent event, Emitter<DatasetsState> emit) async {
    try {
      if (!event.isRefresh) {
        emit(DatasetsLoadingState());
      }

      if (allPlayers.isEmpty) {
        allPlayers = await repository.fetchPlayers();
        
        // Extract unique sports and teams
        availableSports = allPlayers
            .map((player) => player.position)
            .toSet()
            .toList();
        
        availableTeams = allTeams
            .map((team) => team.name)
            .toSet()
            .toList();
      }

      // Filter players based on selected filters
      final List<Player> filteredPlayers = allPlayers.where((player) {
        final matchesSport = selectedSport.isEmpty || player.position == selectedSport;
        final matchesTeam = selectedTeam.isEmpty || player.position == selectedTeam;
        return matchesSport && matchesTeam;
      }).toList();

      emit(PlayersLoadedState(
        filteredPlayers,
        selectedSport,
        selectedTeam,
        availableSports,
        availableTeams,
      ));
    } catch (e) {
      emit(DatasetsErrorState(e.toString()));
    }
  }

  Future<void> _onLoadTeams(LoadTeamsEvent event, Emitter<DatasetsState> emit) async {
    try {
      if (!event.isRefresh) {
        emit(DatasetsLoadingState());
      }

      if (allTeams.isEmpty) {
        allTeams = await repository.fetchTeams();
      }

      // Filter teams based on selected sport
      final filteredTeams = allTeams.where((team) {
        return selectedSport.isEmpty || team.players.any((p) => p.position == selectedSport);
      }).toList();

      emit(TeamsLoadedState(
        filteredTeams,
        selectedSport,
        availableSports,
      ));
    } catch (e) {
      emit(DatasetsErrorState(e.toString()));
    }
  }

  Future<void> _onRefreshData(RefreshDataEvent event, Emitter<DatasetsState> emit) async {
    allPlayers = [];
    allTeams = [];
    add(LoadPlayersEvent(isRefresh: true));
    add(LoadTeamsEvent(isRefresh: true));
  }

  Future<void> _onSportChanged(FilterSportChangedEvent event, Emitter<DatasetsState> emit) async {
    selectedSport = event.sport;
    selectedTeam = ''; // Reset team selection when sport changes
    add(LoadPlayersEvent());
    add(LoadTeamsEvent());
  }

  Future<void> _onTeamChanged(FilterTeamChangedEvent event, Emitter<DatasetsState> emit) async {
    selectedTeam = event.team;
    add(LoadPlayersEvent());
  }
}
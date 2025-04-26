// lib/features/bets/bloc/bets_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:upsilon_sa/features/bets/repository/bets_repository.dart';
import '../models/bet_model.dart';

part 'bets_event.dart';
part 'bets_state.dart';

class BetsBloc extends Bloc<BetsEvent, BetsState> {
  final BetsRepository repository;

  BetsBloc({required this.repository}) : super(BetsInitial()) {
    on<LoadBets>(_onLoadBets);
    on<ApplySystem>(_onApplySystem);
    on<FilterBets>(_onFilterBets);
    on<SortBets>(_onSortBets);
    on<SelectBetType>(_onSelectBetType);
  }

  Future<void> _onLoadBets(LoadBets event, Emitter<BetsState> emit) async {
    emit(BetsLoading());
    try {
      final bets = await repository.getUpcomingBets(
        sport: event.sport,
        regions: event.regions,
        markets: event.markets,
        oddsFormat: event.oddsFormat,
      );
      emit(BetsLoaded(
        bets: bets,
        filteredBets: bets,
        selectedBetType: 'moneyline',
        sort: BetsSort.startTime,
        appliedSystem: null,
      ));
    } catch (e) {
      emit(BetsError(message: e.toString()));
    }
  }

  Future<void> _onApplySystem(ApplySystem event, Emitter<BetsState> emit) async {
    if (state is BetsLoaded) {
      final currentState = state as BetsLoaded;
      // Apply the system to the bets
      // This would involve complex logic specific to your system's algorithm
      // For now, we'll just emit the same state with the system applied
      emit(currentState.copyWith(appliedSystem: event.systemId));
    }
  }

  void _onFilterBets(FilterBets event, Emitter<BetsState> emit) {
    if (state is BetsLoaded) {
      final currentState = state as BetsLoaded;
      final filteredBets = currentState.bets.where((bet) {
        // Apply filters based on event.filters
        // For example, filter by team name
        if (event.teamName != null && event.teamName!.isNotEmpty) {
          return bet.homeTeam.toLowerCase().contains(event.teamName!.toLowerCase()) ||
              bet.awayTeam.toLowerCase().contains(event.teamName!.toLowerCase());
        }
        return true;
      }).toList();

      emit(currentState.copyWith(filteredBets: filteredBets));
    }
  }

  void _onSortBets(SortBets event, Emitter<BetsState> emit) {
    if (state is BetsLoaded) {
      final currentState = state as BetsLoaded;
      final sortedBets = List<Bet>.from(currentState.filteredBets);

      switch (event.sort) {
        case BetsSort.startTime:
          sortedBets.sort((a, b) => a.commenceTime.compareTo(b.commenceTime));
          break;
        case BetsSort.odds:
          // Sort by best odds for selected bet type
          if (currentState.selectedBetType == 'moneyline') {
            sortedBets.sort((a, b) {
              final aOdds = a.getBestMoneylineOdds();
              final bOdds = b.getBestMoneylineOdds();
              return (bOdds['home']['odds'] ?? 0).compareTo(aOdds['home']['odds'] ?? 0);
            });
          } else if (currentState.selectedBetType == 'spread') {
            sortedBets.sort((a, b) {
              final aOdds = a.getBestSpreadOdds();
              final bOdds = b.getBestSpreadOdds();
              return (bOdds['home']['odds'] ?? 0).compareTo(aOdds['home']['odds'] ?? 0);
            });
          } else if (currentState.selectedBetType == 'totals') {
            sortedBets.sort((a, b) {
              final aOdds = a.getBestTotalsOdds();
              final bOdds = b.getBestTotalsOdds();
              return (bOdds['over']['odds'] ?? 0).compareTo(aOdds['over']['odds'] ?? 0);
            });
          }
          break;
        case BetsSort.systemConfidence:
          // This would be replaced with actual logic to sort by system confidence
          // once the system is applied
          break;
      }

      emit(currentState.copyWith(filteredBets: sortedBets, sort: event.sort));
    }
  }

  void _onSelectBetType(SelectBetType event, Emitter<BetsState> emit) {
    if (state is BetsLoaded) {
      final currentState = state as BetsLoaded;
      emit(currentState.copyWith(selectedBetType: event.betType));
    }
  }
}
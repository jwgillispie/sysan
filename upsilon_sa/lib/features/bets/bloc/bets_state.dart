// lib/features/bets/bloc/bets_state.dart
part of 'bets_bloc.dart';

@immutable
abstract class BetsState extends Equatable {
  const BetsState();

  @override
  List<Object?> get props => [];
}

class BetsInitial extends BetsState {}

class BetsLoading extends BetsState {}

class BetsLoaded extends BetsState {
  final List<Bet> bets;
  final List<Bet> filteredBets;
  final String selectedBetType; // 'moneyline', 'spread', or 'totals'
  final BetsSort sort;
  final String? appliedSystem;

  const BetsLoaded({
    required this.bets,
    required this.filteredBets,
    required this.selectedBetType,
    required this.sort,
    this.appliedSystem,
  });

  BetsLoaded copyWith({
    List<Bet>? bets,
    List<Bet>? filteredBets,
    String? selectedBetType,
    BetsSort? sort,
    String? appliedSystem,
  }) {
    return BetsLoaded(
      bets: bets ?? this.bets,
      filteredBets: filteredBets ?? this.filteredBets,
      selectedBetType: selectedBetType ?? this.selectedBetType,
      sort: sort ?? this.sort,
      appliedSystem: appliedSystem ?? this.appliedSystem,
    );
  }

  @override
  List<Object?> get props => [bets, filteredBets, selectedBetType, sort, appliedSystem];
}

class BetsError extends BetsState {
  final String message;

  const BetsError({required this.message});

  @override
  List<Object> get props => [message];
}
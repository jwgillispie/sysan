// lib/features/bets/bloc/bets_event.dart
part of 'bets_bloc.dart';

enum BetsSort { startTime, odds, systemConfidence }

@immutable
abstract class BetsEvent {}

class LoadBets extends BetsEvent {
  final String sport;
  final String regions;
  final String markets;
  final String oddsFormat;

  LoadBets({
    this.sport = 'basketball_nba',
    this.regions = 'us',
    this.markets = 'h2h,spreads,totals',
    this.oddsFormat = 'american',
  });
}

class ApplySystem extends BetsEvent {
  final String systemId;

  ApplySystem({required this.systemId});
}

class FilterBets extends BetsEvent {
  final String? teamName;
  final String? sportType;
  final DateTime? startTimeFrom;
  final DateTime? startTimeTo;

  FilterBets({
    this.teamName,
    this.sportType,
    this.startTimeFrom,
    this.startTimeTo,
  });
}

class SortBets extends BetsEvent {
  final BetsSort sort;

  SortBets({required this.sort});
}

class SelectBetType extends BetsEvent {
  final String betType; // 'moneyline', 'spread', or 'totals'

  SelectBetType({required this.betType});
}
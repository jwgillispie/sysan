// lib/features/analytics/bloc/systems_creation_state.dart

import 'package:equatable/equatable.dart';
import '../models/factor_model.dart';

enum SystemsCreationStatus { initial, loading, success, failure }

class SystemsCreationState extends Equatable {
  final SystemsCreationStatus status;
  final String systemName;
  final String selectedSport;
  final String? selectedPropId;
  final List<Factor> factors;
  final double systemConfidence;
  final String? errorMessage;
  final int systemGamesBack; // System-wide games back setting

  const SystemsCreationState({
    this.status = SystemsCreationStatus.initial,
    this.systemName = '',
    this.selectedSport = 'NBA',
    this.selectedPropId,
    this.factors = const [],
    this.systemConfidence = 0.0,
    this.errorMessage,
    this.systemGamesBack = 10, // Default to 10 games
  });

  SystemsCreationState copyWith({
    SystemsCreationStatus? status,
    String? systemName,
    String? selectedSport,
    String? selectedPropId,
    List<Factor>? factors,
    double? systemConfidence,
    String? errorMessage,
    int? systemGamesBack,
  }) {
    return SystemsCreationState(
      status: status ?? this.status,
      systemName: systemName ?? this.systemName,
      selectedSport: selectedSport ?? this.selectedSport,
      selectedPropId: selectedPropId ?? this.selectedPropId,
      factors: factors ?? this.factors,
      systemConfidence: systemConfidence ?? this.systemConfidence,
      errorMessage: errorMessage,
      systemGamesBack: systemGamesBack ?? this.systemGamesBack,
    );
  }

  @override
  List<Object?> get props => [
        status,
        systemName,
        selectedSport,
        selectedPropId,
        factors,
        systemConfidence,
        errorMessage,
        systemGamesBack,
      ];
}
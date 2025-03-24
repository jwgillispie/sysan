// lib/features/analytics/bloc/systems_creation_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/features/analytics/bloc/system_creation_event.dart';
import 'package:upsilon_sa/features/analytics/bloc/system_creation_state.dart';
import '../models/factor_model.dart';


class SystemsCreationBloc
    extends Bloc<SystemsCreationEvent, SystemsCreationState> {
  SystemsCreationBloc() : super(const SystemsCreationState()) {
    on<SystemNameChanged>(_onSystemNameChanged);
    on<SportChanged>(_onSportChanged);
    on<PropSelected>(_onPropSelected);
    on<AddFactor>(_onAddFactor);
    on<RemoveFactor>(_onRemoveFactor);
    on<ToggleFactorExpansion>(_onToggleFactorExpansion);
    on<UpdateFactorWeight>(_onUpdateFactorWeight);
    on<UpdateFactorThreshold>(_onUpdateFactorThreshold);
    on<UpdateFactorGamesBack>(_onUpdateFactorGamesBack);
    on<CreateSystem>(_onCreateSystem);
    on<TestSystem>(_onTestSystem);
    
    // Initialize with default factors
    add(const AddFactor());
    add(const AddFactor());
  }

  void _onSystemNameChanged(
      SystemNameChanged event, Emitter<SystemsCreationState> emit) {
    emit(state.copyWith(systemName: event.name));
  }

  void _onSportChanged(SportChanged event, Emitter<SystemsCreationState> emit) {
    emit(state.copyWith(selectedSport: event.sport));
  }

  void _onPropSelected(
      PropSelected event, Emitter<SystemsCreationState> emit) {
    emit(state.copyWith(selectedPropId: event.propId));
  }

  void _onAddFactor(AddFactor event, Emitter<SystemsCreationState> emit) {
    final factors = List<Factor>.from(state.factors);
    final newId = factors.isEmpty ? 1 : factors.last.id + 1;
    factors.add(Factor(
      id: newId,
      name: 'Factor $newId',
      expanded: true,
    ));
    emit(state.copyWith(factors: factors));
  }

  void _onRemoveFactor(
      RemoveFactor event, Emitter<SystemsCreationState> emit) {
    final factors = List<Factor>.from(state.factors);
    factors.removeWhere((factor) => factor.id == event.factorId);
    emit(state.copyWith(factors: factors));
  }

  void _onToggleFactorExpansion(
      ToggleFactorExpansion event, Emitter<SystemsCreationState> emit) {
    final factors = List<Factor>.from(state.factors);
    final index = factors.indexWhere((factor) => factor.id == event.factorId);
    if (index != -1) {
      factors[index] = factors[index].copyWith(expanded: !factors[index].expanded);
      emit(state.copyWith(factors: factors));
    }
  }

  void _onUpdateFactorWeight(
      UpdateFactorWeight event, Emitter<SystemsCreationState> emit) {
    final factors = List<Factor>.from(state.factors);
    final index = factors.indexWhere((factor) => factor.id == event.factorId);
    if (index != -1) {
      factors[index] = factors[index].copyWith(weight: event.weight);
      emit(state.copyWith(factors: factors));
    }
  }

  void _onUpdateFactorThreshold(
      UpdateFactorThreshold event, Emitter<SystemsCreationState> emit) {
    final factors = List<Factor>.from(state.factors);
    final index = factors.indexWhere((factor) => factor.id == event.factorId);
    if (index != -1) {
      factors[index] = factors[index].copyWith(threshold: event.threshold);
      emit(state.copyWith(factors: factors));
    }
  }

  void _onUpdateFactorGamesBack(
      UpdateFactorGamesBack event, Emitter<SystemsCreationState> emit) {
    final factors = List<Factor>.from(state.factors);
    final index = factors.indexWhere((factor) => factor.id == event.factorId);
    if (index != -1) {
      factors[index] = factors[index].copyWith(gamesBack: event.gamesBack);
      emit(state.copyWith(factors: factors));
    }
  }

  void _onCreateSystem(
      CreateSystem event, Emitter<SystemsCreationState> emit) {
    // In a real implementation, you would save the system to a repository or API
    emit(state.copyWith(status: SystemsCreationStatus.loading));
    
    try {
      // Simulate a delay
      Future.delayed(const Duration(seconds: 1), () {
        emit(state.copyWith(status: SystemsCreationStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(
        status: SystemsCreationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onTestSystem(TestSystem event, Emitter<SystemsCreationState> emit) {
    // Calculate a confidence score based on factors
    double confidence = 0.0;
    
    // Simple algorithm: average of all factor weights
    if (state.factors.isNotEmpty) {
      double total = state.factors.fold(0.0, (sum, factor) => sum + factor.weight);
      confidence = total / state.factors.length;
    }
    
    emit(state.copyWith(systemConfidence: confidence));
  }
}
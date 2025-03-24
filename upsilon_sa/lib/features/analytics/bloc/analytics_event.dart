// lib/features/analytics/bloc/systems_creation_event.dart

import 'package:equatable/equatable.dart';
import '../models/factor_model.dart';

abstract class SystemsCreationEvent extends Equatable {
  const SystemsCreationEvent();

  @override
  List<Object?> get props => [];
}

class SystemNameChanged extends SystemsCreationEvent {
  final String name;

  const SystemNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class SportChanged extends SystemsCreationEvent {
  final String sport;

  const SportChanged(this.sport);

  @override
  List<Object?> get props => [sport];
}

class PropSelected extends SystemsCreationEvent {
  final String propId;

  const PropSelected(this.propId);

  @override
  List<Object?> get props => [propId];
}

class AddFactor extends SystemsCreationEvent {
  const AddFactor();
}

class RemoveFactor extends SystemsCreationEvent {
  final int factorId;

  const RemoveFactor(this.factorId);

  @override
  List<Object?> get props => [factorId];
}

class ToggleFactorExpansion extends SystemsCreationEvent {
  final int factorId;

  const ToggleFactorExpansion(this.factorId);

  @override
  List<Object?> get props => [factorId];
}

class UpdateFactorWeight extends SystemsCreationEvent {
  final int factorId;
  final double weight;

  const UpdateFactorWeight(this.factorId, this.weight);

  @override
  List<Object?> get props => [factorId, weight];
}

class UpdateFactorThreshold extends SystemsCreationEvent {
  final int factorId;
  final int threshold;

  const UpdateFactorThreshold(this.factorId, this.threshold);

  @override
  List<Object?> get props => [factorId, threshold];
}

class UpdateFactorGamesBack extends SystemsCreationEvent {
  final int factorId;
  final int gamesBack;

  const UpdateFactorGamesBack(this.factorId, this.gamesBack);

  @override
  List<Object?> get props => [factorId, gamesBack];
}

class CreateSystem extends SystemsCreationEvent {
  const CreateSystem();
}

class TestSystem extends SystemsCreationEvent {
  const TestSystem();
}
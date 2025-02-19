
// lib/features/profile/bloc/profile_state.dart
part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userData;
  ProfileLoaded(this.userData);
}

class ProfileUpdated extends ProfileState {}

class ProfileSystemsLoaded extends ProfileState {
  final List<Map<String, dynamic>> systems;
  ProfileSystemsLoaded(this.systems);
}

class ProfileStatsLoaded extends ProfileState {
  final Map<String, dynamic> stats;
  ProfileStatsLoaded(this.stats);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
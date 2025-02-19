// lib/features/profile/bloc/profile_event.dart
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final Map<String, dynamic> userData;
  UpdateProfileEvent(this.userData);
}

class LoadProfileSystemsEvent extends ProfileEvent {}

class LoadProfileStatsEvent extends ProfileEvent {}
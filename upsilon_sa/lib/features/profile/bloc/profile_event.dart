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

class LoadSubscriptionEvent extends ProfileEvent {}

class UpdateSubscriptionEvent extends ProfileEvent {
  final String planName;
  UpdateSubscriptionEvent(this.planName);
}

class CancelSubscriptionEvent extends ProfileEvent {}
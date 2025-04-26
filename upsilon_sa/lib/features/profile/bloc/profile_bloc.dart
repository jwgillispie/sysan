// lib/features/profile/bloc/profile_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository = ProfileRepository();
  Map<String, dynamic>? profileData;
  List<Map<String, dynamic>>? systemsData;
  Map<String, dynamic>? statsData;
  Map<String, dynamic>? subscriptionData;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LoadProfileSystemsEvent>(_onLoadProfileSystems);
    on<LoadProfileStatsEvent>(_onLoadProfileStats);
    on<LoadSubscriptionEvent>(_onLoadSubscription);
    on<UpdateSubscriptionEvent>(_onUpdateSubscription);
    on<CancelSubscriptionEvent>(_onCancelSubscription);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      profileData = await repository.getProfile();
      emit(ProfileLoaded(profileData!));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onLoadProfileSystems(
    LoadProfileSystemsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      systemsData = await repository.getProfileSystems();
      emit(ProfileSystemsLoaded(systemsData!));
    } catch (e) {
      emit(ProfileError('Failed to load systems: $e'));
    }
  }

  Future<void> _onLoadProfileStats(
    LoadProfileStatsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      statsData = await repository.getProfileStats();
      emit(ProfileStatsLoaded(statsData!));
    } catch (e) {
      emit(ProfileError('Failed to load stats: $e'));
    }
  }

  Future<void> _onLoadSubscription(
    LoadSubscriptionEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      subscriptionData = await repository.getSubscription();
      emit(SubscriptionLoaded(subscriptionData!));
    } catch (e) {
      emit(ProfileError('Failed to load subscription: $e'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await repository.updateProfile(event.userData);
      emit(ProfileUpdated());
      add(LoadProfileEvent()); // Reload profile
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }

  Future<void> _onUpdateSubscription(
    UpdateSubscriptionEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await repository.updateSubscription(event.planName);
      subscriptionData = await repository.getSubscription();
      emit(SubscriptionUpdated());
      emit(SubscriptionLoaded(subscriptionData!));
    } catch (e) {
      emit(ProfileError('Failed to update subscription: $e'));
    }
  }

  Future<void> _onCancelSubscription(
    CancelSubscriptionEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await repository.cancelSubscription();
      subscriptionData = await repository.getSubscription();
      emit(SubscriptionCancelled());
      emit(SubscriptionLoaded(subscriptionData!));
    } catch (e) {
      emit(ProfileError('Failed to cancel subscription: $e'));
    }
  }
}
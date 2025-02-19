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

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LoadProfileSystemsEvent>(_onLoadProfileSystems);
    on<LoadProfileStatsEvent>(_onLoadProfileStats);
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
}
// lib/features/social/bloc/social_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/features/social/models/social_system.dart';
import 'package:upsilon_sa/features/social/models/story.dart';
import 'package:upsilon_sa/features/social/models/friend.dart';
import 'package:upsilon_sa/features/social/repos/social_repository.dart';

part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialRepository repository = SocialRepository();

  SocialBloc() : super(SocialInitial()) {
    on<LoadFriendsSystems>(_onLoadFriendsSystems);
    on<LoadWorldSystems>(_onLoadWorldSystems);
    on<LoadStories>(_onLoadStories);
    on<SearchFriends>(_onSearchFriends);
    on<FollowSystem>(_onFollowSystem);
    on<UnfollowSystem>(_onUnfollowSystem);
    on<ShareSystem>(_onShareSystem);
    on<PostStory>(_onPostStory);
  }

  Future<void> _onLoadFriendsSystems(
    LoadFriendsSystems event,
    Emitter<SocialState> emit,
  ) async {
    try {
      emit(SocialLoading());
      final systems = await repository.getFriendsSystems();
      emit(FriendsSystemsLoaded(systems));
    } catch (e) {
      emit(SocialError('Failed to load friends systems: $e'));
    }
  }

  Future<void> _onLoadWorldSystems(
    LoadWorldSystems event,
    Emitter<SocialState> emit,
  ) async {
    try {
      emit(SocialLoading());
      final systems = await repository.getWorldBestSystems();
      emit(WorldSystemsLoaded(systems));
    } catch (e) {
      emit(SocialError('Failed to load world systems: $e'));
    }
  }

  Future<void> _onLoadStories(
    LoadStories event,
    Emitter<SocialState> emit,
  ) async {
    try {
      emit(SocialLoading());
      final stories = await repository.getStories();
      emit(StoriesLoaded(stories));
    } catch (e) {
      emit(SocialError('Failed to load stories: $e'));
    }
  }

  Future<void> _onSearchFriends(
    SearchFriends event,
    Emitter<SocialState> emit,
  ) async {
    try {
      emit(SocialLoading());
      final friends = await repository.searchFriends(event.query);
      emit(FriendsSearchResult(friends));
    } catch (e) {
      emit(SocialError('Failed to search friends: $e'));
    }
  }

  Future<void> _onFollowSystem(
    FollowSystem event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await repository.followSystem(event.systemId);
      emit(SystemFollowed(event.systemId));
    } catch (e) {
      emit(SocialError('Failed to follow system: $e'));
    }
  }

  Future<void> _onUnfollowSystem(
    UnfollowSystem event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await repository.unfollowSystem(event.systemId);
      emit(SystemUnfollowed(event.systemId));
    } catch (e) {
      emit(SocialError('Failed to unfollow system: $e'));
    }
  }

  Future<void> _onShareSystem(
    ShareSystem event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await repository.shareSystem(event.systemId);
      emit(SystemShared(event.systemId));
    } catch (e) {
      emit(SocialError('Failed to share system: $e'));
    }
  }

  Future<void> _onPostStory(
    PostStory event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await repository.postStory(event.game, event.systemId);
      emit(StoryPosted());
      add(LoadStories()); // Reload stories after posting
    } catch (e) {
      emit(SocialError('Failed to post story: $e'));
    }
  }
}
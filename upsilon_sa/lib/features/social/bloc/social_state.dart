// lib/features/social/bloc/social_state.dart
part of 'social_bloc.dart';

@immutable
abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialError extends SocialState {
  final String message;
  SocialError(this.message);
}

class FriendsSystemsLoaded extends SocialState {
  final List<SocialSystem> systems;
  FriendsSystemsLoaded(this.systems);
}

class WorldSystemsLoaded extends SocialState {
  final List<SocialSystem> systems;
  WorldSystemsLoaded(this.systems);
}

class StoriesLoaded extends SocialState {
  final List<Story> stories;
  StoriesLoaded(this.stories);
}

class FriendsSearchResult extends SocialState {
  final List<Friend> friends;
  FriendsSearchResult(this.friends);
}

class SystemFollowed extends SocialState {
  final String systemId;
  SystemFollowed(this.systemId);
}

class SystemUnfollowed extends SocialState {
  final String systemId;
  SystemUnfollowed(this.systemId);
}

class SystemShared extends SocialState {
  final String systemId;
  SystemShared(this.systemId);
}

class StoryPosted extends SocialState {}
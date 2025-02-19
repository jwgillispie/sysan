
// lib/features/social/bloc/social_event.dart
part of 'social_bloc.dart';

@immutable
abstract class SocialEvent {}

class LoadFriendsSystems extends SocialEvent {}

class LoadWorldSystems extends SocialEvent {}

class LoadStories extends SocialEvent {}

class SearchFriends extends SocialEvent {
  final String query;
  SearchFriends(this.query);
}

class FollowSystem extends SocialEvent {
  final String systemId;
  FollowSystem(this.systemId);
}

class UnfollowSystem extends SocialEvent {
  final String systemId;
  UnfollowSystem(this.systemId);
}

class ShareSystem extends SocialEvent {
  final String systemId;
  ShareSystem(this.systemId);
}

class PostStory extends SocialEvent {
  final String game;
  final String? systemId;
  PostStory({required this.game, this.systemId});
}
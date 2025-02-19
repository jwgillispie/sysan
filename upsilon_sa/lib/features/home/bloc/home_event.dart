part of 'home_bloc.dart';


abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}
class LineItemsLoadedEvent extends HomeEvent {}
class NewsLoadedEvent extends HomeEvent {}
class SystemsLoadedEvent extends HomeEvent {}
class LeaderboardClickedEvent extends HomeEvent {}
class SystemsCickedEvent extends HomeEvent {}

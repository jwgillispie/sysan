part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}
class LineItemsLoadedState extends HomeState {}
class NewsLoadedState extends HomeState {
  final List<String> titles;
  final List<String> urls;
  final List<String> imageUrls;
  final List<String> descriptions;

  NewsLoadedState(this.titles, this.urls, this.imageUrls, this.descriptions);
}

class SystemsLoadedState extends HomeState {}

class HomeActionState extends HomeState {}
class SystemsNavigateToLeaderboard extends HomeActionState {}
class SystemsNavigateToSystems extends HomeActionState {}
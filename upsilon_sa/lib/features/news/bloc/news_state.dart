part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<String> titles;
  final List<String> urls;
  final List<String> imageUrls;
  final List<String> descriptions;

  NewsLoadedState(this.titles, this.urls, this.imageUrls, this.descriptions);
}

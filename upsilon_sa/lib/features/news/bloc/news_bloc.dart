import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:upsilon_sa/features/news/repos/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<NewsLoadedEvent>(_onNewsLoaded);
  }
  FutureOr<void> _onNewsLoaded(
      NewsLoadedEvent event, Emitter<NewsState> emit) async {
    final List<String> titles = await NewsRepository().getTitles();
    final List<String> urls = await NewsRepository().getUrls();
    // for image urls 
    final List<String> imageUrls = await NewsRepository().getImageUrls();
    final List<String> descriptions = await NewsRepository().getDescriptions();
    emit(NewsLoadedState(titles, urls, imageUrls, descriptions));
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

import '../repos/home_repository.dart';

import 'package:bloc/bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<LeaderboardClickedEvent>(_onLeaderboardClicked);
    on<SystemsCickedEvent>(_onSystemsClicked);
    on<NewsLoadedEvent>(_onNewsLoaded);
  }

  FutureOr<void> _onLeaderboardClicked(
      LeaderboardClickedEvent event, Emitter<HomeState> emit) {
    emit(SystemsNavigateToLeaderboard());
    // Leaderboard Clicked
  }

  FutureOr<void> _onSystemsClicked(
      SystemsCickedEvent event, Emitter<HomeState> emit) {
    emit(SystemsNavigateToSystems());
    // Systems Clicked
  }


  FutureOr<void> _onNewsLoaded(
      NewsLoadedEvent event, Emitter<HomeState> emit) async {
    final List<String> titles = await HomeRepository().getTitles();
    final List<String> urls = await HomeRepository().getUrls();
    //image urls
    final List<String> imageUrls = await HomeRepository().getImageUrls();
    // descriptions
    final List<String> descriptions = await HomeRepository().getDescriptions();

    emit(NewsLoadedState(titles, urls, imageUrls, descriptions));
  }
}

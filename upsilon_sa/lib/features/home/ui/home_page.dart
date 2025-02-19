// Path: lib/features/home/ui/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/config/routes.dart';
import 'dart:async';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/features/home/bloc/home_bloc.dart';
import 'package:upsilon_sa/features/home/ui/components/home_app_bar.dart';
import 'package:upsilon_sa/features/home/ui/components/ticker_bar.dart';
import 'package:upsilon_sa/features/home/ui/components/home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomeBloc homeBloc = HomeBloc();
  late ScrollController _scrollController;
  Timer? _scrollTimer;

  final List<String> systemItems = [
    'Infinite Money Glitch',
    'Quantum β',
    'Random System',
  ];
  final List<double> systemValues = [99.8, 92.3, 88.5];

  final List<Map<String, String>> newsItems = [
    {
      'title': 'AI System Predicts Major Playoff Upset',
      'url': 'https://example.com/news1',
      'time': '2h ago',
      'category': 'PREDICTION',
    },
    {
      'title': 'Neural Network Shows 98% Accuracy in Recent Games',
      'url': 'https://example.com/news2',
      'time': '4h ago',
      'category': 'PERFORMANCE',
    },
    {
      'title': 'New Quantum Algorithm Beats Market Average',
      'url': 'https://example.com/news3',
      'time': '6h ago',
      'category': 'TECHNOLOGY',
    },
  ];

  final List<Map<String, dynamic>> bettingLines = [
    {
      'sport': 'NBA',
      'teams': 'Lakers vs Warriors',
      'spread': 'LAL -4.5',
      'total': 'O/U 224.5',
      'moneyline': {'home': '+165', 'away': '-185'},
      'prediction': {'confidence': '87%', 'pick': 'Lakers -4.5'}
    },
    {
      'sport': 'NFL',
      'teams': 'Chiefs vs Ravens',
      'spread': 'BAL -3.0',
      'total': 'O/U 47.5',
      'moneyline': {'home': '-150', 'away': '+130'},
      'prediction': {'confidence': '92%', 'pick': 'Over 47.5'}
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startScrolling();
    homeBloc.add(NewsLoadedEvent());
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _scrollTickerItems();
    });
  }

  void _scrollTickerItems() {
    if (_scrollController.hasClients) {
      final double maxWidth = _scrollController.position.maxScrollExtent;
      final double currentOffset = _scrollController.offset;
      final double newOffset = currentOffset % maxWidth;
      _scrollController.jumpTo(newOffset + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state is SystemsNavigateToLeaderboard) {
          Navigator.pushNamed(context, Routes.routeLeaderboard);
        } else if (state is SystemsNavigateToSystems) {
          Navigator.pushNamed(context, Routes.routeSystems);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              const CyberGrid(),
              SafeArea(
                child: CustomScrollView(
                  slivers: [
                    const HomeAppBar(),
                    SliverToBoxAdapter(
                      child: TickerBar(
                        scrollController: _scrollController,
                        bettingLines: bettingLines,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverToBoxAdapter(
                        child: HomeContent(
                          homeBloc: homeBloc,
                          systemItems: systemItems,
                          systemValues: systemValues,
                          newsItems: newsItems,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

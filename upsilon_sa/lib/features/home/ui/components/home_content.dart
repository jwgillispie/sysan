// Path: lib/features/home/ui/components/home_content.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/hot_props_widget.dart';
import 'package:upsilon_sa/features/home/bloc/home_bloc.dart';
import 'package:upsilon_sa/features/home/ui/components/boxes/leaderboard_box.dart';
import 'package:upsilon_sa/features/home/ui/components/boxes/news_box.dart';
import 'package:upsilon_sa/features/home/ui/components/boxes/scoreboard_box.dart';
import 'package:upsilon_sa/features/home/ui/components/boxes/systems_box.dart';
import 'package:upsilon_sa/features/news/ui/news_page.dart';

class HomeContent extends StatelessWidget {
  final HomeBloc homeBloc;
  final List<String> systemItems;
  final List<double> systemValues;
  final List<Map<String, String>> newsItems;

  const HomeContent({
    super.key,
    required this.homeBloc,
    required this.systemItems,
    required this.systemValues,
    required this.newsItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLeaderboardSection(context),
        const SizedBox(height: 24),
        _buildSystemsSection(context),
        const SizedBox(height: 24),
        _buildLiveGamesSection(context),
        const SizedBox(height: 24),
        _buildHotPropsSection(context),
        const SizedBox(height: 24),
        _buildUpdatesSection(context),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildLeaderboardSection(BuildContext context) {
    // align this to the center
    
    return LeaderboardBox(
      width: double.infinity,
      height: 300,
      title: 'TOP PERFORMERS',
      icon: Icons.emoji_events_outlined,
      onTap: () => homeBloc.add(LeaderboardClickedEvent()),
    );
  }
  Widget _buildHotPropsSection(BuildContext context) {
    final hotProps = [
      const HotProp(
        name: "Steph Curry Over 28.5 Points",
        confidence: 90.0,
        odds: "-110",
      ),
      const HotProp(
        name: "LeBron James Triple Double",
        confidence: 75.0,
        odds: "+250",
      ),
      const HotProp(
        name: "Luka Doncic Over 9.5 Assists",
        confidence: 65.0,
        odds: "-115",
      ),
    ];

    return HotPropsBox(
      width: double.infinity,
      height: 300,
      props: hotProps,
    );
  }
  Widget _buildSystemsSection(BuildContext context) {
    return SystemsBox(
      width: double.infinity,
      height: 300,
      systemItems: systemItems,
      systemValues: systemValues,
      title: 'ACTIVE SYSTEMS',
      icon: Icons.memory,
      onTap: () => homeBloc.add(SystemsCickedEvent()),
    );
  }

  Widget _buildLiveGamesSection(BuildContext context) {
    return const ScoreboardBox(
      width: double.infinity,
      height: 400,
      team1: 'BOS',
      team2: 'GSW',
      score1: 108,
      score2: 102,
      title: 'LIVE GAMES',
      icon: Icons.sports_basketball,
    );
  }

  Widget _buildUpdatesSection(BuildContext context) {
    return NewsBox(
      width: double.infinity,
      height: 300,
      newsItems: newsItems,
      title: 'LATEST UPDATES',
      icon: Icons.article_outlined,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewsPage()),
      ),
    );
  }
}
// Path: lib/features/home/ui/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/containers/animated_border_container.dart';
import 'package:upsilon_sa/features/home/bloc/home_bloc.dart';
import 'package:upsilon_sa/features/home/ui/components/home_app_bar.dart';
import 'package:upsilon_sa/features/home/ui/components/ticker_bar.dart';
import 'package:upsilon_sa/core/widgets/hot_props_widget.dart';
import 'package:upsilon_sa/features/news/ui/news_page.dart';

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
  late TabController _tabController;
  int _selectedTab = 0;

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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _startScrolling();
    homeBloc.add(NewsLoadedEvent());
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTab = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    _tabController.dispose();
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
    return BlocListener<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state is SystemsNavigateToLeaderboard) {
          Navigator.pushNamed(context, '/leaderboard');
        } else if (state is SystemsNavigateToSystems) {
          Navigator.pushNamed(context, '/systems');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const HomeAppBar(),
        body: Stack(
        children: [
          const CyberGrid(), // Cyber grid background
          Column(
            children: [
              // Ticker Bar
              TickerBar(
                scrollController: _scrollController,
                bettingLines: bettingLines,
              ),
              
              // Main Content
              Expanded(
                child: _selectedTab == 0
                    ? _buildLeaderboardContent()
                    : _buildSystemsContent(),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildLeaderboardContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLeaderboardSection(context),
            const SizedBox(height: 20),
            _buildLiveGamesSection(context),
            const SizedBox(height: 20),
            _buildHotPropsSection(context),
            const SizedBox(height: 20),
            _buildUpdatesSection(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemsContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSystemsSection(context),
            const SizedBox(height: 20),
            _buildLiveGamesSection(context),
            const SizedBox(height: 20),
            _buildHotPropsSection(context),
            const SizedBox(height: 20),
            _buildUpdatesSection(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection(BuildContext context) {
    return GestureDetector(
      onTap: () => homeBloc.add(LeaderboardClickedEvent()),
      child: AnimatedBorderContainer(
        borderColor: Theme.of(context).colorScheme.primary,
        lightColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 4),
        child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'TOP PERFORMERS',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // List of top performers
            _buildTopPerformersList(),
          ],
        ),
      ),
    ));
  }

  Widget _buildTopPerformersList() {
    final topUsers = [
      {'rank': '01', 'name': 'Infinite Money Glitch', 'profit': '+234.5%'},
      {'rank': '02', 'name': 'Quantum β', 'profit': '+187.2%'},
      {'rank': '03', 'name': 'Random System', 'profit': '+156.8%'},
      {'rank': '04', 'name': 'Big Bags', 'profit': '+143.2%'},
      {'rank': '05', 'name': 'Matrix v2.0', 'profit': '+138.7%'},
    ];

    return Column(
      children: topUsers.map((user) {
        final primaryColor = Theme.of(context).colorScheme.primary;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: primaryColor.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    user['rank']!,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      user['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      user['profit']!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress indicator line
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: 1 -
                      (double.parse(user['rank']!) - 1) *
                          0.15, // Decreasing progress for each rank
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.withOpacity(0.3)),
                  minHeight: 2,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSystemsSection(BuildContext context) {
    return GestureDetector(
      onTap: () => homeBloc.add(SystemsCickedEvent()),
      child: AnimatedBorderContainer(
        borderColor: Theme.of(context).colorScheme.primary,
        lightColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 4),
        child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.memory,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'ACTIVE SYSTEMS',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // List of user's active systems
            _buildActiveSystemsList(),
          ],
        ),
      ),
    ));
  }

  Widget _buildActiveSystemsList() {
    return Column(
      children: List.generate(systemItems.length, (index) {
        final primaryColor = Theme.of(context).colorScheme.primary;
        final value = systemValues[index];
        final valueColor = value > 90 ? Colors.green : primaryColor;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: valueColor.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: valueColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      systemItems[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: valueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: valueColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: value / 100,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      valueColor.withOpacity(0.3)),
                  minHeight: 2,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLiveGamesSection(BuildContext context) {
    return AnimatedBorderContainer(
      borderColor: Theme.of(context).colorScheme.primary,
      lightColor: Theme.of(context).colorScheme.primary,
      duration: const Duration(seconds: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sports_basketball,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CURRENT GAME',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Using our simplified scoreboard UI here
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamColumn('BOS', 108, true),
                _buildVersusLabel(context),
                _buildTeamColumn('GSW', 102, false),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGameInfoItem(context, 'QUARTER', 'Q4'),
                _buildGameInfoItem(context, 'TIME LEFT', '4:32'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String team, int score, bool hasPossession) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasPossession ? primaryColor : Colors.grey.shade800,
              width: hasPossession ? 2 : 1,
            ),
          ),
          child: Text(
            team,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (hasPossession)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
          ),
      ],
    );
  }

  Widget _buildVersusLabel(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'VS',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGameInfoItem(BuildContext context, String label, String value) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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

    return AnimatedBorderContainer(
      borderColor: Colors.redAccent,
      lightColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.redAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'HOT PROPS',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hotProps.length,
              itemBuilder: (context, index) {
                return HotPropCard(prop: hotProps[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdatesSection(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewsPage()),
      ),
      child: AnimatedBorderContainer(
        borderColor: Theme.of(context).colorScheme.primary,
        lightColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 4),
        child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'LATEST UPDATES',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // News items
            Column(
              children: newsItems.map((news) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.article,
                            color: Theme.of(context).colorScheme.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              news['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            news['time'] ?? 'Just now',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                news['category']!,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).colorScheme.primary,
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ));
  }
}
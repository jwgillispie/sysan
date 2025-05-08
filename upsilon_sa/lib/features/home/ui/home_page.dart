// Path: lib/features/home/ui/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/containers/animated_border_container.dart';
import 'package:upsilon_sa/features/home/bloc/home_bloc.dart';
import 'package:upsilon_sa/features/home/repos/live_game_repository.dart';
import 'package:upsilon_sa/features/home/ui/components/home_app_bar.dart';
import 'package:upsilon_sa/features/home/ui/components/ticker_bar.dart';
import 'package:upsilon_sa/core/widgets/hot_props_widget.dart';
import 'package:upsilon_sa/features/news/ui/news_page.dart';
import 'package:upsilon_sa/features/home/repos/home_repository.dart';
import 'package:upsilon_sa/features/home/repos/hot_props_repository.dart';


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
  
  // Repositories for fetching data
  final HomeRepository _repository = HomeRepository();
  final HotPropsRepository _hotPropsRepository = HotPropsRepository();
  final LiveGamesRepository _liveGamesRepository = LiveGamesRepository();

  // System data
  final List<String> systemItems = [
    'Lakers 4th Quarter',
    'Underdog Special',
    'Home Run Heroes',
  ];
  final List<double> systemValues = [89.8, 84.3, 78.5];

  // News data
  final List<Map<String, String>> newsItems = [
    {
      'title': 'Weekend Underdogs: Teams to Watch This Sunday',
      'url': 'https://example.com/news1',
      'time': '2h ago',
      'category': 'PREDICTION',
    },
    {
      'title': 'Lakers 4th Quarter System Hits 90% Success Rate',
      'url': 'https://example.com/news2',
      'time': '4h ago',
      'category': 'PERFORMANCE',
    },
    {
      'title': 'Why Home Team Betting is Trending This Season',
      'url': 'https://example.com/news3',
      'time': '6h ago',
      'category': 'STRATEGY',
    },
  ];

  // Live betting lines state
  List<Map<String, dynamic>> bettingLines = [];
  bool isLoadingBettingLines = true;
  
  // Hot props state
  List<HotProp> hotProps = [];
  bool isLoadingHotProps = true;
  
  // Live game state
  LiveGame? liveGame;
  bool isLoadingLiveGame = true;
  
  // Timer for updating live game data
  Timer? _liveGameUpdateTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    
    // Load data
    _loadBettingLines();
    _loadHotProps();
    _loadLiveGame();
    
    homeBloc.add(NewsLoadedEvent());
  }
  
  // Method to load live game data from the API
  Future<void> _loadLiveGame() async {
    setState(() {
      isLoadingLiveGame = true;
    });
    
    try {
      final game = await _liveGamesRepository.getLiveGame();
      
      setState(() {
        liveGame = game;
        isLoadingLiveGame = false;
      });
      
      // Set up timer to refresh the live game data periodically
    } catch (e) {
      print('Error loading live game: $e');
      setState(() {
        liveGame = null;
        isLoadingLiveGame = false;
      });
    }
  }
  
  // Method to update live game data periodically
  void _startLiveGameUpdates() {
    // Cancel existing timer if it exists
    _liveGameUpdateTimer?.cancel();
    
    // Set up a timer to refresh the live game data every 60 seconds
    _liveGameUpdateTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _loadLiveGame();
    });
  }
  
  // Method to load hot props
  Future<void> _loadHotProps() async {
    setState(() {
      isLoadingHotProps = true;
    });
    
    try {
      final props = await _hotPropsRepository.getHotProps();
      
      setState(() {
        hotProps = props;
        isLoadingHotProps = false;
      });
    } catch (e) {
      print('Error loading hot props: $e');
      setState(() {
        hotProps = [];
        isLoadingHotProps = false;
      });
    }
  }

  // Method to load betting lines
  Future<void> _loadBettingLines() async {
    setState(() {
      isLoadingBettingLines = true;
    });
    
    try {
      final lines = await _repository.getBettingLines();
      
      setState(() {
        bettingLines = lines;
        isLoadingBettingLines = false;
      });
      
      // Start scrolling once we have the data
      _startScrolling();
    } catch (e) {
      print('Error loading betting lines: $e');
      setState(() {
        bettingLines = [];
        isLoadingBettingLines = false;
      });
      
      // Still start scrolling even if we had an error
      _startScrolling();
    }
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
    _liveGameUpdateTimer?.cancel();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    // Cancel existing timer if it exists
    _scrollTimer?.cancel();
    
    // Only start scrolling if we have betting lines
    if (bettingLines.isNotEmpty) {
      _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        _scrollTickerItems();
      });
    }
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
                // Ticker Bar with loading state
                isLoadingBettingLines
                    ? _buildLoadingTickerBar()
                    : TickerBar(
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

  // Widget to show while betting lines are loading
  Widget _buildLoadingTickerBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'LOADING BETTING LINES...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
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
      {'rank': '01', 'name': 'First Half Heroes', 'profit': '+134.5%'},
      {'rank': '02', 'name': 'Underdog Special', 'profit': '+127.2%'},
      {'rank': '03', 'name': '3-Point Kings', 'profit': '+116.8%'},
      {'rank': '04', 'name': 'Sunday Winners', 'profit': '+103.2%'},
      {'rank': '05', 'name': 'Power Play Picks', 'profit': '+98.7%'},
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

  // Updated Hot Props Section with real data
  Widget _buildHotPropsSection(BuildContext context) {
    return AnimatedBorderContainer(
      borderColor: Colors.redAccent,
      lightColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.redAccent,
                  size: 20,
                ),
                SizedBox(width: 8),
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
            // Show loading indicator or props
            isLoadingHotProps 
                ? _buildLoadingHotProps()
                : ListView.builder(
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
  
  // Widget to show while hot props are loading
  Widget _buildLoadingHotProps() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 2,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'LOADING HOT PROPS...',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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

  // Updated Live Games Section with real data
  Widget _buildLiveGamesSection(BuildContext context) {
    return AnimatedBorderContainer(
      borderColor: Theme.of(context).colorScheme.primary,
      lightColor: Theme.of(context).colorScheme.primary,
      duration: const Duration(seconds: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: isLoadingLiveGame 
            ? _buildLoadingLiveGame() 
            : Column(
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
                            Text(
                              liveGame?.status ?? 'LIVE',
                              style: const TextStyle(
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
                  
                  // Live game scoreboard
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTeamColumn(
                        liveGame?.homeTeam ?? 'Home', 
                        liveGame?.homeScore ?? 0, 
                        liveGame?.possession == 'home'
                      ),
                      _buildVersusLabel(context),
                      _buildTeamColumn(
                        liveGame?.awayTeam ?? 'Away', 
                        liveGame?.awayScore ?? 0, 
                        liveGame?.possession == 'away'
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Game info (period, time)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGameInfoItem(
                        context, 
                        'QUARTER', 
                        liveGame?.period ?? 'Q1'
                      ),
                      _buildGameInfoItem(
                        context, 
                        'TIME LEFT', 
                        liveGame?.timeRemaining ?? '--:--'
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  // Widget to show while live game is loading
  Widget _buildLoadingLiveGame() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'LOADING LIVE GAME...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
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
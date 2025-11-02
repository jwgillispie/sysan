// lib/features/bets/ui/bets_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/features/bets/bloc/bets_bloc.dart';
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'package:upsilon_sa/features/bets/repository/bets_repository.dart';
import 'package:upsilon_sa/features/systems_creation/models/system_model.dart';
import 'package:upsilon_sa/features/systems_creation/repositories/systems_creation_repository.dart';
import 'components/compact_bet_card.dart';
import 'components/system_selector.dart';
import 'components/applied_system_indicator.dart';
import 'components/simple_system_test_dialog.dart';

class BetsPage extends StatelessWidget {
  const BetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BetsBloc(
        repository: BetsRepository(),
      )..add(LoadBets()),
      child: const _BetsPageContent(),
    );
  }
}

class _BetsPageContent extends StatefulWidget {
  const _BetsPageContent();

  @override
  State<_BetsPageContent> createState() => _BetsPageContentState();
}

class _BetsPageContentState extends State<_BetsPageContent> {
  final TextEditingController _searchController = TextEditingController();
  final SystemsCreationRepository _systemsRepository = SystemsCreationRepository();
  List<SystemModel> _systems = [];
  SystemModel? _selectedSystem;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSystems();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    BlocProvider.of<BetsBloc>(context)
        .add(FilterBets(teamName: _searchController.text));
  }

  Future<void> _loadSystems() async {
    // Try to get real systems first
    final systems = await _systemsRepository.getSystems();
    
    // If no systems exist, add mock systems for demonstration
    if (systems.isEmpty) {
      final mockSystems = [
        SystemModel(
          id: 'lakers-fourth',
          name: 'Lakers 4th Quarter',
          sport: 'basketball_nba',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
          confidence: 0.87,
        ),
        SystemModel(
          id: 'three-point-kings',
          name: '3-Point Kings',
          sport: 'basketball_nba',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          confidence: 0.76,
        ),
        SystemModel(
          id: 'underdog-special',
          name: 'Underdog Special',
          sport: 'basketball_nba',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          confidence: 0.92,
        ),
        SystemModel(
          id: 'sunday-winners',
          name: 'Sunday Winners',
          sport: 'americanfootball_nfl',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 21)),
          confidence: 0.81,
        ),
        SystemModel(
          id: 'home-run-heroes',
          name: 'Home Run Heroes',
          sport: 'baseball_mlb',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          confidence: 0.79,
        ),
        SystemModel(
          id: 'power-play-picks',
          name: 'Power Play Picks',
          sport: 'icehockey_nhl',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          confidence: 0.83,
        ),
        SystemModel(
          id: 'corner-kick-kings',
          name: 'Corner Kick Kings',
          sport: 'soccer_epl',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 9)),
          confidence: 0.84,
        ),
      ];
      setState(() {
        _systems = mockSystems;
      });
    } else {
      setState(() {
        _systems = systems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PulsingDot(color: Colors.blue),
            SizedBox(width: 10),
            Text(
              "AVAILABLE BETS",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.analytics_outlined,
              color: Colors.blue,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          const CyberGrid(),
          // Constrain the content width on web platform to prevent stretching
          Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildSystemSelector(),
                    const SizedBox(height: 10),
                    _buildAppliedSystemIndicator(),
                    const SizedBox(height: 10),
                    // Make sure this expands to fill available space
                    Expanded(
                      child: _buildBetsList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // No floating action button
    );
  }

  Widget _buildSystemSelector() {
    return SystemSelector(
      systems: _systems,
      selectedSystem: _selectedSystem,
      onSystemSelected: (systemId) {
        final selectedSystem = _systems.firstWhere((system) => system.id == systemId);
        setState(() {
          _selectedSystem = selectedSystem;
        });
        BlocProvider.of<BetsBloc>(context).add(ApplySystem(systemId: selectedSystem.name));
      },
    );
  }

  // Removed the bet type selector as we now show all bet types together in a condensed format

  Widget _buildAppliedSystemIndicator() {
    return BlocBuilder<BetsBloc, BetsState>(
      builder: (context, state) {
        if (state is BetsLoaded && state.appliedSystem != null) {
          return AppliedSystemIndicator(
            systemName: state.appliedSystem!,
            onRemove: () {
              // In a real app, you might want to implement a "remove system" event
              BlocProvider.of<BetsBloc>(context).add(LoadBets());
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBetsList() {
    
    return BlocBuilder<BetsBloc, BetsState>(
      builder: (context, state) {
        if (state is BetsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is BetsLoaded) {
          if (state.filteredBets.isEmpty) {
            return const Center(
              child: Text(
                'No bets found',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
            );
          }
          
          // Use a more web-friendly layout for the list
          return ListView.builder(
            itemCount: state.filteredBets.length,
            itemBuilder: (context, index) {
              final bet = state.filteredBets[index];
              return CompactBetCard(
                bet: bet,
                appliedSystem: state.appliedSystem,
                onBetSelected: (bet) {
                  // Handle bet selection
                  _showBetDetailsDialog(bet);
                },
                onBetOptionSelected: (bet, betType, selection, details) {
                  // Handle individual bet option selection
                  _showBetOptionDialog(bet, betType, selection, details);
                },
              );
            },
          );
        } else if (state is BetsError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Floating action button removed

  void _showBetDetailsDialog(Bet bet) {
    final currentState = BlocProvider.of<BetsBloc>(context).state;
    final hasSystemApplied = currentState is BetsLoaded && currentState.appliedSystem != null;
    
    // Implement a dialog to show more details about the bet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          '${bet.homeTeam} vs ${bet.awayTeam}',
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Game starts at: ${bet.commenceTime.toLocal().toString().substring(0, 16)}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Available at:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...bet.bookmakers.map((bookmaker) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '• ${bookmaker.title}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CLOSE',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (hasSystemApplied) 
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSystemPerformanceDialog(bet);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'TEST SYSTEM',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  void _showSystemPerformanceDialog(Bet bet) {
    // Find the currently selected system
    final currentState = BlocProvider.of<BetsBloc>(context).state;
    if (currentState is BetsLoaded && currentState.appliedSystem != null) {
      // Get the system name from the state
      final systemName = currentState.appliedSystem!;
      
      // Find the system model by name
      final systemModel = _systems.firstWhere(
        (system) => system.name == systemName,
        orElse: () => SystemModel(
          id: 'default',
          name: systemName,
          sport: 'basketball_nba',
          factors: [],
          createdAt: DateTime.now(),
          confidence: 0.75,
        ),
      );
      
      // Show the simple system test results dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Force user to make a decision
        builder: (context) => SimpleSystemTestDialog(
          bet: bet,
          system: systemModel,
        ),
      );
    }
  }

  void _showBetOptionDialog(Bet bet, String betType, String selection, dynamic details) {
    
    // Prepare display strings
    String betTypeDisplay = betType == 'moneyline' ? 'Winner' : betType.toUpperCase();
    String selectionDisplay = '';
    String valueDisplay = '';
    
    switch (betType) {
      case 'spread':
        selectionDisplay = details['team'];
        valueDisplay = '${_formatPoint(details['point'])} (${_formatOdds(details['odds'])})';
        break;
      case 'total':
        selectionDisplay = details['type'] == 'over' ? 'Over' : 'Under';
        valueDisplay = '${details['point']} (${_formatOdds(details['odds'])})';
        break;
      case 'moneyline':
        selectionDisplay = details['team'];
        valueDisplay = _formatOdds(details['odds']);
        break;
    }
    
    // Check if system is already applied
    if (_selectedSystem == null) {
      _showNoSystemDialog();
      return;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'APPLY SYSTEM TO BET',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${bet.homeTeam} vs ${bet.awayTeam}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _getSportIcon(bet.sportKey),
                        color: Colors.blue,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          betTypeDisplay,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectionDisplay,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        valueDisplay,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
                 child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System to apply
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SYSTEM',
                            style: TextStyle(
                              color: Colors.blue.withValues(alpha: 0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedSystem!.name,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // System confidence
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(_selectedSystem!.confidence * 100).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(_selectedSystem!.confidence * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: _getConfidenceColor(_selectedSystem!.confidence * 100),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This will test how your "${_selectedSystem!.name}" system performs with this specific bet option.',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Show the system test results
              _showSystemTestResultsDialog(bet, betType, selection, details);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'TEST SYSTEM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showNoSystemDialog() {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'NO SYSTEM SELECTED',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        content: Text(
          'Please select a system from the dropdown above before testing individual bet options.',
          style: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showSystemTestResultsDialog(Bet bet, String betType, String selection, dynamic details) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleSystemTestDialog(
        bet: bet,
        system: _selectedSystem!,
        betType: betType,
        selection: selection,
        details: details,
      ),
    );
  }
  
  String _formatPoint(dynamic point) {
    if (point == null) return '--';
    final pointValue = point as num;
    if (pointValue > 0) {
      return '+$pointValue';
    }
    return '$pointValue';
  }

  String _formatOdds(dynamic odds) {
    if (odds == null) return '--';
    final oddsValue = odds as num;
    if (oddsValue > 0) {
      return '+$oddsValue';
    }
    return '$oddsValue';
  }
  
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) {
      return Colors.green;
    } else if (confidence >= 65) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  
  IconData _getSportIcon(String sportKey) {
    if (sportKey.contains('basketball')) {
      return Icons.sports_basketball;
    } else if (sportKey.contains('football') || sportKey.contains('nfl')) {
      return Icons.sports_football;
    } else if (sportKey.contains('baseball') || sportKey.contains('mlb')) {
      return Icons.sports_baseball;
    } else if (sportKey.contains('hockey') || sportKey.contains('nhl')) {
      return Icons.sports_hockey;
    } else if (sportKey.contains('soccer')) {
      return Icons.sports_soccer;
    } else {
      return Icons.sports;
    }
  }

  // Helper methods are now only needed within the SystemSelector component
}
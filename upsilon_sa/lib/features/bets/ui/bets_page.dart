// lib/features/bets/ui/bets_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/features/bets/bloc/bets_bloc.dart';
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'package:upsilon_sa/features/bets/repository/bets_repository.dart';
import 'package:upsilon_sa/features/systems_creation/models/system_model.dart';
import 'package:upsilon_sa/features/systems_creation/repositories/systems_creation_repository.dart';
import 'components/bet_card.dart';
import 'components/sport_selector.dart';
import 'components/system_selector.dart';
import 'components/applied_system_indicator.dart';

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
  const _BetsPageContent({super.key});

  @override
  State<_BetsPageContent> createState() => _BetsPageContentState();
}

class _BetsPageContentState extends State<_BetsPageContent> {
  final TextEditingController _searchController = TextEditingController();
  final SystemsCreationRepository _systemsRepository = SystemsCreationRepository();
  List<SystemModel> _systems = [];
  List<SystemModel> _filteredSystems = [];
  SystemModel? _selectedSystem;
  String _selectedSport = 'basketball_nba';

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
          id: 'neural-alpha',
          name: 'Neural Alpha v2.4',
          sport: 'basketball_nba',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
          confidence: 0.87,
        ),
        SystemModel(
          id: 'momentum-tracker',
          name: 'Momentum Tracker',
          sport: 'basketball_nba',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          confidence: 0.76,
        ),
        SystemModel(
          id: 'quantum-delta',
          name: 'Quantum Delta',
          sport: 'basketball_nba',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          confidence: 0.92,
        ),
        SystemModel(
          id: 'beta-protocol',
          name: 'Beta Protocol',
          sport: 'americanfootball_nfl',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 21)),
          confidence: 0.81,
        ),
        SystemModel(
          id: 'genesis-analytics',
          name: 'Genesis Analytics',
          sport: 'baseball_mlb',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          confidence: 0.79,
        ),
        SystemModel(
          id: 'ice-predictor',
          name: 'Ice Predictor',
          sport: 'icehockey_nhl',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          confidence: 0.83,
        ),
        SystemModel(
          id: 'goal-analyzer',
          name: 'Goal Analyzer Pro',
          sport: 'soccer_epl',
          factors: [],
          createdAt: DateTime.now().subtract(const Duration(days: 9)),
          confidence: 0.84,
        ),
      ];
      setState(() {
        _systems = mockSystems;
        _filterSystemsBySport();
      });
    } else {
      setState(() {
        _systems = systems;
        _filterSystemsBySport();
      });
    }
  }
  
  void _filterSystemsBySport() {
    setState(() {
      _filteredSystems = _systems.where((system) => system.sport == _selectedSport).toList();
      // Clear selected system if it doesn't belong to the currently selected sport
      if (_selectedSystem != null && _selectedSystem!.sport != _selectedSport) {
        _selectedSystem = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PulsingDot(),
            const SizedBox(width: 10),
            Text(
              "AVAILABLE BETS",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.analytics_outlined,
              color: primaryColor,
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
              constraints: BoxConstraints(
                maxWidth: isWebPlatform ? 800 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildSportSelector(),
                    const SizedBox(height: 16),
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
      // Position the floating action button appropriately based on platform
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: isWebPlatform ? 20.0 : 0.0,
          right: isWebPlatform ? 20.0 : 0.0,
        ),
        child: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildSportSelector() {
    return SportSelector(
      selectedSport: _selectedSport,
      onSportSelected: (sportId) {
        setState(() {
          _selectedSport = sportId;
          _filterSystemsBySport();
        });
        // Update bets list with new sport
        BlocProvider.of<BetsBloc>(context).add(LoadBets(sport: sportId));
      },
    );
  }

  Widget _buildSystemSelector() {
    return SystemSelector(
      systems: _filteredSystems,
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
    const bool isWebPlatform = kIsWeb;
    
    return BlocBuilder<BetsBloc, BetsState>(
      builder: (context, state) {
        if (state is BetsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is BetsLoaded) {
          if (state.filteredBets.isEmpty) {
            return Center(
              child: Text(
                'No bets found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: isWebPlatform ? 20 : 18,
                ),
              ),
            );
          }
          
          // Use a more web-friendly layout for the list
          return ListView.builder(
            itemCount: state.filteredBets.length,
            itemBuilder: (context, index) {
              final bet = state.filteredBets[index];
              return BetCard(
                bet: bet,
                appliedSystem: state.appliedSystem,
                onBetSelected: (bet) {
                  // Handle bet selection
                  _showBetDetailsDialog(bet);
                },
              );
            },
          );
        } else if (state is BetsError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: TextStyle(
                color: Colors.red,
                fontSize: isWebPlatform ? 20 : 18,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return BlocBuilder<BetsBloc, BetsState>(
      builder: (context, state) {
        if (state is BetsLoaded) {
          return GlowingActionButton(
            onPressed: () {
              _showSystemsDialog();
            },
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, size: 20, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  state.appliedSystem == null
                      ? 'APPLY SYSTEM'
                      : 'CHANGE SYSTEM',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showBetDetailsDialog(Bet bet) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    final dialogWidth = isWebPlatform ? 400.0 : null;
    
    // Implement a dialog to show more details about the bet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          '${bet.homeTeam} vs ${bet.awayTeam}',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: dialogWidth,
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
            child: Text(
              'CLOSE',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logic to place a bet
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
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

  void _showSystemsDialog() async {
    if (_systems.isEmpty) {
      await _loadSystems();
    }
    
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    final dialogWidth = isWebPlatform ? 400.0 : null;

    // Sport mappings for display
    final sportLabels = {
      'basketball_nba': 'NBA',
      'americanfootball_nfl': 'NFL',
      'baseball_mlb': 'MLB',
      'icehockey_nhl': 'NHL',
      'soccer_epl': 'Soccer',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'APPLY SYSTEM',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: dialogWidth,
          child: SizedBox(
            width: double.maxFinite,
            child: _filteredSystems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'No systems found for ${sportLabels[_selectedSport] ?? _selectedSport}. Create a system for this sport.',
                        style: TextStyle(color: primaryColor.withOpacity(0.7)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/systems_creation');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('CREATE SYSTEM'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredSystems.length,
                  itemBuilder: (context, index) {
                    final system = _filteredSystems[index];
                    return ListTile(
                      title: Text(
                        system.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Confidence: ${(system.confidence * 100).toStringAsFixed(1)}%',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                      ),
                      leading: Icon(
                        Icons.memory,
                        color: primaryColor,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedSystem = system;
                        });
                        Navigator.pop(context);
                        BlocProvider.of<BetsBloc>(context)
                            .add(ApplySystem(systemId: system.name));
                      },
                    );
                  },
                ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
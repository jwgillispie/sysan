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
              constraints: const BoxConstraints(
                maxWidth: isWebPlatform ? 800 : double.infinity,
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
              return CompactBetCard(
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
              style: const TextStyle(
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

  // Floating action button removed

  void _showBetDetailsDialog(Bet bet) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    const dialogWidth = isWebPlatform ? 400.0 : null;
    final currentState = BlocProvider.of<BetsBloc>(context).state;
    final hasSystemApplied = currentState is BetsLoaded && currentState.appliedSystem != null;
    
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
          if (hasSystemApplied) 
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSystemPerformanceDialog(bet);
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

  // Helper methods are now only needed within the SystemSelector component
}
// lib/features/bets/ui/bets_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/features/bets/bloc/bets_bloc.dart';
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'package:upsilon_sa/features/bets/repository/bets_repository.dart';
import 'components/bet_card.dart';
import 'components/filter_section.dart';
import 'components/bet_type_selector.dart';
import 'components/applied_system_indicator.dart';

class BetsPage extends StatelessWidget {
  const BetsPage({Key? key}) : super(key: key);

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
  const _BetsPageContent({Key? key}) : super(key: key);

  @override
  State<_BetsPageContent> createState() => _BetsPageContentState();
}

class _BetsPageContentState extends State<_BetsPageContent> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedBetType = 'moneyline';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildFilterSection(),
                const SizedBox(height: 20),
                _buildBetTypeSelector(),
                const SizedBox(height: 10),
                _buildAppliedSystemIndicator(),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildBetsList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFilterSection() {
    return FilterSection(
      searchController: _searchController,
      onSortChanged: (sort) {
        BlocProvider.of<BetsBloc>(context).add(SortBets(sort: sort));
      },
    );
  }

  Widget _buildBetTypeSelector() {
    return BlocBuilder<BetsBloc, BetsState>(
      builder: (context, state) {
        if (state is BetsLoaded) {
          _selectedBetType = state.selectedBetType;
        }
        return BetTypeSelector(
          selectedType: _selectedBetType,
          onTypeSelected: (type) {
            BlocProvider.of<BetsBloc>(context).add(SelectBetType(betType: type));
          },
        );
      },
    );
  }

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
            return Center(
              child: Text(
                'No bets found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.filteredBets.length,
            itemBuilder: (context, index) {
              final bet = state.filteredBets[index];
              return BetCard(
                bet: bet,
                selectedBetType: state.selectedBetType,
                appliedSystem: state.appliedSystem,
                onBetSelected: (bet) {
                  // Handle bet selection
                  // You could navigate to a detail page or show a dialog
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
                fontSize: 18,
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
                const Icon(Icons.add, size: 20),
                const SizedBox(width: 8),
                Text(
                  state.appliedSystem == null
                      ? 'APPLY SYSTEM'
                      : 'CHANGE SYSTEM',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
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
    // Implement a dialog to show more details about the bet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          '${bet.homeTeam} vs ${bet.awayTeam}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logic to place a bet
            },
            child: Text(
              'PLACE BET',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSystemsDialog() {
    // Mock data for available systems
    final systems = [
      {'id': 'system1', 'name': 'Neural Alpha'},
      {'id': 'system2', 'name': 'Beta Protocol'},
      {'id': 'system3', 'name': 'Quantum System'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'APPLY SYSTEM',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: systems.length,
            itemBuilder: (context, index) {
              final system = systems[index];
              return ListTile(
                title: Text(
                  system['name']!,
                  style: const TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.memory,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<BetsBloc>(context)
                      .add(ApplySystem(systemId: system['name']!));
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
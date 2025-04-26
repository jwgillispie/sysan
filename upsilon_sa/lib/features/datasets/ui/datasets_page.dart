// lib/features/datasets/ui/datasets_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_bloc.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_event.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_state.dart';
import 'package:upsilon_sa/features/datasets/ui/components/filter_bar.dart';
import 'package:upsilon_sa/features/datasets/ui/components/player_list.dart';
import 'package:upsilon_sa/features/datasets/ui/components/team_list.dart';

class DatasetsPage extends StatefulWidget {
  @override
  State<DatasetsPage> createState() => _DatasetsPageState();
}

class _DatasetsPageState extends State<DatasetsPage> {
  late DatasetsBloc datasetsBloc;

  @override
  void initState() {
    super.initState();
    datasetsBloc = DatasetsBloc();
    // Initial data load is now handled in the bloc's constructor
  }

  @override
  void dispose() {
    datasetsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => datasetsBloc,
      child: BlocConsumer<DatasetsBloc, DatasetsState>(
        listener: (context, state) {
          if (state is DatasetsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          List<String> availableSports = [];
          List<String> availableTeams = [];
          String selectedSport = '';
          String selectedTeam = '';

          if (state is PlayersLoadedState) {
            availableSports = state.availableSports;
            availableTeams = state.availableTeams;
            selectedSport = state.selectedSport;
            selectedTeam = state.selectedTeam;
          } else if (state is TeamsLoadedState) {
            availableSports = state.availableSports;
            selectedSport = state.selectedSport;
          }

          return Scaffold(
            backgroundColor: Colors.black,
            appBar: _buildAppBar(),
            body: Stack(
              children: [
                const CyberGrid(),
                Column(
                  children: [
                    FilterBar(
                      selectedSport: selectedSport,
                      selectedTeam: selectedTeam,
                      onSportChanged: (sport) {
                        datasetsBloc.add(FilterSportChangedEvent(sport));
                      },
                      onTeamChanged: (team) {
                        datasetsBloc.add(FilterTeamChangedEvent(team));
                      },
                      availableSports: availableSports,
                      availableTeams: availableTeams,
                    ),
                    Expanded(
                      child: _buildContent(state),
                    ),
                  ],
                ),
                if (state is DatasetsLoadingState)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PulsingDot(),
          const SizedBox(width: 10),
          Text(
            "DATASETS",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent(DatasetsState state) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              children: [
                PlayerList(state: state),
                TeamList(state: state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.black,
      child: TabBar(
        tabs: const [
          Tab(
            icon: Icon(Icons.person),
            text: 'PLAYERS',
          ),
          Tab(
            icon: Icon(Icons.group),
            text: 'TEAMS',
          ),
        ],
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey,
      ),
    );
  }
}
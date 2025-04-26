// lib/features/systems_creation/ui/systems_creation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/core/config/constants.dart';
import 'package:upsilon_sa/features/systems_creation/bloc/system_creation_bloc.dart';
import 'package:upsilon_sa/features/systems_creation/bloc/system_creation_event.dart';
import 'package:upsilon_sa/features/systems_creation/bloc/system_creation_state.dart';
import '../models/factor_model.dart';

class SystemCreationPage extends StatelessWidget {
  const SystemCreationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SystemsCreationBloc(),
      child: const _SystemCreationView(),
    );
  }
}

class _SystemCreationView extends StatefulWidget {
  const _SystemCreationView({Key? key}) : super(key: key);

  @override
  State<_SystemCreationView> createState() => _SystemCreationViewState();
}

class _SystemCreationViewState extends State<_SystemCreationView>
    with SingleTickerProviderStateMixin {
  final _systemNameController = TextEditingController();
  final List<String> _sports = ['NBA', 'NFL', 'MLB', 'NHL'];

  // Sample predefined factors - in a real app, this would come from a repository
  static final List<Map<String, dynamic>> availableFactors = [
    {
      'id': 1,
      'name': 'Points Per Game',
      'category': 'Offense',
      'unit': 'points'
    },
    {'id': 2, 'name': 'Field Goal %', 'category': 'Offense', 'unit': '%'},
    {'id': 3, 'name': 'Three Point %', 'category': 'Offense', 'unit': '%'},
    {'id': 4, 'name': 'Free Throw %', 'category': 'Offense', 'unit': '%'},
    {
      'id': 5,
      'name': 'Rebounds Per Game',
      'category': 'Defense',
      'unit': 'rebounds'
    },
    {
      'id': 6,
      'name': 'Assists Per Game',
      'category': 'Offense',
      'unit': 'assists'
    },
    {
      'id': 7,
      'name': 'Steals Per Game',
      'category': 'Defense',
      'unit': 'steals'
    },
    {
      'id': 8,
      'name': 'Blocks Per Game',
      'category': 'Defense',
      'unit': 'blocks'
    },
    {
      'id': 9,
      'name': 'Turnovers Per Game',
      'category': 'Offense',
      'unit': 'turnovers'
    },
    {
      'id': 10,
      'name': 'Player Efficiency Rating',
      'category': 'Advanced',
      'unit': 'rating'
    },
    {'id': 11, 'name': 'True Shooting %', 'category': 'Advanced', 'unit': '%'},
    {'id': 12, 'name': 'Win Shares', 'category': 'Advanced', 'unit': 'WS'},
    {'id': 13, 'name': 'Box Plus/Minus', 'category': 'Advanced', 'unit': 'BPM'},
    {
      'id': 14,
      'name': 'Value Over Replacement',
      'category': 'Advanced',
      'unit': 'VORP'
    },
    {'id': 15, 'name': 'Team Pace', 'category': 'Team', 'unit': 'possessions'},
    {
      'id': 16,
      'name': 'Team Offensive Rating',
      'category': 'Team',
      'unit': 'ORTG'
    },
    {
      'id': 17,
      'name': 'Team Defensive Rating',
      'category': 'Team',
      'unit': 'DRTG'
    },
    {'id': 18, 'name': 'Net Rating', 'category': 'Team', 'unit': 'NetRTG'},
    {
      'id': 19,
      'name': 'Home Court Advantage',
      'category': 'Context',
      'unit': 'points'
    },
    {'id': 20, 'name': 'Days of Rest', 'category': 'Context', 'unit': 'days'},
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: UIConstants.longAnimationDuration,
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _systemNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocConsumer<SystemsCreationBloc, SystemsCreationState>(
      listener: (context, state) {
        if (state.status == SystemsCreationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('System created successfully!'),
              backgroundColor: primaryColor,
            ),
          );
        } else if (state.status == SystemsCreationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to create system'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(context),
          body: Stack(
            children: [
              const CyberGrid(),
              _buildContent(context, state),
              _buildCreateButton(context, state),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PulsingDot(),
          const SizedBox(width: 10),
          Text(
            "SYSTEM CREATION",
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

  Widget _buildContent(BuildContext context, SystemsCreationState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // System Configuration Section
          _buildConfigurationSection(context, state),

          const SizedBox(height: 24),

          // Factors Section
          _buildFactorsSection(context, state),

          // Add space at the bottom for the floating create button
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildConfigurationSection(
      BuildContext context, SystemsCreationState state) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'SYSTEM CONFIGURATION',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // System Name Input
            TextField(
              controller: _systemNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'System Name',
                labelStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.money_rounded,
                  color: primaryColor,
                ),
              ),
              onChanged: (value) {
                context
                    .read<SystemsCreationBloc>()
                    .add(SystemNameChanged(value));
              },
            ),

            const SizedBox(height: 16),

            // Sport Selection Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: state.selectedSport,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: primaryColor,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (String? value) {
                    if (value != null) {
                      context
                          .read<SystemsCreationBloc>()
                          .add(SportChanged(value));
                    }
                  },
                  items: _sports.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text('Sport/League',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorsSection(
      BuildContext context, SystemsCreationState state) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.psychology,
                color: primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'SYSTEM FACTORS',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Factors list
          state.factors.isEmpty
              ? _buildEmptyFactorsPrompt(context)
              : Column(
                  children: state.factors
                      .map((factor) => _buildFactorCard(context, factor))
                      .toList(),
                ),

          const SizedBox(height: 16),

          // Add Factor Button
          GestureDetector(
            onTap: () {
              context.read<SystemsCreationBloc>().add(const AddFactor());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ADD FACTOR',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFactorsPrompt(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.psychology_outlined,
            color: primaryColor.withOpacity(0.7),
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Add factors to your system',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Factors determine which statistics are used to make predictions',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
Widget _buildFactorCard(BuildContext context, Factor factor) {
  final primaryColor = Theme.of(context).colorScheme.primary;
  
  // Find the category and unit for the current factor
  String currentCategory = 'Unknown';
  String currentUnit = '';
  for (var f in availableFactors) {
    if (f['name'] == factor.name) {
      currentCategory = f['category'];
      currentUnit = f['unit'] ?? '';
      break;
    }
  }
  
  final categoryColor = _getCategoryColor(currentCategory);
  final thresholdDirection = factor.isAboveThreshold ? 'OVER' : 'UNDER';
  final directionColor = factor.isAboveThreshold ? Colors.green : Colors.red;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: primaryColor.withOpacity(0.3),
      ),
    ),
    child: Column(
      children: [
        // Factor header with search capability
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              // Remove button
              GestureDetector(
                onTap: () {
                  context.read<SystemsCreationBloc>().add(RemoveFactor(factor.id));
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Threshold direction indicator (new)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: directionColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: directionColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  thresholdDirection,
                  style: TextStyle(
                    color: directionColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              Expanded(
                child: Row(
                  children: [
                    // Factor name with category badge
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _showFactorSelectorForFactor(context, factor);
                        },
                        child: Row(
                          children: [
                            // Category indicator
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: categoryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                currentCategory,
                                style: TextStyle(
                                  color: categoryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Factor name
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      factor.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.search,
                                    color: primaryColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  context.read<SystemsCreationBloc>().add(ToggleFactorExpansion(factor.id));
                },
                child: Icon(
                  factor.expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),

        // Expanded content
        if (factor.expanded)
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Threshold direction toggle (new)
                Row(
                  children: [
                    Text(
                      'COMPARISON:',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        context.read<SystemsCreationBloc>().add(
                          ToggleFactorThresholdDirection(factor.id),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: directionColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: directionColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              factor.isAboveThreshold 
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                              color: directionColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              thresholdDirection,
                              style: TextStyle(
                                color: directionColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Threshold and Games Back inputs
                Row(
                  children: [
                    Expanded(
                      child: _buildParameterInput(
                        context,
                        label: 'THRESHOLD',
                        value: factor.threshold,
                        onChanged: (value) {
                          context.read<SystemsCreationBloc>().add(
                            UpdateFactorThreshold(factor.id, value),
                          );
                        },
                        unit: currentUnit,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildParameterInput(
                        context,
                        label: 'GAMES BACK',
                        value: factor.gamesBack,
                        onChanged: (value) {
                          context.read<SystemsCreationBloc>().add(
                            UpdateFactorGamesBack(factor.id, value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
  Widget _buildParameterInput(
    BuildContext context, {
    required String label,
    required int value,
    required Function(int) onChanged,
    String? unit, // Make unit optional
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final controller = TextEditingController(text: value.toString());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              if (unit != null && unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  '($unit)',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (text) {
                    final newValue = int.tryParse(text);
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      final newValue = value + 1;
                      controller.text = newValue.toString();
                      onChanged(newValue);
                    },
                    child: Icon(
                      Icons.arrow_drop_up,
                      color: primaryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (value > 1) {
                        final newValue = value - 1;
                        controller.text = newValue.toString();
                        onChanged(newValue);
                      }
                    },
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFactorSelectorForFactor(
      BuildContext context, Factor currentFactor) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final TextEditingController searchController = TextEditingController();
    List<Map<String, dynamic>> filteredFactors = [...availableFactors];
    final bloc = context.read<SystemsCreationBloc>(); // Get the bloc here

    // Group factors by category for better organization
    Map<String, List<Map<String, dynamic>>> groupedFactors = {};
    for (var factor in availableFactors) {
      String category = factor['category'] as String;
      if (!groupedFactors.containsKey(category)) {
        groupedFactors[category] = [];
      }
      groupedFactors[category]!.add(factor);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.psychology,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SELECT FACTOR',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search field
                    TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search factors',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: primaryColor.withOpacity(0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: primaryColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            filteredFactors = [...availableFactors];
                          } else {
                            filteredFactors = availableFactors
                                .where((factor) =>
                                    factor['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    factor['category']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Factors list
                    SizedBox(
                      height: 300,
                      child: searchController.text.isEmpty
                          // Organized by category when not searching
                          ? ListView.builder(
                              itemCount: groupedFactors.keys.length,
                              itemBuilder: (context, categoryIndex) {
                                String category = groupedFactors.keys
                                    .elementAt(categoryIndex);
                                List<Map<String, dynamic>> categoryFactors =
                                    groupedFactors[category]!;
                                Color categoryColor =
                                    _getCategoryColor(category);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Category header
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 8, top: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: categoryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        category.toUpperCase(),
                                        style: TextStyle(
                                          color: categoryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Category factors
                                    ...categoryFactors
                                        .map((factor) => _buildFactorItem(
                                              context,
                                              factor,
                                              currentFactor,
                                              primaryColor,
                                              bloc, // Pass the bloc here
                                            )),
                                  ],
                                );
                              })
                          // Flat list when searching
                          : filteredFactors.isEmpty
                              ? Center(
                                  child: Text(
                                    'No factors found',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredFactors.length,
                                  itemBuilder: (context, index) {
                                    return _buildFactorItem(
                                      context,
                                      filteredFactors[index],
                                      currentFactor,
                                      primaryColor,
                                      bloc, // Pass the bloc here
                                    );
                                  },
                                ),
                    ),

                    const SizedBox(height: 16),

                    // Cancel button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFactorItem(
    BuildContext context,
    Map<String, dynamic> factor,
    Factor currentFactor,
    Color primaryColor,
    SystemsCreationBloc bloc,
  ) {
    final String factorName = factor['name'];
    final String unit = factor['unit'] ?? ''; // Get unit from factor
    final bool isSelected = currentFactor.name == factorName;
    final categoryColor = _getCategoryColor(factor['category']);

    return InkWell(
      onTap: () {
        bloc.add(
          UpdateFactorName(
            currentFactor.id,
            factorName,
            unit, // Pass unit to the event
          ),
        );
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? primaryColor : primaryColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      factor['category'],
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      factorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: primaryColor,
                size: 20,
              )
            else
              Icon(
                Icons.add_circle_outline,
                color: primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Offense':
        return Colors.blue;
      case 'Defense':
        return Colors.red;
      case 'Advanced':
        return Colors.purple;
      case 'Team':
        return Colors.green;
      case 'Context':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
Widget _buildCreateButton(BuildContext context, SystemsCreationState state) {
  final primaryColor = Theme.of(context).colorScheme.primary;
  final mediaQuery = MediaQuery.of(context);
  final bottomPadding = mediaQuery.padding.bottom;

  return Positioned(
    bottom: 20 + bottomPadding,
    left: 20,
    right: 20,
    child: Row(
      children: [
        // First button - CREATE SYSTEM
        Expanded(
          flex: 1,
          child: GlowingActionButton(
            onPressed: () {
              context.read<SystemsCreationBloc>().add(const CreateSystem());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sync_alt,
                  color: Colors.white,
                  size: 16, // Slightly smaller icon
                ),
                const SizedBox(width: 4), // Smaller spacing
                Flexible(
                  child: Text(
                    state.status == SystemsCreationStatus.loading
                        ? 'CREATING...'
                        : 'CREATE',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Smaller text
                      letterSpacing: 0.5, // Less letter spacing
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 10),
        
        // Second button - TEST ON BETS
        Expanded(
          flex: 1,
          child: GlowingActionButton(
            onPressed: () {
              // Navigate to the bets page
              Navigator.pushNamed(context, '/bets');
            },
            color: Colors.blue, // Different color to distinguish
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 16, // Slightly smaller icon
                ),
                SizedBox(width: 4), // Smaller spacing
                Flexible(
                  child: Text(
                    'TEST BETS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Smaller text
                      letterSpacing: 0.5, // Less letter spacing
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}
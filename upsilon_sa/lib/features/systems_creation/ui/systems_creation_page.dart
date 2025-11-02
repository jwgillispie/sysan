// lib/features/systems_creation/ui/systems_creation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/core/config/constants.dart';
import 'package:upsilon_sa/core/widgets/custom_toast.dart';
import 'package:upsilon_sa/core/widgets/animated_button.dart';
import 'package:upsilon_sa/core/widgets/numeric_input_field.dart';
import 'package:upsilon_sa/features/systems_creation/bloc/system_creation_bloc.dart';
import 'package:upsilon_sa/features/systems_creation/bloc/system_creation_event.dart';
import 'package:upsilon_sa/features/systems_creation/bloc/system_creation_state.dart';
import '../models/factor_model.dart';
import 'tutorial_overlay.dart';

class SystemCreationPage extends StatelessWidget {
  const SystemCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SystemsCreationBloc(),
      child: const _SystemCreationView(),
    );
  }
}

class _SystemCreationView extends StatefulWidget {
  const _SystemCreationView();

  @override
  State<_SystemCreationView> createState() => _SystemCreationViewState();
}

class _SystemCreationViewState extends State<_SystemCreationView>
    with SingleTickerProviderStateMixin {
  final _systemNameController = TextEditingController();
  final List<String> _sports = ['NBA', 'NFL', 'MLB', 'NHL'];
  bool _showTutorial = false;

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

    return BlocConsumer<SystemsCreationBloc, SystemsCreationState>(
      listener: (context, state) {
        if (state.status == SystemsCreationStatus.success) {
          // Use CustomToast instead of SnackBar to avoid layout conflicts
          CustomToast.showSuccess(
            context, 
            'System created successfully!'
          );
        } else if (state.status == SystemsCreationStatus.failure) {
          // Use CustomToast for error messages too
          CustomToast.showError(
            context, 
            state.errorMessage ?? 'Failed to create system'
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
              // Tutorial overlay
              if (_showTutorial)
                TutorialOverlay(
                  onClose: () {
                    setState(() {
                      _showTutorial = false;
                    });
                  },
                ),
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
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {
              setState(() {
                _showTutorial = true;
              });
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            tooltip: 'Tutorial',
          ),
        ),
      ],
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

          // Add space at the bottom for better padding and visibility
          const SizedBox(height: 70),
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
            color: primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.1),
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
                    color: primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor.withValues(alpha: 0.3),
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
                  color: primaryColor.withValues(alpha: 0.3),
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

            const SizedBox(height: 16),

            // System Games Back Setting (moved under sports choice)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'GAMES BACK (APPLIES TO ALL FACTORS)',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Number of recent games to analyze for all factors in this system',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  NumericInputField(
                    value: state.systemGamesBack,
                    label: 'GAMES BACK',
                    primaryColor: primaryColor,
                    min: 1,
                    max: 82, // NBA season length
                    allowDecimals: false,
                    showLabel: false,
                    onChanged: (value) {
                      context.read<SystemsCreationBloc>().add(
                        UpdateSystemGamesBack(value.toInt()),
                      );
                    },
                  ),
                ],
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
          color: primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.1),
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
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
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
          
          const SizedBox(height: 20),
          
          // Create System Button with animations
          Center(
            child: AnimatedButton(
              text: 'FINISH',
              icon: Icons.add_circle,
              primaryColor: primaryColor,
              onTap: () {
                context.read<SystemsCreationBloc>().add(const CreateSystem());
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Test Bets Button with animations
          Center(
            child: AnimatedButton(
              text: 'TEST ON BETS',
              icon: Icons.check_circle_outline,
              primaryColor: Colors.blue,
              onTap: () {
                // Show confirmation toast and navigate to the bets page
                CustomToast.show(
                  context: context,
                  message: 'System ready for testing',
                  backgroundColor: Colors.blue,
                  icon: Icons.check_circle_outline,
                );
                
                // Navigate to the bets page after a short delay
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    Navigator.pushNamed(context, '/bets');
                  }
                });
              },
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
        color: primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.psychology_outlined,
            color: primaryColor.withValues(alpha: 0.7),
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Add factors to your system',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
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
          const SizedBox(height: 24),
          
          // Example cards to demonstrate how factors work
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXAMPLE FACTORS:',
                  style: TextStyle(
                    color: primaryColor, 
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Example factor items
                _buildExampleFactorItem(
                  context, 
                  'Points Per Game > 20', 
                  'Offense', 
                  Colors.blue, 
                  'Bet when a player is averaging more than 20 points per game'
                ),
                const SizedBox(height: 8),
                _buildExampleFactorItem(
                  context, 
                  'Field Goal % < 45%', 
                  'Shooting', 
                  Colors.green, 
                  'Bet when a team is shooting below 45% on average from the field'
                ),
                const SizedBox(height: 8),
                _buildExampleFactorItem(
                  context, 
                  'Team Pace > 105', 
                  'Team', 
                  Colors.purple, 
                  'Bet when the team plays at a high pace (more possessions)'
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          Text(
            'Click the "ADD FACTOR" button below to get started',
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildExampleFactorItem(
    BuildContext context, 
    String name, 
    String category, 
    Color categoryColor, 
    String description
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Category tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: categoryColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
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

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: primaryColor.withValues(alpha: 0.3),
      ),
    ),
    child: Column(
      children: [
        // Factor header with search capability
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
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
                    color: Colors.red.withValues(alpha: 0.1),
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
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  thresholdDirection,
                  style: const TextStyle(
                    color: Colors.green,
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
                                color: categoryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: categoryColor.withValues(alpha: 0.3),
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
          BlocBuilder<SystemsCreationBloc, SystemsCreationState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Compact factor settings in single column layout
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900]?.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Over/Under Slider
                      Row(
                        children: [
                          Text(
                            'COMPARISON',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (currentUnit.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '(${factor.name} in $currentUnit)',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 9,
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Simple over/under toggle
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (factor.isAboveThreshold) {
                                    context.read<SystemsCreationBloc>().add(
                                      ToggleFactorThresholdDirection(factor.id),
                                    );
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: !factor.isAboveThreshold
                                        ? Colors.green.withValues(alpha: 0.8)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'UNDER',
                                    style: TextStyle(
                                      color: !factor.isAboveThreshold ? Colors.white : Colors.grey[500],
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (!factor.isAboveThreshold) {
                                    context.read<SystemsCreationBloc>().add(
                                      ToggleFactorThresholdDirection(factor.id),
                                    );
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: factor.isAboveThreshold
                                        ? Colors.green.withValues(alpha: 0.8)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'OVER',
                                    style: TextStyle(
                                      color: factor.isAboveThreshold ? Colors.white : Colors.grey[500],
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Simplified threshold input with clear metric display
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${factor.name.toUpperCase()} ${factor.isAboveThreshold ? 'OVER' : 'UNDER'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _showThresholdHelpDialog(context, factor, state),
                            child: Icon(
                              Icons.help_outline,
                              color: primaryColor,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: NumericInputField(
                              value: factor.threshold,
                              label: 'THRESHOLD',
                              unit: currentUnit,
                              primaryColor: primaryColor,
                              min: currentUnit == '%' ? 0 : 1,
                              max: currentUnit == '%' ? 100 : 
                                   currentUnit == 'rating' ? 150 : 50,
                              allowDecimals: currentUnit == '%',
                              step: currentUnit == '%' ? 0.5 : 1,
                              showLabel: false,
                              onChanged: (value) {
                                context.read<SystemsCreationBloc>().add(
                                  UpdateFactorThreshold(factor.id, value.toDouble()),
                                );
                              },
                            ),
                          ),
                          if (currentUnit.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              currentUnit,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Games back (read-only)
                      Text(
                        'GAMES BACK',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[600]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.grey[500],
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${state.systemGamesBack} games',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      ],
    ),
  );
}
  // Removed _buildParameterInput - no longer needed with system-wide games back

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
                    color: primaryColor.withValues(alpha: 0.3),
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
                            color: primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: primaryColor.withValues(alpha: 0.3),
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
                                        color: categoryColor.withValues(alpha: 0.1),
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
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.3),
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
          color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.3),
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
                      color: categoryColor.withValues(alpha: 0.1),
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

  void _showThresholdHelpDialog(BuildContext context, Factor factor, SystemsCreationState state) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    String currentUnit = '';
    
    // Find the unit for the factor
    for (var f in availableFactors) {
      if (f['name'] == factor.name) {
        currentUnit = f['unit'] ?? '';
        break;
      }
    }
    
    final direction = factor.isAboveThreshold ? 'ABOVE' : 'BELOW';
    const directionColor = Colors.green;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: primaryColor, width: 1),
        ),
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: primaryColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              'THRESHOLD SETTINGS',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection(
              'What This Factor Does',
              'Your system will look for situations where ${factor.name} is $direction the threshold of ${factor.threshold}${currentUnit.isNotEmpty ? ' $currentUnit' : ''}.',
              Icons.info_outline
            ),
            
            const SizedBox(height: 16),
            
            _buildHelpSection(
              'Games Back (System-Wide)',
              'The system will analyze the last ${state.systemGamesBack} games to calculate the ${factor.name} statistic. This setting applies to ALL factors in your system.',
              Icons.history
            ),
            
            const SizedBox(height: 16),
            
            _buildHelpSection(
              'Threshold Direction',
              factor.isAboveThreshold
                  ? 'Currently set to trigger when values are ABOVE the threshold. This is good for positive stats like points, assists, etc.'
                  : 'Currently set to trigger when values are BELOW the threshold. This is good for negative stats like turnovers, missed shots, etc.',
              factor.isAboveThreshold ? Icons.trending_up : Icons.trending_down,
              color: directionColor
            ),
            
            const SizedBox(height: 16),
            
            _buildHelpSection(
              'Fine-Tuning Tips',
              '• Higher thresholds for ABOVE factors = more selective but fewer matches\n'
              '• Lower thresholds for BELOW factors = more selective but fewer matches\n'
              '• More games back = more stable but less responsive to recent trends',
              Icons.tune
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'GOT IT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHelpSection(String title, String content, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color != null ? color.withValues(alpha: 0.5) : Colors.grey[700]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color ?? Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: color ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
// The floating create button has been replaced with inline buttons in the UI
}
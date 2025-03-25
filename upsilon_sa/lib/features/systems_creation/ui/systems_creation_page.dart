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
  
  void _showFactorSearchDialog(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final TextEditingController searchController = TextEditingController();
    
    // Sample predefined factors - in a real app, this would come from a repository
    final List<Map<String, dynamic>> availableFactors = [
      {'id': 1, 'name': 'Points Per Game', 'category': 'Offense'},
      {'id': 2, 'name': 'Field Goal %', 'category': 'Offense'},
      {'id': 3, 'name': 'Three Point %', 'category': 'Offense'},
      {'id': 4, 'name': 'Free Throw %', 'category': 'Offense'},
      {'id': 5, 'name': 'Rebounds Per Game', 'category': 'Defense'},
      {'id': 6, 'name': 'Assists Per Game', 'category': 'Offense'},
      {'id': 7, 'name': 'Steals Per Game', 'category': 'Defense'},
      {'id': 8, 'name': 'Blocks Per Game', 'category': 'Defense'},
      {'id': 9, 'name': 'Turnovers Per Game', 'category': 'Offense'},
      {'id': 10, 'name': 'Player Efficiency Rating', 'category': 'Advanced'},
      {'id': 11, 'name': 'True Shooting %', 'category': 'Advanced'},
      {'id': 12, 'name': 'Win Shares', 'category': 'Advanced'},
      {'id': 13, 'name': 'Box Plus/Minus', 'category': 'Advanced'},
      {'id': 14, 'name': 'Value Over Replacement', 'category': 'Advanced'},
      {'id': 15, 'name': 'Team Pace', 'category': 'Team'},
      {'id': 16, 'name': 'Team Offensive Rating', 'category': 'Team'},
      {'id': 17, 'name': 'Team Defensive Rating', 'category': 'Team'},
      {'id': 18, 'name': 'Net Rating', 'category': 'Team'},
      {'id': 19, 'name': 'Home Court Advantage', 'category': 'Context'},
      {'id': 20, 'name': 'Days of Rest', 'category': 'Context'},
    ];
    
    List<Map<String, dynamic>> filteredFactors = [...availableFactors];
    
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
                          Icons.search,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SEARCH FACTORS',
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
                        hintText: 'Search by name or category',
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
                                    factor['name'].toString().toLowerCase().contains(value.toLowerCase()) ||
                                    factor['category'].toString().toLowerCase().contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Factors list
                    SizedBox(
                      height: 300,
                      child: filteredFactors.isEmpty
                          ? Center(
                              child: Text(
                                'No factors found',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredFactors.length,
                              itemBuilder: (context, index) {
                                final factor = filteredFactors[index];
                                return InkWell(
                                  onTap: () {
                                    // Add the selected factor
                                    context.read<SystemsCreationBloc>().add(const AddFactor());
                                    // Close the dialog
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                factor['name'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: _getCategoryColor(factor['category']).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  factor['category'],
                                                  style: TextStyle(
                                                    color: _getCategoryColor(factor['category']),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.add_circle_outline,
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Close button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'CLOSE',
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
}

class _SystemCreationView extends StatefulWidget {
  const _SystemCreationView({Key? key}) : super(key: key);

  @override
  State<_SystemCreationView> createState() => _SystemCreationViewState();
}

class _SystemCreationViewState extends State<_SystemCreationView> with SingleTickerProviderStateMixin {
  final _systemNameController = TextEditingController();
  final List<String> _sports = ['NBA', 'NFL', 'MLB', 'NHL'];
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: UIConstants.longAnimationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
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
  
  Widget _buildConfigurationSection(BuildContext context, SystemsCreationState state) {
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

  Widget _buildFactorsSection(BuildContext context, SystemsCreationState state) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
              // Search button
              GestureDetector(
                onTap: () {
                  _showFactorSearchDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.search,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Factors list
          ...state.factors.map((factor) => _buildFactorCard(context, factor)).toList(),
          
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

  Widget _buildFactorCard(BuildContext context, Factor factor) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
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
          // Factor header - always visible
          InkWell(
            onTap: () {
              context
                  .read<SystemsCreationBloc>()
                  .add(ToggleFactorExpansion(factor.id));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context
                          .read<SystemsCreationBloc>()
                          .add(RemoveFactor(factor.id));
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      factor.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    factor.expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content - only visible if expanded
          if (factor.expanded)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FACTOR WEIGHT',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: primaryColor,
                            inactiveTrackColor: primaryColor.withOpacity(0.2),
                            thumbColor: primaryColor,
                            overlayColor: primaryColor.withOpacity(0.1),
                          ),
                          child: Slider(
                            value: factor.weight,
                            min: 1,
                            max: 100,
                            divisions: 99,
                            onChanged: (value) {
                              context
                                  .read<SystemsCreationBloc>()
                                  .add(UpdateFactorWeight(factor.id, value));
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${factor.weight.toInt()}%',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildParameterInput(
                          context,
                          label: 'THRESHOLD',
                          value: factor.threshold,
                          onChanged: (value) {
                            context
                                .read<SystemsCreationBloc>()
                                .add(UpdateFactorThreshold(factor.id, value));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildParameterInput(
                          context,
                          label: 'GAMES BACK',
                          value: factor.gamesBack,
                          onChanged: (value) {
                            context
                                .read<SystemsCreationBloc>()
                                .add(UpdateFactorGamesBack(factor.id, value));
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
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
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
  void _showFactorSearchDialog(BuildContext context) {
  final primaryColor = Theme.of(context).colorScheme.primary;
  final TextEditingController searchController = TextEditingController();
  
  // Sample predefined factors - in a real app, this would come from a repository
  final List<Map<String, dynamic>> availableFactors = [
    {'id': 1, 'name': 'Points Per Game', 'category': 'Offense'},
    {'id': 2, 'name': 'Field Goal %', 'category': 'Offense'},
    {'id': 3, 'name': 'Three Point %', 'category': 'Offense'},
    {'id': 4, 'name': 'Free Throw %', 'category': 'Offense'},
    {'id': 5, 'name': 'Rebounds Per Game', 'category': 'Defense'},
    {'id': 6, 'name': 'Assists Per Game', 'category': 'Offense'},
    {'id': 7, 'name': 'Steals Per Game', 'category': 'Defense'},
    {'id': 8, 'name': 'Blocks Per Game', 'category': 'Defense'},
    {'id': 9, 'name': 'Turnovers Per Game', 'category': 'Offense'},
    {'id': 10, 'name': 'Player Efficiency Rating', 'category': 'Advanced'},
    {'id': 11, 'name': 'True Shooting %', 'category': 'Advanced'},
    {'id': 12, 'name': 'Win Shares', 'category': 'Advanced'},
    {'id': 13, 'name': 'Box Plus/Minus', 'category': 'Advanced'},
    {'id': 14, 'name': 'Value Over Replacement', 'category': 'Advanced'},
    {'id': 15, 'name': 'Team Pace', 'category': 'Team'},
    {'id': 16, 'name': 'Team Offensive Rating', 'category': 'Team'},
    {'id': 17, 'name': 'Team Defensive Rating', 'category': 'Team'},
    {'id': 18, 'name': 'Net Rating', 'category': 'Team'},
    {'id': 19, 'name': 'Home Court Advantage', 'category': 'Context'},
    {'id': 20, 'name': 'Days of Rest', 'category': 'Context'},
  ];
  
  List<Map<String, dynamic>> filteredFactors = [...availableFactors];
  
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
                        Icons.search,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SEARCH FACTORS',
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
                      hintText: 'Search by name or category',
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
                                  factor['name'].toString().toLowerCase().contains(value.toLowerCase()) ||
                                  factor['category'].toString().toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        }
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Factors list
                  SizedBox(
                    height: 300,
                    child: filteredFactors.isEmpty
                        ? Center(
                            child: Text(
                              'No factors found',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredFactors.length,
                            itemBuilder: (context, index) {
                              final factor = filteredFactors[index];
                              return InkWell(
                                onTap: () {
                                  // Add the selected factor
                                  context.read<SystemsCreationBloc>().add(const AddFactor());
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              factor['name'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: _getCategoryColor(factor['category']).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                factor['category'],
                                                style: TextStyle(
                                                  color: _getCategoryColor(factor['category']),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'CLOSE',
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
    
    return Positioned(
      bottom: 20,
      right: 20,
      left: 20,
      child: GlowingActionButton(
        onPressed: () {
          context.read<SystemsCreationBloc>().add(const CreateSystem());
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sync_alt,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              state.status == SystemsCreationStatus.loading 
                ? 'CREATING...' 
                : 'CREATE SYSTEM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
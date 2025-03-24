// lib/features/analytics/ui/systems_creation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/features/analytics/bloc/analytics_bloc.dart';
import 'package:upsilon_sa/features/analytics/bloc/analytics_event.dart';
import 'package:upsilon_sa/features/analytics/bloc/analytics_state.dart';
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

class _SystemCreationViewState extends State<_SystemCreationView> {
  final _systemNameController = TextEditingController();
  final List<String> _sports = ['NBA', 'NFL', 'MLB', 'NHL'];

  @override
  void dispose() {
    _systemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SystemsCreationBloc, SystemsCreationState>(
      listener: (context, state) {
        if (state.status == SystemsCreationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('System created successfully!'),
              backgroundColor: Color(0xFF09BF30),
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
          appBar: AppBar(
            title: const Text(
              'CREATE SYSTEM',
              style: TextStyle(
                color: Color(0xFF09BF30),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(
              color: Color(0xFF09BF30),
            ),
          ),
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // System Name Field
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF09BF30),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _systemNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Name of System',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      context
                          .read<SystemsCreationBloc>()
                          .add(SystemNameChanged(value));
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Sport Selection Dropdown
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF09BF30),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.black,
                      value: state.selectedSport,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF09BF30),
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

                // Factors List
                Expanded(
                  child: ListView.builder(
                    itemCount: state.factors.length,
                    itemBuilder: (context, index) {
                      final factor = state.factors[index];
                      return _buildFactorCard(factor);
                    },
                  ),
                ),

                // Add Factor Button
                TextButton(
                  onPressed: () {
                    context.read<SystemsCreationBloc>().add(const AddFactor());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF09BF30),
                    side: const BorderSide(color: Color(0xFF09BF30)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('+ Factor'),
                ),

                const SizedBox(height: 16),

                // Create System Button
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<SystemsCreationBloc>()
                        .add(const CreateSystem());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF09BF30),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: state.status == SystemsCreationStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Create System',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFactorCard(Factor factor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF09BF30),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
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
              color: const Color(0xFF09BF30).withOpacity(0.2),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  factor.name,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Icon(
                  factor.expanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: const Color(0xFF09BF30),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    context
                        .read<SystemsCreationBloc>()
                        .add(RemoveFactor(factor.id));
                  },
                ),
              ),
            ),
          ),

          // Expanded content - only visible if expanded
          if (factor.expanded)
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FACTOR WEIGHT',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: factor.weight,
                          min: 1,
                          max: 100,
                          divisions: 99,
                          activeColor: const Color(0xFF09BF30),
                          inactiveColor: const Color(0xFF09BF30).withOpacity(0.2),
                          onChanged: (value) {
                            context
                                .read<SystemsCreationBloc>()
                                .add(UpdateFactorWeight(factor.id, value));
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${factor.weight.toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF09BF30),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildThresholdInput(
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
                        child: _buildThresholdInput(
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

  Widget _buildThresholdInput({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    final controller = TextEditingController(text: value.toString());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
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
                    child: const Icon(
                      Icons.arrow_drop_up,
                      color: Color(0xFF09BF30),
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
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF09BF30),
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
}
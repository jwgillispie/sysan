// lib/features/datasets/ui/components/filter_bar.dart

import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String selectedSport;
  final String selectedTeam;
  final Function(String) onSportChanged;
  final Function(String) onTeamChanged;
  final List<String> availableSports;
  final List<String> availableTeams;

  const FilterBar({
    super.key,
    required this.selectedSport,
    required this.selectedTeam,
    required this.onSportChanged,
    required this.onTeamChanged,
    required this.availableSports,
    required this.availableTeams,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              context,
              icon: Icons.sports_basketball,
              value: selectedSport,
              items: availableSports,
              onChanged: onSportChanged,
              hint: 'Select Position',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdown(
              context,
              icon: Icons.group,
              value: selectedTeam,
              items: availableTeams,
              onChanged: onTeamChanged,
              hint: 'Select Team',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButton<String>(
        value: value.isEmpty ? null : value,
        hint: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              hint,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
        items: [
          DropdownMenuItem(
            value: '',
            child: Text(
              'All',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ...items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Colors.white),
            ),
          )),
        ],
        onChanged: (value) => onChanged(value ?? ''),
        dropdownColor: Colors.black,
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.primary,
        ),
        underline: const SizedBox(),
      ),
    );
  }
}
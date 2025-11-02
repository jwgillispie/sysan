// lib/features/bets/ui/components/system_selector.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/systems_creation/models/system_model.dart';

class SystemSelector extends StatelessWidget {
  final List<SystemModel> systems;
  final SystemModel? selectedSystem;
  final Function(String) onSystemSelected;

  const SystemSelector({
    super.key,
    required this.systems,
    this.selectedSystem,
    required this.onSystemSelected,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and info button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    selectedSystem != null ? 'ACTIVE SYSTEM' : 'SELECT SYSTEM',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Tooltip(
                message: 'Systems are prediction models you create to analyze bets',
                child: Icon(
                  Icons.info_outline,
                  color: primaryColor.withValues(alpha: 0.7),
                  size: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          if (systems.isEmpty)
            _buildEmptySystemsMessage(context)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selected system or compact system selector
                if (selectedSystem != null)
                  // Show the selected system with a change button
                  _buildSelectedSystemDisplay(context)
                else
                  // Compact system selector
                  _buildCompactSystemSelector(context),
              ],
            ),
        ],
      ),
    );
  }
  
  // New method to display the currently selected system
  Widget _buildSelectedSystemDisplay(BuildContext context) {
    final system = selectedSystem!;
    
    return Row(
      children: [
        // Selected system button
        Expanded(
          child: _buildSystemButton(
            context,
            system,
            true,
            () {}, // No action on tap since it's already selected
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Change system button
        InkWell(
          onTap: () {
            // Use a dropdown menu or dialog to change the system
            showDialog(
              context: context,
              builder: (context) => _buildSystemSelectionDialog(context),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swap_horiz,
                  color: Colors.blue,
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  'CHANGE',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // New method for compact system selector with horizontal scrolling
  Widget _buildCompactSystemSelector(BuildContext context) {
    if (systems.length <= 3) {
      // For 3 or fewer systems, use a simple row
      return Row(
        children: [
          for (var system in systems) ...[
            Expanded(
              child: _buildSystemButton(
                context,
                system,
                selectedSystem?.id == system.id,
                () => onSystemSelected(system.id),
              ),
            ),
            if (system != systems.last)
              const SizedBox(width: 8),
          ],
        ],
      );
    } else {
      // For more systems, use a horizontal scrolling list
      return SizedBox(
        height: 34, // Fixed height for the horizontal list
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: systems.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final system = systems[index];
            return _buildSystemButton(
              context,
              system,
              selectedSystem?.id == system.id,
              () => onSystemSelected(system.id),
            );
          },
        ),
      );
    }
  }
  
  // New method to build a dialog for system selection
  Widget _buildSystemSelectionDialog(BuildContext context) {
    const primaryColor = Colors.blue;
    
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text(
        'SELECT SYSTEM',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var system in systems)
              ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getSportColor(system.sport).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _getSportIcon(system.sport),
                      color: _getSportColor(system.sport),
                      size: 14,
                    ),
                  ),
                ),
                title: Text(
                  system.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${_getSportLabel(system.sport)} • ${(system.confidence * 100).toStringAsFixed(0)}% Confidence',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                trailing: system.id == selectedSystem?.id
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    )
                  : null,
                onTap: () {
                  Navigator.pop(context);
                  onSystemSelected(system.id);
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'CANCEL',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySystemsMessage(BuildContext context) {
    const primaryColor = Colors.blue;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.psychology_outlined,
                color: primaryColor.withValues(alpha: 0.7),
                size: 16,
              ),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'No systems found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Create a system to analyze bets',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          
          // Create button
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/systems_creation');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: const Text(
                'CREATE',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemButton(
    BuildContext context,
    SystemModel system,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    const primaryColor = Colors.blue;
    
    // Get sport info for displaying the badge
    final sportIconData = _getSportIcon(system.sport);
    final sportColor = _getSportColor(system.sport);
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
            ? primaryColor.withValues(alpha: 0.3) 
            : primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected 
              ? primaryColor 
              : primaryColor.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 6,
              spreadRadius: -2,
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sport icon
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: sportColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  sportIconData,
                  color: sportColor,
                  size: 10,
                ),
              ),
            ),
            const SizedBox(width: 6),
            
            // System name
            Flexible(
              child: Text(
                system.name,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(width: 4),
            
            // Confidence indicator (only show percentage)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: _getConfidenceColor(system.confidence).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(system.confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: _getConfidenceColor(system.confidence),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Check icon for selected system
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 12,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Helper methods to get sport information
  String _getSportLabel(String sportId) {
    final sportLabels = {
      'basketball_nba': 'NBA',
      'americanfootball_nfl': 'NFL',
      'baseball_mlb': 'MLB',
      'icehockey_nhl': 'NHL',
      'soccer_epl': 'Soccer',
    };
    return sportLabels[sportId] ?? sportId;
  }
  
  IconData _getSportIcon(String sportId) {
    final sportIcons = {
      'basketball_nba': Icons.sports_basketball,
      'americanfootball_nfl': Icons.sports_football,
      'baseball_mlb': Icons.sports_baseball,
      'icehockey_nhl': Icons.sports_hockey,
      'soccer_epl': Icons.sports_soccer,
    };
    return sportIcons[sportId] ?? Icons.sports;
  }
  
  Color _getSportColor(String sportId) {
    final sportColors = {
      'basketball_nba': Colors.orange,
      'americanfootball_nfl': Colors.brown,
      'baseball_mlb': Colors.green,
      'icehockey_nhl': Colors.blue,
      'soccer_epl': Colors.red,
    };
    return sportColors[sportId] ?? Colors.grey;
  }
  
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.85) return Colors.green;
    if (confidence >= 0.7) return Colors.lightGreen;
    if (confidence >= 0.5) return Colors.yellow;
    return Colors.red;
  }
  }


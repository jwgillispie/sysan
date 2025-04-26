// lib/features/profile/ui/components/profile_header.dart

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileHeader({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            child: Text(
              userData['displayName'].substring(0, 1),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userData['displayName'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            userData['username'],
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat(context, 'Systems', userData['activeSystems'].toString()),
              _buildStat(context, 'Followers', userData['totalFollowers'].toString()),
              _buildStat(context, 'Win Rate', '${userData['avgWinRate']}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
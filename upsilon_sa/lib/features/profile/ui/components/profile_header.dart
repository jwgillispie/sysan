// lib/features/profile/ui/components/profile_header.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/auth/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final AppUser? user;
  final Map<String, dynamic>? userData;

  const ProfileHeader({
    super.key, 
    this.user,
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    // Use authenticated user data with fallbacks
    final displayName = user?.displayName ?? 'Systems User';
    final email = user?.email ?? 'user@example.com';
    final initials = displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : 'S';
    
    // Get stats from userData if available, otherwise use defaults
    final activeSystems = userData?['activeSystems']?.toString() ?? '0';
    final totalFollowers = userData?['totalFollowers']?.toString() ?? '0';
    final avgWinRate = userData?['avgWinRate']?.toString() ?? '0';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null
                ? Text(
                    initials,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          if (user?.emailVerified == false) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: const Text(
                'Email not verified',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat(context, 'Systems', activeSystems),
              _buildStat(context, 'Followers', totalFollowers),
              _buildStat(context, 'Win Rate', '$avgWinRate%'),
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
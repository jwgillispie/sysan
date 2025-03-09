// lib/features/social/components/systems_tab_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/features/social/bloc/social_bloc.dart';
import 'package:upsilon_sa/features/social/models/social_system.dart';

class SystemsTabView extends StatelessWidget {
  final TabController tabController;
  final SocialBloc socialBloc;

  const SystemsTabView({
    super.key,
    required this.tabController,
    required this.socialBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            color: Colors.black,
            child: TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: 'FRIENDS BEST'),
                Tab(text: 'WORLD BEST'),
              ],
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildSystemsList(context, true),
                _buildSystemsList(context, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemsList(BuildContext context, bool isFriends) {
    return BlocBuilder<SocialBloc, SocialState>(
      bloc: socialBloc,
      builder: (context, state) {
        if (state is SocialLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<SocialSystem> systems = [];
        if (isFriends && state is FriendsSystemsLoaded) {
          systems = state.systems;
        } else if (!isFriends && state is WorldSystemsLoaded) {
          systems = state.systems;
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: systems.length,
          itemBuilder: (context, index) {
            return _buildSystemCard(context, systems[index]);
          },
        );
      },
    );
  }

  Widget _buildSystemCard(BuildContext context, SocialSystem system) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                system.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${system.winRate}%',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            system.username,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
            ),
          ),
          if (system.description != null) ...[
            const SizedBox(height: 8),
            Text(
              system.description!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                context,
                Icons.share,
                'Share',
                () => socialBloc.add(ShareSystem(system.name)),
              ),
              _buildActionButton(
                context,
                Icons.star_border,
                'Follow',
                () => socialBloc.add(FollowSystem(system.name)),
              ),
              _buildActionButton(
                context,
                Icons.message_outlined,
                'Message',
                () {}, // TODO: Implement messaging
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

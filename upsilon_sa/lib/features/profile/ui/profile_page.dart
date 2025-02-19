// lib/features/profile/ui/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/features/profile/bloc/profile_bloc.dart';
import 'components/profile_header.dart';
import 'components/profile_systems.dart';
import 'components/profile_stats.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc _profileBloc = ProfileBloc();
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    _profileBloc
      ..add(LoadProfileEvent())
      ..add(LoadProfileSystemsEvent())
      ..add(LoadProfileStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _profileBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'PROFILE',
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
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                // TODO: Implement settings navigation
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            const CyberGrid(),
            MultiBlocListener(
              listeners: [
                BlocListener<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                ),
              ],
              child: RefreshIndicator(
                onRefresh: () async => _loadProfileData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state is ProfileLoading && _isInitialLoad) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (state is ProfileLoaded || _profileBloc.profileData != null) {
                              _isInitialLoad = false;
                              return ProfileHeader(userData: _profileBloc.profileData!);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        // const SizedBox(height: 24),
                        // BlocBuilder<ProfileBloc, ProfileState>(
                        //   builder: (context, state) {
                        //     if (_profileBloc.systemsData != null) {
                        //       return ProfileSystems(systems: _profileBloc.systemsData!);
                        //     }
                        //     return const SizedBox.shrink();
                        //   },
                        // ),
                        const SizedBox(height: 24),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (_profileBloc.statsData != null) {
                              return ProfileStats(stats: _profileBloc.statsData!);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }
}
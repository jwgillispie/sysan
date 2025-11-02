// lib/features/profile/ui/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid_painter.dart';
import 'package:upsilon_sa/features/profile/bloc/profile_bloc.dart';
import 'package:upsilon_sa/features/auth/bloc/auth_bloc.dart';
import 'package:upsilon_sa/features/auth/bloc/auth_event.dart';
import 'package:upsilon_sa/features/auth/bloc/auth_state.dart';
import 'package:upsilon_sa/core/config/themes.dart';
import 'components/profile_header.dart';
import 'components/profile_stats.dart';
import 'components/profile_subscription.dart';
import 'components/profile_roi_chart.dart';
import 'package:upsilon_sa/features/marketplace/widgets/stripe_connect_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
    _loadData();
  }

  void _loadData() {
    _profileBloc
      ..add(LoadProfileEvent())
      ..add(LoadProfileStatsEvent())
      ..add(LoadSubscriptionEvent());
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
              style: TextButton.styleFrom(
                foregroundColor: SystemsColors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
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
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
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
                // Navigate to settings
              },
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.primary,
              ),
              onSelected: (value) {
                if (value == 'logout') {
                  _showLogoutDialog(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: SystemsColors.red),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
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
                    } else if (state is SubscriptionUpdated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subscription updated successfully')),
                      );
                    } else if (state is SubscriptionCancelled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subscription cancelled')),
                      );
                    }
                  },
                ),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthUnauthenticated) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
              child: Stack(
                children: [
                  // Add an additional subtle cyber grid overlay with different spacing
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CyberGridPainter(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.03),
                        gridSpacing: 40,
                        lineWidth: 0.8,
                      ),
                    ),
                  ),
                  
                  // Content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Profile Header
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, authState) {
                              return BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, profileState) {
                                  final user = authState is AuthAuthenticated ? authState.user : null;
                                  
                                  if (profileState is ProfileLoaded || _profileBloc.profileData != null) {
                                    return ProfileHeader(
                                      user: user,
                                      userData: _profileBloc.profileData,
                                    );
                                  }
                                  
                                  // Show header with authenticated user data even if profile data is loading
                                  if (user != null) {
                                    return ProfileHeader(user: user);
                                  }
                                  
                                  return const SizedBox(
                                    height: 200,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                },
                              );
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Subscription Section (Condensed)
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              if (state is SubscriptionLoaded || _profileBloc.subscriptionData != null) {
                                return ProfileSubscription(subscriptionData: _profileBloc.subscriptionData!);
                              }
                              if (state is ProfileLoading) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          const SizedBox(height: 24),

                          // Stripe Connect Section
                          const StripeConnectWidget(),

                          const SizedBox(height: 24),

                          // Stats Section
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              if (state is ProfileStatsLoaded || _profileBloc.statsData != null) {
                                return ProfileStats(stats: _profileBloc.statsData!);
                              }
                              if (state is ProfileLoading) {
                                return const SizedBox(
                                  height: 150,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // ROI Chart Section
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              if (state is ProfileStatsLoaded || _profileBloc.statsData != null) {
                                // Convert the ROI data from the repository to FlSpot format
                                final List<dynamic> roiDataRaw = _profileBloc.statsData!['roiData'] ?? [];
                                final List<FlSpot> roiData = roiDataRaw
                                    .map((data) => FlSpot(
                                          data['x'].toDouble(),
                                          data['y'].toDouble(),
                                        ))
                                    .toList();
                                
                                return ProfileROIChart(roiData: roiData);
                              }
                              if (state is ProfileLoading) {
                                return const SizedBox(
                                  height: 300,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                  
                  // Loading overlay
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return Container(
                          color: Colors.black.withValues(alpha: 0.3),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
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

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }
}
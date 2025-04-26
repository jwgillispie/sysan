// lib/features/social/ui/social_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/features/social/bloc/social_bloc.dart';

import 'package:upsilon_sa/features/social/ui/components/social_search_bar.dart';
import 'package:upsilon_sa/features/social/ui/components/stories_section.dart';
import 'package:upsilon_sa/features/social/ui/components/systems_tab_view.dart';

import 'components/social_app_bar.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SocialBloc _socialBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _socialBloc = SocialBloc();
    
    // Load initial data
    _socialBloc.add(LoadFriendsSystems());
    _socialBloc.add(LoadStories());

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          _socialBloc.add(LoadFriendsSystems());
        } else {
          _socialBloc.add(LoadWorldSystems());
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _socialBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _socialBloc,
      child: BlocListener<SocialBloc, SocialState>(
        listener: (context, state) {
          if (state is SocialError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SystemFollowed || state is SystemUnfollowed) {
            final message = state is SystemFollowed ? 'System followed' : 'System unfollowed';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          } else if (state is SystemShared) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('System shared successfully')),
            );
          } else if (state is StoryPosted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Story posted successfully')),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: const SocialAppBar(),
          body: Stack(
            children: [
              const CyberGrid(),
              Column(
                children: [
                  const SocialSearchBar(),
                  BlocBuilder<SocialBloc, SocialState>(
                    builder: (context, state) {
                      if (state is StoriesLoaded) {
                        return StoriesSection(stories: state.stories);
                      }
                      return const StoriesSection(stories: []);
                    },
                  ),
                  SystemsTabView(
                    tabController: _tabController,
                    socialBloc: _socialBloc,
                  ),
                ],
              ),
              // Loading indicator
              BlocBuilder<SocialBloc, SocialState>(
                builder: (context, state) {
                  if (state is SocialLoading) {
                    return Container(
                      color: Colors.black54,
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
      ),
    );
  }
}
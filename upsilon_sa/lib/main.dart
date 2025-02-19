// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/core/widgets/nav_bar.dart';
import 'package:upsilon_sa/features/leaderboard/ui/leaderboard_page.dart';
import 'package:upsilon_sa/features/datasets/ui/datasets_page.dart';
import 'package:upsilon_sa/features/news/bloc/news_bloc.dart';
import 'package:upsilon_sa/features/systems/ui/systems_page.dart';
import 'package:upsilon_sa/features/home/bloc/home_bloc.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_bloc.dart';
import 'package:upsilon_sa/features/social/bloc/social_bloc.dart';
import 'package:upsilon_sa/features/home/ui/home_page.dart';
import 'core/config/themes.dart';

void main() {
  runApp(const SystemsAnalyticsApp());
}

class SystemsAnalyticsApp extends StatelessWidget {
  const SystemsAnalyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(),
        ),
        BlocProvider<DatasetsBloc>(
          create: (context) => DatasetsBloc(),
        ),
        BlocProvider<SocialBloc>(
          create: (context) => SocialBloc(),
        ),
      ],
      child: MaterialApp(
        title: "Systems Analytics",
        debugShowCheckedModeBanner: false,
        theme: SystemsThemes.lightTheme,
        darkTheme: SystemsThemes.darkTheme,
        themeMode: ThemeMode.dark,
        home: const SA(),
        routes: {
          '/home': (context) => const HomePage(),
          '/leaderboard': (context) => const LeaderboardPage(),
          '/systems': (context) => const SystemsPage(),
          '/datasets': (context) =>  DatasetsPage(),
        },
      ),
    );
  }
}

class SA extends StatefulWidget {
  const SA({super.key});

  @override
  State<SA> createState() => _SAState();
}
class _SAState extends State<SA> {
  final NavBar nb = NavBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is SystemsNavigateToLeaderboard) {
            Navigator.pushNamed(context, '/leaderboard');
          } else if (state is SystemsNavigateToSystems) {
            Navigator.pushNamed(context, '/systems');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Systems Analytics",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          bottomNavigationBar: nb.build(context),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeInitialState) {
                return const HomePage();
              }
              return const HomePage();
            },
          ),
        ),
      ),
    );
  }
}
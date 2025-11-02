// lib/main.dart
// Update the main function to load environment variables

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:upsilon_sa/core/widgets/nav_bar.dart';
import 'package:upsilon_sa/features/leaderboard/ui/leaderboard_page.dart';
import 'package:upsilon_sa/features/datasets/ui/datasets_page.dart';
import 'package:upsilon_sa/features/news/bloc/news_bloc.dart';
import 'package:upsilon_sa/features/systems/ui/systems_page.dart';
import 'package:upsilon_sa/features/home/bloc/home_bloc.dart';
import 'package:upsilon_sa/features/datasets/bloc/datasets_bloc.dart';
import 'package:upsilon_sa/features/social/bloc/social_bloc.dart';
import 'package:upsilon_sa/features/home/ui/home_page.dart';
import 'package:upsilon_sa/features/bets/ui/bets_page.dart';
import 'package:upsilon_sa/features/bets/bloc/bets_bloc.dart';
import 'package:upsilon_sa/features/bets/repository/bets_repository.dart';
import 'package:upsilon_sa/features/auth/bloc/auth_bloc.dart';
import 'package:upsilon_sa/features/auth/repository/auth_repository.dart';
import 'package:upsilon_sa/features/auth/ui/auth_wrapper.dart';
import 'package:upsilon_sa/features/auth/ui/login_page.dart';
import 'package:upsilon_sa/features/auth/ui/sign_up_page.dart';
import 'package:upsilon_sa/features/auth/bloc/auth_event.dart';
import 'package:upsilon_sa/features/landing/ui/landing_page.dart';
import 'package:upsilon_sa/core/utils/helpers.dart';
import 'core/config/themes.dart';
import 'firebase_options.dart';

// Create a global variable for API keys that will be populated at startup
Map<String, String> environmentVariables = {};

// Function to set up environment variables, including those provided via --dart-define
void setupEnvironmentVariables() {
  // Get the API key from dart-define if available
  final oddsApiKey = EnvironmentHelper.getEnvironmentValue('ODDS_API_KEY');
  
  // Add your API keys to the global map
  environmentVariables['ODDS_API_KEY'] = oddsApiKey.isNotEmpty 
      ? oddsApiKey 
      : 'YOUR_ODDS_API_KEY'; // Only use default if no value provided
  
  if (kDebugMode) {
    // Environment variables set up completed
    // ODDS_API_KEY: ${oddsApiKey.isEmpty ? "(using default)" : "(found key)"}
    EnvironmentHelper.debugPrintEnvironment();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    // First try to load from .env file (works on mobile)
    await dotenv.load(fileName: '.env');
    // Loaded environment from .env file
  } catch (e) {
    // Could not load .env file: $e
  }
  
  // Set up environment variables for web
  setupEnvironmentVariables();
  
  // Initialize Firebase using the generated options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Firebase initialized successfully
  } catch (e) {
    // Error initializing Firebase: $e
  }

  runApp(const SystemsAnalyticsApp());
}

class SystemsAnalyticsApp extends StatelessWidget {
  const SystemsAnalyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // If we're on web, only show the landing page
    // if (kIsWeb) {
    //   return MaterialApp(
    //     title: "Systems Analytics",
    //     debugShowCheckedModeBanner: false,
    //     theme: SystemsThemes.darkTheme,
    //     home: const LandingPage(),
    //   );
    // }

    // Otherwise, show the full mobile app with BLoC providers
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AuthCheckRequested()),
        ),
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
        BlocProvider<BetsBloc>(
          create: (context) => BetsBloc(
            repository: BetsRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: "Systems Analytics",
        debugShowCheckedModeBanner: false,
        theme: SystemsThemes.lightTheme,
        darkTheme: SystemsThemes.darkTheme,
        themeMode: ThemeMode.dark,
        home: const AuthWrapper(),
        routes: {
          '/home': (context) => const SA(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/landing': (context) => const LandingPage(),
          '/leaderboard': (context) => const LeaderboardPage(),
          '/systems': (context) => const SystemsPage(),
          '/datasets': (context) => const DatasetsPage(),
          '/bets': (context) => const BetsPage(),
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
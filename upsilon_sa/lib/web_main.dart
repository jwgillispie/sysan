import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upsilon_sa/features/landing/ui/landing_page.dart';

// This is the entry point for web specifically
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
      authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN',
          defaultValue: 'upsilon-sa.firebaseapp.com'),
      projectId: String.fromEnvironment('FIREBASE_PROJECT_ID',
          defaultValue: 'upsilon-sa'),
      storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET',
          defaultValue: 'upsilon-sa.appspot.com'),
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID',
          defaultValue: ''),
      appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: ''),
    ),
  );

  runApp(const LandingPageApp());
}

class LandingPageApp extends StatelessWidget {
  const LandingPageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Systems Analytics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF09BF30),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF09BF30),
          secondary: Color(0xFF2196F3),
          surface: Color(0xFF1E1E1E),
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LandingPage(),
    );
  }
}

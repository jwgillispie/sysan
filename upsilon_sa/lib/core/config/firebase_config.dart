import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  // Get API key from .env file or environment variables
  static String get apiKey {
    if (kIsWeb) {
      // For web, we need to handle it differently
      return const String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');
    }
    // For mobile, we can use dotenv directly
    return dotenv.env['FIREBASE_API_KEY'] ?? '';
  }

  // Get auth domain from .env file
  static String get authDomain {
    return dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'upsilon-sa.firebaseapp.com';
  }

  // Get project ID from .env file
  static String get projectId {
    return dotenv.env['FIREBASE_PROJECT_ID'] ?? 'upsilon-sa';
  }

  // Get storage bucket from .env file
  static String get storageBucket {
    return dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'upsilon-sa.appspot.com';
  }

  // Get messaging sender ID from .env file
  static String get messagingSenderId {
    if (kIsWeb) {
      return const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '');
    }
    return dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  }

  // Get app ID from .env file
  static String get appId {
    if (kIsWeb) {
      return const String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '');
    }
    return dotenv.env['FIREBASE_APP_ID'] ?? '';
  }
}
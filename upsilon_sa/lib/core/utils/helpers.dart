import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper class to get environment variables consistently across the app
class EnvironmentHelper {
  /// Get value from environment, handling both web and mobile scenarios
  static String getEnvironmentValue(String key, {String defaultValue = ''}) {
    if (kIsWeb) {
      // Use top-level consts declared with String.fromEnvironment for web
      switch (key) {
        case 'FIREBASE_API_KEY':
          return kFirebaseApiKey;
        case 'FIREBASE_PROJECT_ID':
          return kFirebaseProjectId;
        case 'FIREBASE_AUTH_DOMAIN':
          return kFirebaseAuthDomain;
        case 'FIREBASE_STORAGE_BUCKET':
          return kFirebaseStorageBucket;
        case 'FIREBASE_MESSAGING_SENDER_ID':
          return kFirebaseMessagingSenderId;
        case 'FIREBASE_APP_ID':
          return kFirebaseAppId;
        case 'ODDS_API_KEY':
          return kOddsApiKey;
        default:
          return dotenv.env[key] ?? defaultValue;
      }
    }

    // For mobile, use dotenv
    return dotenv.env[key] ?? defaultValue;
  }

  /// Print environment variables for debugging (do not use in production)
  static void debugPrintEnvironment() {
    if (kDebugMode) {
      print('FIREBASE_API_KEY: ${getEnvironmentValue('FIREBASE_API_KEY', defaultValue: 'not found')}');
      print('FIREBASE_PROJECT_ID: ${getEnvironmentValue('FIREBASE_PROJECT_ID', defaultValue: 'not found')}');
      print('ODDS_API_KEY: ${getEnvironmentValue('ODDS_API_KEY', defaultValue: 'not found')}');
      // Add more variables as needed
    }
  }
}

// Web-only top-level constants using `--dart-define`
const String kFirebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');
const String kFirebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');
const String kFirebaseAuthDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: '');
const String kFirebaseStorageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: '');
const String kFirebaseMessagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '');
const String kFirebaseAppId = String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '');
const String kOddsApiKey = String.fromEnvironment('ODDS_API_KEY', defaultValue: '');
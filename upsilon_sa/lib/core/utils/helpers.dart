// lib/core/utils/environment_helper.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper class to get environment variables consistently across the app
class EnvironmentHelper {
  /// Get value from environment, handling both web and mobile scenarios
  static String getEnvironmentValue(String key, {String defaultValue = ''}) {
    if (kIsWeb) {
      // For web, we try fromEnvironment first (for dart-define values)
      final webValue = String.fromEnvironment(key, defaultValue: '');
      if (webValue.isNotEmpty) {
        return webValue;
      }
      
      // Then fall back to dotenv (might work in some web scenarios)
      return dotenv.env[key] ?? defaultValue;
    }
    
    // For mobile, prioritize dotenv
    return dotenv.env[key] ?? defaultValue;
  }
  
  /// Print environment variables for debugging (do not use in production)
  static void debugPrintEnvironment() {
    if (kDebugMode) {
      print('FIREBASE_API_KEY: ${getEnvironmentValue('FIREBASE_API_KEY', defaultValue: 'not found')}');
      print('FIREBASE_PROJECT_ID: ${getEnvironmentValue('FIREBASE_PROJECT_ID', defaultValue: 'not found')}');
      // Add other variables as needed
    }
  }
}
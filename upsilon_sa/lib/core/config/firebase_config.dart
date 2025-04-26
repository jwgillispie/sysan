import 'package:upsilon_sa/core/utils/helpers.dart';

class FirebaseConfig {
  static String get apiKey => EnvironmentHelper.getEnvironmentValue('FIREBASE_API_KEY');
  static String get authDomain => EnvironmentHelper.getEnvironmentValue('FIREBASE_AUTH_DOMAIN', defaultValue: 'upsilon-sa.firebaseapp.com');
  static String get projectId => EnvironmentHelper.getEnvironmentValue('FIREBASE_PROJECT_ID', defaultValue: 'upsilon-sa');
  static String get storageBucket => EnvironmentHelper.getEnvironmentValue('FIREBASE_STORAGE_BUCKET', defaultValue: 'upsilon-sa.appspot.com');
  static String get messagingSenderId => EnvironmentHelper.getEnvironmentValue('FIREBASE_MESSAGING_SENDER_ID');
  static String get appId => EnvironmentHelper.getEnvironmentValue('FIREBASE_APP_ID');
}

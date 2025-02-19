// Path: lib/core/config/constants.dart

class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  static const Duration defaultTimeout = Duration(seconds: 30);
  
  // API Endpoints
  static const String playersEndpoint = '/players';
  static const String teamsEndpoint = '/teams';
  static const String systemsEndpoint = '/systems';
}

class UIConstants {
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Padding & Margins
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Border Radius
  static const double defaultBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  
  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 24.0;
  static const double largeIconSize = 32.0;
}

class SportCategories {
  static const List<String> all = [
    'ALL',
    'NBA',
    'NFL',
    'MLB',
    'NCAAB',
    'NCAAF',
  ];
}

class SystemStatuses {
  static const String active = 'ACTIVE';
  static const String inactive = 'INACTIVE';
  static const String pending = 'PENDING';
  static const String error = 'ERROR';
}
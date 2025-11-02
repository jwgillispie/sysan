import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemsColors {
  static const Color primary = Color(0xFF09BF30);
  static const Color secondary = Color(0xFF2196F3);
  static const Color accent = Color(0xFF00E5FF);
  static const Color red = Color(0xFFF44336);
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF1E1E1E);
  static const Color smokyGrey = Color(0xFF505050);
  static const Color white = Color(0xFFFFFFFF);
  
  // New sophisticated gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF09BF30),
      Color(0xFF00E676),
    ],
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1E1E),
      Color(0xFF2D2D2D),
    ],
  );
}

class SystemsDecorations {
  static BoxDecoration get whiteContainerShadow {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: SystemsColors.smokyGrey.withValues(alpha: 0.1), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.2),
          spreadRadius: 0,
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          spreadRadius: -5,
          blurRadius: 25,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration get darkContainerShadow {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1E1E1E),
          Color(0xFF2D2D2D),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          spreadRadius: 0,
          blurRadius: 20,
          offset: const Offset(0, 5),
        ),
        BoxShadow(
          color: SystemsColors.primary.withValues(alpha: 0.03),
          spreadRadius: 0,
          blurRadius: 10,
          offset: const Offset(0, -1),
        ),
      ],
    );
  }

  static BoxDecoration get glassContainer {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ],
    );
  }
}

class SystemsThemes {
  static TextTheme _customTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        letterSpacing: 0.2,
        height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      primaryColor: SystemsColors.primary,
      colorScheme: const ColorScheme.light(
        primary: SystemsColors.primary,
        secondary: SystemsColors.secondary,
        surface: Colors.white,
        error: SystemsColors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: SystemsColors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      textTheme: _customTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: SystemsColors.black,
        titleTextStyle: _customTextTheme(base.textTheme).titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: SystemsColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: SystemsColors.primary,
        secondary: SystemsColors.secondary,
        surface: Color(0xFF1E1E1E),
        error: SystemsColors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      textTheme: _customTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        titleTextStyle: _customTextTheme(base.textTheme).titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
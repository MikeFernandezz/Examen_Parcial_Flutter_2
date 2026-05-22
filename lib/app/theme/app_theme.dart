import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData build() {
    const seedColor = Color(0xFF0E5A6F);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        surface: const Color.fromARGB(255, 192, 218, 245),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 192, 218, 245),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0C2B33),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

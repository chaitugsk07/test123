import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  //Primary
  static const Color _lightPrimaryColor = Colors.white;
  static const Color _darkPrimaryColor = Colors.black;

  //Background
  static const Color _lightBackgroundColor = Colors.white;
  static const Color _darkBackgroundColor = Colors.black;

  //Text
  static const Color _lightTextColor = Colors.black;
  static const Color _darkTextColor = Colors.white;

  //Text
  static const Color _lightTileBackgroundColor = Colors.black;
  static const Color _darkTileBackgroundColor = Colors.white;

  //Text
  static const Color _lightSubTextColor = Colors.black87;
  static const Color _darkSubTextColor = Colors.white;

//Text themes
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 96, color: _lightTextColor),
    displayMedium: TextStyle(fontSize: 60, color: _lightTextColor),
    displaySmall: TextStyle(fontSize: 48, color: _lightTextColor),
    headlineMedium: TextStyle(fontSize: 34, color: _lightTextColor),
    headlineSmall: TextStyle(fontSize: 24, color: _lightTextColor),
    titleLarge: TextStyle(
      fontSize: 25,
      color: _lightTextColor,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto condensed',
    ),
    titleMedium: TextStyle(
      fontSize: 22,
      color: _lightSubTextColor,
      fontFamily: 'Roboto condensed',
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      color: _lightTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(fontSize: 22, color: _lightTextColor),
    bodyMedium: TextStyle(fontSize: 20, color: _lightSubTextColor),
    labelLarge: TextStyle(
      fontSize: 14,
      color: _lightTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(fontSize: 12, color: _lightTextColor),
    labelSmall: TextStyle(fontSize: 14, color: _lightTextColor),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 96, color: _darkTextColor),
    displayMedium: TextStyle(fontSize: 60, color: _darkTextColor),
    displaySmall: TextStyle(fontSize: 48, color: _darkTextColor),
    headlineMedium: TextStyle(fontSize: 34, color: _darkTextColor),
    headlineSmall: TextStyle(fontSize: 24, color: _darkTextColor),
    titleLarge: TextStyle(
      fontSize: 25,
      color: _darkTextColor,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto condensed',
    ),
    titleMedium: TextStyle(
      fontSize: 22,
      color: _darkSubTextColor,
      fontFamily: 'Roboto condensed',
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      color: _darkTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(fontSize: 22, color: _darkTextColor),
    bodyMedium: TextStyle(fontSize: 20, color: _darkSubTextColor),
    labelLarge: TextStyle(
      fontSize: 14,
      color: _darkTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(fontSize: 12, color: _darkTextColor),
    labelSmall: TextStyle(fontSize: 14, color: _darkTextColor),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    colorScheme: const ColorScheme.light(
      background: _lightBackgroundColor,
      onBackground: _lightTextColor,
      primary: _lightPrimaryColor,
      onPrimary: _lightTextColor,
      secondary: _lightTileBackgroundColor,
      onSecondary: _lightTextColor,
      surface: _lightBackgroundColor,
      onSurface: _lightTextColor,
    ),
    textTheme: _lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: _darkPrimaryColor,
    scaffoldBackgroundColor: _darkBackgroundColor,
    colorScheme: const ColorScheme.dark(
      background: _darkBackgroundColor,
      onBackground: _darkTextColor,
      primary: _darkPrimaryColor,
      onPrimary: _darkTextColor,
      secondary: _darkTileBackgroundColor,
      onSecondary: _darkTextColor,
      surface: _darkBackgroundColor,
      onSurface: _darkTextColor,
    ),
    textTheme: _darkTextTheme,
  );
}

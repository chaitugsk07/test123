import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rss1_v2/core/theme/bloc/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeHelper {
  static final bThemeBloc = BThemeBloc();

  static ThemeData currentTheme(BuildContext context) {
    return BlocProvider.of<BThemeBloc>(context).state.themeData;
  }
}

Future<void> saveThemeToPreferences(bool isLightTheme) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLightTheme', isLightTheme);
}

Future<bool> getThemeFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLightTheme') ?? true;
}

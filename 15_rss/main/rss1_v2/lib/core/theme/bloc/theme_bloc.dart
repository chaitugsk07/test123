// Define theme events and states
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rss1_v2/core/theme/app_themes.dart';
import 'package:rss1_v2/core/theme/theme_helper.dart';

enum ThemeEvent { toggle }

class ThemeState {
  final ThemeData themeData;
  final IconData iconData;

  ThemeState({required this.themeData, required this.iconData});
}

// Bloc for managing themes and icons
class BThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  BThemeBloc()
      : super(ThemeState(
            themeData: AppThemes.lightTheme, iconData: Icons.brightness_4)) {
    on<ThemeEvent>((event, emit) {
      if (event == ThemeEvent.toggle) {
        emit(state.themeData == AppThemes.lightTheme
            ? ThemeState(
                themeData: AppThemes.darkTheme, iconData: Icons.brightness_7)
            : ThemeState(
                themeData: AppThemes.lightTheme, iconData: Icons.brightness_4));
        saveThemeToPreferences(state.themeData == AppThemes.lightTheme);
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/core/theme/app_themes.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeData.dark()) {
    //when app is started
    on<InitialThemeSetEvent>((event, emit) async {
      final bool hasDarkTheme = await isDark();
      if (hasDarkTheme) {
        emit(AppThemes.darkTheme);
      } else {
        emit(AppThemes.lightTheme);
      }
    });

    //while switch is clicked
    on<ThemeSwitchEvent>((event, emit) {
      final isDark = state == AppThemes.darkTheme;
      emit(isDark ? AppThemes.lightTheme : AppThemes.darkTheme);
      setTheme(isDark);
    });
  }
}

Future<bool> isDark() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_dark") ?? true;
}

Future<void> setTheme(bool isDark) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_dark", !isDark);
}

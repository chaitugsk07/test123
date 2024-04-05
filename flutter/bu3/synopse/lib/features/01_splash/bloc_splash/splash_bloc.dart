import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_event.dart';
part 'splash_state.dart';

enum SplashStatus {
  initial,
  isloggedin,
  isnotloggedin,
  isloginskipped,
  isOnBoardingskipped,
  isLanguageSelected,
  error,
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState(status: SplashStatus.initial)) {
    // Initial Event
    on<SplashCheckLoginStatus>(
      _onCheckLogin,
      transformer: droppable(),
    );
  }

  Future<FutureOr<void>> _onCheckLogin(
      SplashCheckLoginStatus event, Emitter<SplashState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setBool('isOnboardingSkip', false);
    // prefs.setString('selectedLanguage', '');
    // prefs.setBool('isLoginSkipped', false);

    // prefs.setBool('isLoggedIn', true);
    // prefs.setString('loginToken',
    //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsidXNlciJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtdXNlci1pZCI6IjQyNzA3MDgyLWMzZjktNDM0MC1hOGEwLTIxZGRmY2FmZDc4MyJ9LCJleHAiOjE3MDg3ODI4MjB9.KO5CoN9Sb0Aq6a1e7DlhBfy_sdDE_HFg1PkjIluSTAA");
    prefs.setString('selectedLanguage', "en");
    final bool isLoginSkipped = prefs.getBool('isLoginSkipped') ?? false;
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final bool isOnboardingSkip = prefs.getBool('isOnboardingSkip') ?? false;
    final String selectedLanguage = prefs.getString('selectedLanguage') ?? '';

    const url = 'https://acceptable-etty-chaitugsk07.koyeb.app/v1/gurl';
    Uri uri = Uri.parse(url);
    // print(prefs.getString('loginToken'));
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      prefs.setString('graphql', data);
    }
    if (isLoggedIn) {
      emit(state.copyWith(status: SplashStatus.isloggedin));
    } else if (isLoginSkipped) {
      emit(state.copyWith(status: SplashStatus.isloginskipped));
    } else if (isOnboardingSkip) {
      emit(state.copyWith(status: SplashStatus.isOnBoardingskipped));
    } else if (selectedLanguage == "") {
      emit(state.copyWith(status: SplashStatus.isLanguageSelected));
    } else {
      emit(state.copyWith(status: SplashStatus.isnotloggedin));
    }
  }
}

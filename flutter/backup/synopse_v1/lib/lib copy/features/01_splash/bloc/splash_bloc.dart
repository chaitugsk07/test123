import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_event.dart';
part 'splash_state.dart';

enum SplashStatus {
  isloggedin,
  isnotloggedin,
  isloginskipped,
  error,
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState(status: SplashStatus.isnotloggedin)) {
    // Initial Event
    on<SplashCheckLoginStatus>(
      _onCheckLogin,
      transformer: droppable(),
    );
  }

  Future<FutureOr<void>> _onCheckLogin(
      SplashCheckLoginStatus event, Emitter<SplashState> emit) async {
    final isLoginSkipped = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getBool('isLoginSkipped') ?? false,
    );
    final isLoggedIn = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getBool('isLoggedIn') ?? false,
    );
    if (isLoginSkipped) {
      emit(state.copyWith(status: SplashStatus.isloginskipped));
    } else if (isLoggedIn) {
      emit(state.copyWith(status: SplashStatus.isloggedin));
    } else {
      emit(state.copyWith(status: SplashStatus.isnotloggedin));
    }
  }
}

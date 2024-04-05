import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/f_repo/models/mod_01_signup.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';

part 'signup_event.dart';
part 'signup_state.dart';

enum SignUpStatus { initial, success, failure }

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final RssFeedServicesFeed _rssFeedServices;

  SignUpBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const SignUpState()) {
    // Initial Event
    on<GetSignUpFetch>(
      _onSignUpFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSignUpFetch(
      GetSignUpFetch event, Emitter<SignUpState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selectedLanguage') ?? 'en';
    final articles = await _rssFeedServices.getSignUp(languageCode);
    return emit(
      state.copyWith(
        signUp: List.of(state.signUp)..addAll(articles),
        status: SignUpStatus.success,
      ),
    );
  }
}

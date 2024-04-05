import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/f_repo/models/mod_01_onboarding.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';

part 'onBoarding_event.dart';
part 'onBoarding_state.dart';

enum OnBoardingStatus { initial, success, failure }

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final RssFeedServicesFeed _rssFeedServices;

  OnBoardingBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const OnBoardingState()) {
    // Initial Event
    on<GetOnBoardingFetch>(
      _onOnBoardingFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onOnBoardingFetch(
      GetOnBoardingFetch event, Emitter<OnBoardingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selectedLanguage') ?? 'en';
    final articles = await _rssFeedServices.getOnBoarding(languageCode);
    return emit(
      state.copyWith(
        onboarding: List.of(state.onboarding)..addAll(articles),
        status: OnBoardingStatus.success,
      ),
    );
  }
}

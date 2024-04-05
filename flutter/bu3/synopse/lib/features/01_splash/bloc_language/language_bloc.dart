import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/f_repo/models/mod_01_language.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';

part 'language_event.dart';
part 'language_state.dart';

enum LanguageStatus { initial, success, failure }

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final RssFeedServicesFeed _rssFeedServices;

  LanguageBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const LanguageState()) {
    // Initial Event
    on<GetlanguageFetch>(
      _onLanguageFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onLanguageFetch(
      GetlanguageFetch event, Emitter<LanguageState> emit) async {
    final articles = await _rssFeedServices.getAllLanguage();
    return emit(
      state.copyWith(
        languageElement: List.of(state.languageElement)..addAll(articles),
        status: LanguageStatus.success,
      ),
    );
  }
}

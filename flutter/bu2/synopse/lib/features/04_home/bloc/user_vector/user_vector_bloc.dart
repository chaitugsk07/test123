import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/source_syn_api.dart';

part 'user_vector_event.dart';
part 'user_vector_state.dart';

class UserVectorBloc extends Bloc<UserVectorEvent, UserVectorState> {
  final RssFeedServicesFeed _rssFeedServices;

  UserVectorBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const UserVectorState()) {
    // Initial Event
    on<UserVectorFetch>(
      _onUserVectorFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onUserVectorFetch(
      UserVectorFetch event, Emitter<UserVectorState> emit) async {
    final articles = await _rssFeedServices.getUserVector();
    if (articles == "success") {
      return emit(state.copyWith(status: UserVectorStatus.success));
    }
    return emit(state.copyWith(status: UserVectorStatus.error));
  }
}

enum UserVectorStatus {
  initial,
  success,
  error,
}

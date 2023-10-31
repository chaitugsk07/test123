import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v001/features/04_home/01_model_repo/source_articlerss1_api.dart';

part 'set_like_view_comment_event.dart';
part 'set_like_view_comment_state.dart';

enum SetLikeViewCommentStatus {
  initial,
  success,
  error,
}

class SetLikeViewCommentBloc
    extends Bloc<SetLikeViewCommentEvent, SetLikeViewCommentState> {
  final RssFeedServicesFeed _rssFeedServices;

  SetLikeViewCommentBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const SetLikeViewCommentState()) {
    // Initial Event
    on<SetLikeViewCommentEventSetLike>(
      _onSetRequired,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSetRequired(SetLikeViewCommentEventSetLike event,
      Emitter<SetLikeViewCommentState> emit) {
    if (event.action == 'InsertLike') {
      _rssFeedServices.setLikeOrView(event.articleGroupId, 0);
    }
    if (event.action == 'DeleteLike') {
      _rssFeedServices.deleteLikeOrView(event.articleGroupId, 0);
    }
  }
}

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v001/features/05_article_detail/01_model_repo/source_articlerss1_api.dart';

part 'set_like_view_comment_event.dart';
part 'set_like_view_comment_state.dart';

enum SetLikeViewCommentStatus {
  initial,
  success,
  error,
}

class SetLikeViewCommentBloc
    extends Bloc<SetLikeViewCommentEvent, SetLikeViewCommentState> {
  final RssFeedServicesFeedDetails _rssFeedServicesFeedDetails;

  SetLikeViewCommentBloc(
      {required RssFeedServicesFeedDetails rssFeedServicesFeedDetails})
      : _rssFeedServicesFeedDetails = rssFeedServicesFeedDetails,
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
      _rssFeedServicesFeedDetails.setLikeOrView(event.articleGroupId, 1);
    }
    if (event.action == 'DeleteLike') {
      _rssFeedServicesFeedDetails.deleteLikeOrView(event.articleGroupId, 1);
    }

    if (event.action == 'InsertView') {
      _rssFeedServicesFeedDetails.setLikeOrView(event.articleGroupId, 0);
    }
  }
}

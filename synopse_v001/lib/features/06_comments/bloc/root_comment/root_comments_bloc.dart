import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/mod_article_comments.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/06_comments/01_model_repo/source_articlerss1_comments.dart';

part 'root_comments_state.dart';
part 'root_comments_event.dart';

class RootCommentsBloc extends Bloc<RootCommentsEvent, RootCommentsState> {
  final RssFeedServicesDetailComments
      _rssFeedServicesDetailCommentsDetailComments;

  RootCommentsBloc(
      {required RssFeedServicesDetailComments rssFeedServicesDetailComments})
      : _rssFeedServicesDetailCommentsDetailComments =
            rssFeedServicesDetailComments,
        super(const RootCommentsState()) {
    // Initial Event
    on<RootCommentsFetch>(
      _onRootCommentsFetch,
      transformer: droppable(),
    );
  }

  Future<FutureOr<void>> _onRootCommentsFetch(
      RootCommentsFetch event, Emitter<RootCommentsState> emit) async {
    if (state.status == RootCommentStatus.initial) {
      final articles = await _rssFeedServicesDetailCommentsDetailComments
          .getArticleCommentRoot(event.commentId);
      emit(
        state.copyWith(
          realtimeVUserArticleComment: articles,
          status: RootCommentStatus.success,
        ),
      );
    }
  }
}

enum RootCommentStatus {
  initial,
  success,
  error,
}

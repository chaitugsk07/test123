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
// Refresh Event
    on<ArticleCommentSet>(
      _onArticleCommentSet,
      transformer: droppable(),
    );

    on<ArticleCommentLikeSend>(
      _onArticleCommentLikeSend,
      transformer: droppable(),
    );

    on<ArticleCommentDisLikeSend>(
      _onArticleCommentDisLikeSend,
      transformer: droppable(),
    );

    on<ArticleCommentLikeDelete>(
      _onArticleCommentLikeDelete,
      transformer: droppable(),
    );

    on<ArticleCommentDisLikeDelete>(
      _onArticleCommentDisLikeDelete,
      transformer: droppable(),
    );

    on<ArticleCommentReplySet>(
      _onArticleCommentReplySet,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSetRequired(SetLikeViewCommentEventSetLike event,
      Emitter<SetLikeViewCommentState> emit) {
    if (event.action == 'InsertLike') {
      _rssFeedServicesFeedDetails.setLike(event.articleGroupId);
    }
    if (event.action == 'DeleteLike') {
      _rssFeedServicesFeedDetails.deleteLike(event.articleGroupId);
    }

    if (event.action == 'InsertView') {
      _rssFeedServicesFeedDetails.setView(event.articleGroupId);
    }
  }

  FutureOr<void> _onArticleCommentSet(
      ArticleCommentSet event, Emitter<SetLikeViewCommentState> emit) {
    _rssFeedServicesFeedDetails.setArticleComment(
        event.articleId, event.comment);
  }

  FutureOr<void> _onArticleCommentLikeSend(
      ArticleCommentLikeSend event, Emitter<SetLikeViewCommentState> emit) {
    _rssFeedServicesFeedDetails.setArticleCommentLike(event.commentId);
  }

  FutureOr<void> _onArticleCommentDisLikeSend(
      ArticleCommentDisLikeSend event, Emitter<SetLikeViewCommentState> emit) {
    _rssFeedServicesFeedDetails.setArticleCommentDisLike(event.commentId);
  }

  FutureOr<void> _onArticleCommentLikeDelete(
      ArticleCommentLikeDelete event, Emitter<SetLikeViewCommentState> emit) {
    _rssFeedServicesFeedDetails.deleteArticleCommentLike(event.commentId);
  }

  FutureOr<void> _onArticleCommentDisLikeDelete(
      ArticleCommentDisLikeDelete event,
      Emitter<SetLikeViewCommentState> emit) {
    _rssFeedServicesFeedDetails.deleteArticleCommentDisLike(event.commentId);
  }

  FutureOr<void> _onArticleCommentReplySet(
      ArticleCommentReplySet event, Emitter<SetLikeViewCommentState> emit) {
    _rssFeedServicesFeedDetails.setArticleCommentReply(
        event.articleId, event.comment, event.commentId);
  }
}

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/source_syn_api.dart';

part 'user_event_event.dart';
part 'user_event_state.dart';

class UserEventBloc extends Bloc<UserEventEvent, UserEventState> {
  final RssFeedServicesFeed _rssFeedServices;

  UserEventBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const UserEventState()) {
    // Initial Event
    on<UserEventView>(
      _onUserEventView,
      transformer: droppable(),
    );
    on<UserEventLike>(
      _onUserEventLike,
      transformer: droppable(),
    );
    on<UserEventBookmark>(
      _onUserEventBookmark,
      transformer: droppable(),
    );
    on<UserEventViewDelete>(
      _onUserEventViewDelete,
      transformer: droppable(),
    );
    on<UserEventLikeDelete>(
      _onUserEventLikeDelete,
      transformer: droppable(),
    );
    on<UserEventBookmarkDelete>(
      _onUserEventBookmarkDelete,
      transformer: droppable(),
    );
    on<UserEventCommentSet>(
      _onUserEventCommentSet,
      transformer: droppable(),
    );

    on<UserEventCommentLike>(
      _onUserEventCommentLikeSet,
      transformer: droppable(),
    );
    on<UserEventCommentDislike>(
      _onUserEventCommentDislikeSet,
      transformer: droppable(),
    );
    on<UserEventCommentLikeDelete>(
      _onUserEventCommentLikeDelete,
      transformer: droppable(),
    );
    on<UserEventCommentDislikeDelete>(
      _onUserEventCommentDislikeDelete,
      transformer: droppable(),
    );
    on<UserEventCommentEdit>(
      _onUserEventCommentEdit,
      transformer: droppable(),
    );
    on<UserEventCommentReply>(
      _onUserEventCommentReply,
      transformer: droppable(),
    );
    on<UserEventTag>(
      _onUserEventTag,
      transformer: droppable(),
    );
    on<UserEventTagDelete>(
      _onUserEventTagDelete,
      transformer: droppable(),
    );
    on<UserEventNav1>(
      _onUserEventNav1,
      transformer: droppable(),
    );
    on<UserEventUsername>(
      _onUserEventUsername,
      transformer: droppable(),
    );
    on<UserEventName>(
      _onUserEventName,
      transformer: droppable(),
    );
    on<UserEventBio>(
      _onUserEventBio,
      transformer: droppable(),
    );
    on<UserEventPhoto>(
      _onUserEventPhoto,
      transformer: droppable(),
    );

    on<UserEventNoNotification>(
      _onUserEventUserEventNoNotification,
      transformer: droppable(),
    );
    on<UserEventNotification>(
      _onUserEventNotification,
      transformer: droppable(),
    );
    on<UserEventUpdateNotification>(
      _onUserEventUpdateNotification,
      transformer: droppable(),
    );

    on<UserEventFeedback>(
      _onUserEventFeedback,
      transformer: droppable(),
    );

    on<UserEventFollow>(
      _onUserEventFollow,
      transformer: droppable(),
    );

    on<UserEventUnFollow>(
      _onUserEventUnFollow,
      transformer: droppable(),
    );

    on<UserEventArticleSearchWithText>(
      _onUserEventArticleSearchWithText,
      transformer: droppable(),
    );

    on<UserEventArticleFoollowUpOutputSet>(
      _onUserEventArticleFoollowUpOutputSet,
      transformer: droppable(),
    );

    on<UserEventViewInShort>(
      _onUserEventViewInShort,
      transformer: droppable(),
    );
  }

  Future<void> _onUserEventView(
      UserEventView event, Emitter<UserEventState> emit) async {
    final set1 =
        await _rssFeedServices.setArticleGroupView(event.articleGrouppId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventLike(
      UserEventLike event, Emitter<UserEventState> emit) async {
    final set1 =
        await _rssFeedServices.setArticleGroupLike(event.articleGrouppId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventBookmark(
      UserEventBookmark event, Emitter<UserEventState> emit) async {
    final set1 =
        await _rssFeedServices.setArticleGroupBookmark(event.articleGrouppId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventViewDelete(
      UserEventViewDelete event, Emitter<UserEventState> emit) async {
    final set1 =
        await _rssFeedServices.setArticleGroupViewDelete(event.articleGrouppId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventLikeDelete(
      UserEventLikeDelete event, Emitter<UserEventState> emit) async {
    final set1 =
        await _rssFeedServices.setArticleGroupLikeDelete(event.articleGrouppId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventBookmarkDelete(
      UserEventBookmarkDelete event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices
        .setArticleGroupBookmarkDelete(event.articleGrouppId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventCommentSet(
      UserEventCommentSet event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setArticleGroupComment(
        event.articleGrouppId, event.comment);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventCommentLikeSet(
      UserEventCommentLike event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setUserCommentLike(event.commentId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventCommentDislikeSet(
      UserEventCommentDislike event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setUserCommentDislike(event.commentId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventCommentLikeDelete(
      UserEventCommentLikeDelete event, Emitter<UserEventState> emit) async {
    final set1 =
        await _rssFeedServices.setUserCommentLikeDelete(event.commentId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventCommentDislikeDelete(
      UserEventCommentDislikeDelete event, Emitter<UserEventState> emit) async {
    final set1 =
        await _rssFeedServices.setUserCommentDislikeDelete(event.commentId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventCommentEdit(
      UserEventCommentEdit event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setArticleGroupCommentEdit(
        event.commentId, event.comment);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventCommentReply(
      UserEventCommentReply event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setArticleGroupCommentReply(
        event.articleGroupId, event.commentId, event.comment);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventTag(
      UserEventTag event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setUserTag(event.tagId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventTagDelete(
      UserEventTagDelete event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.deleteUserTag(event.tagId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventNav1(
      UserEventNav1 event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setCombinedTabs(event.combinedTabs);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventUsername(
      UserEventUsername event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setProfileUsername(event.username);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventName(
      UserEventName event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setProfileName(event.name);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventBio(
      UserEventBio event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setProfileBio(event.bio);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventPhoto(
      UserEventPhoto event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setProfilePhoto(event.photo);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventUserEventNoNotification(
      UserEventNoNotification event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.updateUserNoNotification(
        event.deviceType,
        event.deviceId,
        event.deviceSerial,
        event.loginDate,
        event.timeZone);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventNotification(
      UserEventNotification event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.insertUserNotification(
        event.fcmToken,
        event.deviceType,
        event.deviceId,
        event.deviceSerial,
        event.loginDate,
        event.timeZone);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventUpdateNotification(
      UserEventUpdateNotification event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.updateNotification(
        event.fcmTokenOld,
        event.fcmToken,
        event.deviceType,
        event.deviceId,
        event.deviceSerial,
        event.loginDate,
        event.timeZone);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventFeedback(
      UserEventFeedback event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.insertFeedback(
        event.type, event.subject, event.body);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventFollow(
      UserEventFollow event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setUserFollow(event.account);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventUnFollow(
      UserEventUnFollow event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setUserFollowDelete(event.account);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventArticleSearchWithText(
      UserEventArticleSearchWithText event,
      Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.setArticleSearchText(event.searchText);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventArticleFoollowUpOutputSet(
      UserEventArticleFoollowUpOutputSet event,
      Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices.fetFollowUpLatest(event.followUpId);
    if (set1 > 0) {
      final set2 = await _rssFeedServices.updateReply(set1, event.out1);
      if (set2 == "success") {
        return emit(state.copyWith(status: UserEventStatus.success));
      }
      return emit(state.copyWith(status: UserEventStatus.error));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }

  FutureOr<void> _onUserEventViewInShort(
      UserEventViewInShort event, Emitter<UserEventState> emit) async {
    final set1 = await _rssFeedServices
        .setArticleGroupViewInShort(event.articleGrouppId);
    if (set1 == "success") {
      return emit(state.copyWith(status: UserEventStatus.success));
    }
    return emit(state.copyWith(status: UserEventStatus.error));
  }
}

enum UserEventStatus {
  initial,
  success,
  error,
}

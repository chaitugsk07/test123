part of 'user_event_bloc.dart';

@immutable
abstract class UserEventEvent extends Equatable {
  const UserEventEvent();
  @override
  List<Object?> get props => [];
}

class UserEventView extends UserEventEvent {
  final int articleGrouppId;
  const UserEventView({required this.articleGrouppId});
}

class UserEventLike extends UserEventEvent {
  final int articleGrouppId;
  const UserEventLike({required this.articleGrouppId});
}

class UserEventBookmark extends UserEventEvent {
  final int articleGrouppId;
  const UserEventBookmark({required this.articleGrouppId});
}

class UserEventViewDelete extends UserEventEvent {
  final int articleGrouppId;
  const UserEventViewDelete({required this.articleGrouppId});
}

class UserEventLikeDelete extends UserEventEvent {
  final int articleGrouppId;
  const UserEventLikeDelete({required this.articleGrouppId});
}

class UserEventBookmarkDelete extends UserEventEvent {
  final int articleGrouppId;
  const UserEventBookmarkDelete({required this.articleGrouppId});
}

class UserEventCommentSet extends UserEventEvent {
  final int articleGrouppId;
  final String comment;

  const UserEventCommentSet(
      {required this.articleGrouppId, required this.comment});
}

class UserEventCommentLike extends UserEventEvent {
  final int commentId;

  const UserEventCommentLike({required this.commentId});
}

class UserEventCommentDislike extends UserEventEvent {
  final int commentId;

  const UserEventCommentDislike({required this.commentId});
}

class UserEventCommentLikeDelete extends UserEventEvent {
  final int commentId;

  const UserEventCommentLikeDelete({required this.commentId});
}

class UserEventCommentDislikeDelete extends UserEventEvent {
  final int commentId;

  const UserEventCommentDislikeDelete({required this.commentId});
}

class UserEventCommentEdit extends UserEventEvent {
  final int commentId;
  final String comment;

  const UserEventCommentEdit({required this.commentId, required this.comment});
}

class UserEventCommentReply extends UserEventEvent {
  final int commentId;
  final String comment;
  final int articleGroupId;

  const UserEventCommentReply(
      {required this.commentId,
      required this.comment,
      required this.articleGroupId});
}

class UserEventNav1 extends UserEventEvent {
  final List combinedTabs;

  const UserEventNav1({required this.combinedTabs});
}

class UserEventTag extends UserEventEvent {
  final int tagId;

  const UserEventTag({required this.tagId});
}

class UserEventTagDelete extends UserEventEvent {
  final int tagId;

  const UserEventTagDelete({required this.tagId});
}

class UserEventUsername extends UserEventEvent {
  final String username;

  const UserEventUsername({required this.username});
}

class UserEventName extends UserEventEvent {
  final String name;

  const UserEventName({required this.name});
}

class UserEventBio extends UserEventEvent {
  final String bio;

  const UserEventBio({required this.bio});
}

class UserEventPhoto extends UserEventEvent {
  final int photo;

  const UserEventPhoto({required this.photo});
}

class UserEventNoNotification extends UserEventEvent {
  final int deviceType;
  final String deviceId;
  final String deviceSerial;
  final String loginDate;
  final String timeZone;

  const UserEventNoNotification(
      {required this.deviceType,
      required this.deviceId,
      required this.deviceSerial,
      required this.loginDate,
      required this.timeZone});
}

class UserEventNotification extends UserEventEvent {
  final String fcmToken;
  final int deviceType;
  final String deviceId;
  final String deviceSerial;
  final String loginDate;
  final String timeZone;

  const UserEventNotification(
      {required this.fcmToken,
      required this.deviceType,
      required this.deviceId,
      required this.deviceSerial,
      required this.loginDate,
      required this.timeZone});
}

class UserEventUpdateNotification extends UserEventEvent {
  final String fcmTokenOld;
  final String fcmToken;
  final int deviceType;
  final String deviceId;
  final String deviceSerial;
  final String loginDate;
  final String timeZone;

  const UserEventUpdateNotification(
      {required this.fcmTokenOld,
      required this.fcmToken,
      required this.deviceType,
      required this.deviceId,
      required this.deviceSerial,
      required this.loginDate,
      required this.timeZone});
}

class UserEventFeedback extends UserEventEvent {
  final String type;
  final String subject;
  final String body;

  const UserEventFeedback(
      {required this.type, required this.subject, required this.body});
}

class UserEventFollow extends UserEventEvent {
  final String account;

  const UserEventFollow({required this.account});
}

class UserEventUnFollow extends UserEventEvent {
  final String account;

  const UserEventUnFollow({required this.account});
}

class UserEventArticleSearchWithText extends UserEventEvent {
  final String searchText;

  const UserEventArticleSearchWithText({required this.searchText});
}

class UserEventArticleFoollowUpOutputSet extends UserEventEvent {
  final String out1;
  final int followUpId;

  const UserEventArticleFoollowUpOutputSet(
      {required this.out1, required this.followUpId});
}

class UserEventViewInShort extends UserEventEvent {
  final int articleGrouppId;
  const UserEventViewInShort({required this.articleGrouppId});
}

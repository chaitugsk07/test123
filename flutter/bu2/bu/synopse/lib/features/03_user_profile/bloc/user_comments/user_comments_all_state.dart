part of 'user_comments_all_bloc.dart';

class UserCommentsState extends Equatable {
  final List<SynopseRealtimeVUserArticleCommentUser>
      synopseRealtimeVUserArticleCommentUser;
  final bool hasReachedMax;
  final UserCommentsStatus status;

  const UserCommentsState(
      {this.synopseRealtimeVUserArticleCommentUser =
          const <SynopseRealtimeVUserArticleCommentUser>[],
      this.hasReachedMax = false,
      this.status = UserCommentsStatus.initial});

  UserCommentsState copyWith({
    List<SynopseRealtimeVUserArticleCommentUser>?
        synopseRealtimeVUserArticleCommentUser,
    bool? hasReachedMax,
    UserCommentsStatus? status,
  }) {
    return UserCommentsState(
      synopseRealtimeVUserArticleCommentUser:
          synopseRealtimeVUserArticleCommentUser ??
              this.synopseRealtimeVUserArticleCommentUser,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseRealtimeVUserArticleCommentUser, hasReachedMax, status];
}

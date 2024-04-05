part of 'user_saved_all_bloc.dart';

class UserSavedState extends Equatable {
  final List<SynopseRealtimeTUserArticleBookmark>
      synopseRealtimeTUserArticleBookmark;
  final bool hasReachedMax;
  final UserSavedStatus status;

  const UserSavedState(
      {this.synopseRealtimeTUserArticleBookmark =
          const <SynopseRealtimeTUserArticleBookmark>[],
      this.hasReachedMax = false,
      this.status = UserSavedStatus.initial});

  UserSavedState copyWith({
    List<SynopseRealtimeTUserArticleBookmark>?
        synopseRealtimeTUserArticleBookmark,
    bool? hasReachedMax,
    UserSavedStatus? status,
  }) {
    return UserSavedState(
      synopseRealtimeTUserArticleBookmark:
          synopseRealtimeTUserArticleBookmark ??
              this.synopseRealtimeTUserArticleBookmark,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseRealtimeTUserArticleBookmark, hasReachedMax, status];
}

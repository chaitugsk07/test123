part of 'ext_user_follow_bloc.dart';

class ExtUserFollowState extends Equatable {
  final int followingCount;
  final bool hasReachedMax;
  final ExtUserFollowStatus status;

  const ExtUserFollowState(
      {this.followingCount = 0,
      this.hasReachedMax = false,
      this.status = ExtUserFollowStatus.initial});

  ExtUserFollowState copyWith({
    int? followingCount,
    bool? hasReachedMax,
    ExtUserFollowStatus? status,
  }) {
    return ExtUserFollowState(
      followingCount: followingCount ?? this.followingCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [followingCount, hasReachedMax, status];
}

part of 'user_intrests_bloc.dart';

class UserIntrestsTagsState extends Equatable {
  final List<SynopseRealtimeTUserTag> synopseRealtimeTUserTag;
  final bool hasReachedMax;
  final UserIntrestsTagsStatus status;

  const UserIntrestsTagsState(
      {this.synopseRealtimeTUserTag = const <SynopseRealtimeTUserTag>[],
      this.hasReachedMax = false,
      this.status = UserIntrestsTagsStatus.initial});

  UserIntrestsTagsState copyWith({
    List<SynopseRealtimeTUserTag>? synopseRealtimeTUserTag,
    bool? hasReachedMax,
    UserIntrestsTagsStatus? status,
  }) {
    return UserIntrestsTagsState(
      synopseRealtimeTUserTag:
          synopseRealtimeTUserTag ?? this.synopseRealtimeTUserTag,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseRealtimeTUserTag, hasReachedMax, status];
}

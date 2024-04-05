part of 'user_intrests_tags_bloc.dart';

class UserIntrestsTagsState extends Equatable {
  final List<SynopseRealtimeTUserTagUI> synopseRealtimeTUserTagUI;
  final bool hasReachedMax;
  final UserIntrestsTagsStatus status;

  const UserIntrestsTagsState(
      {this.synopseRealtimeTUserTagUI = const <SynopseRealtimeTUserTagUI>[],
      this.hasReachedMax = false,
      this.status = UserIntrestsTagsStatus.initial});

  UserIntrestsTagsState copyWith({
    List<SynopseRealtimeTUserTagUI>? synopseRealtimeTUserTagUI,
    bool? hasReachedMax,
    UserIntrestsTagsStatus? status,
  }) {
    return UserIntrestsTagsState(
      synopseRealtimeTUserTagUI:
          synopseRealtimeTUserTagUI ?? this.synopseRealtimeTUserTagUI,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseRealtimeTUserTagUI, hasReachedMax, status];
}

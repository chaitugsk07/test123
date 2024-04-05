part of 'ext_user_follow_bloc.dart';

@immutable
abstract class ExtUserFollowEvent extends Equatable {
  const ExtUserFollowEvent();
  @override
  List<Object?> get props => [];
}

class ExtUserFollowFetch extends ExtUserFollowEvent {
  final String account;

  const ExtUserFollowFetch({required this.account});
}

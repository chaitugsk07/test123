part of 'user_comments_all_bloc.dart';

@immutable
abstract class UserCommentsEvent extends Equatable {
  const UserCommentsEvent();
  @override
  List<Object?> get props => [];
}

class UserCommentsFetch extends UserCommentsEvent {
  final String account;

  const UserCommentsFetch({required this.account});
}

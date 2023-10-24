part of 'root_comments_bloc.dart';

@immutable
abstract class RootCommentsEvent extends Equatable {
  const RootCommentsEvent();
  @override
  List<Object?> get props => [];
}

class RootCommentsFetch extends RootCommentsEvent {
  final int commentId;

  const RootCommentsFetch({required this.commentId});
}

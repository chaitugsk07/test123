part of 'comments1_reply_bloc.dart';

@immutable
abstract class Comments1REvent extends Equatable {
  const Comments1REvent();
  @override
  List<Object?> get props => [];
}

class Comments1RFetch extends Comments1REvent {
  final int commentId;

  const Comments1RFetch({required this.commentId});
}

class Comments1RRefresh extends Comments1REvent {
  final int commentId;

  const Comments1RRefresh({required this.commentId});
}

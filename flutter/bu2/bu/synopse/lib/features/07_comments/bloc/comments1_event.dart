part of 'comments1_bloc.dart';

@immutable
abstract class Comments1Event extends Equatable {
  const Comments1Event();
  @override
  List<Object?> get props => [];
}

class Comments1Fetch extends Comments1Event {
  final int articleGroupId;

  const Comments1Fetch({required this.articleGroupId});
}

class Comments1Refresh extends Comments1Event {
  final int articleGroupId;

  const Comments1Refresh({required this.articleGroupId});
}

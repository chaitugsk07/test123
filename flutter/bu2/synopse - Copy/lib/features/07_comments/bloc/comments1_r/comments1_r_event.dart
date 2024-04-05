part of 'comments1_r_bloc.dart';

@immutable
abstract class Comments1R1Event extends Equatable {
  const Comments1R1Event();
  @override
  List<Object?> get props => [];
}

class Comments1R1Fetch extends Comments1R1Event {
  final int commnentId;

  const Comments1R1Fetch({required this.commnentId});
}

part of 'get_all_read_bloc.dart';

@immutable
abstract class GetAllReadEvent extends Equatable {
  const GetAllReadEvent();
  @override
  List<Object?> get props => [];
}

class GetAllReadFetch extends GetAllReadEvent {}

class GetAllReadRefresh extends GetAllReadEvent {}

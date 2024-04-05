part of 'get_all_vector_bloc.dart';

@immutable
abstract class GetAllVectorEvent extends Equatable {
  const GetAllVectorEvent();
  @override
  List<Object?> get props => [];
}

class GetAllVectorFetch extends GetAllVectorEvent {}

class GetAllVectorRefresh extends GetAllVectorEvent {}

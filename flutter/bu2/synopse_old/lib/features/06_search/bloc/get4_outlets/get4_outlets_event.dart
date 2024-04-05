part of 'get4_outlets_bloc.dart';

@immutable
abstract class Get4OutletsEvent extends Equatable {
  const Get4OutletsEvent();
  @override
  List<Object?> get props => [];
}

class Get4OutletsFetch extends Get4OutletsEvent {
  const Get4OutletsFetch();
}

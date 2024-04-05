part of 'get_all_publisher_bloc.dart';

@immutable
abstract class GetAllPublisherEvent extends Equatable {
  const GetAllPublisherEvent();
  @override
  List<Object?> get props => [];
}

class GetAllPublisherFetch extends GetAllPublisherEvent {
  final int outletId;

  const GetAllPublisherFetch({required this.outletId});
}

class GetAllPublisherRefresh extends GetAllPublisherEvent {
  final int outletId;

  const GetAllPublisherRefresh({required this.outletId});
}

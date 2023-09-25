// network_checker_event.dart
part of 'network_checker_bloc.dart';

abstract class NetworkCheckerEvent extends Equatable {
  const NetworkCheckerEvent();

  @override
  List<Object> get props => [];
}

class CheckNetwork extends NetworkCheckerEvent {}

// network_checker_state.dart
part of 'network_checker_bloc.dart';

abstract class NetworkCheckerState extends Equatable {
  const NetworkCheckerState();

  @override
  List<Object> get props => [];
}

class NetworkCheckerInitial extends NetworkCheckerState {}

class NetworkCheckerLoading extends NetworkCheckerState {}

class NetworkCheckerLoaded extends NetworkCheckerState {
  final bool isConnected;

  NetworkCheckerLoaded({required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}

// network_checker_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_checker_usecase.dart';

part 'network_checker_event.dart';
part 'network_checker_state.dart';

class NetworkCheckerBloc
    extends Bloc<NetworkCheckerEvent, NetworkCheckerState> {
  final NetworkCheckerUseCase networkCheckerUseCase;

  NetworkCheckerBloc({required this.networkCheckerUseCase})
      : super(NetworkCheckerInitial()) {
    on<CheckNetwork>((event, emit) async {
      emit(NetworkCheckerLoading());
      final isConnected = await networkCheckerUseCase.isConnected();
      emit(NetworkCheckerLoaded(isConnected: isConnected));
    });
  }
}

// network_checker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/network_checker_bloc.dart';

class NetworkCheckerPage extends StatelessWidget {
  final NetworkChecker networkChecker;

  NetworkCheckerPage({@required this.networkChecker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Checker'),
      ),
      body: BlocProvider(
        create: (context) => NetworkCheckerBloc(
          networkCheckerUseCase: NetworkCheckerUseCaseImpl(
            networkCheckerRepository: NetworkCheckerRepositoryImpl(
              networkChecker: networkChecker,
            ),
          ),
        ),
        child: BlocBuilder<NetworkCheckerBloc, NetworkCheckerState>(
          builder: (context, state) {
            if (state is NetworkCheckerInitial) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<NetworkCheckerBloc>().add(CheckNetwork());
                  },
                  child: Text('Check Network'),
                ),
              );
            } else if (state is NetworkCheckerLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NetworkCheckerLoaded) {
              return Center(
                child: Text(state.isConnected ? 'Connected' : 'Not Connected'),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

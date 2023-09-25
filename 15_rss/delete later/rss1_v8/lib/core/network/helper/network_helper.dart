import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../bloc/network_bloc.dart';
import '../bloc/network_event.dart';

class NetworkHelper {
  static void observeNetwork() {
    if (kIsWeb) {
      NetworkBloc().add(NetworkNotify(isConnected: true));
    } else {
      Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) {
          if (result == ConnectivityResult.none) {
            NetworkBloc().add(NetworkNotify());
          } else {
            NetworkBloc().add(NetworkNotify(isConnected: true));
          }
        },
      );
    }
  }
}

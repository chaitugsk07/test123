import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'network_info.dart';

class NetworkInfoDataSource implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoDataSource(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}

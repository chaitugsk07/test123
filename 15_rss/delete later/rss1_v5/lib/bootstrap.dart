import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:url_strategy/url_strategy.dart';

import 'core/di/di.dart';
import 'core/observer/observer.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder, String env) async {
  flutterLogError();
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  HttpOverrides.global = MyHttpOverrides();
  configureAppInjection(env);

  await runZonedGuarded(
    () async {
      // Initialize the AppObserver
      final AppObserver appObserver = AppObserver();
      // Set the BlocObserver to use the AppObserver
      Bloc.observer = appObserver;
      runApp(await builder());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

void flutterLogError() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Logger.root.level = Level.INFO; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

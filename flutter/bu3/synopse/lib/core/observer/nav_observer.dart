import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logging/logging.dart';

class MyNavObserver extends NavigatorObserver {
  MyNavObserver() {
    log.onRecord.listen((e) => debugPrint('$e'));
  }

  final log = Logger('MyNavObserver');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // log.info('didPush: ${route.settings.name}');
    FirebaseAnalytics.instance.logEvent(
      name: 'didPush',
      parameters: {
        'route': route.settings.name,
        'previousRoute': previousRoute?.settings.name ?? 'No previous route',
      },
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // log.info('didPop: ${route.settings.name}');
    FirebaseAnalytics.instance.logEvent(
      name: 'didPop',
      parameters: {
        'route': route.settings.name,
        'previousRoute': previousRoute?.settings.name ?? 'No previous route',
      },
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // log.info('didRemove: ${route.settings.name}');
    FirebaseAnalytics.instance.logEvent(
      name: 'didRemove',
      parameters: {
        'route': route.settings.name,
        'previousRoute': previousRoute?.settings.name ?? 'No previous route',
      },
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    // log.info('didReplace: ${newRoute?.settings.name ?? 'No previous route'}');
    FirebaseAnalytics.instance.logEvent(
      name: 'didReplace',
      parameters: {
        'newRoute': newRoute?.settings.name ?? 'No new route',
        'oldRoute': oldRoute?.settings.name ?? 'No old route',
      },
    );
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    // log.info('didStartUserGesture: ${route.settings.name}');
    FirebaseAnalytics.instance.logEvent(
      name: 'didStartUserGesture',
      parameters: {
        'route': route.settings.name,
        'previousRoute': previousRoute?.settings.name ?? 'No previous route',
      },
    );
  }
}

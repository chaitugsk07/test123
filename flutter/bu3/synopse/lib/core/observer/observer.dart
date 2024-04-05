import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    String eventString = event.toString();
    if (eventString.length > 100) {
      eventString = eventString.substring(0, 100);
    }
    FirebaseAnalytics.instance.logEvent(
      name: 'bloc_event',
      parameters: {
        'event': eventString,
        'bloc': '${bloc.runtimeType}',
      },
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // log('Change: $change, Bloc: ${bloc.runtimeType}', name: 'BLOC');
    String changeString = change.toString();
    if (changeString.length > 100) {
      changeString = changeString.substring(0, 100);
    }
    FirebaseAnalytics.instance.logEvent(
      name: 'bloc_change',
      parameters: {
        'change': changeString,
        'bloc': '${bloc.runtimeType}',
      },
    );
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    // log('Create: ${bloc.runtimeType}');
    FirebaseAnalytics.instance.logEvent(
      name: 'bloc_create',
      parameters: {
        'bloc': '${bloc.runtimeType}',
      },
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // log('Transition: $transition, Bloc: ${bloc.runtimeType}');
    String transitionString = transition.toString();
    if (transitionString.length > 100) {
      transitionString = transitionString.substring(0, 100);
    }
    FirebaseAnalytics.instance.logEvent(
      name: 'bloc_transition',
      parameters: {
        'transition': transitionString,
        'bloc': '${bloc.runtimeType}',
      },
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // log('Error: $error, Bloc: ${bloc.runtimeType}');
    super.onError(bloc, error, stackTrace);
    String errorString = error.toString();
    if (errorString.length > 100) {
      errorString = errorString.substring(0, 100);
    }
    FirebaseAnalytics.instance.logEvent(
      name: 'bloc_error',
      parameters: {
        'error': errorString,
        'bloc': '${bloc.runtimeType}',
      },
    );
  }
}

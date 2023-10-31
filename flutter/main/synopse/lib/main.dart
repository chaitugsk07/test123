import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/observer/observer.dart';
import 'package:synopse/core/theme/bloc/theme_bloc.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/p_bloc/splash_bloc/splash_bloc.dart';

Future<void> main() async {
  // Initialize the AppObserver
  final AppObserver appObserver = AppObserver();
  // Set the BlocObserver to use the AppObserver
  Bloc.observer = appObserver;

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(InitialThemeSetEvent()),
        ),
        BlocProvider(create: (context) => SplashBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, themeState) {
        return MaterialApp.router(
          routeInformationProvider: router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeState,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
        );
      },
    );
  }
}

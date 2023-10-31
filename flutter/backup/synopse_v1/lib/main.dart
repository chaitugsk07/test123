import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v1/core/graphql/graphql_service.dart';
import 'package:synopse_v1/core/observer/observer.dart';
import 'package:synopse_v1/core/theme/bloc/theme_bloc.dart';
import 'package:synopse_v1/core/utils/router.dart';
import 'package:synopse_v1/features/feed/01_model_repo/source_articlerss1_api.dart';
import 'package:synopse_v1/features/feed/bloc/articles_rss1_bloc.dart';

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
          create: (context) => BThemeBloc(),
        ),
        BlocProvider(
          create: (context) => ArticlesRss1Bloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          )..add(const ArticlesRss1Fetch()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          routeInformationProvider: router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeState.themeData,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
        );
      },
    );
  }
}

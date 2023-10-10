import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/observer/observer.dart';
import 'package:synopse_v001/core/theme/bloc/theme_bloc.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/01_splash/bloc/splash_bloc.dart';
import 'package:synopse_v001/features/02_loginscreens/bloc/send_otp/send_otp_bloc.dart';
import 'package:synopse_v001/features/02_loginscreens/bloc/verify_otp/verifiy_otp_bloc.dart';
import 'package:synopse_v001/features/04_home/01_model_repo/source_articlerss1_api.dart';
import 'package:synopse_v001/features/04_home/bloc/articles_rss1_bloc.dart';
import 'package:synopse_v001/features/05_article_detail/01_model_repo/source_articlerss1_api.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/articles_detail_rss1_bloc.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/set_like_view_comment/set_like_view_comment_bloc.dart';

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
        BlocProvider(create: (context) => SendOTPBloc()),
        BlocProvider(create: (context) => VerifyOTPBloc()),
        BlocProvider(
          create: (context) => ArticlesRss1Bloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SetLikeViewCommentBloc(
            rssFeedServicesFeedDetails: RssFeedServicesFeedDetails(
              GraphQLService(),
            ),
          ),
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

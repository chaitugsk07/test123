

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/observer/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  Bloc.observer = AppObserver();

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return ScreenUtilInit(
      designSize: Size(414, 848),
      allowFontScaling: false,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        routes: {
          '/checkEmailScreen': (context) => CheckEmailScreen(),
          '/loginPage': (context) => SignInPage(),
          '/signUpPage': (context) => SignUpPage(),
        },
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Color(0xff4878FF),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        onGenerateRoute: (_) => AuthUnknownScreen.route(),
        navigatorObservers: [
          BotToastNavigatorObserver(),
        ],
        builder: (context, child) {
          child = MediaQuery(
            data: MediaQuery.of(context),
            child: MultiBlocProvider(
              providers: [
                //asset bloc
                BlocProvider<AssetsCubit>(
                  create: (BuildContext context) => AssetsCubit(
                    assetRepository: widget.assetRepository,
                  ),
                ),

                BlocProvider<NetworkBloc>(
                  create: (context) => NetworkBloc()..add(ListenConnection()),
                ),

                //home content
                BlocProvider<HomeContentCubit>(
                  create: (BuildContext context) => HomeContentCubit(
                    assetRepository: widget.assetRepository,
                    newsRepository: widget.newsRepository,
                  )..loadHomeContent(),
                ),

                BlocProvider<AllCoinsCubit>(
                  create: (context) => AllCoinsCubit(
                    allCoinsRepository: widget.allCoinsRepository,
                  )..loadCoinData(),
                ),

                BlocProvider<WatchListBloc>(
                  create: (context) => WatchListBloc(),
                ),

                BlocProvider<PricesSwitcherBloc>(
                    create: (context) => PricesSwitcherBloc()),

                //news bloc
                BlocProvider(
                  create: (BuildContext context) => NewsBloc(
                    newsRepository: widget.newsRepository,
                  ),
                ),

                BlocProvider(
                  create: (BuildContext context) => TextFieldBloc(),
                ),

                // BlocProvider<B>()
                BlocProvider<BottomNavBarBloc>(
                  create: (context) => BottomNavBarBloc(),
                ),

                BlocProvider<SortCubit>(
                  create: (context) => SortCubit(),
                ),

                BlocProvider<ChartCubit>(
                  create: (context) => ChartCubit(
                    chartRepository: widget.chartRepository,
                  ),
                ),

                BlocProvider<Chart24hCubit>(
                  create: (context) => Chart24hCubit(
                    chartRepository: widget.chartRepository,
                  ),
                ),

                BlocProvider<ConverterBloc>(
                  create: (context) => ConverterBloc(),
                ),

                BlocProvider<SortNowCubit>(
                  create: (context) => SortNowCubit(),
                ),

                BlocProvider<CalculatorBloc>(
                  create: (context) => CalculatorBloc(),
                ),

                BlocProvider<SetPriceCubit>(
                  create: (context) => SetPriceCubit(),
                ),

                //tab switcher
                BlocProvider<TabSwitcherBloc>(
                  create: (context) => TabSwitcherBloc(),
                ),

                BlocProvider<RangeSwitcherBloc>(
                  create: (context) => RangeSwitcherBloc(),
                ),

                BlocProvider<LoginCubit>(
                  create: (BuildContext context) => LoginCubit(
                    context.read<AuthenticationRepository>(),
                  ),
                ),

                BlocProvider<SignUpCubit>(
                  create: (BuildContext context) => SignUpCubit(
                    context.read<AuthenticationRepository>(),
                  ),
                ),
              ],
              child: BlocListener<AuthenticationBloc, AuthenticationState>(
                child: child,
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        PagesBuilder.route(),
                        (route) => false,
                      );
                      break;
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushAndRemoveUntil<void>(
                        SignInPage.route(),
                        (route) => false,
                      );
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
          );
          child = botToastBuilder(context, child);
          return child;
        },
      ),
    );
  }
}

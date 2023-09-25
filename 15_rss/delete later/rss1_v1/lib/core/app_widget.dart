import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rss1_v1/core/generated/l10n.dart';

import 'connectivity/03_cubit/connectivity_cubit.dart';
import 'di/di.dart';
import 'router/router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    final botToastBuilder = BotToastInit();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => getIt<ConnectivityCubit>(),
        ),
      ],
      child: Listener(
        onPointerUp: (_) {
          if (Platform.isIOS) {
            final FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          }
        },
        child: BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (!state.isUserConnectedToTheInternet) {
              BotToast.showText(
                text: "Connection Failed!",
                duration: const Duration(days: 365),
              );
            } else if (state.isUserConnectedToTheInternet) {
              BotToast.cleanAll();
            }
          },
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.router,
            localizationsDelegates: const [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // you can add more locales below
            // ignore: avoid_redundant_argument_values
            supportedLocales: const [
              Locale('en', ''),
            ],
            builder: (context, child) {
              child = botToastBuilder(context, child);

              return child;
            },
          ),
        ),
      ),
    );
  }
}

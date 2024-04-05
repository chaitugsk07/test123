import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/observer/observer.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/theme/app_themes.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    // Get account from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String account = prefs.getString('account') ?? 'na';

    // Set the user ID in Firebase Analytics
    FirebaseAnalytics.instance.setUserId(id: account);

    // Get device info
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // Set the device ID and device serial as user properties
      FirebaseAnalytics.instance
          .setUserProperty(name: 'device_id', value: androidInfo.id);
      FirebaseAnalytics.instance.setUserProperty(
          name: 'device_serial', value: androidInfo.serialNumber);
      FirebaseAnalytics.instance
          .setUserProperty(name: 'os_type', value: 'Android');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // Set the device ID as a user property
      FirebaseAnalytics.instance.setUserProperty(
          name: 'device_id', value: iosInfo.identifierForVendor);
      FirebaseAnalytics.instance.setUserProperty(name: 'os_type', value: 'iOS');
    }
  } catch (e) {
    if (kDebugMode) {
      print("Failed to initialize Firebase: $e");
    }
  }
  Bloc.observer = AppObserver();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiBlocProvider(providers: [
        BlocProvider(
          create: (context) => UserEventBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ], child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log(state.toString());
    // switch (state) {
    //   case AppLifecycleState.inactive:
    //     // Handle this state
    //     break;
    //   case AppLifecycleState.paused:
    //     // Handle this state
    //     break;
    //   case AppLifecycleState.detached:
    //     // Handle this state
    //     break;
    //   case AppLifecycleState.resumed:
    //     // Handle this state
    //     break;
    //   case AppLifecycleState.hidden:
    //     // Handle this state
    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'AllianceNo2',
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'AllianceNo2',
        colorScheme: darkColorScheme,
      ),
      themeMode: ThemeMode.system,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}

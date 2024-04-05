import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/01_splash/bloc_splash/splash_bloc.dart';

class SplashScreen111 extends StatefulWidget {
  const SplashScreen111({super.key});

  @override
  State<SplashScreen111> createState() => _SplashScreen111State();
}

class _SplashScreen111State extends State<SplashScreen111> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashBloc()),
        BlocProvider(
          create: (context) => UserEventBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const SplashCheckLoginStatus());
    notification();
  }

  void notification() async {
    final prefs = await SharedPreferences.getInstance();
    final String fcmtokenOld = prefs.getString('fcmToken') ?? '';
    if (!kIsWeb && fcmtokenOld != '') {
      final bool isLoggedin = prefs.getBool('isLoggedIn') ?? false;
      DateTime now = DateTime.now();
      String loginDate = DateFormat('yyyy-MM-dd').format(now);
      final String lastLoginOld = prefs.getString('lastLogin') ?? '';
      String timeZoneName =
          'UTC${now.timeZoneOffset.isNegative ? '-' : '+'}${now.timeZoneOffset.inHours}';
      int devicetype = 0;
      String deviceId = '';
      String deviceSerial = '';
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission();

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        devicetype = 1;
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceSerial = androidInfo.serialNumber;
        prefs.setString('androidId', deviceId);
        prefs.setString('androidSerialNumber', deviceSerial);
      }
      if (settings.authorizationStatus == AuthorizationStatus.denied ||
          settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        if (isLoggedin && lastLoginOld != loginDate) {
          insetNoNotification(
              devicetype, deviceId, deviceSerial, loginDate, timeZoneName);
        }
      } else if (settings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
        if (fcmtokenOld == "") {
          insetNotification(fcmToken, devicetype, deviceId, deviceSerial,
              loginDate, timeZoneName);
        } else if (fcmtokenOld != fcmToken || lastLoginOld != loginDate) {
          updateNotification(fcmtokenOld, fcmToken, devicetype, deviceId,
              deviceSerial, loginDate, timeZoneName);
        }
        prefs.setString('fcmToken', fcmToken);
        prefs.setString('lastLogin', loginDate);
      }
    }
  }

  void insetNoNotification(
      devicetype, deviceId, deviceSerial, loginDate, timeZone) {
    context.read<UserEventBloc>().add(
          UserEventNoNotification(
              deviceType: devicetype,
              deviceId: deviceId,
              deviceSerial: deviceSerial,
              loginDate: loginDate,
              timeZone: timeZone),
        );
  }

  void insetNotification(
      fcmToken, devicetype, deviceId, deviceSerial, loginDate, timeZone) {
    context.read<UserEventBloc>().add(
          UserEventNotification(
              fcmToken: fcmToken,
              deviceType: devicetype,
              deviceId: deviceId,
              deviceSerial: deviceSerial,
              loginDate: loginDate,
              timeZone: timeZone),
        );
  }

  void updateNotification(fcmTokenOld, fcmToken, devicetype, deviceId,
      deviceSerial, loginDate, timeZone) {
    context.read<UserEventBloc>().add(
          UserEventUpdateNotification(
              fcmTokenOld: fcmTokenOld,
              fcmToken: fcmToken,
              deviceType: devicetype,
              deviceId: deviceId,
              deviceSerial: deviceSerial,
              loginDate: loginDate,
              timeZone: timeZone),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          BlocListener<SplashBloc, SplashState>(
            listener: (context, state) {
              if (state.status == SplashStatus.isloggedin) {
                context.push(home);
              } else if (state.status == SplashStatus.isLanguageSelected) {
                context.push(language);
              } else if (state.status == SplashStatus.isloginskipped) {
              } else if (state.status == SplashStatus.isnotloggedin) {
                context.push(onBoarding);
              } else if (state.status == SplashStatus.isOnBoardingskipped) {
                context.push(signUp);
              } else if (state.status == SplashStatus.error) {
                context.push(onBoarding);
              }
            },
            child: const PageLoading(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

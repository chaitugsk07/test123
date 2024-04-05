import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/03_user_profile/ui/widget/notification_container.dart';
import 'package:synopse/features/04_home/bloc/user_events/user_event_bloc.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserEventBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const Notification(),
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  late bool _isnotifiaction;
  @override
  void initState() {
    super.initState();
    _isnotifiaction = true;
    checkNotificationEnabled();
  }

  Future<void> checkNotificationEnabled() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      _isnotifiaction = true;
      notification();
    } else {
      _isnotifiaction = false;
    }
  }

  void notification() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedin = prefs.getBool('isLoggedIn') ?? false;
    final fcmtokenOld = prefs.getString('fcmToken') ?? '';
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
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      if (fcmtokenOld == "") {
        insetNotification(fcmToken, devicetype, deviceId, deviceSerial,
            loginDate, timeZoneName);
      } else if (fcmtokenOld != "" && fcmtokenOld != fcmToken) {
        updateNotification(fcmtokenOld, fcmToken, devicetype, deviceId,
            deviceSerial, loginDate, timeZoneName);
      }
      prefs.setString('fcmToken', fcmToken);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.push(splash);
              }
            },
          ),
          title: const Text('Notifications'),
        ),
        body: Column(children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.teal.shade700,
                  labelColor: Colors.teal.shade700,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(
                      child: Text("News"),
                    ),
                    Tab(
                      child: Text("Activity"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: MediaQuery.of(context).size.height - 175,
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            if (!_isnotifiaction) const NotificationWidgets(),
                            const Center(
                              child: Text("News 1"),
                            ),
                          ],
                        ),
                        const Center(
                          child: Text("Activity 11"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

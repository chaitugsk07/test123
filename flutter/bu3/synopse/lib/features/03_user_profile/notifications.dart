import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/03_user_profile/widget/notification_container.dart';

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
      notification1();
    } else {
      _isnotifiaction = false;
    }
  }

  void notification1() async {
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
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 5),
                      child: SizedBox(
                        height: 45,
                        width: 250,
                        child: TabBar(
                          isScrollable: false,
                          indicatorWeight: 0,
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          labelPadding: const EdgeInsets.all(0),
                          labelStyle:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          unselectedLabelStyle:
                              Theme.of(context).textTheme.titleMedium,
                          tabs: const [
                            SizedBox(
                              width: 150,
                              child: Tab(
                                text: 'News',
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Tab(
                                text: 'Activity',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 225,
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            if (!_isnotifiaction) const NotificationWidgets(),
                            const Center(
                              child: Text(""),
                            ),
                          ],
                        ),
                        const Center(
                          child: Text(""),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Animate(
          effects: const [
            SlideEffect(
              begin: Offset(0, 1),
              end: Offset(0, 0),
              duration: Duration(milliseconds: 500),
              delay: Duration(milliseconds: 100),
              curve: Curves.easeInOutCubic,
            ),
          ],
          child: BottomNavigationBar(
            useLegacyColorScheme: false,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            type: BottomNavigationBarType.fixed,
            currentIndex: 2,
            onTap: (index) {
              if (index == 0) {
                context.push(home);
              } else if (index == 1) {
                context.push(searchWithText);
              } else if (index == 2) {
                context.push(notification);
              } else if (index == 3) {
                context.push(userMain);
              }
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  SvgConstant.aiIco,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onBackground,
                      BlendMode.srcIn),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  SvgConstant.discoverIco,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onBackground,
                      BlendMode.srcIn),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  SvgConstant.bellIco,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onBackground,
                      BlendMode.srcIn),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  SvgConstant.profileIco,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onBackground,
                      BlendMode.srcIn),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

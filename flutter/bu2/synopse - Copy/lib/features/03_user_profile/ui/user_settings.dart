import 'dart:convert';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/02_login_screens/bloc/login_api.dart';
import 'package:synopse/features/03_user_profile/ui/widget/account_options.dart';
import 'package:synopse/features/03_user_profile/ui/widget/feedback_widget.dart';
import 'package:synopse/features/03_user_profile/ui/widget/legal_widget.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => UserEventBloc(
          rssFeedServices: RssFeedServicesFeed(
            GraphQLService(),
          ),
        ),
      ),
    ], child: const UserSetting());
  }
}

class UserSetting extends StatefulWidget {
  const UserSetting({super.key});

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  Future<List<List<dynamic>>> loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('c1List') ?? '[]';
    return jsonDecode(jsonString);
  }

  static final Config config = Config(
    tenant: '4ce54642-fd13-4892-88a9-729f6b45f3f1',
    clientId: 'a6e335f0-95eb-4b4a-959d-e4aeb4c742b0',
    scope: 'openid profile offline_access',
    navigatorKey: router.routerDelegate.navigatorKey,
    loader: const SizedBox(),
    appBar: AppBar(
      title: const Text('AAD OAuth Demo'),
    ),
  );
  final AadOAuth oauth = AadOAuth(config);
  void signOut() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('isOnboardingSkip', true);
    prefs.setBool('isLoggedIn', false);
    prefs.setBool('isLoginSkipped', false);
    prefs.setString('loginToken', "");
    prefs.setString('account', "");
    prefs.setString('exp', "");
    if (prefs.getBool("isMicrosoftLoggedIn") ?? false) {
      await oauth.logout();
      prefs.setBool("isMicrosoftLoggedIn", false);
    }
    if (prefs.getBool("isGoogleLoggedIn") ?? false) {
      await LoginApi.signOut();
      prefs.setBool("isGoogleLoggedIn", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Animate(
            effects: const [
              FadeEffect(
                duration: Duration(milliseconds: 300),
                delay: Duration(milliseconds: 1000),
              )
            ],
            child: IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.push(splash);
                  }
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          title: Animate(
            effects: const [
              FadeEffect(
                duration: Duration(milliseconds: 300),
                delay: Duration(milliseconds: 1000),
              )
            ],
            child: const Text('User Settings', textAlign: TextAlign.center),
          ),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.push(userUpdate);
              },
              child: Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1000),
                  )
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: FaIcon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      Text(
                        "Edit Profile",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(userNav, extra: 2);
              },
              child: Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1000),
                  )
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: FaIcon(
                          FontAwesomeIcons.eye,
                          color: Colors.grey,
                          size: 17,
                        ),
                      ),
                      Text(
                        "Navigation Preferences",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(userIntrests);
              },
              child: Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1000),
                  )
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: FaIcon(
                          FontAwesomeIcons.userLock,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      Text(
                        "Manage Intrests",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(notification);
              },
              child: Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1000),
                  )
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      Text(
                        "Enable Push Notifications",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const LegalWidget();
                  },
                );
              },
              child: Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1000),
                  )
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: FaIcon(
                          FontAwesomeIcons.gavel,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                      Text(
                        "Legal",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const FeedbackWidget();
                  },
                );
              },
              child: Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1000),
                  )
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 10),
                        child: FaIcon(
                          FontAwesomeIcons.towerBroadcast,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      Text(
                        "Feedback & Support",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AccountOptions();
                  },
                );
              },
              child: Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1000),
                  )
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: FaIcon(
                          FontAwesomeIcons.userPen,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
                      Text(
                        "Account Options",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                signOut();
                context.push(splash);
              },
              child: Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1000),
                  )
                ],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: FaIcon(
                          FontAwesomeIcons.rightFromBracket,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      Text(
                        "Sign Out",
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.red,
                                ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

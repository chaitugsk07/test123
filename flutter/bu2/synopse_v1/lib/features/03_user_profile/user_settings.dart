import 'dart:convert';

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
import 'package:synopse/features/02_login_screens/login_api.dart';
import 'package:synopse/features/03_user_profile/widget/account_options.dart';
import 'package:synopse/features/03_user_profile/widget/feedback_widget.dart';
import 'package:synopse/features/03_user_profile/widget/legal_widget.dart';

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

  void signOut() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('isOnboardingSkip', true);
    prefs.setBool('isLoggedIn', false);
    prefs.setBool('isLoginSkipped', false);
    prefs.setString('loginToken', "");
    prefs.setString('account', "");
    prefs.setString('exp', "");
    if (prefs.getBool("isMicrosoftLoggedIn") ?? false) {
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.push(userMain);
            },
          ),
          title: const Text('User Settings'),
          centerTitle: true,
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
            //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
            Animate(
              effects: [
                FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
              ],
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                thickness: 0.1,
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
                      SizedBox(width: 1),
                      Text(
                        "Navigation Preferences",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
            Animate(
              effects: [
                FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
              ],
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                thickness: 0.1,
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
                          size: 16,
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
            //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
            Animate(
              effects: [
                FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
              ],
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                thickness: 0.1,
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
                      SizedBox(width: 2),
                      Text(
                        "Push Notifications",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
            Animate(
              effects: [
                FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
              ],
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                thickness: 0.1,
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
                      SizedBox(width: 2),
                      Text(
                        "Legal",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
            Animate(
              effects: [
                FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
              ],
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                thickness: 0.1,
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
                      SizedBox(width: 2),
                      Text(
                        "Feedback & Support",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
            Animate(
              effects: [
                FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
              ],
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                thickness: 0.1,
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
                      SizedBox(width: 2),
                      Text(
                        "Account Options",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
            Animate(
              effects: [
                FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
              ],
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                thickness: 0.1,
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
            //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
            Animate(
              effects: [
                FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
              ],
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                thickness: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

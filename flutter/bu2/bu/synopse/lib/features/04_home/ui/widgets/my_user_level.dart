import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/04_home/bloc/user_level_metadata/user_level_bloc.dart';

class MyUserLevel1 extends StatelessWidget {
  const MyUserLevel1({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserLevelBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const MyUserLevel(),
    );
  }
}

class MyUserLevel extends StatefulWidget {
  const MyUserLevel({super.key});

  @override
  State<MyUserLevel> createState() => _MyUserLevelState();
}

class _MyUserLevelState extends State<MyUserLevel> {
  late String account;
  @override
  void initState() {
    super.initState();
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        account = prefs.getString('account') ?? '';
        context.read<UserLevelBloc>().add(
              UserLevelFetch(account: account),
            );
      },
    );
  }

  _userLevel(int level, String userName, String levelName, int reputationPoints,
      int requiredPoints, String memberSince) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("userLevel", level);
    prefs.setString("userName", userName);
    prefs.setString("userLevelName", levelName);
    prefs.setInt("userLevelReputationPoints", reputationPoints);
    prefs.setInt("userLevelRequiredPoints", requiredPoints);
    prefs.setString("userLevelMemberSince", memberSince);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLevelBloc, UserLevelState>(
        builder: (context, userLevelState) {
      if (userLevelState.status == UserLevelStatus.initial) {
        return Container();
      } else if (userLevelState.status == UserLevelStatus.success) {
        final userLevel1 = userLevelState.synopseRealtimeVUserLevel[0];
        _userLevel(
            userLevel1.levelNo,
            userLevel1.userToLink!.username,
            userLevel1.userLevelLink!.levelName,
            userLevel1.userReputation,
            userLevel1.requiredPoints,
            userLevel1.userMetadata!.memberSince);
        return GestureDetector(
          onTap: () {
            context.push(userLevel);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Animate(
                        effects: const [
                          FadeEffect(
                            duration: Duration(milliseconds: 1000),
                            delay: Duration(milliseconds: 500),
                          ),
                        ],
                        child: FaIcon(
                          FontAwesomeIcons.shield,
                          color: Colors.purpleAccent.shade400,
                          size: 15,
                        ),
                      ),
                      Animate(
                        effects: const [
                          FadeEffect(
                            duration: Duration(milliseconds: 1000),
                            delay: Duration(milliseconds: 700),
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            userLevel1.userLevelLink!.levelName,
                            style: MyTypography.body.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Animate(
                        effects: const [
                          FadeEffect(
                            duration: Duration(milliseconds: 1000),
                            delay: Duration(milliseconds: 700),
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${userLevel1.userReputation} reputation",
                            style: MyTypography.body.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Animate(
                  effects: const [
                    FadeEffect(
                      duration: Duration(milliseconds: 1000),
                      delay: Duration(milliseconds: 900),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: LinearProgressIndicator(
                      value: userLevel1.requiredPoints / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.purpleAccent),
                    ),
                  ),
                ),
                Animate(
                  effects: const [
                    FadeEffect(
                      duration: Duration(milliseconds: 1000),
                      delay: Duration(milliseconds: 900),
                    ),
                  ],
                  child: Text(
                    '${userLevel1.userLevelLink!.userReputationTo - userLevel1.userReputation} points required for next level ${userLevel1.levelNo + 1}',
                    style: MyTypography.body.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 350.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                    thickness: 0.7,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc/user_levels/user_levels_bloc.dart';

class UserLevels extends StatelessWidget {
  const UserLevels({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserLevelsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const UserLevel(),
    );
  }
}

class UserLevel extends StatefulWidget {
  const UserLevel({super.key});

  @override
  State<UserLevel> createState() => _UserLevelState();
}

class _UserLevelState extends State<UserLevel> {
  late String account;
  late String levelName;
  late int levelNo;
  late int userReputation;
  late int requiredPoints;
  late String memberSince;
  late String userName;
  @override
  void initState() {
    super.initState();
    context.read<UserLevelsBloc>().add(const UserLevelsFetch());
    account = '';
    levelName = '';
    levelNo = 0;
    userReputation = 0;
    requiredPoints = 0;
    memberSince = '';
    userName = '';
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(
      () {
        account = prefs.getString('account') ?? '';
        levelName = prefs.getString('userLevelName') ?? '';
        levelNo = prefs.getInt('userLevel') ?? 0;
        userReputation = prefs.getInt('userLevelReputationPoints') ?? 0;
        requiredPoints = prefs.getInt('userLevelRequiredPoints') ?? 0;
        memberSince = prefs.getString('userLevelMemberSince') ?? '';
        userName = prefs.getString('userName') ?? '';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(home);
              }
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text("view Levels"),
          centerTitle: true,
        ),
        body: BlocBuilder<UserLevelsBloc, UserLevelsState>(
          builder: (context, userLevelsState) {
            if (userLevelsState.status == UserLevelsStatus.initial) {
              return const Center(
                child: PageLoading(),
              );
            } else if (userLevelsState.status == UserLevelsStatus.success) {
              return Center(
                child: Column(
                  children: [
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 350.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Text(
                        levelName,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 500.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          "$requiredPoints more points required untill you reach next level",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 650.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          "Level up to get more reputation points and unlock more features",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 650.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                        thickness: 0.4,
                      ),
                    ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 750.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              "Level",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              "Points",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount:
                            userLevelsState.synopseRealtimeTUserLevel.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 4.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: userLevelsState
                                              .synopseRealtimeTUserLevel[index]
                                              .levelNo ==
                                          levelNo
                                      ? Colors.blueAccent
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(
                                              0.05), // Set border color
                                  width: 3.0, // Set border width
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: userLevelsState
                                            .synopseRealtimeTUserLevel[index]
                                            .levelNo ==
                                        levelNo
                                    ? Colors.blueAccent.withOpacity(0.5)
                                    : Theme.of(context).colorScheme.background,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userLevelsState
                                              .synopseRealtimeTUserLevel[index]
                                              .levelName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          userLevelsState
                                              .synopseRealtimeTUserLevel[index]
                                              .levelInfo,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      userLevelsState
                                          .synopseRealtimeTUserLevel[index]
                                          .userReputationFrom
                                          .toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/f_repo/models/user_imp_tiles.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/ui/widget/user_comments.dart';
import 'package:synopse/features/03_user_profile/ui/widget/user_read.dart';
import 'package:synopse/features/03_user_profile/ui/widget/user_saved.dart';
import 'package:synopse/features/09_external_user/bloc/ext_user_follow/ext_user_follow_bloc.dart';
import 'package:synopse/features/09_external_user/bloc/ext_user_metadata/ext_user_bloc.dart';

class UserProfile1 extends StatelessWidget {
  const UserProfile1({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExtUserBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ExtUserFollowBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late int randomNumber;
  late String account;
  @override
  void initState() {
    super.initState();

    _getAccountFromSharedPreferences();

    randomNumber = getRandomNumber();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        account = prefs.getString('account') ?? '';

        context.read<ExtUserBloc>().add(ExtUserFetch(account: account));
        context.read<ExtUserFollowBloc>().add(
              ExtUserFollowFetch(account: account),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> backgroundColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.brown,
      Colors.lime,
      Colors.amber,
      Colors.grey,
    ];
    final List<Color> textColors = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.black,
      Colors.black,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.black,
      Colors.black,
      Colors.black,
    ];
    return SafeArea(
      child: BlocBuilder<ExtUserBloc, ExtUserState>(
        builder: (context, extUserState) {
          if (extUserState.status == ExtUserStatus.initial) {
            return const Center(
              child: PageLoading(),
            );
          } else if (extUserState.status == ExtUserStatus.success) {
            final String initials = getInitials(extUserState
                .synopseRealtimeVUserMetadatum[0]
                .userToLevel!
                .userToLink!
                .name);
            return Scaffold(
              appBar: AppBar(
                leading: Animate(
                  effects: [
                    FadeEffect(
                        delay: 100.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.push(home);
                    },
                  ),
                ),
                title: Animate(
                  effects: [
                    FadeEffect(
                        delay: 100.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: const Text('User', style: MyTypography.t1),
                ),
                actions: [
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        context.push(userSettings);
                      },
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Handle share button press
                      },
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 100,
                                child: Text(
                                  extUserState.synopseRealtimeVUserMetadatum[0]
                                      .userToLevel!.userToLink!.name,
                                  textAlign: TextAlign.center,
                                  style: MyTypography.t1,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.1)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: Text(
                                    extUserState
                                        .synopseRealtimeVUserMetadatum[0]
                                        .userToLevel!
                                        .userLevelLink!
                                        .levelName,
                                    style: MyTypography.t12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (extUserState.synopseRealtimeVUserMetadatum[0]
                                .userToLevel!.userToLink!.photourl ==
                            "na")
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 200.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10, top: 5),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: backgroundColors[randomNumber],
                                child: Text(
                                  initials,
                                  style: MyTypography.t12.copyWith(
                                    color: textColors[randomNumber],
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (extUserState.synopseRealtimeVUserMetadatum[0]
                                .userToLevel!.userToLink!.photourl !=
                            "na")
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 200.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10, top: 5),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(extUserState
                                    .synopseRealtimeVUserMetadatum[0]
                                    .userToLevel!
                                    .userToLink!
                                    .photourl),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (extUserState.synopseRealtimeVUserMetadatum[0]
                            .userToLevel!.userToLink!.bio !=
                        "")
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            extUserState.synopseRealtimeVUserMetadatum[0]
                                .userToLevel!.userToLink!.bio,
                            textAlign: TextAlign.center,
                            style: MyTypography.t1,
                          ),
                        ),
                      ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 350.milliseconds,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UserImpTile1(
                            t1Number: extUserState
                                .synopseRealtimeVUserMetadatum[0].userReputation
                                .toString(),
                            t1Text: "Reputation",
                          ),
                          UserImpTile1(
                            t1Number: extUserState
                                .synopseRealtimeVUserMetadatum[0].userFollowing
                                .toString(),
                            t1Text: "Following",
                          ),
                          UserImpTile1(
                            t1Number: extUserState
                                .synopseRealtimeVUserMetadatum[0].userFollowers
                                .toString(),
                            t1Text: "Followers",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UserImpTile1(
                            t1Number: extUserState
                                .synopseRealtimeVUserMetadatum[0].userViewCount
                                .toString(),
                            t1Text: "Views",
                          ),
                          UserImpTile1(
                            t1Number: extUserState
                                .synopseRealtimeVUserMetadatum[0].userLikeCount
                                .toString(),
                            t1Text: "Likes",
                          ),
                          UserImpTile1(
                            t1Number: extUserState
                                .synopseRealtimeVUserMetadatum[0]
                                .userCommentCount
                                .toString(),
                            t1Text: "Comments",
                          ),
                        ],
                      ),
                    ),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            isScrollable: true,
                            indicatorColor: Colors.teal.shade700,
                            labelColor: Colors.teal.shade700,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(
                                child: Text("Saves"),
                              ),
                              Tab(
                                child: Text("Comments"),
                              ),
                              Tab(
                                child: Text("Read"),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 135,
                            child: TabBarView(
                              children: [
                                const UserSavedS(),
                                Center(
                                  child: UserComments1(
                                    photoUrl: extUserState
                                        .synopseRealtimeVUserMetadatum[0]
                                        .userToLevel!
                                        .userToLink!
                                        .photourl,
                                    userName: extUserState
                                        .synopseRealtimeVUserMetadatum[0]
                                        .userToLevel!
                                        .userToLink!
                                        .username,
                                    initials: initials,
                                  ),
                                ),
                                const Center(
                                  child: UserReadS(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  String getInitials(String text) {
    List<String> words = text.split(' ');
    if (words.length > 1) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    } else {
      return words[0][0].toUpperCase() +
          words[0][words[0].length - 1].toUpperCase();
    }
  }

  int getRandomNumber() {
    var random = Random();
    return random.nextInt(13); // 14 is exclusive
  }
}

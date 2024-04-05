import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc_ext_user_follow/ext_user_follow_bloc.dart';
import 'package:synopse/features/03_user_profile/bloc_ext_user_metadata/ext_user_bloc.dart';
import 'package:synopse/features/03_user_profile/widget/user_liked.dart';
import 'package:synopse/features/03_user_profile/widget/user_read.dart';
import 'package:synopse/features/03_user_profile/widget/user_saved.dart';

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

  Future<void> share(String username, String account) async {
    final result = await Share.shareWithResult(
        'Checkout my Synopse profile $username \n https://synopse-ai.web.app/de/$account'
        '\n -via Synopse AI');

    if (result.status == ShareResultStatus.success) {
      _showSnackBar('Profile link shared successfully');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
        ),
      ),
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
            // final String initials = getInitials(extUserState
            //     .synopseRealtimeVUserMetadatum[0]
            //     .userToLevel!
            //     .userToLink!
            //     .name);
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
                  child: const Text(
                    'Profile',
                  ),
                ),
                centerTitle: true,
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
                        share(
                            extUserState.synopseRealtimeVUserMetadatum[0]
                                .userToLevel!.userToLink!.username,
                            account);
                      },
                    ),
                  ),
                ],
              ),
              body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: ((context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        floating: true,
                        automaticallyImplyLeading: false,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        foregroundColor:
                            Theme.of(context).colorScheme.onBackground,
                        scrolledUnderElevation: 0.0,
                        centerTitle: true,
                        elevation: 0.0,
                        expandedHeight: 400,
                        flexibleSpace: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            BlocBuilder<ExtUserBloc, ExtUserState>(
                              builder: (context, extUserState) {
                                if (extUserState.status ==
                                    ExtUserStatus.initial) {
                                  return const Center(
                                    child: PageLoading(),
                                  );
                                } else if (extUserState.status ==
                                    ExtUserStatus.success) {
                                  final String initials = getInitials(
                                      extUserState
                                          .synopseRealtimeVUserMetadatum[0]
                                          .userToLevel!
                                          .userToLink!
                                          .name);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 5,
                                              ),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: SizedBox(
                                                      height: 110,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Image.asset(
                                                        ImageConstant.prodile,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 120,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 50,
                                              left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  50,
                                              child: Column(
                                                children: [
                                                  if (extUserState
                                                          .synopseRealtimeVUserMetadatum[
                                                              0]
                                                          .userToLevel!
                                                          .userToLink!
                                                          .photourl !=
                                                      "na")
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10,
                                                              top: 5),
                                                      child: CircleAvatar(
                                                        radius: 50,
                                                        backgroundImage:
                                                            NetworkImage(extUserState
                                                                .synopseRealtimeVUserMetadatum[
                                                                    0]
                                                                .userToLevel!
                                                                .userToLink!
                                                                .photourl),
                                                      ),
                                                    ),
                                                  if (extUserState
                                                          .synopseRealtimeVUserMetadatum[
                                                              0]
                                                          .userToLevel!
                                                          .userToLink!
                                                          .photourl ==
                                                      "na")
                                                    Animate(
                                                      effects: [
                                                        FadeEffect(
                                                            delay: 200
                                                                .milliseconds,
                                                            duration: 1000
                                                                .milliseconds)
                                                      ],
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 20,
                                                                top: 5),
                                                        child: CircleAvatar(
                                                          radius: 52,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: CircleAvatar(
                                                              radius: 50,
                                                              backgroundColor:
                                                                  backgroundColors[
                                                                      randomNumber],
                                                              child: Text(
                                                                initials,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayMedium!
                                                                    .copyWith(
                                                                      color: textColors[
                                                                          randomNumber],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 170,
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 20,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              "@${extUserState.synopseRealtimeVUserMetadatum[0].userToLevel!.userToLink!.username}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              extUserState
                                                                  .synopseRealtimeVUserMetadatum[
                                                                      0]
                                                                  .userToLevel!
                                                                  .userToLink!
                                                                  .bio,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 75,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.1),
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 100,
                                                height: 60,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        extUserState
                                                            .synopseRealtimeVUserMetadatum[
                                                                0]
                                                            .userFollowing
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const Text(
                                                        'Following',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(0.2),
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        extUserState
                                                            .synopseRealtimeVUserMetadatum[
                                                                0]
                                                            .userReputation
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const Text(
                                                        'Reputation',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                width: 100,
                                                height: 60,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        extUserState
                                                            .synopseRealtimeVUserMetadatum[
                                                                0]
                                                            .userFollowers
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const Text(
                                                        'Followers',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(kToolbarHeight),
                          child: Container(
                            color: Theme.of(context).colorScheme.background,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width - 30,
                                  child: TabBar(
                                    isScrollable: false,
                                    dividerColor: Colors.transparent,
                                    indicator: BoxDecoration(
                                      gradient: const SweepGradient(
                                        center: FractionalOffset.center,
                                        startAngle: 0.0,
                                        endAngle: 3.14 * 2,
                                        colors: <Color>[
                                          Color.fromARGB(255, 252, 165, 124),
                                          Color.fromARGB(255, 114, 170, 220),
                                          Color.fromARGB(255, 196, 141, 193),
                                          Color.fromARGB(255, 116, 220, 244),
                                          Color.fromARGB(255, 210, 184, 166),
                                        ],
                                        stops: <double>[
                                          0.0,
                                          0.15,
                                          0.35,
                                          0.65,
                                          1.0
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    indicatorPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 13),
                                    labelPadding: const EdgeInsets.all(
                                        5), // Add this line
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.grey,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    unselectedLabelStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                    tabs: const [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 8.0),
                                        child: Tab(
                                          text: 'Saved',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 8.0),
                                        child: Tab(
                                          text: 'Read',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 8.0),
                                        child: Tab(
                                          text: 'Likes',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  }),
                  body: Builder(builder: (context) {
                    final innerScrollController =
                        PrimaryScrollController.of(context);
                    return TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UserSavedS(
                            primaryScrollController: innerScrollController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UserReadS(
                            primaryScrollController: innerScrollController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UserLikedS(
                            account: account,
                            primaryScrollController: innerScrollController,
                          ),
                        ),
                      ],
                    );
                  }),
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

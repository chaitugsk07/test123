import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/my_user_level.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc_ext_user_follow/ext_user_follow_bloc.dart';
import 'package:synopse/features/03_user_profile/bloc_ext_user_metadata/ext_user_bloc.dart';
import 'package:synopse/features/03_user_profile/widget/user_liked.dart';
import 'package:synopse/features/03_user_profile/widget/user_read.dart';
import 'package:synopse/features/03_user_profile/widget/user_saved.dart';
import 'package:synopse/features/04_home/widgets/my_user_follow.dart';

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
        'Checkout my Synopse profile $username \n https://d.synopseai.com/de/$account'
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
    //   Size screenSize = MediaQuery.of(context).size;
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
              child: PageLoading(
                title: 'User Profile',
              ),
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
                elevation: 0,
                scrolledUnderElevation: 0,
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
                                    child: PageLoading(
                                      title: 'User Profile',
                                    ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                              minWidth: 300, maxWidth: 500),
                                          child: Builder(builder: (context) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5),
                                                        child: CircleAvatar(
                                                          radius: 40,
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
                                                                  left: 10,
                                                                  right: 10,
                                                                  top: 5),
                                                          child: CircleAvatar(
                                                            radius: 42,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .background,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 40,
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
                                                                            FontWeight.bold,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      extUserState
                                                          .synopseRealtimeVUserMetadatum[
                                                              0]
                                                          .userToLevel!
                                                          .userToLink!
                                                          .name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                              fontSize: 20),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "@${extUserState.synopseRealtimeVUserMetadatum[0].userToLevel!.userToLink!.username}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onBackground
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width >
                                                              500
                                                          ? 350
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      child: Text(
                                                          extUserState
                                                              .synopseRealtimeVUserMetadatum[
                                                                  0]
                                                              .userToLevel!
                                                              .userToLink!
                                                              .bio,
                                                          maxLines: 2,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                        Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child: MyUserLevel1(),
                                            ),
                                            Animate(
                                              effects: [
                                                FadeEffect(
                                                    delay: 200.milliseconds,
                                                    duration: 1000.milliseconds)
                                              ],
                                              child: MyUserFollow(
                                                following: extUserState
                                                    .synopseRealtimeVUserMetadatum[
                                                        0]
                                                    .userFollowing
                                                    .toString(),
                                                reputation: extUserState
                                                    .synopseRealtimeVUserMetadatum[
                                                        0]
                                                    .userReputation
                                                    .toString(),
                                                followers: extUserState
                                                    .synopseRealtimeVUserMetadatum[
                                                        0]
                                                    .userFollowers
                                                    .toString(),
                                              ),
                                            ),
                                          ],
                                        ),
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
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Animate(
                              effects: [
                                FadeEffect(
                                    delay: 300.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                child: SizedBox(
                                  height: 45,
                                  width: 350,
                                  child: TabBar(
                                    isScrollable: false,
                                    indicatorWeight: 0,
                                    dividerColor: Colors.transparent,
                                    indicator: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.grey,
                                    labelPadding: const EdgeInsets.all(0),
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    unselectedLabelStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                    tabs: const [
                                      SizedBox(
                                        width: 150,
                                        child: Tab(
                                          text: 'Saved',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Tab(
                                          text: 'Read',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Tab(
                                          text: 'Likes',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                  currentIndex: 3,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/04_home/bloc_user_intrests_tags/user_intrests_tags_bloc.dart';
import 'package:synopse/features/04_home/bloc_user_level_metadata/user_level_bloc.dart';
import 'package:synopse/features/04_home/bloc_user_nav1/user_nav1_bloc.dart';
import 'package:synopse/features/04_home/widgets/audio_player.dart';
import 'package:synopse/features/04_home/widgets/for_you_page.dart';
import 'package:synopse/features/04_home/widgets/tag_page.dart';

class Home111 extends StatelessWidget {
  const Home111({super.key});

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
        BlocProvider(
          create: (context) => UserNav1Bloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UserIntrestsTagsBloc1(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const Home11(),
    );
  }
}

class Home11 extends StatefulWidget {
  const Home11({super.key});

  @override
  State<Home11> createState() => _Home11State();
}

class _Home11State extends State<Home11> {
  late String account;
  late String level;
  late String search;
  late String forYou;
  late List<List<dynamic>> combinedTabList;
  late List<String> navTabList;
  late String areYouSure;
  late String exitApp;
  late String yes;
  late String no;
  late List<String> hTags;

  @override
  void initState() {
    super.initState();
    account = '';
    level = '';
    combinedTabList = [];
    navTabList = [];
    search = '';
    forYou = '';
    areYouSure = '';
    exitApp = '';
    yes = '';
    no = '';
    hTags = [];
    _getAccountFromSharedPreferences();
    closeKeyboardIfOpen();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        account = prefs.getString('account') ?? '';
        level = prefs.getString('level') ?? 'Level';
        search = prefs.getString('search') ?? 'Search';
        forYou = prefs.getString('forYou') ?? 'For You';
        areYouSure = prefs.getString('areYouSure') ?? 'Are you sure?';
        exitApp = prefs.getString('exitApp') ?? 'Do you want to exit the App?';
        yes = prefs.getString('yes') ?? 'Yes';
        no = prefs.getString('no') ?? 'No';
        context.read<UserLevelBloc>().add(
              UserLevelFetch(account: account),
            );
        combinedTabList = [
          [forYou, 0, 0, 0]
        ];
        navTabList = [];
        context.read<UserNav1Bloc>().add(UserNav1Fetch());

        final userNav1Bloc = BlocProvider.of<UserNav1Bloc>(context);
        userNav1Bloc.stream.listen(
          (state) {
            if (state.status == UserNav1Status.success) {
              for (final item in state.synopseAuthTAuthUserProfile[0].nav1) {
                combinedTabList
                    .add([item.tabItem, item.type, item.index1, item.index2]);
                navTabList.add(item.tabItem);
              }
              setState(() {});
            }
          },
        );
        final userIntrestsTags =
            BlocProvider.of<UserIntrestsTagsBloc1>(context);
        context.read<UserIntrestsTagsBloc1>().add(UserIntrestsTagsFetch());
        userIntrestsTags.stream.listen(
          (state) {
            if (state.status == UserIntrestsTagsStatus.success) {
              for (final item in state.synopseRealtimeTUserTagUI) {
                hTags.add(item.tV4TagsHierarchy!.tag);
              }
              setState(() {});
            }
          },
        );
      },
    );
  }

  void closeKeyboardIfOpen() {
    if (FocusManager.instance.primaryFocus?.hasFocus == true) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _userLevel(int level, String userName, String levelName, int reputationPoints,
      int requiredPoints, String memberSince, String photoURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("userLevel", level);
    prefs.setString("userName", userName);
    prefs.setString("userLevelName", levelName);
    prefs.setInt("userLevelReputationPoints", reputationPoints);
    prefs.setInt("userLevelRequiredPoints", requiredPoints);
    prefs.setString("userLevelMemberSince", memberSince);
    prefs.setString("userLevePhotoURL", photoURL);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              shadowColor: Theme.of(context).colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: SizedBox(
                height: 300,
                width: 400,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: SvgPicture.asset(
                      SvgConstant.logo,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onBackground,
                          BlendMode.srcIn),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      "Do you want to exit the App?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "Are you sure?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: GestureDetector(
                      onTap: () {
                        context.push(home);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 40,
                        width: 200,
                        child: Text(
                          "No",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.background,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: GestureDetector(
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            );
          },
        );
        return;
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 300,
                maxWidth: 1500,
                minHeight: 500,
              ),
              child: Builder(builder: (context) {
                return BlocBuilder<UserNav1Bloc, UserNav1State>(
                    builder: (context, userNav1State) {
                  if (userNav1State.status == UserNav1Status.success) {
                    return DefaultTabController(
                      length: combinedTabList.length,
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
                              expandedHeight: 172,
                              flexibleSpace: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  BlocBuilder<UserLevelBloc, UserLevelState>(
                                    builder: (context, userLevelState) {
                                      if (userLevelState.status ==
                                          UserLevelStatus.initial) {
                                        return Container();
                                      } else if (userLevelState.status ==
                                          UserLevelStatus.success) {
                                        final userLevel1 = userLevelState
                                            .synopseRealtimeVUserLevel[0];
                                        _userLevel(
                                          userLevel1.levelNo,
                                          userLevel1.userToLink!.username,
                                          userLevel1.userLevelLink!.levelName,
                                          userLevel1.userReputation,
                                          userLevel1.requiredPoints,
                                          userLevel1.userMetadata!.memberSince,
                                          userLevel1.userToLink!.photourl,
                                        );
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 16),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        context.push(inShorts);
                                                      },
                                                      child: SizedBox(
                                                        width: 40,
                                                        child: SvgPicture.asset(
                                                          SvgConstant.layers,
                                                          colorFilter: ColorFilter.mode(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                              BlendMode.srcIn),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 55,
                                                  ),
                                                  const Spacer(),
                                                  SizedBox(
                                                    width: 40,
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        SvgConstant.logo,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  SizedBox(
                                                    width: 55,
                                                    child: Center(
                                                      child: Text(
                                                        "$level ${userLevel1.levelNo}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: SizedBox(
                                                      width: 40,
                                                      child: SvgPicture.asset(
                                                        "${SvgConstant.svgPath}/level_${userLevel1.levelNo}.svg",
                                                        width: 20,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
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
                                  GestureDetector(
                                    onTap: () {
                                      context.push(searchWithText);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: SizedBox(
                                        height:
                                            50, // Adjust the height as needed
                                        child: Center(
                                          child: SizedBox(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                50,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 10),
                                                  Icon(
                                                    Icons.search_outlined,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground
                                                        .withOpacity(0.5),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    search,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onBackground
                                                              .withOpacity(0.5),
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
                                ],
                              ),
                              bottom: PreferredSize(
                                preferredSize:
                                    const Size.fromHeight(kToolbarHeight),
                                child: Container(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: SizedBox(
                                          height: 55,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: TabBar(
                                            tabAlignment: TabAlignment.start,
                                            isScrollable: true,
                                            dividerColor: Colors.transparent,
                                            indicator: BoxDecoration(
                                              gradient: const SweepGradient(
                                                center: FractionalOffset.center,
                                                startAngle: 0.0,
                                                endAngle: 3.14 * 2,
                                                colors: <Color>[
                                                  Color.fromARGB(
                                                      255, 252, 165, 124),
                                                  Color.fromARGB(
                                                      255, 114, 170, 220),
                                                  Color.fromARGB(
                                                      255, 196, 141, 193),
                                                  Color.fromARGB(
                                                      255, 116, 220, 244),
                                                  Color.fromARGB(
                                                      255, 210, 184, 166),
                                                ],
                                                stops: <double>[
                                                  0.0,
                                                  0.15,
                                                  0.35,
                                                  0.65,
                                                  1.0
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            indicatorPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 13),
                                            labelPadding: const EdgeInsets.all(
                                                5), // Add this line
                                            labelColor: Colors.white,
                                            unselectedLabelColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                            unselectedLabelStyle:
                                                Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                            tabs: [
                                              for (final item
                                                  in combinedTabList)
                                                Tab(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 5,
                                                            bottom: 2),
                                                    child: Text(
                                                      item[0],
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.push(userNav, extra: 1);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: FaIcon(
                                            FontAwesomeIcons.ellipsis,
                                            size: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ];
                        }),
                        body: Builder(
                          builder: (context) {
                            final innerScrollController =
                                PrimaryScrollController.of(context);
                            return Stack(
                              children: [
                                TabBarView(
                                  children: [
                                    for (final item in combinedTabList)
                                      Column(
                                        children: [
                                          if (item[1] == 0)
                                            ForYouS(
                                              primaryScrollController:
                                                  innerScrollController,
                                              hTags: hTags,
                                            ),
                                          if (item[1] == 1)
                                            TagPage(
                                              tag: item[0],
                                              tagIndex1: item[2],
                                              tagIndex2: item[3],
                                              primaryScrollController:
                                                  innerScrollController,
                                            ),
                                          if (item[1] > 1)
                                            ForYouS(
                                              primaryScrollController:
                                                  innerScrollController,
                                              hTags: hTags,
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 1000.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: AudioPlayer111(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
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
              currentIndex: 0,
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
      ),
    );
  }
}

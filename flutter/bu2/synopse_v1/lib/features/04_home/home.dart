import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/04_home/bloc_user_level_metadata/user_level_bloc.dart';
import 'package:synopse/features/04_home/bloc_user_nav1/user_nav1_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    account = ''; // Initialize account
    level = ''; // Initialize level
    combinedTabList = []; // Initialize combinedTabList
    navTabList = []; // Initialize navTabList
    search = '';
    forYou = '';
    areYouSure = '';
    exitApp = '';
    yes = '';
    no = '';

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
      },
    );
  }

  void closeKeyboardIfOpen() {
    // Check if the keyboard is open
    if (FocusManager.instance.primaryFocus?.hasFocus == true) {
      // Close the keyboard
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              areYouSure,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            content: Text(
              exitApp,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.push(home);
                      }
                    },
                    child: Text(
                      no,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text(
                      yes,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<UserNav1Bloc, UserNav1State>(
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
                        expandedHeight: 150,
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
                                      userLevel1.userMetadata!.memberSince);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const SizedBox(
                                              width: 40,
                                              child:
                                                  Icon(Icons.layers_outlined),
                                            ),
                                            const SizedBox(
                                              width: 55,
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              width: 40,
                                              child: Center(
                                                child: Image.asset(
                                                    ImageConstant.imgLogo,
                                                    height: 35,
                                                    width: 35),
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              width: 55,
                                              child: Center(
                                                child: Text(
                                                  "$level ${userLevel1.levelNo}",
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 40,
                                              child: Icon(Icons
                                                  .keyboard_double_arrow_up_outlined),
                                            ),
                                            const SizedBox(
                                              width: 10,
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
                              child: SizedBox(
                                height: 50, // Adjust the height as needed
                                child: Center(
                                  child: SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
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
                                                  color: Theme.of(context)
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
                                    tabAlignment: TabAlignment.start,
                                    isScrollable: true,
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
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    unselectedLabelStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                    tabs: [
                                      for (final item in combinedTabList)
                                        Tab(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              item[0],
                                            ),
                                          ),
                                        ),
                                    ],
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
                  body: Builder(builder: (context) {
                    final innerScrollController =
                        PrimaryScrollController.of(context);
                    return TabBarView(
                      children: [
                        for (final item in combinedTabList)
                          Column(
                            children: [
                              if (item[1] == 0)
                                ForYouS(
                                  primaryScrollController:
                                      innerScrollController,
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
                                ),
                            ],
                          ),
                      ],
                    );
                  }),
                ),
              );
            } else {
              return Container();
            }
          }),
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
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.wandMagicSparkles,
                    size: 18,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.compass,
                    size: 20,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.bell,
                    size: 20,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.user,
                    size: 20,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/04_home/bloc/user_nav1/user_nav1_bloc.dart';
import 'package:synopse/features/04_home/bloc/user_vector/user_vector_bloc.dart';
import 'package:synopse/features/04_home/ui/widgets/for_you_page.dart';
import 'package:synopse/features/04_home/ui/widgets/home_top_bar.dart';
import 'package:synopse/features/04_home/ui/widgets/tag_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserNav1Bloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UserEventBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UserVectorBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const HomeFeed(),
    );
  }
}

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  late List<List<dynamic>> combinedTabList;
  late List<List<dynamic>> navTabList;
  bool isVectorForYou = false;
  @override
  void initState() {
    super.initState();
    closeKeyboardIfOpen();
    combinedTabList = [
      ['For You', 0, 0, 0]
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
            navTabList.add([item.tabItem, item.type, item.index1, item.index2]);
          }
          setState(() {});
        }
      },
    );
    // getForYou();
  }

  Future<void> getForYou() async {
    final prefs = await SharedPreferences.getInstance();

    final bool isVector = prefs.getBool('isVector') ?? false;
    if (!isVector) {
      vector();
    } else {
      isVectorForYou = true;
    }
  }

  void vector() {
    context.read<UserVectorBloc>().add(UserVectorFetch());
  }

  void closeKeyboardIfOpen() {
    // Check if the keyboard is open
    if (FocusManager.instance.primaryFocus?.hasFocus == true) {
      // Close the keyboard
      FocusManager.instance.primaryFocus?.unfocus();
    }
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
              'Are you sure?',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Do you want to exit the App',
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
                      "No",
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
                      "Yes",
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
          body: Column(
            children: [
              const HomeTopBar(),
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
                  thickness: 0.5,
                ),
              ),
              BlocBuilder<UserNav1Bloc, UserNav1State>(
                builder: (context, userNav1State) {
                  if (userNav1State.status == UserNav1Status.success) {
                    return DefaultTabController(
                      length: combinedTabList.length,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width - 30,
                                child: Center(
                                  child: TabBar(
                                    tabAlignment: TabAlignment.start,
                                    isScrollable: true,
                                    indicator:
                                        const BoxDecoration(), // Add this line
                                    labelColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    unselectedLabelColor: Colors.grey,
                                    tabs: [
                                      for (final item in combinedTabList)
                                        Tab(
                                          child: Text(
                                            item[0],
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 155,
                            width: MediaQuery.of(context).size.width,
                            child: TabBarView(
                              children: [
                                for (final item in combinedTabList)
                                  Column(
                                    children: [
                                      if (item[1] == 0) const ForYouS(),
                                      if (item[1] == 1)
                                        TagPage(
                                          tag: item[0],
                                          tagIndex1: item[2],
                                          tagIndex2: item[3],
                                        ),
                                      if (item[1] == 2)
                                        Text(
                                          item[0],
                                        ),
                                      if (item[1] == 3)
                                        Text(
                                          item[0],
                                        ),
                                    ],
                                  ),
                              ],
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/06_search/bloc_get4_outlets/get4_outlets_bloc.dart';
import 'package:synopse/features/06_search/bloc_search_last3_with_text/search_last3_with_text_bloc.dart';

class SearchScreenSWithText extends StatelessWidget {
  const SearchScreenSWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchLast3WithTextBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => Get4OutletsBloc(
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
      ],
      child: const SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  late String level;
  late int userLevel;
  late String search;

  @override
  void initState() {
    context.read<SearchLast3WithTextBloc>().add(
          const SearchLast3WithTextFetch(),
        );
    context.read<Get4OutletsBloc>().add(
          const Get4OutletsFetch(),
        );
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
    level = "Level";
    userLevel = 1;
    search = "Search";
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        userLevel = prefs.getInt('userLevel') ?? 1;
        level = prefs.getString('level') ?? 'Level';
        search = prefs.getString('search') ?? 'Search';
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 40,
                    child: GestureDetector(
                      onTap: () => context.push(home),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(
                    width: 55,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 80,
                    child: Text("Search",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            )),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 55,
                    child: Center(
                      child: Text(
                        "$level $userLevel",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: SvgPicture.asset(
                      "${SvgConstant.svgPath}/level_$userLevel.svg",
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onBackground,
                          BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  context.push(searchWithText);
                },
                child: SizedBox(
                  height: 50, // Adjust the height as needed
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 300,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Center(
                              child: SizedBox(
                                width: 250,
                                height: 50,
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  onSubmitted: (value) {
                                    context.read<UserEventBloc>().add(
                                        UserEventArticleSearchWithText(
                                            searchText: value));
                                    context.push(searchResultswithText,
                                        extra: value);
                                  },
                                  autofocus: true,
                                  controller: searchController,
                                  textAlignVertical: TextAlignVertical.center,
                                  textInputAction: TextInputAction.search,
                                  decoration: const InputDecoration(
                                    hintText: "Search",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  BlocBuilder<SearchLast3WithTextBloc,
                          SearchLast3WithTextState>(
                      builder: (context, searchLast3WithTextState) {
                    if (searchLast3WithTextState.status ==
                        SearchLast3WithTextsStatus.success) {
                      if (searchLast3WithTextState
                          .synopseRealtimeTTempUserSearchWithText.isEmpty) {
                        return Container();
                      }

                      return Column(
                        children: [
                          if (searchLast3WithTextState
                              .synopseRealtimeTTempUserSearchWithText
                              .isNotEmpty)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, top: 10.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Recent searches",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25, top: 10.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Clear",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.grey,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: searchLast3WithTextState
                                      .synopseRealtimeTTempUserSearchWithText
                                      .length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(searchResultswithText,
                                            extra: searchLast3WithTextState
                                                .synopseRealtimeTTempUserSearchWithText[
                                                    index]
                                                .text);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.history_outlined,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  top: 8.0,
                                                  bottom: 8.0),
                                              child: Center(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    searchLast3WithTextState
                                                        .synopseRealtimeTTempUserSearchWithText[
                                                            index]
                                                        .text,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
                  BlocBuilder<Get4OutletsBloc, Get4OutletsState>(
                      builder: (context, get4OutletsState) {
                    if (get4OutletsState.status == Get4OutletssStatus.success) {
                      if (get4OutletsState.synopseArticlesVGet4Outlet.isEmpty) {
                        return Container();
                      }

                      return Column(
                        children: [
                          if (get4OutletsState
                              .synopseArticlesVGet4Outlet.isNotEmpty)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Publishers",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: get4OutletsState
                                        .synopseArticlesVGet4Outlet.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          context.push(mainPublisher,
                                              extra: get4OutletsState
                                                  .synopseArticlesVGet4Outlet[
                                                      index]
                                                  .logoUrl);
                                        },
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Column(
                                                  children: [
                                                    Animate(
                                                      effects: [
                                                        FadeEffect(
                                                            delay: 150
                                                                .milliseconds,
                                                            duration: 1000
                                                                .milliseconds)
                                                      ],
                                                      child: CachedNetworkImage(
                                                        imageUrl: get4OutletsState
                                                            .synopseArticlesVGet4Outlet[
                                                                index]
                                                            .logoUrl,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              imageProvider,
                                                        ),
                                                        placeholder:
                                                            (context, url) =>
                                                                Center(
                                                          child: Shimmer
                                                              .fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              height: 25,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .background,
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                    Animate(
                                                      effects: [
                                                        FadeEffect(
                                                            delay: 150
                                                                .milliseconds,
                                                            duration: 1000
                                                                .milliseconds)
                                                      ],
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          get4OutletsState
                                                              .synopseArticlesVGet4Outlet[
                                                                  index]
                                                              .outletDisplay,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          ],
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
            currentIndex: 2,
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
    );
  }
}

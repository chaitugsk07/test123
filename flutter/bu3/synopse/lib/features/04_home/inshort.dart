import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/04_home/bloc_get_all_inshorts/get_all_inshorts_bloc.dart';
import 'package:synopse/features/04_home/bloc_user_intrests_tags/user_intrests_tags_bloc.dart';
import 'package:synopse/features/04_home/bloc_user_level_metadata/user_level_bloc.dart';
import 'package:synopse/features/04_home/widgets/inshort_view.dart';

class ArticleInshorts111 extends StatelessWidget {
  const ArticleInshorts111({super.key});

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
          create: (context) => UserIntrestsTagsBloc1(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetAllInShortsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const ArticleInshorts11(),
    );
  }
}

class ArticleInshorts11 extends StatefulWidget {
  const ArticleInshorts11({super.key});

  @override
  State<ArticleInshorts11> createState() => _ArticleInshorts11State();
}

class _ArticleInshorts11State extends State<ArticleInshorts11> {
  late List<String> hTags;
  late int userLevel;
  late String level;

  @override
  void initState() {
    super.initState();
    _getAccountFromSharedPreferences();
    final userIntrestsTags = BlocProvider.of<UserIntrestsTagsBloc1>(context);
    context.read<UserIntrestsTagsBloc1>().add(UserIntrestsTagsFetch());
    hTags = [];
    level = 'Level';
    userLevel = 1;
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
    if (hTags.isNotEmpty) {
      context
          .read<GetAllInShortsBloc>()
          .add(GetAllInShortsFetch(tags: hTags, noTags: false));
    } else {
      context
          .read<GetAllInShortsBloc>()
          .add(GetAllInShortsFetch(tags: hTags, noTags: true));
    }
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        userLevel = prefs.getInt('userLevel') ?? 1;
        level = prefs.getString('level') ?? 'Level';
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 1500,
              minHeight: 500,
            ),
            child: Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 16),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: GestureDetector(
                                onTap: () {
                                  context.push(home);
                                },
                                child: SizedBox(
                                  width: 40,
                                  child: SvgPicture.asset(
                                    SvgConstant.home,
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
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      BlendMode.srcIn),
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 55,
                              child: Center(
                                child: Text(
                                  "$level $userLevel",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: SizedBox(
                                width: 40,
                                child: SvgPicture.asset(
                                  "${SvgConstant.svgPath}/level_$userLevel.svg",
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            width: screenSize.width > 800
                                ? 700
                                : screenSize.width - 50,
                            child: BlocBuilder<GetAllInShortsBloc,
                                    GetAllInShortsState>(
                                builder: (context, getAllInShortsState) {
                              if (getAllInShortsState.status ==
                                  GetAllInShortsStatus.success) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: screenSize.height > 1100
                                          ? 900
                                          : screenSize.height - 200,
                                      width: screenSize.width > 800
                                          ? 750
                                          : screenSize.width - 50,
                                      child: CardSwiper(
                                        numberOfCardsDisplayed: 3,
                                        scale: 1.0,
                                        backCardOffset: const Offset(30, 30),
                                        cardsCount: getAllInShortsState
                                            .synopseArticlesTV4ArticleGroupsL2DetailInShorts
                                            .length,
                                        cardBuilder: (context,
                                                index,
                                                percentThresholdX,
                                                percentThresholdY) =>
                                            Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: InshortView111(
                                            images: getAllInShortsState
                                                .synopseArticlesTV4ArticleGroupsL2DetailInShorts[
                                                    index]
                                                .imageUrls,
                                            title: getAllInShortsState
                                                .synopseArticlesTV4ArticleGroupsL2DetailInShorts[
                                                    index]
                                                .title,
                                            keypoints: getAllInShortsState
                                                .synopseArticlesTV4ArticleGroupsL2DetailInShorts[
                                                    index]
                                                .keypoints,
                                            lastUpdatedat: getAllInShortsState
                                                .synopseArticlesTV4ArticleGroupsL2DetailInShorts[
                                                    index]
                                                .articleDetailLink!
                                                .updatedAtFormatted,
                                            viewsCount: getAllInShortsState
                                                .synopseArticlesTV4ArticleGroupsL2DetailInShorts[
                                                    index]
                                                .articleDetailLink!
                                                .viewsCount,
                                            likesCount: getAllInShortsState
                                                .synopseArticlesTV4ArticleGroupsL2DetailInShorts[
                                                    index]
                                                .articleDetailLink!
                                                .likesCount,
                                            articleCount: getAllInShortsState
                                                .synopseArticlesTV4ArticleGroupsL2DetailInShorts[
                                                    index]
                                                .articleDetailLink!
                                                .articleCount,
                                            articleGroupid: getAllInShortsState
                                                .synopseArticlesTV4ArticleGroupsL2DetailInShorts[
                                                    index]
                                                .articleGroupId,
                                            width: (screenSize.width > 800
                                                    ? 750
                                                    : screenSize.width - 50)
                                                .toInt(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ),
                        )
                      ],
                    ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 1000.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              // Handle button press
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(ImageConstant.bg),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 10,
                                    blurRadius: 15,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
  }
}

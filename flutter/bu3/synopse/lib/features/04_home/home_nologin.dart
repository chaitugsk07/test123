import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc_get_all_no_login/get_all_nologin_bloc.dart';

class HomeNoLogin extends StatelessWidget {
  const HomeNoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllNoLoginBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const HomeNoLoginS(),
    );
  }
}

class HomeNoLoginS extends StatefulWidget {
  const HomeNoLoginS({super.key});

  @override
  State<HomeNoLoginS> createState() => _HomeNoLoginSState();
}

class _HomeNoLoginSState extends State<HomeNoLoginS> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context.read<GetAllNoLoginBloc>().add(GetAllNoLoginFetch());

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      context.read<GetAllNoLoginBloc>().add(GetAllNoLoginFetch());
    }
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
                        context.push(signUp);
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
          appBar: AppBar(
            leading: Animate(
              effects: [
                FadeEffect(delay: 200.milliseconds, duration: 1000.milliseconds)
              ],
              child: IconButton(
                onPressed: () {
                  context.push(signUp);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                ),
              ),
            ),
            title: Animate(
              effects: [
                FadeEffect(delay: 300.milliseconds, duration: 1000.milliseconds)
              ],
              child: const Text(
                'Guest Home',
              ),
            ),
            centerTitle: true,
            scrolledUnderElevation: 0,
            elevation: 0,
          ),
          body: BlocBuilder<GetAllNoLoginBloc, GetAllNoLoginState>(
            builder: (context, getAllNoLoginState) {
              if (getAllNoLoginState.status == GetAllNoLoginStatus.initial) {
                return const Center(
                  child: PageLoading(
                    title: 'HomeNoLogin',
                  ),
                );
              } else if (getAllNoLoginState.status ==
                  GetAllNoLoginStatus.success) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<GetAllNoLoginBloc>()
                          .add(GetAllNoLoginRefresh());
                    },
                    color: Colors.grey,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: getAllNoLoginState
                          .synopseArticlesTV4ArticleGroupsL2Detail.length,
                      itemBuilder: (context, index) {
                        final searchResult = getAllNoLoginState
                            .synopseArticlesTV4ArticleGroupsL2Detail[index];
                        final images = searchResult.imageUrls;
                        images.shuffle();
                        final logoUrls = searchResult.logoUrls;
                        logoUrls.shuffle();
                        final articleGroupId = searchResult.articleGroupId;
                        final lastUpdatedat =
                            searchResult.articleDetailLink!.updatedAtFormatted;
                        final title = searchResult.title;
                        final likescount =
                            searchResult.articleDetailLink!.likesCount;
                        final viewcount =
                            searchResult.articleDetailLink!.viewsCount;
                        final commentcount =
                            searchResult.articleDetailLink!.commentsCount;
                        final articlecount =
                            searchResult.articleDetailLink!.articleCount;
                        const htag = 'na';
                        return FeedTileM(
                          ind: index,
                          articleGroupid: articleGroupId,
                          images: images,
                          logoUrls: logoUrls,
                          lastUpdatedat: lastUpdatedat,
                          title: title,
                          likesCount: likescount,
                          viewsCount: viewcount,
                          commentsCount: commentcount,
                          isLiked: false,
                          isViewed: false,
                          isCommented: false,
                          articleCount: articlecount,
                          type: 1,
                          hTag: htag,
                          isLoggedin: false,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc/get_all_no_login/get_all_nologin_bloc.dart';

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
    return SafeArea(
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
            child: Text(
              'Guest Home',
              style: MyTypography.t12
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ),
        body: BlocBuilder<GetAllNoLoginBloc, GetAllNoLoginState>(
          builder: (context, getAllNoLoginState) {
            if (getAllNoLoginState.status == GetAllNoLoginStatus.initial) {
              return const Center(
                child: PageLoading(),
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FeedTileM(
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
                          isbookmarked: false,
                          articleCount: articlecount,
                          type: 1,
                          hTag: htag,
                          isLoggedin: false,
                        ),
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
    );
  }
}

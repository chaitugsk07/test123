import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc/get_all_read/get_all_read_bloc.dart';

class UserReadS extends StatelessWidget {
  const UserReadS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllReadBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const UserRead(),
    );
  }
}

class UserRead extends StatefulWidget {
  const UserRead({super.key});

  @override
  State<UserRead> createState() => _UserReadState();
}

class _UserReadState extends State<UserRead> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context.read<GetAllReadBloc>().add(GetAllReadFetch());

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
      context.read<GetAllReadBloc>().add(GetAllReadFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllReadBloc, GetAllReadState>(
      builder: (context, getAllReadState) {
        if (getAllReadState.status == GetAllReadStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (getAllReadState.status == GetAllReadStatus.success) {
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<GetAllReadBloc>().add(GetAllReadRefresh());
              },
              color: Colors.grey,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: getAllReadState
                    .synopseArticlesTV4ArticleGroupsL2Detail.length,
                itemBuilder: (context, index) {
                  final searchResult = getAllReadState
                      .synopseArticlesTV4ArticleGroupsL2Detail[index];
                  final images = searchResult.imageUrls;
                  images.shuffle();
                  final logoUrls = searchResult.logoUrls;
                  logoUrls.shuffle();
                  final articleGroupId = searchResult.articleGroupId;
                  final lastUpdatedat =
                      searchResult.articleDetailLink!.updatedAtFormatted;
                  final title = searchResult.title;
                  final likescount = searchResult.articleDetailLink!.likesCount;
                  final viewcount = searchResult.articleDetailLink!.viewsCount;
                  final commentcount =
                      searchResult.articleDetailLink!.commentsCount;
                  final isliked = searchResult
                              .tUserArticleLikesAggregate!.aggregate!.count ==
                          0
                      ? false
                      : true;
                  final isviewed = searchResult
                              .tUserArticleViewsAggregate!.aggregate!.count ==
                          0
                      ? false
                      : true;
                  final iscommented = searchResult
                              .tUserArticleCommentsAggregate!
                              .aggregate!
                              .count ==
                          0
                      ? false
                      : true;
                  final isbookmarked = searchResult
                              .tUserArticleBookmarksAggregate!
                              .aggregate!
                              .count ==
                          0
                      ? false
                      : true;
                  final articlecount =
                      searchResult.articleDetailLink!.articleCount;
                  String htag = 'na';
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
                    isLiked: isliked,
                    isViewed: isviewed,
                    isCommented: iscommented,
                    isbookmarked: isbookmarked,
                    articleCount: articlecount,
                    type: 7,
                    hTag: htag,
                    isLoggedin: true,
                  );
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/06_search/bloc/search_results/search_results_bloc.dart';

class SearchResults extends StatelessWidget {
  final int searchID;
  const SearchResults({super.key, required this.searchID});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchResultsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: Searchs(
        searchID: searchID,
      ),
    );
  }
}

class Searchs extends StatefulWidget {
  final int searchID;
  const Searchs({super.key, required this.searchID});

  @override
  State<Searchs> createState() => _SearchsState();
}

class _SearchsState extends State<Searchs> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    context
        .read<SearchResultsBloc>()
        .add(SearchResultsFetch(searchId: widget.searchID));

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
      context
          .read<SearchResultsBloc>()
          .add(SearchResultsFetch(searchId: widget.searchID));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchResultsBloc, SearchResultsState>(
      builder: (context, searchResultsState) {
        if (searchResultsState.status == SearchResultsStatus.initial) {
          return const PageLoading();
        }
        if (searchResultsState.status == SearchResultsStatus.success) {
          return Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: searchResultsState
                  .synopseArticlesFGetSearchArticleGroup.length,
              itemBuilder: (context, index) {
                final searchResult = searchResultsState
                    .synopseArticlesFGetSearchArticleGroup[index];
                final images = searchResult.tV4ArticleGroupsL2Detail!.imageUrls;
                images.shuffle();
                final logoUrls =
                    searchResult.tV4ArticleGroupsL2Detail!.logoUrls;
                logoUrls.shuffle();
                final articleGroupId = searchResult.articleGroupId;
                final lastUpdatedat = searchResult.tV4ArticleGroupsL2Detail!
                    .articleDetailLink!.updatedAtFormatted;
                final title = searchResult.tV4ArticleGroupsL2Detail!.title;
                final likescount = searchResult
                    .tV4ArticleGroupsL2Detail!.articleDetailLink!.likesCount;
                final viewcount = searchResult
                    .tV4ArticleGroupsL2Detail!.articleDetailLink!.viewsCount;
                final commentcount = searchResult
                    .tV4ArticleGroupsL2Detail!.articleDetailLink!.commentsCount;
                final isliked = searchResult.tV4ArticleGroupsL2Detail!
                            .tUserArticleLikesAggregate!.aggregate!.count ==
                        0
                    ? false
                    : true;
                final isviewed = searchResult.tV4ArticleGroupsL2Detail!
                            .tUserArticleViewsAggregate!.aggregate!.count ==
                        0
                    ? false
                    : true;
                final iscommented = searchResult.tV4ArticleGroupsL2Detail!
                            .tUserArticleCommentsAggregate!.aggregate!.count ==
                        0
                    ? false
                    : true;
                final articlecount = searchResult
                    .tV4ArticleGroupsL2Detail!.articleDetailLink!.articleCount;
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
                  articleCount: articlecount,
                  type: 3,
                  hTag: "na",
                  isLoggedin: true,
                );
              },
            ),
          );
        }
        return const PageLoading();
      },
    );
  }
}

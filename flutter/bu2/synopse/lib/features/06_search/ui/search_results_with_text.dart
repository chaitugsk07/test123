import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/06_search/bloc/search_results_withText/search_results_with_text_bloc.dart';

class SearchResultsWithText extends StatelessWidget {
  final String searchText;

  const SearchResultsWithText({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchResultsWithTextBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: Searchs(
        searchText: searchText,
      ),
    );
  }
}

class Searchs extends StatefulWidget {
  final String searchText;

  const Searchs({super.key, required this.searchText});

  @override
  State<Searchs> createState() => _SearchsState();
}

class _SearchsState extends State<Searchs> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    context
        .read<SearchResultsWithTextBloc>()
        .add(SearchResultsWithTextFetch(search: widget.searchText));

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
          .read<SearchResultsWithTextBloc>()
          .add(SearchResultsWithTextFetch(search: widget.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => context.push(searchWithText),
            child: const Icon(Icons.arrow_back),
          ),
          title: Text(widget.searchText),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<SearchResultsWithTextBloc,
              SearchResultsWithTextState>(
            builder: (context, searchResultsWithTextState) {
              if (searchResultsWithTextState.status ==
                  SearchResultsWithTextStatus.initial) {
                return const PageLoading();
              }
              if (searchResultsWithTextState.status ==
                  SearchResultsWithTextStatus.success) {
                return Column(
                  children: [
                    if (searchResultsWithTextState
                        .synopseArticlesVArticlesGroupDetailsSearch.isEmpty)
                      const Center(
                        child: Text("No Results Found for the search"),
                      ),
                    if (searchResultsWithTextState
                        .synopseArticlesVArticlesGroupDetailsSearch.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: searchResultsWithTextState
                            .synopseArticlesVArticlesGroupDetailsSearch.length,
                        itemBuilder: (context, index) {
                          final searchResult = searchResultsWithTextState
                                  .synopseArticlesVArticlesGroupDetailsSearch[
                              index];
                          final images = searchResult.articleGroup!.imageUrls;
                          images.shuffle();
                          final logoUrls = searchResult.articleGroup!.logoUrls;
                          logoUrls.shuffle();
                          final articleGroupId = searchResult.articleGroupId;
                          final lastUpdatedat = searchResult.articleGroup!
                              .articleDetailLink!.updatedAtFormatted;
                          final title = searchResult.articleGroup!.title;
                          final likescount = searchResult
                              .articleGroup!.articleDetailLink!.likesCount;
                          final viewcount = searchResult
                              .articleGroup!.articleDetailLink!.viewsCount;
                          final commentcount = searchResult
                              .articleGroup!.articleDetailLink!.commentsCount;
                          final isliked = searchResult
                                      .articleGroup!
                                      .tUserArticleLikesAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final isviewed = searchResult
                                      .articleGroup!
                                      .tUserArticleViewsAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final iscommented = searchResult
                                      .articleGroup!
                                      .tUserArticleCommentsAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final articlecount = searchResult
                              .articleGroup!.articleDetailLink!.articleCount;
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
                            type: 2,
                            hTag: "na",
                            isLoggedin: true,
                          );
                        },
                      ),
                  ],
                );
              }
              return const PageLoading();
            },
          ),
        ),
      ),
    );
  }
}

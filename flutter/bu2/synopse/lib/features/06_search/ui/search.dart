import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/06_search/bloc/get4_outlets/get4_outlets_bloc.dart';
import 'package:synopse/features/06_search/bloc/search_last3/search_last3_bloc.dart';

class SearchScreenS extends StatelessWidget {
  const SearchScreenS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchLast3Bloc(
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

  @override
  void initState() {
    context.read<SearchLast3Bloc>().add(
          const SearchLast3Fetch(),
        );
    context.read<Get4OutletsBloc>().add(
          const Get4OutletsFetch(),
        );
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.push(home),
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text("Search"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 500),
                  delay: Duration(milliseconds: 300),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 8.0),
                child: Center(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      context.push(
                        searchM1,
                        extra: value,
                      );
                    },
                    autofocus: true,
                    controller: searchController,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: " Search",
                    ),
                  ),
                ),
              ),
            ),
            if (searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  context.push(
                    searchM1,
                    extra: searchController.text,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(Icons.search),
                      Expanded(
                        child: Center(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Search for ${searchController.text}",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            BlocBuilder<SearchLast3Bloc, SearchLast3State>(
                builder: (context, searchLast3State) {
              if (searchLast3State.status == SearchLast3sStatus.success) {
                if (searchLast3State.synopseRealtimeTTempUserSearch.isEmpty) {
                  return Container();
                }

                return Column(
                  children: [
                    if (searchLast3State
                        .synopseRealtimeTTempUserSearch.isNotEmpty)
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 25, top: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Recent searches",
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchLast3State
                                .synopseRealtimeTTempUserSearch.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  context.push(
                                    searchOutput,
                                    extra: SearchOutputData(
                                      searchText: searchLast3State
                                          .synopseRealtimeTTempUserSearch[index]
                                          .search,
                                      searchId: searchLast3State
                                          .synopseRealtimeTTempUserSearch[index]
                                          .id,
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 8.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors
                                                  .grey, // Set border color
                                              width: 2.0, // Set border width
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(Icons.search),
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 8.0, bottom: 8.0),
                                        child: Center(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              searchLast3State
                                                  .synopseRealtimeTTempUserSearch[
                                                      index]
                                                  .search,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
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
                    if (get4OutletsState.synopseArticlesVGet4Outlet.isNotEmpty)
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Publishers",
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
                                            .synopseArticlesVGet4Outlet[index]
                                            .logoUrl);
                                  },
                                  child: SingleChildScrollView(
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
                                                      delay: 150.milliseconds,
                                                      duration:
                                                          1000.milliseconds)
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
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        height: 25,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                              Animate(
                                                effects: [
                                                  FadeEffect(
                                                      delay: 150.milliseconds,
                                                      duration:
                                                          1000.milliseconds)
                                                ],
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    get4OutletsState
                                                        .synopseArticlesVGet4Outlet[
                                                            index]
                                                        .outletDisplay,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                    textAlign: TextAlign.center,
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
    );
  }
}

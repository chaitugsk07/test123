import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/06_search/bloc/search/search_bloc.dart';
import 'package:synopse/features/06_search/bloc/search_last3/search_last3_bloc.dart';

class SearchScreenS extends StatelessWidget {
  const SearchScreenS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SearchLast3Bloc(
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
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 8.0),
                      child: Center(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          autofocus: true,
                          controller: searchController,
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.search,
                          style: MyTypography.t12,
                          cursorColor: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.8),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: " Search",
                            hintStyle: MyTypography.t12.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(
                                color: Colors
                                    .grey, // Set the color as per your requirement
                                width:
                                    1, // Set the width as per your requirement
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.push(splash);
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, top: 8.0, right: 2),
                      child: Text(
                        "Cancel",
                        style: MyTypography.body.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  context.read<SearchBloc>().add(
                        SearchFetch(
                          search: searchController.text,
                        ),
                      );
                  BlocListener<SearchBloc, SearchState>(
                    listener: (context, searchState) {
                      if (searchState.status == SearchStatus.success) {
                        if (searchState.synopseRealtimeGetEmbedding[0].id ==
                            0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "No result found for ${searchController.text}",
                                style: MyTypography.t12.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.8),
                                ),
                              ),
                            ),
                          );
                          context.push(home);
                        } else {
                          context.push(
                            searchOutput,
                            extra: SearchOutputData(
                              searchText: searchController.text,
                              searchId:
                                  searchState.synopseRealtimeGetEmbedding[0].id,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 8.0),
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 8.0),
                        child: Center(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Search for ${searchController.text}",
                              style: MyTypography.t12.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            BlocBuilder<SearchLast3Bloc, SearchLast3State>(
                builder: (context, searchLast3State) {
              if (searchLast3State.status == SearchLast3sStatus.success) {
                if (searchLast3State.synopseRealtimeTTempUserSearch.isEmpty) {
                  return Container();
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount:
                        searchLast3State.synopseRealtimeTTempUserSearch.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            searchOutput,
                            extra: SearchOutputData(
                              searchText: searchLast3State
                                  .synopseRealtimeTTempUserSearch[index].search,
                              searchId: searchLast3State
                                  .synopseRealtimeTTempUserSearch[index].id,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, top: 8.0),
                              child: Icon(Icons.search),
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
                                          .synopseRealtimeTTempUserSearch[index]
                                          .search,
                                      style: MyTypography.t12.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.8),
                                      ),
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
                );
              } else if (searchLast3State.status == SearchLast3sStatus.error) {
                return Container();
              } else {
                return Container();
              }
            })
          ],
        ),
      ),
    );
  }
}

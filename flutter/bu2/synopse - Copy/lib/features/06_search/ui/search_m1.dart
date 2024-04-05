import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/06_search/bloc/search/search_bloc.dart';

class SearchM111 extends StatelessWidget {
  final String searchText;

  const SearchM111({super.key, required this.searchText});

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
      ],
      child: SearchM1(
        searchText: searchText,
      ),
    );
  }
}

class SearchM1 extends StatefulWidget {
  final String searchText;

  const SearchM1({super.key, required this.searchText});

  @override
  State<SearchM1> createState() => _SearchM1State();
}

class _SearchM1State extends State<SearchM1> {
  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(SearchFetch(search: widget.searchText));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              if (state.status == SearchStatus.success) {
                context.push(
                  searchOutput,
                  extra: SearchOutputData(
                    searchText: widget.searchText,
                    searchId: state.searchId,
                  ),
                );
              } else if (state.status == SearchStatus.error) {
                SnackBar(
                  content: Text(
                    "No result found for ${widget.searchText}",
                  ),
                );
                context.push(home);
              }
            },
            child: const PageLoading(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

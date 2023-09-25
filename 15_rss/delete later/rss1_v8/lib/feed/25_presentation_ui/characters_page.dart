import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rss1_v8/core/presentation/widgets/platform_progress_bar.dart';
import 'package:rss1_v8/core/utils/ui_state.dart';
import 'package:rss1_v8/feed/20_presentation_mapping/ui_articlesrss1.dart';
import 'package:rss1_v8/feed/25_presentation_ui/bloc/articlesfss1_cubit.dart';
import 'package:rss1_v8/feed/25_presentation_ui/characters_page_widgets.dart';

class ArticlesRss1Page extends StatelessWidget {
  const ArticlesRss1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticlesRss1Cubit(),
      child: BlocListener<ArticlesRss1Cubit, UiState<List<UiArticleRss1>>>(
        child: const ArticalsRss1ListWidget(),
        listener: (context, state) {},
      ),
    );
  }
}

class ArticalsRss1ListWidget extends StatefulWidget {
  const ArticalsRss1ListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ArticalsRss1ListWidgetState();
}

class _ArticalsRss1ListWidgetState extends State<ArticalsRss1ListWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  final searchTextController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesRss1Cubit, UiState<List<UiArticleRss1>>>(
      builder: (context, state) {
        final cubit = context.read<ArticlesRss1Cubit>();
        return state is Loading
            ? const Align(
                child: RmProgressBar(),
              )
            : state is Success
                ? buildarticlesRss1ListWidget(
                    context: context,
                    searchTextController: searchTextController,
                    animationController: animationController,
                    articlesRss1List:
                        (state as Success).data as List<UiArticleRss1>,
                    onScrolledToEndCallback: () {
                      setState(
                        () {
                          if (!cubit.isPageLoadInProgress) {
                            cubit.limit = 10;
                            cubit.offset += 10;
                            cubit
                              ..loadArticlesRss1()
                              ..isPageLoadInProgress = true;
                          }
                        },
                      );
                    },
                  )
                : Container();
      },
    );
  }
}

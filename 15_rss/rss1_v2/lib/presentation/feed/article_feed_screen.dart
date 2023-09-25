import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rss1_v2/core/presentation/widgets/platform_progress_bar.dart';
import 'package:rss1_v2/core/utils/ui_state.dart';
import 'package:rss1_v2/presentation/feed/article_feed.cubit.dart';
import 'package:rss1_v2/presentation/feed/article_feed_widgets.dart';
import 'package:rss1_v2/presentation/feed/models/ui_article_feed.dart';

class ArticleFeedScreen extends StatelessWidget {
  const ArticleFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticleFeedCubit(),
      child: BlocListener<ArticleFeedCubit, UiState<List<UiRss1Artical>>>(
        child: const ArticlesListWidget(),
        listener: (context, state) {},
      ),
    );
  }
}

class ArticlesListWidget extends StatefulWidget {
  const ArticlesListWidget({super.key});

  @override
  State<ArticlesListWidget> createState() => _ArticlesListWidgetState();
}

class _ArticlesListWidgetState extends State<ArticlesListWidget>
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
    return BlocBuilder<ArticleFeedCubit, UiState<List<UiRss1Artical>>>(
      builder: (context, state) {
        final cubit = context.read<ArticleFeedCubit>();
        return state is Loading
            ? const Align(
                child: RmProgressBar(),
              )
            : state is Success
                ? buildArticleListWidget(
                    context: context,
                    searchTextController: searchTextController,
                    animationController: animationController,
                    articlesList:
                        (state as Success).data as List<UiRss1Artical>,
                    onScrolledToEndCallback: () {
                      setState(
                        () {
                          if (!cubit.isPageLoadInProgress) {
                            cubit.page++;
                            cubit
                              ..loadarticles()
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

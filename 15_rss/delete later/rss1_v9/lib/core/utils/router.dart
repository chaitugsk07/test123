import 'package:go_router/go_router.dart';
import 'package:rss1_v9/features/article_detail/ui/article_detail.dart';
import 'package:rss1_v9/features/article_web_view/article_web_view.dart';
import 'package:rss1_v9/features/feed/ui/artcles_feed.dart';

const feed = '/';
const articleDetail = '/detail';
const webLink = '/weblink';

final GoRouter router = GoRouter(
  routes: [
    feedRoute(),
    detailRoute(),
    webLinkRoute(),
  ],
);

GoRoute webLinkRoute() {
  return GoRoute(
    path: webLink,
    builder: (context, state) {
      final postlink = state.extra as String;
      return ArticleWeb(postLink: postlink);
    },
  );
}

GoRoute detailRoute() {
  return GoRoute(
    path: articleDetail,
    builder: (context, state) {
      final routeData = state.extra as ArticleDetailRouteData;
      return AeticleDetailPage(
        postLink: routeData.postLink,
        summary: routeData.summary,
        postPublished: routeData.postPublished,
        logoUrl: routeData.logoUrl,
        outletDisplay: routeData.outletDisplay,
      );
    },
  );
}

GoRoute feedRoute() {
  return GoRoute(
    path: feed,
    builder: (context, state) => const ArticlesRss1Feed(),
  );
}

class ArticleDetailRouteData {
  final String postLink;
  final String summary;
  final DateTime postPublished;
  final String logoUrl;
  final String outletDisplay;

  ArticleDetailRouteData(
      {required this.postLink,
      required this.summary,
      required this.postPublished,
      required this.logoUrl,
      required this.outletDisplay});
}

import 'package:go_router/go_router.dart';
import 'package:rss1_v2/presentation/feed/articke_feed_screen.dart';
import 'package:rss1_v2/presentation/details/detail_screen.dart';

const rootRoute = '/';
const detailRoute = '/detail';

final routes = GoRouter(
  routes: [dashboardRoute(), characterInfoRoute()],
);

GoRoute dashboardRoute() {
  return GoRoute(
    path: rootRoute,
    builder: (context, state) => const ArticleFeedScreen(),
  );
}

GoRoute characterInfoRoute() {
  return GoRoute(
    path: detailRoute,
    builder: (context, state) {
      final routeData = state.extra as ArticleDetailRouteData;
      return DetailScreen(
          postLink: routeData.postLink, summary: routeData.summary);
    },
  );
}

class ArticleDetailRouteData {
  final String postLink;
  final String summary;

  ArticleDetailRouteData({required this.postLink, required this.summary});
}

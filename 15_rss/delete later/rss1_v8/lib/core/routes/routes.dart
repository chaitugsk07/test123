import 'package:go_router/go_router.dart';
import 'package:rss1_v8/feed/25_presentation_ui/characters_page.dart';

import '../../../main copy.dart';

const rootRouteLink = '/';
const articleRss1RouteLink = '/feed';

final routes = GoRouter(
  routes: [feedRoute(), articleRss1Route()],
);

GoRoute feedRoute() {
  return GoRoute(
    path: rootRouteLink,
    builder: (context, state) => const App(),
  );
}

GoRoute articleRss1Route() {
  return GoRoute(
    path: articleRss1RouteLink,
    builder: (context, state) {
      return const ArticlesRss1Page();
    },
  );
}

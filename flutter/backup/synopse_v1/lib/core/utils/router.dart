import 'package:go_router/go_router.dart';
import 'package:synopse_v1/features/article_detail/ui/article_detail.dart';
import 'package:synopse_v1/features/article_group_feed/ui/artclesgroup_feed.dart';
import 'package:synopse_v1/features/article_web_view/article_web_view.dart';
import 'package:synopse_v1/features/feed/ui/artcles_feed.dart';
import 'package:synopse_v1/features/otp/phone.dart';
import 'package:synopse_v1/features/phoneno/otp.dart';

const phone = '/';
const verify = '/verify';
const groupfeed = '/groupfeed';
const feed = '/feed';
const articleDetail = '/detail';
const webLink = '/weblink';

final GoRouter router = GoRouter(
  routes: [
    phoneRoute(),
    verifyRoute(),
    groupRoute(),
    feedRoute(),
    detailRoute(),
    webLinkRoute(),
  ],
);

GoRoute groupRoute() {
  return GoRoute(
    path: groupfeed,
    builder: (context, state) => ArticleGroupFeed(),
  );
}


GoRoute phoneRoute() {
  return GoRoute(
    path: phone,
    builder: (context, state) => const MyPhone(),
  );
}

GoRoute verifyRoute() {
  return GoRoute(
    path: verify,
    builder: (context, state) => const MyVerify(),
  );
}

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

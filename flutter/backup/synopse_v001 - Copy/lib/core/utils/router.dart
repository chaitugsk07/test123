import 'package:go_router/go_router.dart';
import 'package:synopse_v001/features/01_splash/ui/splash_screen.dart';
import 'package:synopse_v001/features/02_loginscreens/ui/otp.dart';
import 'package:synopse_v001/features/02_loginscreens/ui/phone.dart';
import 'package:synopse_v001/features/03_user_profile/ui/user_main.dart';
import 'package:synopse_v001/features/03_user_profile/ui/user_profile.dart';
import 'package:synopse_v001/features/04_home/ui/artcles_feed.dart';
import 'package:synopse_v001/features/05_article_detail/ui/article_detail.dart';
import 'package:synopse_v001/features/06_comments/ui/article_comments.dart';

const splash = '/';
const login = '/login';
const verify = '/verify';
const home = '/home';
const detail = '/detail';
const page = "/page";
const user = '/user';
const userMain = '/userMain';
const comments = '/comments';

final GoRouter router = GoRouter(
  routes: [
    splashRoute(),
    loginRoute(),
    homeRoute(),
    verifyRoute(),
    detailRoute(),
    userRoute(),
    userMainRoute(),
    pageRoute(),
    commentsRoute(),
  ],
);

GoRoute splashRoute() {
  return GoRoute(
    path: splash,
    builder: (context, state) => SplashScreen(),
  );
}

GoRoute pageRoute() {
  return GoRoute(
    path: page,
    builder: (context, state) => SplashScreen(),
  );
}

GoRoute userRoute() {
  return GoRoute(
    path: user,
    builder: (context, state) => const UserProfile(),
  );
}

GoRoute userMainRoute() {
  return GoRoute(
    path: userMain,
    builder: (context, state) => const UserMain(),
  );
}

GoRoute verifyRoute() {
  return GoRoute(
    path: verify,
    builder: (context, state) {
      final phoneNo = state.extra as int;
      return MyVerify(
        phoneNo: phoneNo,
      );
    },
  );
}

GoRoute detailRoute() {
  return GoRoute(
    path: detail,
    builder: (context, state) {
      final articleDetailId = state.extra as int;
      return ArticleDetail(
        articleDetailId: articleDetailId,
      );
    },
  );
}

GoRoute commentsRoute() {
  return GoRoute(
    path: comments,
    builder: (context, state) {
      final articleDetailId = state.extra as int;
      return ArticleComments(
        articleDetailId: articleDetailId,
      );
    },
  );
}

GoRoute loginRoute() {
  return GoRoute(
    path: login,
    builder: (context, state) => const MyPhone(),
  );
}

GoRoute homeRoute() {
  return GoRoute(
    path: home,
    builder: (context, state) => const ArticlesRss1Feed(),
  );
}

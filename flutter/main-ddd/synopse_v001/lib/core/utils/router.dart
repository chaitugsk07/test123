import 'package:go_router/go_router.dart';
import 'package:synopse_v001/features/01_splash/ui/splash_screen.dart';
import 'package:synopse_v001/features/02_loginscreens/ui/otp.dart';
import 'package:synopse_v001/features/02_loginscreens/ui/phone.dart';
import 'package:synopse_v001/features/03_user_profile/ui/ext_user.dart';
import 'package:synopse_v001/features/03_user_profile/ui/user_main.dart';
import 'package:synopse_v001/features/03_user_profile/ui/user_profile.dart';
import 'package:synopse_v001/features/04_home/ui/artcles_feed.dart';
import 'package:synopse_v001/features/05_article_detail/ui/article_detail.dart';
import 'package:synopse_v001/features/06_comments/ui/article_comments.dart';
import 'package:synopse_v001/features/06_comments/ui/comment_reply_page.dart';
import 'package:synopse_v001/features/10_pageview/ui/artcles_feed_page.dart';

const splash = '/';
const login = '/login';
const verify = '/verify';
const home = '/home';
const detail = '/detail';
const page = "/page";
const user = '/user';
const userMain = '/userMain';
const comments = '/comments';
const commentReply = '/commentReply';
const extUserProfile = "/extUserProfile";

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
    commentReplyRoute(),
    extUserProfileRoute(),
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
    builder: (context, state) => const ArticleRss1Page(),
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

GoRoute extUserProfileRoute() {
  return GoRoute(
    path: extUserProfile,
    builder: (context, state) {
      final account = state.extra as String;
      return ExtUsers(
        account: account,
      );
    },
  );
}

GoRoute commentReplyRoute() {
  return GoRoute(
    path: commentReply,
    builder: (context, state) {
      final commentId = state.extra as int;
      return CommentsReply(
        commentId: commentId,
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

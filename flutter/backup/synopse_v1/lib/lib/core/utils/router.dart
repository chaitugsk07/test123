import 'package:go_router/go_router.dart';
import 'package:synopse_v001/features/01_splash/ui/splash_screen.dart';
import 'package:synopse_v001/features/02_loginscreens/ui/otp.dart';
import 'package:synopse_v001/features/02_loginscreens/ui/phone.dart';
import 'package:synopse_v001/features/04_home/ui/artcles_feed.dart';

const splash = '/';
const login = '/login';
const verify = '/verify';
const home = '/home';

final GoRouter router = GoRouter(
  routes: [splashRoute(), loginRoute(), homeRoute(), verifyRoute()],
);

GoRoute splashRoute() {
  return GoRoute(
    path: splash,
    builder: (context, state) => SplashScreen(),
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

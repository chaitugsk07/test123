import 'package:go_router/go_router.dart';
import 'package:synopse/features/01_splash/ui/splash_screen.dart';
import 'package:synopse/features/02_login_screens/ui/otp.dart';
import 'package:synopse/features/02_login_screens/ui/phone.dart';
import 'package:synopse/features/02_login_screens/ui/signup.dart';
import 'package:synopse/features/04_home/ui/home.dart';

const splash = '/';
const signUp = '/signUp';
const phone = '/phone';
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
    signUpRoute(),
    phoneRoute(),
    verifyRouter(),
    homeRoute(),
  ],
);

GoRoute splashRoute() {
  return GoRoute(
    path: splash,
    builder: (context, state) => const SplashScreen(),
  );
}

GoRoute homeRoute() {
  return GoRoute(
    path: home,
    builder: (context, state) => const Home(),
  );
}

GoRoute signUpRoute() {
  return GoRoute(
    path: signUp,
    builder: (context, state) => const SignUpSl(),
  );
}

GoRoute phoneRoute() {
  return GoRoute(
    path: phone,
    builder: (context, state) {
      final routeData = state.extra as PhoneRouteData;
      return MyPhones(
        name: routeData.name,
        email: routeData.email,
        photoUrl: routeData.photoUrl,
        id: routeData.id,
      );
    },
  );
}

GoRoute verifyRouter() {
  return GoRoute(
    path: verify,
    builder: (context, state) {
      final routeData = state.extra as VerifyRouteData;
      return MyVerifyS(
        name: routeData.name,
        email: routeData.email,
        photoUrl: routeData.photoUrl,
        id: routeData.id,
        country: routeData.country,
        phoneNo: routeData.phoneNo,
      );
    },
  );
}

class PhoneRouteData {
  final String name;
  final String email;
  final String photoUrl;
  final String id;

  PhoneRouteData(
      {required this.name,
      required this.email,
      required this.photoUrl,
      required this.id});
}

class VerifyRouteData {
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  final String country;
  final int phoneNo;

  VerifyRouteData(
      {required this.name,
      required this.email,
      required this.photoUrl,
      required this.id,
      required this.country,
      required this.phoneNo});
}

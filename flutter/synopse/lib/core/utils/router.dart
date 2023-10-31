import 'package:go_router/go_router.dart';
import 'package:synopse/features/01_splash/ui/splash_screen.dart';
import 'package:synopse/features/02_login_screens/ui/otp.dart';
import 'package:synopse/features/02_login_screens/ui/phone.dart';
import 'package:synopse/features/02_login_screens/ui/signingIn.dart';
import 'package:synopse/features/02_login_screens/ui/signup.dart';
import 'package:synopse/features/04_home/ui/home.dart';

const splash = '/';
const signUp = '/signUp';
const signingIn = '/signing';
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
    signingInRoute(),
    phoneRoute(),
    verifyRouter(),
    homeRoute(),
  ],
);

GoRoute splashRoute() {
  return GoRoute(
    path: splash,
    builder: (context, state) => SplashScreenS(),
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

GoRoute signingInRoute() {
  return GoRoute(
    path: signingIn,
    builder: (context, state) {
      final routeData = state.extra as SigningInData;
      return SigningIn(
        type: routeData.type,
        name: routeData.name,
        email: routeData.email,
        photoUrl: routeData.photoUrl,
        id: routeData.id,
      );
    },
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
      final routeData = state.extra as SigningInData;
      return SigningIn(
        type: routeData.type,
        name: routeData.name,
        email: routeData.email,
        photoUrl: routeData.photoUrl,
        id: routeData.id,
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

class SigningInData {
  final String type;
  final String email;
  final String id;
  final String name;
  final String photoUrl;

  SigningInData(
      {required this.type,
      required this.email,
      required this.photoUrl,
      required this.id,
      required this.name});
}

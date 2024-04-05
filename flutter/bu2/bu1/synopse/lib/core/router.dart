import 'package:go_router/go_router.dart';
import 'package:synopse/features/01_splash/ui/onboarding_screen.dart';
import 'package:synopse/features/01_splash/ui/splash_screen.dart';
import 'package:synopse/features/02_login_screens/ui/otp.dart';
import 'package:synopse/features/02_login_screens/ui/phone.dart';
import 'package:synopse/features/02_login_screens/ui/signings.dart';
import 'package:synopse/features/02_login_screens/ui/signup.dart';
import 'package:synopse/features/02_login_screens/ui/verify_otp.dart';
import 'package:synopse/features/02_login_screens/ui/verify_phone_email.dart.dart';
import 'package:synopse/features/04_home/ui/home.dart';
import 'package:synopse/features/04_home/ui/home_nologin.dart';

const splash = '/';
const onBoarding = '/onBoarding';
const signUp = '/signUp';
const signingIn = '/signing';
const phone = '/phone';
const verify = '/verify';
const verifyEmail = '/verifyEmail';
const pVerifyOTP = '/verifyOTP';
const home = '/home';
const homeNo = '/homeNo';

final GoRouter router = GoRouter(
  routes: [
    splashRoute(),
    onBoardingRoute(),
    signUpRoute(),
    signingInRoute(),
    phoneRoute(),
    verifyRouter(),
    verifyEmailRouter(),
    verifyOTPRouter(),
    homeRoute(),
    homeNoRoute(),
  ],
);

GoRoute splashRoute() {
  return GoRoute(
    path: splash,
    name: 'splash',
    builder: (context, state) => const SplashScreen111(),
  );
}

GoRoute onBoardingRoute() {
  return GoRoute(
    path: onBoarding,
    name: 'onBoarding',
    builder: (context, state) => const OnboardingScreen111(),
  );
}

GoRoute signUpRoute() {
  return GoRoute(
    path: signUp,
    name: 'signUp',
    builder: (context, state) => const SignUp111(),
  );
}

GoRoute signingInRoute() {
  return GoRoute(
    path: signingIn,
    name: 'signingIn',
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

GoRoute phoneRoute() {
  return GoRoute(
    path: phone,
    name: 'phone',
    builder: (context, state) {
      final routeData = state.extra as PhoneRouteData;
      return MyPhones111(
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
  final String type;
  final String name;
  final String email;
  final String photoUrl;
  final String id;

  PhoneRouteData(
      {required this.type,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id});
}

GoRoute verifyRouter() {
  return GoRoute(
    path: verify,
    name: 'verify',
    builder: (context, state) {
      final routeData = state.extra as VerifyRouteData;
      return MyVerifyS(
        type: routeData.type,
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

class VerifyRouteData {
  final String type;
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  final int country;
  final int phoneNo;

  VerifyRouteData(
      {required this.type,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id,
      required this.country,
      required this.phoneNo});
}

GoRoute verifyEmailRouter() {
  return GoRoute(
    path: verifyEmail,
    name: 'verifyEmail',
    builder: (context, state) {
      final routeData = state.extra as VerifyRouteData;
      return VerifyPhoneEmail(
        type: routeData.type,
        name: routeData.name,
        email: routeData.email,
        photoUrl: routeData.photoUrl,
        id: routeData.id,
        country: routeData.country,
        phoneno: routeData.phoneNo,
      );
    },
  );
}

GoRoute verifyOTPRouter() {
  return GoRoute(
    path: pVerifyOTP,
    name: 'pVerifyOTP',
    builder: (context, state) {
      final routeData = state.extra as VerifyOTPData;
      return VerifyOTPS(
        type: routeData.type,
        country: routeData.country,
        phoneno: routeData.phoneno,
        otp: routeData.otp,
        name: routeData.name,
        googleEmail: routeData.googleEmail,
        googleId: routeData.googleId,
        googlePhotoUrl: routeData.googlePhotoUrl,
        googlePhotoValid: routeData.googlePhotoValid,
        microsoftEmail: routeData.microsoftEmail,
        microsoftId: routeData.microsoftId,
        microsoftName: routeData.microsoftName,
      );
    },
  );
}

class VerifyOTPData {
  final String type;
  final String country;
  final String phoneno;
  final int otp;
  final String name;
  final String googleEmail;
  final String googleId;
  final String googlePhotoUrl;
  final int googlePhotoValid;
  final String microsoftEmail;
  final String microsoftId;
  final String microsoftName;

  VerifyOTPData(
      {required this.type,
      required this.country,
      required this.phoneno,
      required this.otp,
      required this.name,
      required this.googleEmail,
      required this.googleId,
      required this.googlePhotoUrl,
      required this.googlePhotoValid,
      required this.microsoftEmail,
      required this.microsoftId,
      required this.microsoftName});
}

GoRoute homeRoute() {
  return GoRoute(
    path: home,
    name: 'home',
    builder: (context, state) => const Home(),
  );
}

GoRoute homeNoRoute() {
  return GoRoute(
    path: homeNo,
    name: 'homeNo',
    builder: (context, state) => const HomeNoLogin(),
  );
}

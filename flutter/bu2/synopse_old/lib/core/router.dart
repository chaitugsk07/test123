import 'package:go_router/go_router.dart';
import 'package:synopse/features/01_splash/ui/onboarding_screen.dart';
import 'package:synopse/features/01_splash/ui/splash_screen.dart';
import 'package:synopse/features/02_login_screens/ui/otp.dart';
import 'package:synopse/features/02_login_screens/ui/phone.dart';
import 'package:synopse/features/02_login_screens/ui/signings.dart';
import 'package:synopse/features/02_login_screens/ui/signup.dart';
import 'package:synopse/features/02_login_screens/ui/verify_otp.dart';
import 'package:synopse/features/02_login_screens/ui/verify_phone_email.dart.dart';
import 'package:synopse/features/03_user_profile/ui/manage_intrests.dart';
import 'package:synopse/features/03_user_profile/ui/notifications.dart';
import 'package:synopse/features/03_user_profile/ui/user_level.dart';
import 'package:synopse/features/03_user_profile/ui/user_nav.dart';
import 'package:synopse/features/03_user_profile/ui/user_profile.dart';
import 'package:synopse/features/03_user_profile/ui/user_profile_update.dart';
import 'package:synopse/features/03_user_profile/ui/user_settings.dart';
import 'package:synopse/features/03_user_profile/ui/view_levels.dart';
import 'package:synopse/features/04_home/ui/home.dart';
import 'package:synopse/features/04_home/ui/home_nologin.dart';
import 'package:synopse/features/05_article_details/ui/article_detail.dart';
import 'package:synopse/features/05_article_details/ui/article_webview.dart';
import 'package:synopse/features/06_search/ui/search.dart';
import 'package:synopse/features/06_search/ui/search_m1.dart';
import 'package:synopse/features/06_search/ui/search_output.dart';
import 'package:synopse/features/06_search/ui/search_results_with_text.dart';
import 'package:synopse/features/06_search/ui/search_with_text.dart';
import 'package:synopse/features/07_comments/ui/comments1.dart';
import 'package:synopse/features/07_comments/ui/comments_reply.dart';
import 'package:synopse/features/09_external_user/ui/ext_user.dart';
import 'package:synopse/features/15_article_publisher/ui/article_publisher.dart';

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
const detail = '/detail';
const detailDeep = '/dd/:id';
const detailpage = "/detailpage";
const userMain = '/userMain';
const userSettings = '/userSettings';
const userUpdate = '/userUpdate';
const userIntrests = '/userIntrests';
const userNav = '/userNav';
const notification = '/notification';
const comments = '/comments';
const commentsReply = '/commentsReply';
const commentsDeep = '/dc/:id';
const extUserProfile = "/extUser";
const extUserDeep = '/de/:account';
const userLevel = '/userLevel';
const viewLevel = '/viewLevel';
const search1 = '/search1';
const searchM1 = '/searchM1';
const searchWithText = '/searchWithText';
const searchResultswithText = '/searchResultswithText';
const searchOutput = '/searchOutput';
const mainPublisher = '/mainPublisher';

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
    detailRoute(),
    detailDeepRoute(),
    detailPageRoute(),
    userMainRoute(),
    userSettingsRoute(),
    userUpdateRoute(),
    userIntrestsRoute(),
    userNavRoute(),
    notificationRoute(),
    commentsRoute(),
    commentsReplyRoute(),
    commentsDeepRoute(),
    extUserRoute(),
    extuserDeepRoute(),
    userLevelRoute(),
    viewLevelRoute(),
    searchRoute(),
    searchM1Route(),
    searchWithTextRoute(),
    searchResultswithTextRoute(),
    searchOutputRoute(),
    mainPublisherRoute(),
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

GoRoute detailRoute() {
  return GoRoute(
    path: detail,
    name: 'detail',
    builder: (context, state) {
      final routeData = state.extra as int;
      return ArticleDetailS(
        articleGroupid: routeData,
      );
    },
  );
}

GoRoute detailDeepRoute() {
  return GoRoute(
    path: detailDeep,
    name: 'detailDeep',
    builder: (context, state) {
      return ArticleDetailS(
        articleGroupid: int.parse(state.pathParameters['id']!),
      );
    },
  );
}

GoRoute detailPageRoute() {
  return GoRoute(
    path: detailpage,
    name: 'detailpage',
    builder: (context, state) {
      final postlink = state.extra as String;
      return ArticleWeb(
        postLink: postlink,
      );
    },
  );
}

GoRoute userMainRoute() {
  return GoRoute(
    path: userMain,
    name: 'userMain',
    builder: (context, state) => const UserProfile1(),
  );
}

GoRoute userSettingsRoute() {
  return GoRoute(
    path: userSettings,
    name: 'userSettings',
    builder: (context, state) => const UserSettings(),
  );
}

GoRoute userUpdateRoute() {
  return GoRoute(
    path: userUpdate,
    name: 'userUpdate',
    builder: (context, state) => const UserProfileUpdate(),
  );
}

GoRoute userIntrestsRoute() {
  return GoRoute(
    path: userIntrests,
    name: 'userIntrests',
    builder: (context, state) => const UserIntrests111(),
  );
}

GoRoute userNavRoute() {
  return GoRoute(
    path: userNav,
    name: 'userNav',
    builder: (context, state) {
      final type = state.extra as int;
      return UserNav1(
        type: type,
      );
    },
  );
}

GoRoute notificationRoute() {
  return GoRoute(
    path: notification,
    name: 'notification',
    builder: (context, state) => const Notifications(),
  );
}

GoRoute commentsRoute() {
  return GoRoute(
    path: comments,
    name: 'comments',
    builder: (context, state) {
      final routeData = state.extra as int;
      return Comments1(
        articleGroupId: routeData,
      );
    },
  );
}

GoRoute commentsReplyRoute() {
  return GoRoute(
    path: commentsReply,
    name: 'commentsReply',
    builder: (context, state) {
      final routeData = state.extra as int;
      return Comments1Reply(
        commentMainId: routeData,
      );
    },
  );
}

GoRoute commentsDeepRoute() {
  return GoRoute(
    path: commentsDeep,
    name: 'commentsDeep',
    builder: (context, state) {
      return Comments1Reply(
        commentMainId: int.parse(state.pathParameters['id']!),
      );
    },
  );
}

GoRoute extUserRoute() {
  return GoRoute(
    path: extUserProfile,
    name: 'extUserProfile',
    builder: (context, state) {
      final routeData = state.extra as String;
      return ExtUser1(
        account: routeData,
      );
    },
  );
}

GoRoute extuserDeepRoute() {
  return GoRoute(
    path: extUserDeep,
    name: 'extUserDeep',
    builder: (context, state) {
      return ExtUser1(
        account: state.pathParameters['account']!,
      );
    },
  );
}

GoRoute userLevelRoute() {
  return GoRoute(
    path: userLevel,
    name: 'userLevel',
    builder: (context, state) => const UserLevelCard(),
  );
}

GoRoute viewLevelRoute() {
  return GoRoute(
    path: viewLevel,
    name: 'viewLevel',
    builder: (context, state) => const UserLevels(),
  );
}

GoRoute searchRoute() {
  return GoRoute(
    path: search1,
    name: 'search1',
    builder: (context, state) => const SearchScreenS(),
  );
}

GoRoute searchWithTextRoute() {
  return GoRoute(
    path: searchWithText,
    name: 'searchWithText',
    builder: (context, state) => const SearchScreenSWithText(),
  );
}

GoRoute searchResultswithTextRoute() {
  return GoRoute(
    path: searchResultswithText,
    name: 'searchResultswithText',
    builder: (context, state) {
      final routeData = state.extra as String;
      return SearchResultsWithText(
        searchText: routeData,
      );
    },
  );
}

GoRoute searchM1Route() {
  return GoRoute(
    path: searchM1,
    name: 'searchM1',
    builder: (context, state) {
      final routeData = state.extra as String;
      return SearchM111(
        searchText: routeData,
      );
    },
  );
}

GoRoute searchOutputRoute() {
  return GoRoute(
    path: searchOutput,
    name: 'searchOutput',
    builder: (context, state) {
      final routeData = state.extra as SearchOutputData;
      return SeachOutPutS(
        seachText: routeData.searchText,
        searchId: routeData.searchId,
      );
    },
  );
}

class SearchOutputData {
  final String searchText;
  final int searchId;

  SearchOutputData({
    required this.searchText,
    required this.searchId,
  });
}

GoRoute mainPublisherRoute() {
  return GoRoute(
    path: mainPublisher,
    name: 'mainPublisher',
    builder: (context, state) {
      final routeData = state.extra as String;
      return ArticlePublishers111(
        logoUrl: routeData,
      );
    },
  );
}

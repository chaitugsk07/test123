import 'package:go_router/go_router.dart';
import 'package:synopse/features/01_splash/ui/onboarding_screen.dart';
import 'package:synopse/features/01_splash/ui/splash_screen.dart';
import 'package:synopse/features/02_login_screens/ui/otp.dart';
import 'package:synopse/features/02_login_screens/ui/phone.dart';
import 'package:synopse/features/02_login_screens/ui/signings.dart';
import 'package:synopse/features/02_login_screens/ui/signup.dart';
import 'package:synopse/features/02_login_screens/ui/verify_otp.dart';
import 'package:synopse/features/02_login_screens/ui/verify_phone_email.dart.dart';
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
import 'package:synopse/features/06_search/ui/search_output.dart';
import 'package:synopse/features/07_comments/ui/comments1.dart';
import 'package:synopse/features/07_comments/ui/comments_reply.dart';
import 'package:synopse/features/09_external_user/ui/ext_user.dart';

const splash = '/';
const signUp = '/signUp';
const onBoarding = '/onBoarding';
const notification = '/notification';
const signingIn = '/signing';
const phone = '/phone';
const verify = '/verify';
const verifyEmail = '/verifyEmail';
const pVerifyOTP = '/verifyOTP';
const home = '/home';
const homeNo = '/homeNo';
const detail = '/detail';
const detailDeep = '/dd/:id';
const search1 = '/search1';
const searchOutput = '/searchOutput';
const userNav = '/userNav';
const detailpage = "/detailpage";
const extUser = '/extUser/:account';
const userMain = '/userMain';
const userSettings = '/userSettings';
const userUpdate = '/userUpdate';
const userLevel = '/userLevel';
const viewLevel = '/viewLevel';
const comments = '/comments';
const commentReply = '/commentReply';
const extUserProfile = "/extUserProfile";

final GoRouter router = GoRouter(
  routes: [
    splashRoute(),
    signUpRoute(),
    onBoardingRoute(),
    notificationRoute(),
    signingInRoute(),
    phoneRoute(),
    verifyRouter(),
    verifyEmailRouter(),
    verifyOTPRouter(),
    homeRoute(),
    homeNoRoute(),
    userNavRoute(),
    detailRoute(),
    detailDeepRoute(),
    detailPageRoute(),
    searchRoute(),
    searchOutputRoute(),
    commentsRoute(),
    commentsReplyRoute(),
    extUserRoute(),
    userMainRoute(),
    userUpdateRoute(),
    userSettingsRoute(),
    userLevelRoute(),
    viewLevelRoute(),
  ],
);

GoRoute splashRoute() {
  return GoRoute(
    path: splash,
    name: 'splash',
    builder: (context, state) => const SplashScreenS(),
  );
}

GoRoute onBoardingRoute() {
  return GoRoute(
    path: onBoarding,
    name: 'onBoarding',
    builder: (context, state) => const OnboardingScreen(),
  );
}

GoRoute notificationRoute() {
  return GoRoute(
    path: notification,
    name: 'notification',
    builder: (context, state) => const Notifications(),
  );
}

GoRoute signUpRoute() {
  return GoRoute(
    path: signUp,
    name: 'signUp',
    builder: (context, state) => const SignUpSl(),
  );
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
    path: commentReply,
    name: 'commentReply',
    builder: (context, state) {
      final routeData = state.extra as CommentsReplyOutputData;
      return Comments1Reply(
        name: routeData.name,
        userName: routeData.userName,
        photoUrl: routeData.photoUrl,
        comment: routeData.comment,
        articleGroupId: routeData.articleGroupId,
        updatedAtFormatted: routeData.updatedAtFormatted,
        likesCount: routeData.likesCount,
        dislikesCount: routeData.dislikesCount,
        isLiked: routeData.isLiked,
        isDisliked: routeData.isDisliked,
        isEdited: routeData.isEdited,
        replyCount: routeData.replyCount,
        commentId: routeData.commentId,
        account: routeData.account,
        title: routeData.title,
        logoUrls: routeData.logoUrls,
        isOwner: routeData.isOwner,
      );
    },
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

GoRoute phoneRoute() {
  return GoRoute(
    path: phone,
    name: 'phone',
    builder: (context, state) {
      final routeData = state.extra as PhoneRouteData;
      return MyPhones(
        type: routeData.type,
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

GoRoute searchRoute() {
  return GoRoute(
    path: search1,
    name: 'search1',
    builder: (context, state) => const SearchScreenS(),
  );
}

GoRoute extUserRoute() {
  return GoRoute(
    path: extUser,
    name: 'extUser',
    builder: (context, state) {
      final routeData = state.extra as String;
      return ExtUser1(
        account: routeData,
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

GoRoute userUpdateRoute() {
  return GoRoute(
    path: userUpdate,
    name: 'userUpdate',
    builder: (context, state) => const UserProfileUpdate(),
  );
}

GoRoute userSettingsRoute() {
  return GoRoute(
    path: userSettings,
    name: 'userSettings',
    builder: (context, state) => const UserSettings(),
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

class SearchOutputData {
  final String searchText;
  final int searchId;

  SearchOutputData({
    required this.searchText,
    required this.searchId,
  });
}

class CommentsReplyOutputData {
  final String name;
  final String userName;
  final String photoUrl;
  final String comment;
  final int articleGroupId;
  final String updatedAtFormatted;
  final int likesCount;
  final int dislikesCount;
  final bool isLiked;
  final bool isDisliked;
  final bool isEdited;
  final int replyCount;
  final int commentId;
  final String account;
  final String title;
  final List<String> logoUrls;
  final bool isOwner;

  CommentsReplyOutputData(
      {required this.name,
      required this.userName,
      required this.photoUrl,
      required this.comment,
      required this.articleGroupId,
      required this.updatedAtFormatted,
      required this.likesCount,
      required this.dislikesCount,
      required this.isLiked,
      required this.isDisliked,
      required this.isEdited,
      required this.replyCount,
      required this.commentId,
      required this.account,
      required this.title,
      required this.logoUrls,
      required this.isOwner});
}

import 'package:go_router/go_router.dart';
import 'package:synopse/core/observer/nav_observer.dart';
import 'package:synopse/features/01_splash/language.dart';
import 'package:synopse/features/01_splash/onboarding_screen.dart';
import 'package:synopse/features/01_splash/splash_screen.dart';
import 'package:synopse/features/02_login_screens/manage_intrests_signup.dart';
import 'package:synopse/features/02_login_screens/signup.dart';
import 'package:synopse/features/02_login_screens/signup1_1.dart';
import 'package:synopse/features/02_login_screens/user_profile_signUp.dart';
import 'package:synopse/features/03_user_profile/manage_intrests.dart';
import 'package:synopse/features/03_user_profile/notifications.dart';
import 'package:synopse/features/03_user_profile/user_level.dart';
import 'package:synopse/features/03_user_profile/user_nav.dart';
import 'package:synopse/features/03_user_profile/user_profile.dart';
import 'package:synopse/features/03_user_profile/user_profile_update.dart';
import 'package:synopse/features/03_user_profile/user_settings.dart';
import 'package:synopse/features/03_user_profile/view_levels.dart';
import 'package:synopse/features/04_home/home.dart';
import 'package:synopse/features/04_home/home_nologin.dart';
import 'package:synopse/features/04_home/inshort.dart';
import 'package:synopse/features/05_article_details/article_deep.dart';
import 'package:synopse/features/05_article_details/article_detail.dart';
import 'package:synopse/features/05_article_details/article_detail_no.dart';
import 'package:synopse/features/05_article_details/article_follow_up.dart';
import 'package:synopse/features/05_article_details/article_share.dart';
import 'package:synopse/features/05_article_details/article_webview.dart';
import 'package:synopse/features/06_search/search_results_with_text.dart';
import 'package:synopse/features/06_search/search_with_text.dart';
import 'package:synopse/features/15_article_publisher/article_publisher.dart';

const splash = '/';
const language = '/language';
const onBoarding = '/onBoarding';
const signUp = '/signUp';
const signingIn1 = '/signingIn1';
const userProfileSignUp = '/userProfileSignUp';
const manageIntrestsTags = '/manageIntrestsTags';
const home = '/home';
const homeNo = '/homeNo';
const inShorts = '/inShorts';
const detail = '/detail';
const detailNo = '/detailNo';
const detailpage = "/detailpage";
const userMain = '/userMain';
const userIntrests = '/userIntrests';
const userNav = '/userNav';
const userSettings = '/userSettings';
const userUpdate = '/userUpdate';
const notification = '/notification';
const userLevel = '/userLevel';
const viewLevel = '/viewLevel';
const searchWithText = '/searchWithText';
const searchResultswithText = '/searchResultswithText';
const mainPublisher = '/mainPublisher';
const articleFollowUp = '/articleFollowUp';
const articleShare = '/articleShare';

const detailDeep = '/dd/:id';
const extUserDeep = '/de/:account';

final GoRouter router = GoRouter(
  observers: [MyNavObserver()],
  routes: [
    splashRoute(),
    languageshRoute(),
    onBoardingRoute(),
    signUpRoute(),
    signingInRoute(),
    userProfileSignUpRoute(),
    manageIntrestsTagsRoute(),
    homeRoute(),
    homeNoRoute(),
    inShortsRoute(),
    detailRoute(),
    detailNoRoute(),
    detailPageRoute(),
    userMainRoute(),
    userIntrestsRoute(),
    userNavRoute(),
    userSettingsRoute(),
    userUpdateRoute(),
    notificationRoute(),
    userLevelRoute(),
    viewLevelRoute(),
    searchWithTextRoute(),
    searchResultswithTextRoute(),
    mainPublisherRoute(),
    articleFollowUpRoute(),
    detailDeepRoute(),
    articleShareRoute(),
    // extuserDeepRoute(),
  ],
);

GoRoute splashRoute() {
  return GoRoute(
    path: splash,
    name: 'splash',
    builder: (context, state) => const SplashScreen111(),
  );
}

GoRoute languageshRoute() {
  return GoRoute(
    path: language,
    name: 'language',
    builder: (context, state) => const Language111(),
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
    path: signingIn1,
    name: 'signingIn1',
    builder: (context, state) {
      final routeData = state.extra as SigningInData;
      return SigningIn11(
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

GoRoute homeRoute() {
  return GoRoute(
    path: home,
    name: 'home',
    builder: (context, state) => const Home111(),
  );
}

GoRoute homeNoRoute() {
  return GoRoute(
    path: homeNo,
    name: 'homeNo',
    builder: (context, state) => const HomeNoLogin(),
  );
}

GoRoute inShortsRoute() {
  return GoRoute(
    path: inShorts,
    name: 'inShorts',
    builder: (context, state) => const ArticleInshorts111(),
  );
}

GoRoute detailRoute() {
  return GoRoute(
    path: detail,
    name: 'detail',
    builder: (context, state) {
      final routeData = state.extra as DetailData;
      return ArticleDetailS(
        articleGroupid: routeData.articleGroupid,
        type: routeData.type,
      );
    },
  );
}

GoRoute detailNoRoute() {
  return GoRoute(
    path: detailNo,
    name: 'detailNo',
    builder: (context, state) {
      final routeData = state.extra as DetailData;
      return ArticleDetailSNo(
        articleGroupid: routeData.articleGroupid,
        type: routeData.type,
      );
    },
  );
}

class DetailData {
  final int articleGroupid;
  final int type;

  DetailData({required this.articleGroupid, required this.type});
}

GoRoute detailDeepRoute() {
  return GoRoute(
    path: detailDeep,
    name: 'detailDeep',
    builder: (context, state) {
      return ArticleGroupDeep(
        articleGroupid: int.parse(state.pathParameters['id']!),
      );
    },
  );
}

articleShareRoute() {
  return GoRoute(
    path: articleShare,
    name: 'articleShare',
    builder: (context, state) {
      final routeData = state.extra as ArticleShareData;
      return ArticleShare11(
        tag: routeData.tag,
        title: routeData.title,
        description: routeData.description,
        reads: routeData.reads,
        imageurl: routeData.imageurl,
        articleGroupId: routeData.articleGroupId,
      );
    },
  );
}

class ArticleShareData {
  final String tag;
  final String title;
  final String description;
  final int reads;
  final String imageurl;
  final int articleGroupId;

  ArticleShareData(
      {required this.tag,
      required this.title,
      required this.description,
      required this.reads,
      required this.imageurl,
      required this.articleGroupId});
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

GoRoute userProfileSignUpRoute() {
  return GoRoute(
    path: userProfileSignUp,
    name: 'userProfileSignUp',
    builder: (context, state) => const UserProfileSignUp(),
  );
}

GoRoute manageIntrestsTagsRoute() {
  return GoRoute(
    path: manageIntrestsTags,
    name: 'manageIntrestsTags',
    builder: (context, state) => const UserIntrestsSignUp111(),
  );
}

GoRoute notificationRoute() {
  return GoRoute(
    path: notification,
    name: 'notification',
    builder: (context, state) => const Notifications(),
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

GoRoute articleFollowUpRoute() {
  return GoRoute(
    path: articleFollowUp,
    name: 'articleFollowUp',
    builder: (context, state) {
      final routeData = state.extra as ArticleFollowUpData;
      return ArticleFollowUp111(
        articleId: routeData.articleId,
        title: routeData.title,
      );
    },
  );
}

class ArticleFollowUpData {
  final int articleId;
  final String title;

  ArticleFollowUpData({required this.articleId, required this.title});
}

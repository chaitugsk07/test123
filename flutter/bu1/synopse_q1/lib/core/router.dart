import 'package:go_router/go_router.dart';
import 'package:synopse/features/01_splash/language.dart';
import 'package:synopse/features/01_splash/onboarding_screen.dart';
import 'package:synopse/features/01_splash/splash_screen.dart';
import 'package:synopse/features/02_login_screens/signup.dart';

const splash = '/';
const language = '/language';
const onBoarding = '/onBoarding';
const signUp = '/signUp';

final GoRouter router = GoRouter(
  routes: [
    splashRoute(),
    languageshRoute(),
    onBoardingRoute(),
    signUpRoute(),
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

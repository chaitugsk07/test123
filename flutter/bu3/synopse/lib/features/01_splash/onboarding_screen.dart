import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';
import 'package:synopse/features/00_common_widgets/no_internet_sb.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/01_splash/bloc_onBoarding/onboarding_bloc.dart';

class OnboardingScreen111 extends StatelessWidget {
  const OnboardingScreen111({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OnBoardingBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const OnboardingScreen11(),
    );
  }
}

class OnboardingScreen11 extends StatefulWidget {
  const OnboardingScreen11({super.key});

  @override
  State<OnboardingScreen11> createState() => _OnboardingScreen11State();
}

class _OnboardingScreen11State extends State<OnboardingScreen11> {
  @override
  void initState() {
    super.initState();
    context.read<OnBoardingBloc>().add(GetOnBoardingFetch());
  }

  Future<void> setOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingSkip', true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              shadowColor: Theme.of(context).colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: SizedBox(
                height: 300,
                width: 400,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: SvgPicture.asset(
                      SvgConstant.logo,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onBackground,
                          BlendMode.srcIn),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      "Do you want to exit the App?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "Are you sure?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: GestureDetector(
                      onTap: () {
                        context.push(splash);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 40,
                        width: 200,
                        child: Text(
                          "No",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.background,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: GestureDetector(
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            );
          },
        );
        return;
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<OnBoardingBloc, OnBoardingState>(
            builder: (context, onBoardingState) {
              if (onBoardingState.status == OnBoardingStatus.initial) {
                return const Center(
                  child: PageLoading(
                    title: "Onboarding initial",
                  ),
                );
              }
              if (onBoardingState.status == OnBoardingStatus.success) {
                return Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 55, 61, 70),
                              Color.fromARGB(255, 92, 117, 126),
                            ],
                            stops: [
                              0.5,
                              1.0,
                            ],
                          ),
                        ),
                        child: ListView(
                          children: [
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 100.milliseconds,
                                    duration: 1000.milliseconds,
                                    curve: Curves.easeInOutCirc),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 10, top: 100, bottom: 30),
                                child: Text(
                                  onBoardingState.onboarding[0].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 200.milliseconds,
                                    duration: 1000.milliseconds,
                                    curve: Curves.easeInOutCirc),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 10, top: 10),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        onBoardingState.onboarding[1].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 300.milliseconds,
                                    duration: 1000.milliseconds,
                                    curve: Curves.easeInOutCirc),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 10, top: 10),
                                child: Text(
                                  onBoardingState.onboarding[1].desc,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 400.milliseconds,
                                    duration: 1000.milliseconds,
                                    curve: Curves.easeInOutCirc),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 10, top: 30),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        onBoardingState.onboarding[2].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 500.milliseconds,
                                    duration: 1000.milliseconds,
                                    curve: Curves.easeInOutCirc),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 10, top: 10),
                                child: Text(
                                  onBoardingState.onboarding[2].desc,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 800.milliseconds,
                                    duration: 1000.milliseconds,
                                    curve: Curves.easeInOutCirc),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 100, left: 50, right: 50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setOnboardingStatus();
                                    context.push(splash);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      onBoardingState.onboarding[0].getStarted,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
              }
              if (onBoardingState.status == OnBoardingStatus.failure) {
                return NoInternetSnackBar(context: context);
              } else {
                return const PageLoading(
                  title: "Onboarding final",
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/router.dart';
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
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
    context.read<OnBoardingBloc>().add(GetOnBoardingFetch());
  }

  int _currentPage = 0;

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  Future<void> setOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingSkip', true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<OnBoardingBloc, OnBoardingState>(
          builder: (context, onBoardingState) {
            if (onBoardingState.status == OnBoardingStatus.initial) {
              return const Center(
                child: PageLoading(),
              );
            }
            if (onBoardingState.status == OnBoardingStatus.success) {
              final int onbLen = onBoardingState.onboarding.length;
              return Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 250,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _controller,
                      onPageChanged: (value) =>
                          setState(() => _currentPage = value),
                      itemCount: onbLen,
                      itemBuilder: (context, i) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 300.milliseconds,
                                        duration: 1000.milliseconds,
                                        curve: Curves.easeInOutCirc),
                                  ],
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: 250,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            onBoardingState.onboarding[i].image,
                                        placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              height: 30,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            ),
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 500.milliseconds,
                                        duration: 1000.milliseconds,
                                        curve: Curves.easeInOutCirc),
                                  ],
                                  child: Text(
                                    onBoardingState.onboarding[i].title,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 600.milliseconds,
                                        duration: 1000.milliseconds,
                                        curve: Curves.easeInOutCirc),
                                  ],
                                  child: Text(
                                    onBoardingState.onboarding[i].desc,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onbLen,
                            (int index) => _buildDots(
                              index: index,
                            ),
                          ),
                        ),
                        _currentPage + 1 == onbLen
                            ? Padding(
                                padding: const EdgeInsets.all(30),
                                child: Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 500.milliseconds,
                                        duration: 1000.milliseconds,
                                        curve: Curves.easeInOutCirc),
                                  ],
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setOnboardingStatus();
                                      context.push(splash);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        onBoardingState
                                            .onboarding[0].getStarted,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Animate(
                                      effects: [
                                        FadeEffect(
                                            delay: 1000.milliseconds,
                                            duration: 1000.milliseconds,
                                            curve: Curves.easeInOutCirc),
                                      ],
                                      child: GestureDetector(
                                        onTap: () {
                                          setOnboardingStatus();
                                          context.push(splash);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            onBoardingState.onboarding[0].skip,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
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
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _controller.nextPage(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.easeIn,
                                          );
                                        },
                                        child: Text(
                                          onBoardingState.onboarding[0].next,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ));
            }
            if (onBoardingState.status == OnBoardingStatus.failure) {
              return NoInternetSnackBar(context: context);
            } else {
              return const PageLoading();
            }
          },
        ),
      ),
    );
  }
}

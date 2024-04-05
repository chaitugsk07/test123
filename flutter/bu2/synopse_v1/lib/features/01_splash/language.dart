import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';
import 'package:synopse/features/00_common_widgets/no_internet_sb.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/01_splash/bloc_language/language_bloc.dart';

class Language111 extends StatelessWidget {
  const Language111({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const Language11(),
    );
  }
}

class Language11 extends StatefulWidget {
  const Language11({super.key});

  @override
  State<Language11> createState() => _Language11State();
}

class _Language11State extends State<Language11> {
  late int id;
  late String languageCode;
  late String noInternetMessage;
  late String level;
  late String search;
  late String forYou;
  late String areYouSure;
  late String exitApp;
  late String yes;
  late String no;
  @override
  void initState() {
    super.initState();
    context.read<LanguageBloc>().add(GetlanguageFetch());
    id = 0;
    languageCode = "en";
    noInternetMessage = "There is issue please check internet connection";
    level = "Level";
    search = "Search";
    forYou = "For You";
    areYouSure = "Are you sure?";
    exitApp = "Do you want to exit the app?";
    yes = "Yes";
    no = "No";
  }

  Future<void> setLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', languageCode);
    prefs.setString('noInternetMessage', noInternetMessage);
    prefs.setString('level', level);
    prefs.setString('search', search);
    prefs.setString('forYou', forYou);
    prefs.setString('areYouSure', areYouSure);
    prefs.setString('exitApp', exitApp);
    prefs.setString('yes', yes);
    prefs.setString('no', no);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            if (languageState.status == LanguageStatus.initial) {
              return const Center(
                child: PageLoading(),
              );
            }
            if (languageState.status == LanguageStatus.success) {
              return Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 75,
                        width: MediaQuery.of(context).size.width - 100,
                        child: Center(
                          child: Animate(
                            effects: [
                              FadeEffect(
                                  delay: 30.milliseconds,
                                  duration: 1000.milliseconds),
                            ],
                            child: Text(
                              languageState
                                  .languageElement[id].the111SelectLanguage,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Wrap(
                      children: List.generate(
                        languageState.languageElement.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Animate(
                            effects: [
                              FadeEffect(
                                  delay: (300 + 150 * index).milliseconds,
                                  duration: 1000.milliseconds),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: id == index
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.6)
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    id = index;
                                    languageCode = languageState
                                        .languageElement[index].languageCode;
                                    noInternetMessage = languageState
                                        .languageElement[index]
                                        .the00InternetIssue;
                                    level = languageState
                                        .languageElement[index].the04Level;
                                    search = languageState
                                        .languageElement[index].the04Search;
                                    forYou = languageState
                                        .languageElement[index].the04ForYou;
                                    areYouSure = languageState
                                        .languageElement[index].the04AreYouSure;
                                    exitApp = languageState
                                        .languageElement[index].the04ExitApp;
                                    yes = languageState
                                        .languageElement[index].the04Yes;
                                    no = languageState
                                        .languageElement[index].the04No;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: index == 0
                                            ? const EdgeInsets.only(
                                                bottom: 17.0)
                                            : const EdgeInsets.only(
                                                bottom: 1.0),
                                        child: Text(
                                          languageState.languageElement[index]
                                              .languageNative,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: id == index
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .background
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                              ),
                                        ),
                                      ),
                                      if (index > 0)
                                        Text(
                                          languageState.languageElement[index]
                                              .languageEnglish,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: id == index
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .background
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 1000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setLanguage();
                          context.push(splash);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              languageState.languageElement[id].the111Submit,
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            if (languageState.status == LanguageStatus.failure) {
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

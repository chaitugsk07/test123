import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';
import 'package:synopse/features/00_common_widgets/no_internet_sb.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/02_login_screens/bloc_signUp/signup_bloc.dart';
import 'package:synopse/features/02_login_screens/login_api.dart';

class SignUp111 extends StatelessWidget {
  const SignUp111({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const SignUp11(),
    );
  }
}

class SignUp11 extends StatefulWidget {
  const SignUp11({super.key});

  @override
  State<SignUp11> createState() => _SignUp11State();
}

class _SignUp11State extends State<SignUp11> {
  Future<void> setGuestStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoginSkipped', true);
  }

  @override
  void initState() {
    super.initState();
    context.read<SignUpBloc>().add(GetSignUpFetch());
    signOut();
  }

  void signOut() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('isOnboardingSkip', true);
    prefs.setBool('isLoggedIn', false);
    prefs.setBool('isLoginSkipped', false);
    prefs.setString('loginToken', "");
    prefs.setString('account', "");
    prefs.setString('exp', "");
    await LoginApi.signOut();
    prefs.setBool("isGoogleLoggedIn", false);
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
          body: BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, signUpState) {
              if (signUpState.status == SignUpStatus.initial) {
                return const Center(
                  child: PageLoading(
                    title: "Sign Up initial",
                  ),
                );
              }
              if (signUpState.status == SignUpStatus.success) {
                return Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      width: 350,
                      height: 700,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 100.milliseconds,
                                        duration: 1000.milliseconds,
                                        curve: Curves.easeInOutCirc),
                                  ],
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      child: SizedBox(
                                        height: 4,
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 3,
                                              width: 98,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Container(
                                              height: 3,
                                              width: 98,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Container(
                                              height: 3,
                                              width: 98,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Animate(
                                  effects: [
                                    ScaleEffect(
                                        delay: 1000.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 50),
                                    child: Center(
                                      child: Image.asset(ImageConstant.imgLogo),
                                    ),
                                  ),
                                ),
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 500.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: Text(
                                    signUpState.signUp[0].projectName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 600.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      signUpState.signUp[0].title,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 700.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: SizedBox(
                                    width: 500,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        googleLogin();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
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
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          SizedBox(
                                            width: 30,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: FaIcon(
                                                FontAwesomeIcons.google,
                                                size: 15,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            signUpState.signUp[0].google,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background),
                                          ),
                                          const Spacer(),
                                          const SizedBox(
                                            width: 40,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (1 == 2)
                                  Animate(
                                    effects: [
                                      FadeEffect(
                                          delay: 700.milliseconds,
                                          duration: 1000.milliseconds)
                                    ],
                                    child: SizedBox(
                                      width: 500,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () async {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
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
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            SizedBox(
                                              width: 30,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: FaIcon(
                                                  FontAwesomeIcons.apple,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              signUpState.signUp[0].apple,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background),
                                            ),
                                            const Spacer(),
                                            const SizedBox(
                                              width: 40,
                                            )
                                          ],
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
                                        delay: 800.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: GestureDetector(
                                    onTap: () {
                                      setGuestStatus();
                                      context.push(homeNo);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(0.8)),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "${signUpState.signUp[0].or} "),
                                            TextSpan(
                                              text: signUpState.signUp[0].guest,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 900.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push(detailpage,
                                          extra: "https://synopseai.com/#/tos");
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      child: Center(
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground
                                                          .withOpacity(0.8)),
                                              children: [
                                                TextSpan(
                                                    text: signUpState
                                                        .signUp[0].tos1),
                                                TextSpan(
                                                  text: signUpState
                                                      .signUp[0].tos2,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                TextSpan(
                                                    text:
                                                        " ${signUpState.signUp[0].tos3} "),
                                                TextSpan(
                                                  text: signUpState
                                                      .signUp[0].tos4,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (signUpState.status == SignUpStatus.failure) {
                return NoInternetSnackBar(context: context);
              } else {
                return const PageLoading(
                  title: "Sign Up final",
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void gotoSigningIn1(
      String type, String name, String email, String photoUrl, String id) {
    context.push(
      signingIn1,
      extra: SigningInData(
        type: type,
        name: name,
        email: email,
        photoUrl: photoUrl,
        id: id,
      ),
    );
  }

  void googleLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isGoogleLoggedIn = prefs.getBool("isGoogleLoggedIn") ?? false;
    if (!isGoogleLoggedIn) {
      var user = await LoginApi.loginWithGoogle();
      if (user != null) {
        prefs.setBool("isGoogleLoggedIn", true);
        var name = user.displayName ?? "";
        var email = user.email;
        var photoUrl = user.photoUrl ?? "";
        var id = user.id;
        gotoSigningIn1("google", name, email, photoUrl, id);
      }
    } else {
      var email = prefs.getString('email') ?? "";
      var id = prefs.getString('id') ?? "";
      if (email != "" && id != "") {
        prefs.setBool("isGoogleLoggedIn", !isGoogleLoggedIn);
        prefs.setString('email', "");
        prefs.setString('id', "");

        gotoSigningIn1("google", "", email, "", id);
      } else {
        var user = await LoginApi.loginWithGoogle();
        if (user != null) {
          prefs.setBool("isGoogleLoggedIn", !isGoogleLoggedIn);
          var name = user.displayName ?? "";
          var email = user.email;
          var photoUrl = user.photoUrl ?? "";
          var id = user.id;
          prefs.setString('email', email);
          prefs.setString('id', id);
          gotoSigningIn1("google", name, email, photoUrl, id);
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, signUpState) {
            if (signUpState.status == SignUpStatus.initial) {
              return const Center(
                child: PageLoading(),
              );
            }
            if (signUpState.status == SignUpStatus.success) {
              return Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                      minWidth: 200,
                      maxWidth: 350,
                    ),
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
                              const SizedBox(
                                height: 20,
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
                                        .copyWith(fontWeight: FontWeight.w300),
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: FaIcon(
                                              FontAwesomeIcons.google,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
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
                                          width: 30,
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
                                      delay: 700.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: SizedBox(
                                  width: 500,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () async {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: FaIcon(
                                              FontAwesomeIcons.apple,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
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
                                          width: 30,
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
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ]),
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
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
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
                                                text:
                                                    signUpState.signUp[0].tos1),
                                            TextSpan(
                                              text: signUpState.signUp[0].tos2,
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
                                            TextSpan(
                                                text:
                                                    " ${signUpState.signUp[0].tos3} "),
                                            TextSpan(
                                              text: signUpState.signUp[0].tos4,
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
              return const PageLoading();
            }
          },
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

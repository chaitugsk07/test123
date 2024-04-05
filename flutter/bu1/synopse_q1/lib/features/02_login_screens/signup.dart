import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
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
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 500.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Text(
                                  signUpState.signUp[0].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(fontWeight: FontWeight.w300),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 2000.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: SizedBox(
                                  width: 500,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      googleLogin();
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: FaIcon(
                                            FontAwesomeIcons.google,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          signUpState.signUp[0].google,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 15),
                                        ),
                                        const Spacer(),
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
                                      delay: 2000.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: SizedBox(
                                  width: 500,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () async {},
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: FaIcon(
                                            FontAwesomeIcons.apple,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          signUpState.signUp[0].apple,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 15),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
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
                                      TextSpan(text: signUpState.signUp[0].or),
                                      TextSpan(
                                        text: signUpState.signUp[0].guest,
                                      ),
                                    ]),
                              ),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 2000.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Container(
                                  alignment: Alignment.center,
                                  child: RichText(
                                    text: TextSpan(
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      children: const [
                                        TextSpan(
                                            text:
                                                "By continuing you agree to our "),
                                        TextSpan(
                                          text: "Terms ",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        TextSpan(text: "and "),
                                        TextSpan(
                                          text: "Privacy Policy. ",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
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
        //  context.push(
        //   signingIn,
        //   extra: SigningInData(
        //     type: "google",
        //     name: name,
        //     email: email,
        //     photoUrl: photoUrl,
        //     id: id,
        //   ),
        // );
      }
    } else {
      var email = prefs.getString('email') ?? "";
      var id = prefs.getString('id') ?? "";
      if (email != "" && id != "") {
        prefs.setBool("isGoogleLoggedIn", !isGoogleLoggedIn);
        prefs.setString('email', "");
        prefs.setString('id', "");
        //  context.push(
        //   signingIn,
        //   extra: SigningInData(
        //     type: "google",
        //     name: "",
        //     email: email,
        //     photoUrl: "",
        //     id: id,
        //   ),
        // );
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
          // context.push(
          //   signingIn,
          //   extra: SigningInData(
          //     type: "google",
          //     name: name,
          //     email: email,
          //     photoUrl: photoUrl,
          //     id: id,
          //   ),
          // );
        }
      }
    }
  }
}

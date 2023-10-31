import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/theme/app_themes.dart';
import 'package:synopse/core/theme/bloc/theme_bloc.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/00_common_widgets/Main_ani.dart';
import 'package:synopse/features/02_login_screens/bloc/is_user_already_exists/check_user_bloc.dart';
import 'package:synopse/features/02_login_screens/bloc/login_api.dart';

class SignUpSl extends StatelessWidget {
  const SignUpSl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CheckUserBloc()),
      ],
      child: const SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const MainAni(),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 1000.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Text(
                        "SYNOPSE",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 55,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 7,
                            ),
                      ),
                    ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 1000.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16),
                            children: const [
                              TextSpan(text: "Better With "),
                              TextSpan(
                                text: "Friends",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
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
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.1),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.apple,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.8),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "Continue with Apple",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.8),
                                    ),
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
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.1),
                          ),
                          onPressed: () async {
                            var user = await LoginApi.loginWithGoogle();
                            if (user != null) {
                              context.read<CheckUserBloc>().add(
                                    CheckUserExistsOrNot(
                                      type: "google",
                                      email: user.email,
                                      id: user.id,
                                    ),
                                  );
                              final state = context.read<CheckUserBloc>().state;
                              if (state.status == CheckUserStatus.phone) {
                                context.push(
                                  phone,
                                  extra: PhoneRouteData(
                                    name: user.displayName ?? "adam",
                                    email: user.email,
                                    photoUrl: user.photoUrl ?? "na",
                                    id: user.id,
                                  ),
                                );
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.8),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "Continue with Google",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.8),
                                    ),
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
                      child: GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          width: 500,
                          height: 45,
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                "Continue as Guest",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.8),
                                    ),
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
                      child: Container(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                    ),
                            children: const [
                              TextSpan(text: "By continuing you agree to our "),
                              TextSpan(
                                text: "Terms",
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<ThemeBloc, ThemeData>(
                  builder: (context, themeData) {
                    return CupertinoSwitch(
                        value: themeData == AppThemes.darkTheme,
                        onChanged: (bool val) {
                          BlocProvider.of<ThemeBloc>(context)
                              .add(ThemeSwitchEvent());
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

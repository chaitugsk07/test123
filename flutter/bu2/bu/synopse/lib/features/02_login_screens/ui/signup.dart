// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/asset_gen/assets.gen.dart';
import 'package:synopse/core/localization/language.dart';
import 'package:synopse/core/localization/language_constants.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/02_login_screens/bloc/login_api.dart';
import 'package:synopse/main.dart';

class SignUpSl extends StatelessWidget {
  const SignUpSl({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUp();
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static final Config config = Config(
    tenant: '4ce54642-fd13-4892-88a9-729f6b45f3f1',
    clientId: 'a6e335f0-95eb-4b4a-959d-e4aeb4c742b0',
    scope: 'openid profile offline_access',
    navigatorKey: router.routerDelegate.navigatorKey,
    loader: const SizedBox(),
    appBar: AppBar(
      title: const Text('AAD OAuth Demo'),
    ),
  );
  final AadOAuth oauth = AadOAuth(config);

  Future<void> setGuestStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoginSkipped', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
                          child: Center(
                            child: Assets.images.logo
                                .image(width: 150, height: 150),
                          ),
                        ),
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 1000.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Text(
                            translation(context).name,
                            style: MyTypography.s1,
                          ),
                        ),
                        Row(
                          children: [
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 1000.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return Animate(
                                        effects: [
                                          SlideEffect(
                                            begin: const Offset(0, 1),
                                            end: const Offset(0, 0),
                                            delay: 200.microseconds,
                                            duration: 1000.milliseconds,
                                            curve: Curves.easeInOutCubic,
                                          ),
                                        ],
                                        child: SizedBox(
                                          height: 400,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Icon(
                                                      Icons.language,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      translation(context)
                                                          .changeLanguage,
                                                      style: MyTypography.t1,
                                                    ),
                                                    const SizedBox(width: 24),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                thickness: 1,
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      Language.languageList()
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final language = Language
                                                        .languageList()[index];
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        Locale locale =
                                                            await setLocale(
                                                                language
                                                                    .languageCode);
                                                        MyApp.setLocale(
                                                            context, locale);
                                                        if (context.canPop()) {
                                                          context.pop();
                                                        } else {
                                                          context.push(splash);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                            child: language
                                                                        .name ==
                                                                    translation(
                                                                            context)
                                                                        .language
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        language
                                                                            .name,
                                                                        style: MyTypography
                                                                            .t12
                                                                            .copyWith(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onBackground
                                                                              .withOpacity(0.8),
                                                                          fontStyle:
                                                                              FontStyle.italic,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .onBackground
                                                                            .withOpacity(0.8),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    language
                                                                        .name,
                                                                    style:
                                                                        MyTypography
                                                                            .t12,
                                                                  )),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.language,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        translation(context).language,
                                        style: MyTypography.s2.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 1000.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  translation(context).b2,
                                  style: MyTypography.s2.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                  const Spacer(),
                                  Text(
                                    translation(context).c1Google,
                                    style: MyTypography.s2.copyWith(
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
                                  const Spacer(),
                                  Text(
                                    translation(context).c1Apple,
                                    style: MyTypography.s2.copyWith(
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
                              onPressed: () {
                                login(false);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: FaIcon(
                                      FontAwesomeIcons.microsoft,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    translation(context).c1Microsoft,
                                    style: MyTypography.s2.copyWith(
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
                            onTap: () {
                              setGuestStatus();
                              context.push(homeNo);
                            },
                            child: SizedBox(
                              width: 500,
                              height: 45,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Text(
                                    translation(context).c1Guest,
                                    style: MyTypography.s2.copyWith(
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
                                style: MyTypography.s3,
                                children: [
                                  TextSpan(text: translation(context).r1),
                                  TextSpan(
                                    text: translation(context).r2,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  TextSpan(text: translation(context).r3),
                                  TextSpan(
                                    text: translation(context).r4,
                                    style: const TextStyle(color: Colors.red),
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
        ),
      ),
    );
  }

  void login(bool redirect) async {
    final prefs = await SharedPreferences.getInstance();
    final isMicrosoftLoggedIn = prefs.getBool("isMicrosoftLoggedIn") ?? false;
    if (!isMicrosoftLoggedIn) {
      config.webUseRedirect = redirect;
      await oauth.login();
      var accessToken = await oauth.getAccessToken();
      if (accessToken != null) {
        prefs.setBool("isMicrosoftLoggedIn", !isMicrosoftLoggedIn);

        List<String> parts = accessToken.split(".");
        if (parts.length != 3) {
          throw Exception("Invalid token");
        }

        String payloadPart = parts[1];
        String normalizedPayload = base64Url.normalize(payloadPart);
        String payloadString = utf8.decode(base64Url.decode(normalizedPayload));

        Map<String, dynamic> payload = jsonDecode(payloadString);

        String? email = payload["email"];
        String? name = payload["name"];
        String? oid = payload["oid"];
        prefs.setString('microsoft_email', email ?? "");
        prefs.setString('microsoft_name', name ?? "");
        prefs.setString('microsoft_oid', oid ?? "");
        context.push(
          signingIn,
          extra: SigningInData(
            type: "microsoft",
            name: name ?? "",
            email: email ?? "",
            photoUrl: "",
            id: oid ?? "",
          ),
        );
      }
    } else {
      String? email = prefs.getString('microsoft_email') ?? "";
      String? name = prefs.getString('microsoft_name') ?? "";
      String? oid = prefs.getString('microsoft_oid') ?? "";
      if (email != "" || oid != "") {
        config.webUseRedirect = redirect;
        await oauth.login();
        var accessToken = await oauth.getAccessToken();
        if (accessToken != null) {
          prefs.setBool("isMicrosoftLoggedIn", !isMicrosoftLoggedIn);

          List<String> parts = accessToken.split(".");
          if (parts.length != 3) {
            throw Exception("Invalid token");
          }

          String payloadPart = parts[1];
          String normalizedPayload = base64Url.normalize(payloadPart);
          String payloadString =
              utf8.decode(base64Url.decode(normalizedPayload));

          Map<String, dynamic> payload = jsonDecode(payloadString);

          String? email = payload["email"];
          String? name = payload["name"];
          String? oid = payload["oid"];
          prefs.setString('microsoft_email', email ?? "");
          prefs.setString('microsoft_name', name ?? "");
          prefs.setString('microsoft_oid', oid ?? "");
          context.push(
            signingIn,
            extra: SigningInData(
              type: "microsoft",
              name: name ?? "",
              email: email ?? "",
              photoUrl: "",
              id: oid ?? "",
            ),
          );
        }
      } else {
        context.push(
          signingIn,
          extra: SigningInData(
            type: "microsoft",
            name: name,
            email: email,
            photoUrl: "",
            id: oid,
          ),
        );
      }
    }
  }

  void googleLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isGoogleLoggedIn = prefs.getBool("isGoogleLoggedIn") ?? false;
    if (!isGoogleLoggedIn) {
      var user = await LoginApi.loginWithGoogle();
      if (user != null) {
        prefs.setBool("isGoogleLoggedIn", !isGoogleLoggedIn);
        var name = user.displayName ?? "";
        var email = user.email;
        var photoUrl = user.photoUrl ?? "";
        var id = user.id;
        context.push(
          signingIn,
          extra: SigningInData(
            type: "google",
            name: name,
            email: email,
            photoUrl: photoUrl,
            id: id,
          ),
        );
      }
    } else {
      var email = prefs.getString('email') ?? "";
      var id = prefs.getString('id') ?? "";
      if (email != "" && id != "") {
        prefs.setBool("isGoogleLoggedIn", !isGoogleLoggedIn);
        prefs.setString('email', "");
        prefs.setString('id', "");
        context.push(
          signingIn,
          extra: SigningInData(
            type: "google",
            name: "",
            email: email,
            photoUrl: "",
            id: id,
          ),
        );
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
          context.push(
            signingIn,
            extra: SigningInData(
              type: "google",
              name: name,
              email: email,
              photoUrl: photoUrl,
              id: id,
            ),
          );
        }
      }
    }
  }
}

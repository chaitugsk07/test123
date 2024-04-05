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
import 'package:synopse/core/router.dart';
import 'package:synopse/features/02_login_screens/bloc/login_api.dart';

class SignUp111 extends StatelessWidget {
  const SignUp111({super.key});

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
    tenant: 'f8cdef31-a31e-4b4a-93e4-5f571e91255a',
    clientId: '7af8a350-0a81-4098-9364-ba89433ab2d8',
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
                          child: Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setGuestStatus();
                                  context.push(homeNo);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    "Skip",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                delay: 500.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Text(
                            "SYNOPSE",
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
                            "Feed your mind, Shape the future",
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
                                    "Login With Google",
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
                        if (1 == 2)
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
                                      "Login With Apple",
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
                        if (1 == 2)
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
                                    const SizedBox(
                                      width: 17,
                                    ),
                                    Text(
                                      "Login With Microsoft",
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
                          child: Container(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodySmall,
                                children: const [
                                  TextSpan(
                                      text: "By continuing you agree to our "),
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
        prefs.setBool("isGoogleLoggedIn", true);
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

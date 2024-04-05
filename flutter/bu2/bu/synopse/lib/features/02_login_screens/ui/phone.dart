import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/asset_gen/assets.gen.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/02_login_screens/bloc/login_api.dart';
import 'package:synopse/features/02_login_screens/bloc/send_otp/send_otp_bloc.dart';
import 'package:synopse/core/localization/language_constants.dart';

class MyPhones extends StatelessWidget {
  final String type;
  final String name;
  final String email;
  final String photoUrl;
  final String id;

  const MyPhones(
      {super.key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SendOTPBloc()),
      ],
      child: MyPhone(
        type: type,
        name: name,
        email: email,
        photoUrl: photoUrl,
        id: id,
      ),
    );
  }
}

class MyPhone extends StatefulWidget {
  final String type;
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  const MyPhone(
      {super.key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id,
      required this.type});

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    countryController.dispose();
    phoneNoController.dispose();
    super.dispose();
  }

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
  void signOut() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('isOnboardingSkip', false);
    prefs.setBool('isLoggedIn', false);
    prefs.setBool('isLoginSkipped', false);
    prefs.setString('loginToken', "");
    prefs.setString('account', "");
    prefs.setString('exp', "");
    if (prefs.getBool("isMicrosoftLoggedIn") ?? false) {
      await oauth.logout();
      prefs.setBool("isMicrosoftLoggedIn", false);
    }
    if (prefs.getBool("isGoogleLoggedIn") ?? false) {
      await LoginApi.signOut();
      prefs.setBool("isGoogleLoggedIn", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Animate(
                    effects: [
                      ScaleEffect(
                          delay: 1000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Center(
                      child: Assets.images.logo.image(width: 150, height: 150),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 1300.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Text(translation(context).login,
                        style: MyTypography.t1),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 1300.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Text(translation(context).login1,
                        style: MyTypography.s2, textAlign: TextAlign.center),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 2000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 10,
                            child: Text(
                              "+",
                              style: MyTypography.t12,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: TextFormField(
                              controller: countryController,
                              style: MyTypography.t12,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              cursorColor: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.8),
                              cursorHeight: 25,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {}); // rebuild the widget tree
                              },
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 33, color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {});
                              },
                              controller: phoneNoController,
                              textAlignVertical: TextAlignVertical.center,
                              style: MyTypography.t12,
                              keyboardType: TextInputType.phone,
                              cursorColor: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.8),
                              cursorHeight: 25,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: translation(context).phoneNumber,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (phoneNoController.text.length == 10)
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 2000.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: SizedBox(
                        width: 200,
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
                            context.push(
                              verifyEmail,
                              extra: VerifyRouteData(
                                type: widget.type,
                                name: widget.name,
                                email: widget.email,
                                photoUrl: widget.photoUrl,
                                id: widget.id,
                                country: int.parse(countryController.text),
                                phoneNo: int.parse(phoneNoController.text),
                              ),
                            );
                          },
                          child: Text(
                            translation(context).sendCode,
                            style: MyTypography.s2.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (phoneNoController.text.length != 10)
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 2000.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 45,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  30), // set the background color to blue
                            ),
                            child: Text(
                              translation(context).enterValidNo,
                              style: MyTypography.r1,
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
                          delay: 2000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: SizedBox(
                      width: 200,
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
                          signOut();
                          context.push(splash);
                        },
                        child: Text(
                          translation(context).backSignUp,
                          style: MyTypography.s2.copyWith(
                            fontSize: 15,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.8),
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
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    String pattern = r'^\d{10}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(phoneNumber);
  }
}

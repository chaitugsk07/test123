import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/asset_gen/assets.gen.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/features/02_login_screens/bloc/login_api.dart';
import 'package:synopse/features/02_login_screens/bloc/send_otp/send_otp_bloc.dart';

class MyPhones111 extends StatelessWidget {
  final String type;
  final String name;
  final String email;
  final String photoUrl;
  final String id;

  const MyPhones111(
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
  TextEditingController phoneNoController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    phoneNoController.dispose();
    super.dispose();
  }

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

  String countryCode = "";
  String phoneNumber = "";

  void signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isOnboardingSkip', true);
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
                    child: Text(
                      "Login/Register",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 25,
                              ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 1300.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Text(
                        "We need to register your credentials to get started!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {});
                      countryCode = number.dialCode!.substring(1);
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                      useBottomSheetSafeArea: true,
                    ),
                    spaceBetweenSelectorAndTextField: 0,
                    autoFocus: true,
                    autoFocusSearch: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone Number is required';
                      }
                      if (value.length < 10) {
                        return 'Phone Number must be 10 digit';
                      }
                      return null;
                    },
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    ignoreBlank: false,
                    initialValue: number,
                    textFieldController: phoneNoController,
                    formatInput: false,
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
                          onPressed: () {
                            context.push(
                              verifyEmail,
                              extra: VerifyRouteData(
                                type: widget.type,
                                name: widget.name,
                                email: widget.email,
                                photoUrl: widget.photoUrl,
                                id: widget.id,
                                country: int.parse(countryCode),
                                phoneNo: int.parse(phoneNoController.text),
                              ),
                            );
                          },
                          child: Text(
                            "send code",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 20,
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
                            child: Text(" ",
                                style: Theme.of(context).textTheme.bodyMedium),
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
                    child: ElevatedButton(
                      onPressed: () {
                        signOut();
                        context.push(splash);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Back to SignUp",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 15,
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

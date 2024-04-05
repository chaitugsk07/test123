import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';
import 'package:synopse/features/00_common_widgets/no_internet_sb.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/02_login_screens/bloc_send_otp/send_otp_bloc.dart';
import 'package:synopse/features/02_login_screens/bloc_signUp/signup_bloc.dart';
import 'package:synopse/features/02_login_screens/login_api.dart';

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
        BlocProvider(
          create: (context) => SignUpBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
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
    context.read<SignUpBloc>().add(GetSignUpFetch());
  }

  @override
  void dispose() {
    phoneNoController.dispose();
    super.dispose();
  }

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
      prefs.setBool("isMicrosoftLoggedIn", false);
    }
    if (prefs.getBool("isGoogleLoggedIn") ?? false) {
      await LoginApi.signOut();
      prefs.setBool("isGoogleLoggedIn", false);
    }
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
            return Container(
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
                                delay: 1000.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Center(
                            child: Image.asset(ImageConstant.imgLogo,
                                height: 150, width: 150),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 1300.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Text(
                            signUpState.signUp[0].login,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
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
                                delay: 1300.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Text(signUpState.signUp[0].register,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 1500.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              setState(() {});
                              countryCode = number.dialCode!.substring(1);
                            },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                              useBottomSheetSafeArea: true,
                            ),
                            spaceBetweenSelectorAndTextField: 0,
                            autoFocusSearch: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return signUpState.signUp[0].phnoReq;
                              }
                              if (value.length < 10) {
                                return signUpState.signUp[0].phno10Digits;
                              }
                              return null;
                            },
                            hintText: signUpState.signUp[0].phno,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            ignoreBlank: false,
                            initialValue: number,
                            textFieldController: phoneNoController,
                            formatInput: false,
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
                                onPressed: () {
                                  context.push(
                                    verifyEmail,
                                    extra: VerifyEmailRouteData(
                                      type: widget.type,
                                      name: widget.name,
                                      email: widget.email,
                                      photoUrl: widget.photoUrl,
                                      id: widget.id,
                                      country: int.parse(countryCode),
                                      phoneNo: int.parse(
                                        phoneNoController.text,
                                      ),
                                      anotherEmail:
                                          signUpState.signUp[0].another,
                                      anotherPhoneNo:
                                          signUpState.signUp[0].tryDiffAccount,
                                    ),
                                  );
                                },
                                child: Text(
                                  signUpState.signUp[0].code,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
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
                          child: ElevatedButton(
                            onPressed: () {
                              signOut();
                              context.push(splash);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                signUpState.signUp[0].backToSignup,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
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
            );
          }
          if (signUpState.status == SignUpStatus.failure) {
            return NoInternetSnackBar(context: context);
          } else {
            return const PageLoading();
          }
        }),
      ),
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    String pattern = r'^\d{10}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(phoneNumber);
  }
}

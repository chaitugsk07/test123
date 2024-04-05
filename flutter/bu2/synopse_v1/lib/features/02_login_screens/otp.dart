import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';
import 'package:synopse/features/00_common_widgets/no_internet_sb.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/02_login_screens/bloc_send_otp/send_otp_bloc.dart';
import 'package:synopse/features/02_login_screens/bloc_signUp/signup_bloc.dart';
import 'package:synopse/features/02_login_screens/bloc_verify_otp/verifiy_otp_bloc.dart';

class MyVerifyS extends StatelessWidget {
  final String type;
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  final int country;
  final int phoneNo;

  const MyVerifyS(
      {super.key,
      required this.type,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id,
      required this.country,
      required this.phoneNo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VerifyOTPBloc()),
        BlocProvider(create: (context) => SendOTPBloc()),
        BlocProvider(
          create: (context) => SignUpBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: MyVerify(
        type: type,
        name: name,
        email: email,
        photoUrl: photoUrl,
        id: id,
        country: country,
        phoneNo: phoneNo,
      ),
    );
  }
}

class MyVerify extends StatefulWidget {
  final String type;
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  final int country;
  final int phoneNo;

  const MyVerify(
      {super.key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id,
      required this.country,
      required this.phoneNo,
      required this.type});

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final int _totalSeconds = 60;
  int _secondsRemaining = 0;
  late int pin;
  bool verifyOTP = false;

  @override
  void initState() {
    sendOTP();
    super.initState();
    _secondsRemaining = _totalSeconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalSeconds),
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          _secondsRemaining = (_animation.value * _totalSeconds).ceil();
        });
      });
    _controller.forward();
    context.read<SignUpBloc>().add(GetSignUpFetch());
  }

  void sendOTP() {
    context.read<SendOTPBloc>().add(SendOTPForValidPhNo(
        country: widget.country.toString(),
        phoneno: widget.phoneNo.toString()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

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
            return BlocBuilder<SendOTPBloc, SendOTPState>(
              builder: (context, sendOTPState) {
                if (sendOTPState.status == SendOTPStatus.loading) {
                  return const Scaffold(
                    body: PageLoading(),
                  );
                } else if (sendOTPState.status == SendOTPStatus.failure) {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.push(splash);
                  }
                  return Container();
                } else if (sendOTPState.status == SendOTPStatus.success) {
                  return Scaffold(
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: Animate(
                        effects: [
                          FadeEffect(
                              delay: 100.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: IconButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.push(splash);
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                          ),
                        ),
                      ),
                      elevation: 0,
                    ),
                    body: Container(
                      margin: const EdgeInsets.only(left: 25, right: 25),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    delay: 300.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: Container(
                                alignment: Alignment.center,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    children: [
                                      TextSpan(
                                          text: signUpState.signUp[0].verify),
                                      TextSpan(
                                        text:
                                            "\n +${widget.country} ${widget.phoneNo}",
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 300.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: Text(
                                signUpState.signUp[0].otpEnter,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 500.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: Pinput(
                                length: 6,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                submittedPinTheme: submittedPinTheme,
                                showCursor: true,
                                onCompleted: (value) {
                                  setState(() {
                                    verifyOTP = true;
                                    pin = int.parse(value);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (verifyOTP == true)
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 600.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (widget.type == "google") {
                                        context.push(
                                          pVerifyOTP,
                                          extra: VerifyOTPData(
                                            type: widget.type,
                                            country: widget.country.toString(),
                                            phoneno: widget.phoneNo.toString(),
                                            otp: pin,
                                            name: widget.name,
                                            googleEmail: widget.email,
                                            googleId: widget.id,
                                            googlePhotoUrl: widget.photoUrl,
                                            googlePhotoValid:
                                                widget.photoUrl == "na" ? 0 : 1,
                                            microsoftEmail: "",
                                            microsoftId: "",
                                            microsoftName: "",
                                          ),
                                        );
                                      } else if (widget.type == "microsoft") {
                                        context.push(
                                          pVerifyOTP,
                                          extra: VerifyOTPData(
                                            type: widget.type,
                                            country: widget.country.toString(),
                                            phoneno: widget.phoneNo.toString(),
                                            otp: pin,
                                            name: widget.name,
                                            googleEmail: "",
                                            googleId: "",
                                            googlePhotoUrl: "",
                                            googlePhotoValid: 0,
                                            microsoftEmail: widget.email,
                                            microsoftId: widget.id,
                                            microsoftName: widget.name,
                                          ),
                                        );
                                      } else {
                                        context.push(
                                          pVerifyOTP,
                                          extra: VerifyOTPData(
                                            type: widget.type,
                                            country: widget.country.toString(),
                                            phoneno: widget.phoneNo.toString(),
                                            otp: pin,
                                            name: widget.name,
                                            googleEmail: "",
                                            googleId: "",
                                            googlePhotoUrl: "",
                                            googlePhotoValid: 0,
                                            microsoftEmail: "",
                                            microsoftId: "",
                                            microsoftName: "",
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      signUpState.signUp[0].otpVerify,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                              ),
                            if (verifyOTP == false)
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 600.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: Text(
                                    " ",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                              child: Center(
                                child: SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (context.canPop()) {
                                        context.pop();
                                      } else {
                                        context.push(splash);
                                      }
                                    },
                                    child: Text(
                                      signUpState.signUp[0].editPhNo,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (_secondsRemaining > 0)
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 1000.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Text(
                                  "${signUpState.signUp[0].resendOtpin} $_secondsRemaining ${signUpState.signUp[0].seconds}.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            if (_secondsRemaining == 0)
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 1000.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<SendOTPBloc>().add(
                                        SendOTPForValidPhNo(
                                            country: widget.country.toString(),
                                            phoneno:
                                                widget.phoneNo.toString()));
                                    _controller.reset();
                                    _controller.forward();
                                  },
                                  child: Text(
                                    signUpState.signUp[0].otpResend,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 2000.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
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
                                                "${signUpState.signUp[0].standard}\n"),
                                        TextSpan(
                                            text: signUpState.signUp[0].tos1),
                                        TextSpan(
                                          text: signUpState.signUp[0].tos2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                  fontWeight: FontWeight.w600),
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
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Something went wrong"),
                    ),
                  );
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.push(splash);
                  }
                  return const Scaffold(
                    body: PageLoading(),
                  );
                }
              },
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
}

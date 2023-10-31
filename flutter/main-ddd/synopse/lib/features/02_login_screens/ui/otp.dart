import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:synopse/core/asset_gen/assets.gen.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/02_login_screens/bloc/send_otp/send_otp_bloc.dart';
import 'package:synopse/features/02_login_screens/bloc/verify_otp/verifiy_otp_bloc.dart';

class MyVerifyS extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  final String country;
  final int phoneNo;

  const MyVerifyS(
      {super.key,
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
      ],
      child: MyVerify(
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
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  final String country;
  final int phoneNo;

  const MyVerify(
      {super.key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id,
      required this.country,
      required this.phoneNo});

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
    context.read<SendOTPBloc>().add(SendOTPForValidPhNo(
        country: widget.country, phoneno: widget.phoneNo.toString()));
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

    return BlocBuilder<SendOTPBloc, SendOTPState>(
      builder: (context, sendOTPState) {
        print(sendOTPState.status);
        if (sendOTPState.status == SendOTPStatus.loading) {
          return const Scaffold(
            body: PageLoading(),
          );
        } else if (sendOTPState.status == SendOTPStatus.failure) {
          return Container();
        } else if (sendOTPState.status == SendOTPStatus.success) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: Animate(
                effects: [
                  FadeEffect(
                      delay: 100.milliseconds, duration: 1000.milliseconds)
                ],
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                        FadeEffect(
                            delay: 100.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Center(
                          child: Assets.images.logo
                              .image(width: 150, height: 150)),
                    ),
                    const SizedBox(
                      height: 25,
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
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontSize: 20,
                                ),
                            children: [
                              const TextSpan(text: "OTP Verification \n"),
                              TextSpan(
                                text: "${widget.country} ${widget.phoneNo}",
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 18),
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
                        "Enter your confirmation code",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
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
                              // Add this code where you want to navigate to the splash screen
                              final bloc = context.read<VerifyOTPBloc>();

                              bloc.add(
                                VerifyOTPForValidPhNo(
                                    country: widget.country,
                                    phoneno: widget.phoneNo,
                                    otp: pin,
                                    name: widget.name,
                                    googleEmail: widget.email,
                                    googleId: widget.id,
                                    googlePhotoUrl: widget.photoUrl,
                                    googlePhotoValid:
                                        widget.photoUrl == "na" ? 0 : 1),
                              );
                              // Listen to the state changes of the bloc
                              bloc.stream.listen((state) {
                                if (state.status == VerifyOTPStatus.success) {
                                  context.push(home);
                                } else if (state.status ==
                                    VerifyOTPStatus.failure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Something went wrong, try again"),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Text(
                              "Verify OTP",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontFamily: 'Roboto Condensed',
                                      fontSize: 15),
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
                            "Enter OTP Code",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontFamily: 'Roboto Condensed',
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 800.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: TextButton(
                            onPressed: () {
                              context.go(phone);
                            },
                            child: Text(
                              "Edit Phone Number ?",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
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
                        child: Text("Resend OTP in $_secondsRemaining seconds",
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    if (_secondsRemaining == 0)
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 1000.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: TextButton(
                          onPressed: () {
                            context.read<SendOTPBloc>().add(SendOTPForValidPhNo(
                                country: widget.country,
                                phoneno: widget.phoneNo.toString()));
                            _controller.reset();
                            _controller.forward();
                          },
                          child: Text(
                            "Resend OTP",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontFamily: 'Roboto Condensed'),
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
                      child: Container(
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                    ),
                            children: const [
                              TextSpan(text: "Need Help? "),
                              TextSpan(
                                text: "support@synopse.news ",
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(
                                  text:
                                      "\nStandard rates apply. By continuing you agree to our "),
                              TextSpan(
                                text: "Terms of Service.",
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(text: " For more information, see our "),
                              TextSpan(
                                text: "Privacy Notice",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
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
          Navigator.pop(context);
          return const Scaffold(
            body: PageLoading(),
          );
        }
      },
    );
  }
}

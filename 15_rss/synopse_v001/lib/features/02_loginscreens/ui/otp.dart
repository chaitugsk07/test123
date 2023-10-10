import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:synopse_v001/core/asset_gen/assets.gen.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/02_loginscreens/bloc/send_otp/send_otp_bloc.dart';
import 'package:synopse_v001/features/02_loginscreens/bloc/verify_otp/verifiy_otp_bloc.dart';

class MyVerify extends StatefulWidget {
  final int phoneNo;

  const MyVerify({super.key, required this.phoneNo});
  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify>
    with SingleTickerProviderStateMixin {
  int get _phoneNo => widget.phoneNo;
  late AnimationController _controller;
  late Animation<double> _animation;
  final int _totalSeconds = 60;
  int _secondsRemaining = 0;
  late int pin;
  bool verifyOTP = false;

  @override
  void initState() {
    context.read<SendOTPBloc>().add(SendOTPForValidPhNo(phoneNumber: _phoneNo));
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
        if (sendOTPState.status == SendOTPStatus.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (sendOTPState.status == SendOTPStatus.failure) {
          Navigator.pop(context);
          return Container();
        } else if (sendOTPState.status == SendOTPStatus.success) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
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
                    Assets.images.logo.image(width: 100, height: 100),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Phone Verification: " + _phoneNo.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Roboto Condensed',
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "We need to register your phone without getting started!",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Roboto Condensed',
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Pinput(
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
                    const SizedBox(
                      height: 20,
                    ),
                    if (verifyOTP == true)
                      SizedBox(
                        width: 200,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.5),
                          ),
                          onPressed: () {
                            // Add this code where you want to navigate to the splash screen
                            final bloc = context.read<VerifyOTPBloc>();
                            bloc.add(VerifyOTPForValidPhNo(
                                phoneNumber: _phoneNo, otp: pin));

// Listen to the state changes of the bloc
                            bloc.stream.listen((state) {
                              print(state.status);
                              if (state.status == VerifyOTPStatus.success) {
                                context.go(home);
                              } else if (state.status ==
                                  VerifyOTPStatus.failure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Something went wrong, try again"),
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
                    if (verifyOTP == false)
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: Text(
                          "Enter OTP Code",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontFamily: 'Roboto Condensed',
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.go(login);
                          },
                          child: Text(
                            "Edit Phone Number ?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontFamily: 'Roboto Condensed',
                                ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_secondsRemaining > 0)
                      Text(
                        "Resend OTP in $_secondsRemaining seconds",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: 'Roboto Condensed',
                            ),
                      ),
                    if (_secondsRemaining == 0)
                      TextButton(
                        onPressed: () {
                          context
                              .read<SendOTPBloc>()
                              .add(SendOTPForValidPhNo(phoneNumber: _phoneNo));
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
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

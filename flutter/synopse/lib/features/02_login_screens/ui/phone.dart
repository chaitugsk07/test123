import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/00_common_widgets/Main_ani.dart';
import 'package:synopse/features/02_login_screens/bloc/send_otp/send_otp_bloc.dart';

class MyPhones extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final String id;

  const MyPhones(
      {super.key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SendOTPBloc()),
      ],
      child: MyPhone(
        name: name,
        email: email,
        photoUrl: photoUrl,
        id: id,
      ),
    );
  }
}

class MyPhone extends StatefulWidget {
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  const MyPhone(
      {Key? key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id})
      : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  @override
  void initState() {
    countryController.text = "91";
    phoneNoController.text = "9652007006";
    super.initState();
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
                  const MainAni(),
                  const SizedBox(
                    height: 10,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 1300.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Text("Login/Register",
                        style: Theme.of(context).textTheme.titleLarge),
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
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
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
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: TextFormField(
                              controller: countryController,
                              keyboardType: TextInputType.number,
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
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone Number",
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
                              verify,
                              extra: VerifyRouteData(
                                name: widget.name,
                                email: widget.email,
                                photoUrl: widget.photoUrl,
                                id: widget.id,
                                country: "+${countryController.text}",
                                phoneNo: int.parse(phoneNoController.text),
                              ),
                            );
                          },
                          child: Text(
                            "send code",
                            style: Theme.of(context).textTheme.titleSmall,
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
                              "enter valid phone number",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.red, fontSize: 15),
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
                          context.push(signUp);
                        },
                        child: Text(
                          "Back to SignUp",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 2000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Container(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 10,
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

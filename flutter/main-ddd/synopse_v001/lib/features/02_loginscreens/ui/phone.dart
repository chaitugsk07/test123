import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse_v001/core/asset_gen/assets.gen.dart';
import 'package:synopse_v001/core/theme/bloc/theme_bloc.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/core/theme/app_themes.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/flip_icons.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

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
                  Row(
                    children: [
                      const Spacer(
                        flex: 1,
                      ),
                      Animate(
                        effects: [
                          SlideEffect(
                            begin: const Offset(-3, 0),
                            end: const Offset(0, 0),
                            delay: 10000.microseconds,
                            duration: 200.milliseconds,
                            curve: Curves.easeInOutCubic,
                          ),
                        ],
                        onPlay: (controller) {
                          Future.delayed(const Duration(seconds: 15), () {
                            controller.reset();
                            controller.forward();
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 10,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const Spacer(
                        flex: 4,
                      ),
                      Animate(
                        effects: [
                          SlideEffect(
                            begin: const Offset(-10, 0),
                            end: const Offset(0, 0),
                            delay: 10000.microseconds,
                            duration: 800.milliseconds,
                            curve: Curves.easeInOutCubic,
                          ),
                        ],
                        onPlay: (controller) {
                          Future.delayed(const Duration(seconds: 15), () {
                            controller.reset();
                            controller.forward();
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 10,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Spacer(
                        flex: 3,
                      ),
                      FlipIcons(
                        containerColor: Colors.deepPurpleAccent,
                        faIcon: FontAwesomeIcons.newspaper,
                        size: 40,
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 85,
                                ),
                                FlipIcons(
                                  containerColor:
                                      Colors.deepOrangeAccent.withOpacity(0.8),
                                  faIcon: FontAwesomeIcons.hashtag,
                                  size: 40,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
                                FlipIcons(
                                  containerColor:
                                      Colors.deepOrangeAccent.withOpacity(0.9),
                                  faIcon: FontAwesomeIcons.at,
                                  size: 40,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                FlipIcons(
                                  containerColor:
                                      Colors.deepPurpleAccent.withOpacity(0.7),
                                  faIcon: FontAwesomeIcons.share,
                                  size: 40,
                                ),
                                const SizedBox(
                                  width: 45,
                                ),
                                FlipIcons(
                                  containerColor:
                                      Colors.deepPurpleAccent.withOpacity(0.6),
                                  faIcon: FontAwesomeIcons.addressBook,
                                  size: 40,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Animate(
                              effects: [FadeEffect(delay: 1000.milliseconds)],
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            fontSize: 30, color: Colors.teal),
                                    children: [
                                      const TextSpan(text: "Unbiased News \n"),
                                      TextSpan(
                                        text: "NUGGETS",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.teal.shade700),
                                      ),
                                    ],
                                  ),
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
                                .image(width: 150, height: 150)),
                      ),
                    ],
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 1000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Text(
                      "SYNOPSE",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: 'Cabin Condensed',
                            fontSize: 55,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 7,
                          ),
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 1000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                          children: const [
                            TextSpan(text: "Better With \n"),
                            TextSpan(
                              text: "Friends",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900,
                              ),
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
                            context.push(verify,
                                extra: int.parse(countryController.text +
                                    phoneNoController.text));
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
                    height: 10,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 2000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: SizedBox(
                      child: GestureDetector(
                          child: Container(
                            width: 100,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "skip for now",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isLoginSkipped', true);

                            context.push(splash);
                          }),
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
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    String pattern = r'^\d{10}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(phoneNumber);
  }
}

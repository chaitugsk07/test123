import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyUserLevel1 extends StatelessWidget {
  const MyUserLevel1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyUserLevel();
  }
}

class MyUserLevel extends StatefulWidget {
  const MyUserLevel({super.key});

  @override
  State<MyUserLevel> createState() => _MyUserLevelState();
}

class _MyUserLevelState extends State<MyUserLevel> {
  late String account;
  late int userLevel1;
  late String userName;
  late String levelName;
  late int reputationPoints;
  late int requiredPoints;
  late String memberSince;

  @override
  void initState() {
    super.initState();
    account = '';
    userLevel1 = 0;
    userName = '';
    levelName = '';
    reputationPoints = 0;
    requiredPoints = 0;
    memberSince = '';
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        account = prefs.getString('account') ?? '';
        userLevel1 = prefs.getInt('userLevel') ?? 0;
        userName = prefs.getString('userName') ?? '';
        levelName = prefs.getString('userLevelName') ?? '';
        reputationPoints = prefs.getInt('userLevelReputationPoints') ?? 0;
        requiredPoints = prefs.getInt('userLevelRequiredPoints') ?? 0;
        memberSince = prefs.getString('userLevelMemberSince') ?? '';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Animate(
          effects: const [
            FadeEffect(
              duration: Duration(milliseconds: 1000),
              delay: Duration(milliseconds: 400),
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 500,
            ),
            child: Builder(builder: (context) {
              double screenWidth = MediaQuery.of(context).size.width;
              double containerWidth =
                  math.max(300, math.min(screenWidth, 500)) - 70;
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      children: [
                        Animate(
                          effects: const [
                            FadeEffect(
                              duration: Duration(milliseconds: 1000),
                              delay: Duration(milliseconds: 500),
                            ),
                          ],
                          child: const Icon(
                            Icons.keyboard_double_arrow_up_outlined,
                            size: 20,
                          ),
                        ),
                        Animate(
                          effects: const [
                            FadeEffect(
                              duration: Duration(milliseconds: 1000),
                              delay: Duration(milliseconds: 700),
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              levelName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Animate(
                          effects: const [
                            FadeEffect(
                              duration: Duration(milliseconds: 1000),
                              delay: Duration(milliseconds: 700),
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "$reputationPoints reputation",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Animate(
                    effects: const [
                      FadeEffect(
                        duration: Duration(milliseconds: 1000),
                        delay: Duration(milliseconds: 900),
                      ),
                    ],
                    child: Container(
                      height: 7,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: (requiredPoints / 100) * containerWidth,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 252, 165, 124),
                                    Color.fromARGB(255, 114, 170, 220),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Animate(
                    effects: const [
                      FadeEffect(
                        duration: Duration(milliseconds: 1000),
                        delay: Duration(milliseconds: 900),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        '${requiredPoints - reputationPoints} points required for next level ${userLevel1 + 1}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

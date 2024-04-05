import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/asset_gen/assets.gen.dart';
import 'package:synopse/core/router.dart';

class UserLevelCard extends StatefulWidget {
  const UserLevelCard({super.key});

  @override
  State<UserLevelCard> createState() => _UserLevelCardState();
}

class _UserLevelCardState extends State<UserLevelCard> {
  late String account;
  late String levelName;
  late int levelNo;
  late int userReputation;
  late int requiredPoints;
  late String memberSince;
  late String userName;
  Offset _offset = const Offset(0, 0);
  @override
  void initState() {
    super.initState();
    account = '';
    levelName = '';
    levelNo = 0;
    userReputation = 0;
    requiredPoints = 0;
    memberSince = '';
    userName = '';
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(
      () {
        account = prefs.getString('account') ?? '';
        levelName = prefs.getString('userLevelName') ?? '';
        levelNo = prefs.getInt('userLevel') ?? 0;
        userReputation = prefs.getInt('userLevelReputationPoints') ?? 0;
        requiredPoints = prefs.getInt('userLevelRequiredPoints') ?? 0;
        memberSince = prefs.getString('userLevelMemberSince') ?? '';
        userName = prefs.getString('userName') ?? '';
      },
    );
  }

  Future<void> share(String username, String account) async {
    final result = await Share.shareWithResult(
        'Checkout my Synopse profile $username \n https://synopse-ai.web.app/de/$account'
        '\n -via Synopse AI');

    if (result.status == ShareResultStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "The user is shared successfully",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(home);
              }
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text("User Card"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              width: 500,
              child: Center(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _offset += details.delta;
                    });
                  },
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.01 * _offset.dy)
                      ..rotateY(-0.01 * _offset.dx),
                    alignment: Alignment.center,
                    child: Container(
                      width: 300,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey[500]!,
                            Colors.grey[600]!,
                            Colors.grey[700]!,
                            Colors.grey[800]!,
                          ],
                          stops: const [0.1, 0.3, 0.7, 0.9],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300]!.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 1),
                          ),
                          BoxShadow(
                            color: Colors.grey[500]!.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.grey[700]!.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                          BoxShadow(
                            color: Colors.grey[900]!.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text("Synopse",
                                style:
                                    Theme.of(context).textTheme.displaySmall),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              userName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              "Member Since: $memberSince",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          const Spacer(),
                          Animate(
                            effects: [
                              ScaleEffect(
                                  delay: 1000.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                  child: Assets.images.logo
                                      .image(width: 60, height: 60)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                levelName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$requiredPoints more points required untill you reach next level",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Animate(
              effects: [
                FadeEffect(delay: 600.milliseconds, duration: 1000.milliseconds)
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      share(userName, account);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Share",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Animate(
              effects: [
                FadeEffect(delay: 600.milliseconds, duration: 1000.milliseconds)
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(viewLevel);
                    },
                    child: Text(
                      "View Levels",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

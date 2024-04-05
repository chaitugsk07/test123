import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/router.dart';

import 'onboarding_widgets/onboarding_contents.dart';

class OnboardingScreen111 extends StatefulWidget {
  const OnboardingScreen111({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen111> createState() => _OnboardingScreen111State();
}

class _OnboardingScreen111State extends State<OnboardingScreen111> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  Future<void> setOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingSkip', true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 300.milliseconds,
                                  duration: 1000.milliseconds,
                                  curve: Curves.easeInOutCirc),
                            ],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Image(
                                  image: AssetImage(contents[i].image),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 500.milliseconds,
                                  duration: 1000.milliseconds,
                                  curve: Curves.easeInOutCirc),
                            ],
                            child: Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 600.milliseconds,
                                  duration: 1000.milliseconds,
                                  curve: Curves.easeInOutCirc),
                            ],
                            child: Text(
                              contents[i].desc,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                  _currentPage + 1 == contents.length
                      ? Padding(
                          padding: const EdgeInsets.all(30),
                          child: Animate(
                            effects: [
                              FadeEffect(
                                  delay: 500.milliseconds,
                                  duration: 1000.milliseconds,
                                  curve: Curves.easeInOutCirc),
                            ],
                            child: ElevatedButton(
                              onPressed: () {
                                setOnboardingStatus();
                                context.push(splash);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Get Started",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 1000.milliseconds,
                                      duration: 1000.milliseconds,
                                      curve: Curves.easeInOutCirc),
                                ],
                                child: GestureDetector(
                                  onTap: () {
                                    setOnboardingStatus();
                                    context.push(splash);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Skip",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 500.milliseconds,
                                      duration: 1000.milliseconds,
                                      curve: Curves.easeInOutCirc),
                                ],
                                child: ElevatedButton(
                                  onPressed: () {
                                    _controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  child: Text(
                                    "Next",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

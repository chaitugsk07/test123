import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synopse/core/asset_gen/assets.gen.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/features/00_common_widgets/flip_icons.dart';

class MainAni extends StatelessWidget {
  const MainAni({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Row(
          children: [
            const Spacer(
              flex: 3,
            ),
            FlipIcons(
              containerColor: const Color(0xFF01dcc4).withOpacity(0.8),
              faIcon: FontAwesomeIcons.newspaper,
              size: 40,
            ),
            const Spacer(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 85,
                      ),
                      FlipIcons(
                        containerColor:
                            const Color(0xFF282650).withOpacity(0.8),
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
                            const Color(0xFF01dcc4).withOpacity(0.8),
                        faIcon: FontAwesomeIcons.at,
                        size: 40,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      FlipIcons(
                        containerColor:
                            const Color(0xFF262851).withOpacity(0.8),
                        faIcon: FontAwesomeIcons.share,
                        size: 40,
                      ),
                      const SizedBox(
                        width: 45,
                      ),
                      FlipIcons(
                        containerColor:
                            const Color(0xFF01dcc4).withOpacity(0.8),
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
                    effects: [
                      FadeEffect(
                          delay: 1000.milliseconds, duration: 2000.milliseconds)
                    ],
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Unbiased News Nuggets",
                        style: MyTypography.s2.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.8),
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
                    delay: 500.milliseconds, duration: 3000.milliseconds),
                ShakeEffect(
                    delay: 3000.milliseconds,
                    duration: 1000.milliseconds,
                    curve: Curves.easeInOutCubic),
              ],
              onPlay: (controller1) {
                Future.delayed(const Duration(seconds: 3), () {
                  controller1.reset();
                  controller1.forward();
                });
              },
              child: Center(
                  child: Assets.images.logo.image(width: 150, height: 150)),
            ),
          ],
        ),
      ],
    );
  }
}

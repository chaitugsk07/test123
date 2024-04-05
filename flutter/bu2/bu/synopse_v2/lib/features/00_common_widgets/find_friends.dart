import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synopse/core/asset_gen/assets.gen.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/features/00_common_widgets/flip_icons.dart';

class FindFriends extends StatefulWidget {
  const FindFriends({super.key});

  @override
  State<FindFriends> createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Animate(
        effects: [
          FadeEffect(delay: 300.milliseconds, duration: 1000.milliseconds)
        ],
        child: Column(
          children: [
            Animate(
              effects: [
                FadeEffect(delay: 500.milliseconds, duration: 1000.milliseconds)
              ],
              child: const Divider(
                color: Colors.grey,
                thickness: 0.7,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
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
                                    containerColor: Colors.deepOrangeAccent
                                        .withOpacity(0.8),
                                    faIcon: FontAwesomeIcons.hashtag,
                                    size: 30,
                                  ),
                                  const Spacer(),
                                  const FlipIcons(
                                    containerColor: Colors.deepPurpleAccent,
                                    faIcon: FontAwesomeIcons.newspaper,
                                    size: 30,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Row(
                                children: [
                                  FlipIcons(
                                    containerColor: Colors.deepOrangeAccent
                                        .withOpacity(0.9),
                                    faIcon: FontAwesomeIcons.at,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  FlipIcons(
                                    containerColor: Colors.deepPurpleAccent
                                        .withOpacity(0.7),
                                    faIcon: FontAwesomeIcons.share,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 35,
                                  ),
                                  FlipIcons(
                                    containerColor: Colors.deepPurpleAccent
                                        .withOpacity(0.6),
                                    faIcon: FontAwesomeIcons.addressBook,
                                    size: 30,
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
                                      style: MyTypography.titleLarge.copyWith(
                                          fontSize: 30, color: Colors.teal),
                                      children: [
                                        const TextSpan(
                                            text: "Find & Follow Your "),
                                        TextSpan(
                                          text: "Friends",
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
                                .image(width: 150, height: 150),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 500.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Text(
                        "See posts and comments from people you know.",
                        style: MyTypography.titleMedium.copyWith(fontSize: 15),
                      ),
                    ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 400.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Text(
                        "Synopse is more fun with friends",
                        style: MyTypography.titleMedium.copyWith(fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          onPressed: () {},
                          child: Text(
                            "Find Friends",
                            style: MyTypography.t12.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.8)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

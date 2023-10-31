import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:synopse_v001/core/utils/router.dart';

class FeedBottomNavigationMenu extends StatelessWidget {
  final bool isLoggedIn;
  final int iconPos;
  const FeedBottomNavigationMenu({
    Key? key,
    required this.isLoggedIn,
    required this.iconPos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        SlideEffect(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
          delay: 100.microseconds,
          duration: 1000.milliseconds,
          curve: Curves.easeInOutCubic,
        ),
      ],
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade700,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: iconPos,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(home);
                break;
              case 1:
                // handle onPressed for second icon
                break;
              case 2:
                context.go(page);
                break;
              case 3:
                // handle onPressed for fourth icon
                break;
              case 4:
                context.go(userMain);
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Animate(
                effects: [
                  FadeEffect(
                      delay: 200.milliseconds, duration: 1000.milliseconds)
                ],
                child: const FaIcon(
                  FontAwesomeIcons.house,
                  size: 15,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Animate(
                effects: [
                  FadeEffect(
                      delay: 300.milliseconds, duration: 1000.milliseconds)
                ],
                child: const FaIcon(
                  FontAwesomeIcons.seedling,
                  size: 15,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Animate(
                effects: [
                  FadeEffect(
                      delay: 300.milliseconds, duration: 1000.milliseconds)
                ],
                child: const FaIcon(
                  FontAwesomeIcons.textSlash,
                  size: 15,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Animate(
                effects: [
                  FadeEffect(
                      delay: 400.milliseconds, duration: 1000.milliseconds)
                ],
                child: const FaIcon(
                  FontAwesomeIcons.video,
                  size: 15,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Animate(
                effects: [
                  FadeEffect(
                      delay: 500.milliseconds, duration: 1000.milliseconds)
                ],
                child: const FaIcon(
                  FontAwesomeIcons.userSecret,
                  size: 15,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

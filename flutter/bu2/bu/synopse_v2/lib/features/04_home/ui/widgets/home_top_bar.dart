import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(
          duration: Duration(milliseconds: 500),
          delay: Duration(milliseconds: 300),
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.push(search1);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 20,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.8),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'search',
                            style: MyTypography.s2.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6),
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 500),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.only(left: 2, top: 8),
                  child: IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      context.push(notification);
                    },
                  ),
                ),
              ),
              Animate(
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 600),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.only(left: 2, top: 8),
                  child: IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      context.push(userMain);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

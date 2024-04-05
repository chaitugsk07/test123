import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:synopse/core/theme/typography.dart';

class ArticleTags extends StatelessWidget {
  final List<dynamic> tags;
  final String title;
  const ArticleTags({super.key, required this.tags, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Animate(
          effects: [
            FadeEffect(delay: 600.milliseconds, duration: 1000.milliseconds)
          ],
          child: Divider(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            thickness: 0.4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: MyTypography.t12.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: List<Widget>.generate(
            tags.length,
            (int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        tags[index],
                        style: MyTypography.t12.copyWith(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

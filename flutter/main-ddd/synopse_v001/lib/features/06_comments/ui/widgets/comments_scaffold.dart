import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SAppBar({super.key, required this.title});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Animate(
        effects: [
          FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
        ],
        child: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      title: Center(
        child: Animate(
          effects: [
            FadeEffect(delay: 200.milliseconds, duration: 1000.milliseconds)
          ],
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
          ),
        ),
      ),
      actions: [
        Animate(
          effects: [
            FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
          ],
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.info_rounded,
            ),
          ),
        ),
      ],
    );
  }
}

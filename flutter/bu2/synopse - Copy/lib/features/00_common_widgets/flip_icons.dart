import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlipIcons extends StatelessWidget {
  final Color containerColor;
  final IconData faIcon;
  final double size;

  const FlipIcons(
      {super.key,
      required this.containerColor,
      required this.faIcon,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FlipEffect(
          duration: 800.milliseconds,
          curve: Curves.bounceInOut,
        )
      ],
      onPlay: (controller1) {
        Future.delayed(const Duration(seconds: 3), () {
          controller1.reset();
          controller1.forward();
        });
      },
      child: Container(
        height: size,
        width: size,
        color: containerColor,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: FaIcon(
            faIcon,
            size: size - 10,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
    );
  }
}

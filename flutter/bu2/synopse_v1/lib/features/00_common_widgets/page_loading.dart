import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:synopse/core/utils/image_constant.dart';

class PageLoading extends StatelessWidget {
  const PageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Animate(
          autoPlay: true,
          onComplete: (controller) {
            controller.reverse();
            controller.loop();
          },
          effects: [
            ScaleEffect(delay: 100.milliseconds, duration: 3000.milliseconds),
            RotateEffect(
                delay: 4000.milliseconds,
                duration: 3000.milliseconds,
                curve: Curves.easeInOut),
          ],
          child: Image.asset(ImageConstant.imgLogo),
        ),
      ),
    );
  }
}

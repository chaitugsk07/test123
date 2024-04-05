import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';

class PageLoading extends StatefulWidget {
  final String title;

  const PageLoading({super.key, required this.title});
  @override
  State<PageLoading> createState() => _PageLoadingState();
}

class _PageLoadingState extends State<PageLoading> {
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final endTime = DateTime.now();
      final difference = endTime.difference(_startTime);
      FirebaseAnalytics.instance.logEvent(
        name: 'pageLoading',
        parameters: {
          'page': widget.title,
          'duration': difference.inMilliseconds,
        },
      );
      if (difference > 10.seconds) {
        context.push(splash);
      }
    });
  }

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

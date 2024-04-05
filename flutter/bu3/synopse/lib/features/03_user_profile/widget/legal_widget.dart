import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LegalWidget extends StatelessWidget {
  const LegalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        SlideEffect(
          begin: Offset(0, 1),
          end: Offset(0, 0),
          duration: Duration(milliseconds: 500),
          delay: Duration(milliseconds: 100),
          curve: Curves.easeInOutCubic,
        ),
      ],
      child: AlertDialog(
        alignment: Alignment.bottomCenter,
        content: SizedBox(
          height: 145,
          width: MediaQuery.of(context).size.width - 50,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                    child: FaIcon(
                      FontAwesomeIcons.circleInfo,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ),
                  Text("Terms of Service",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                    child: FaIcon(
                      FontAwesomeIcons.shield,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ),
                  Text("Privacy",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                    child: FaIcon(
                      FontAwesomeIcons.wandMagic,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ),
                  Text("Community Rules",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

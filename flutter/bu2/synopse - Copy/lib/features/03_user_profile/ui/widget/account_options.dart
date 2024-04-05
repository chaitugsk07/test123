import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountOptions extends StatelessWidget {
  const AccountOptions({super.key});

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
          height: 100,
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
                      FontAwesomeIcons.userXmark,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  Text("Deactivate Account",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                    child: FaIcon(
                      FontAwesomeIcons.circleXmark,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  Text("Delete Account",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

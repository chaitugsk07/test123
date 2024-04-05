import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/features/03_user_profile/ui/widget/feedback_box.dart';

class FeedbackWidget extends StatelessWidget {
  const FeedbackWidget({super.key});

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
          height: 385,
          width: MediaQuery.of(context).size.width - 50,
          child: Animate(
            effects: [
              FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
            ],
            child: Column(
              children: [
                Text("How can we Help?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const FeedbackBox(
                          type: 'Report Bug',
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey, // Set border color
                            width: 2.0, // Set border width
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: FaIcon(
                            FontAwesomeIcons.bug,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Report Bug",
                                  textAlign: TextAlign.start,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "let us know about the specific issue you are facing.",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Colors.grey,
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
                Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5),
                  thickness: 0.7,
                ),
                GestureDetector(
                  onTap: () {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const FeedbackBox(
                          type: 'Share Feedback',
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey, // Set border color
                            width: 2.0, // Set border width
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: FaIcon(
                            FontAwesomeIcons.envelope,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Share Feedback",
                                  textAlign: TextAlign.start,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "let us know how to improve by providing some feedback.",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Colors.grey,
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
                Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5),
                  thickness: 0.7,
                ),
                GestureDetector(
                  onTap: () {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const FeedbackBox(
                          type: 'Something Else',
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey, // Set border color
                            width: 2.0, // Set border width
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: FaIcon(
                            FontAwesomeIcons.bolt,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Something Else",
                                  textAlign: TextAlign.start,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Request new features or ask for help with something else.",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Colors.grey,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

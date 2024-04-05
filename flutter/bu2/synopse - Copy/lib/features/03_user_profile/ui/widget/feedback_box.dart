import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';

class FeedbackBox extends StatelessWidget {
  final String type;

  const FeedbackBox({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserEventBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: Feedback(
        type: type,
      ),
    );
  }
}

class Feedback extends StatefulWidget {
  final String type;

  const Feedback({super.key, required this.type});

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _subjectController = TextEditingController();
    _bodyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
      ],
      child: AlertDialog(
        alignment: Alignment.topCenter,
        content: SizedBox(
          height: 390,
          width: MediaQuery.of(context).size.width - 50,
          child: Column(
            children: [
              Text(widget.type,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: _subjectController,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ], // Only numbers can be entered
                    showCursor: true,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Subject",
                      alignLabelWithHint: true,
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                        maxLines: 100,
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: _bodyController,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(1000),
                        ], // Only numbers can be entered
                        showCursor: true,
                        cursorColor: Colors.grey,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Share Some Feedback",
                          alignLabelWithHint: true,
                        ),
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<UserEventBloc>().add(UserEventFeedback(
                      type: widget.type,
                      subject: _subjectController.text,
                      body: _bodyController.text));
                  context.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Submit",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

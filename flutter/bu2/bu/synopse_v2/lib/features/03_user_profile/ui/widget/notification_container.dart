import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/04_home/bloc/user_events/user_event_bloc.dart';

class NotificationWidgets extends StatelessWidget {
  const NotificationWidgets({super.key});

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
      child: const NotificationWidget(),
    );
  }
}

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Animate(
                effects: [
                  FadeEffect(
                      delay: 400.milliseconds, duration: 1000.milliseconds)
                ],
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Get realtime social activits and article recommendations",
                      style: MyTypography.t12.copyWith(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            Animate(
              effects: [
                FadeEffect(delay: 600.milliseconds, duration: 1000.milliseconds)
              ],
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  width: 250,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                    ),
                    onPressed: () {
                      openAppSettings();
                    },
                    child: Text(
                      "Turn On Notifications",
                      style: MyTypography.t12.copyWith(
                          fontSize: 15,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.8)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

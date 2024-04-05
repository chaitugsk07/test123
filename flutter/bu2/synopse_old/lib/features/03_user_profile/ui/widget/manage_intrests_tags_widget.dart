import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';

class UserTags111 extends StatelessWidget {
  final int tagId;
  final String tagName;
  final bool isUserIntrest;

  const UserTags111(
      {super.key,
      required this.tagId,
      required this.tagName,
      required this.isUserIntrest});

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
      child: UserTags11(
        tagId: tagId,
        tagName: tagName,
        isUserIntrest: isUserIntrest,
      ),
    );
  }
}

class UserTags11 extends StatefulWidget {
  final int tagId;
  final String tagName;
  final bool isUserIntrest;

  const UserTags11(
      {super.key,
      required this.tagId,
      required this.tagName,
      required this.isUserIntrest});

  @override
  State<UserTags11> createState() => _UserTags11State();
}

class _UserTags11State extends State<UserTags11> {
  late bool _isUserIntrest;
  @override
  void initState() {
    super.initState();
    _isUserIntrest = widget.isUserIntrest;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isUserIntrest = !_isUserIntrest;
        });
        if (_isUserIntrest) {
          context.read<UserEventBloc>().add(
                UserEventTag(
                  tagId: widget.tagId,
                ),
              );
        } else {
          context.read<UserEventBloc>().add(
                UserEventTagDelete(
                  tagId: widget.tagId,
                ),
              );
        }
      },
      child: Animate(
        effects: [
          FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 4.0,
            vertical: 2.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: _isUserIntrest
                ? Theme.of(context).colorScheme.onBackground
                : Theme.of(context).colorScheme.background,
            border: Border.all(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Text(
              widget.tagName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: _isUserIntrest
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

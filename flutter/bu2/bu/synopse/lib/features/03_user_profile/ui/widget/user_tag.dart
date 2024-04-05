import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/04_home/bloc/user_events/user_event_bloc.dart';

class UserTags extends StatelessWidget {
  final int tagId;
  final bool isTaged;
  final String tag;
  const UserTags(
      {super.key,
      required this.tagId,
      required this.isTaged,
      required this.tag});

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
      child: UserTag(
        tagId: tagId,
        isTaged: isTaged,
        tag: tag,
      ),
    );
  }
}

class UserTag extends StatefulWidget {
  final int tagId;
  final bool isTaged;
  final String tag;
  const UserTag(
      {super.key,
      required this.tagId,
      required this.isTaged,
      required this.tag});

  @override
  State<UserTag> createState() => _UserTagState();
}

class _UserTagState extends State<UserTag> {
  late bool _isTaged;
  @override
  void initState() {
    super.initState();
    _isTaged = widget.isTaged;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.tag,
          textAlign: TextAlign.start,
          style: MyTypography.t12,
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            setState(
              () {
                if (_isTaged) {
                  context.read<UserEventBloc>().add(
                        UserEventTag(
                          tagId: widget.tagId,
                        ),
                      );
                } else if (!_isTaged) {
                  context.read<UserEventBloc>().add(
                        UserEventTagDelete(
                          tagId: widget.tagId,
                        ),
                      );
                }
                _isTaged = !_isTaged;
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
            child: FaIcon(FontAwesomeIcons.tag,
                size: 15,
                color: _isTaged ? Colors.grey : Colors.deepPurpleAccent),
          ),
        ),
      ],
    );
  }
}

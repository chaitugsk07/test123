import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';

class Following1 extends StatelessWidget {
  final bool isFollowing;
  final String account;

  const Following1(
      {super.key, required this.isFollowing, required this.account});
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
      child: Following(
        isFollowing: isFollowing,
        account: account,
      ),
    );
  }
}

class Following extends StatefulWidget {
  final bool isFollowing;

  final String account;

  const Following(
      {super.key, required this.isFollowing, required this.account});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isFollowing)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isFollowing = false;
              });
              context.read<UserEventBloc>().add(
                    UserEventFollow(
                      account: widget.account,
                    ),
                  );
            },
            child: Text(
              "Follow",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        if (!_isFollowing)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isFollowing = true;
              });
              context.read<UserEventBloc>().add(
                    UserEventUnFollow(
                      account: widget.account,
                    ),
                  );
            },
            child: Text(
              "Following",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }
}

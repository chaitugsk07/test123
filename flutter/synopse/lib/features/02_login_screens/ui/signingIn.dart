import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';

import 'package:synopse/features/02_login_screens/bloc/is_user_already_exists/check_user_bloc.dart';

class SigningIn extends StatelessWidget {
  final String type;
  final String email;
  final String id;
  final String name;
  final String photoUrl;
  const SigningIn({
    Key? key,
    required this.type,
    required this.email,
    required this.id,
    required this.name,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CheckUserBloc()),
      ],
      child: Signin(
        type: type,
        email: email,
        id: id,
        name: name,
        photoUrl: photoUrl,
      ),
    );
  }
}

class Signin extends StatefulWidget {
  final String type;
  final String email;
  final String id;
  final String name;
  final String photoUrl;
  const Signin({
    Key? key,
    required this.type,
    required this.email,
    required this.id,
    required this.name,
    required this.photoUrl,
  }) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  void initState() {
    super.initState();
    context.read<CheckUserBloc>().add(
          CheckUserExistsOrNot(
            type: widget.type,
            email: widget.email,
            id: widget.id,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckUserBloc, CheckUserState>(
        builder: (context, checkUserState) {
      if (checkUserState.status == CheckUserStatus.loading) {
        return const PageLoading();
      } else if (checkUserState.status == CheckUserStatus.phone) {
        context.push(phone);
        return Container();
      } else if (checkUserState.status == CheckUserStatus.loggedin) {
        return Container(
          child: Text("ascasc"),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
        context.push(signUp);
        return Container();
      }
    });
  }
}

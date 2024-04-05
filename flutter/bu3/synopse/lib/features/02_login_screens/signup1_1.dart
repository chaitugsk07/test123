import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/02_login_screens/bloc_checkuser/check_user_bloc.dart';
import 'package:synopse/features/02_login_screens/bloc_create_account/create_account_bloc.dart';

class SigningIn11 extends StatelessWidget {
  final String type;
  final String email;
  final String id;
  final String name;
  final String photoUrl;
  const SigningIn11({
    super.key,
    required this.type,
    required this.email,
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CheckUserBloc()),
        BlocProvider(create: (context) => CreateAccountBloc()),
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
    super.key,
    required this.type,
    required this.email,
    required this.id,
    required this.name,
    required this.photoUrl,
  });

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

  void setLoginAccount() {
    context.read<CreateAccountBloc>().add(
          CreateAccountForValidGmail(
              name: widget.name,
              googleEmail: widget.email,
              googleId: widget.id,
              googlePhotoUrl: widget.photoUrl,
              googlePhotoValid: widget.photoUrl.length < 10 ? 0 : 1),
        );

    final createAccountBloc = BlocProvider.of<CreateAccountBloc>(context);
    createAccountBloc.stream.listen(
      (state) {
        if (state.status == CreateAccountStatus.success) {
          context.push(home);
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          BlocListener<CheckUserBloc, CheckUserState>(
            listener: (context, state) {
              //print(state.status);
              if (state.status == CheckUserStatus.loading) {
              } else if (state.status == CheckUserStatus.phone) {
                setLoginAccount();
              } else if (state.status == CheckUserStatus.loggedin) {
                context.push(userProfileSignUp);
              } else if (state.status == CheckUserStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('login failed'),
                  ),
                );
                context.push(splash);
              }
            },
            child: const PageLoading(
              title: 'Checking user',
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

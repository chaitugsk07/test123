import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';

import 'package:synopse/features/02_login_screens/bloc/verify_phone_email/verify_phone_email_bloc.dart';

class VerifyPhoneEmail extends StatelessWidget {
  final String type;
  final String email;
  final int country;
  final int phoneno;
  final String id;
  final String name;
  final String photoUrl;

  const VerifyPhoneEmail(
      {super.key,
      required this.type,
      required this.email,
      required this.country,
      required this.phoneno,
      required this.id,
      required this.name,
      required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VerifyPhoneEmailBloc()),
      ],
      child: VerifyEmail(
        type: type,
        email: email,
        country: country,
        phoneno: phoneno,
        id: id,
        name: name,
        photoUrl: photoUrl,
      ),
    );
  }
}

class VerifyEmail extends StatefulWidget {
  final String type;
  final String email;
  final String id;
  final int country;
  final int phoneno;
  final String name;
  final String photoUrl;

  const VerifyEmail(
      {super.key,
      required this.type,
      required this.email,
      required this.id,
      required this.country,
      required this.phoneno,
      required this.name,
      required this.photoUrl});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  void initState() {
    context.read<VerifyPhoneEmailBloc>().add(
          VerifyPhoneEmailForValidPhNo(
              country: widget.country.toString(),
              phoneno: widget.phoneno.toString(),
              email: widget.email,
              accountType: widget.type),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          BlocListener<VerifyPhoneEmailBloc, VerifyPhoneEmailState>(
            listener: (context, state) {
              //print(state.status);
              if (state.status == VerifyPhoneEmailStatus.loading) {
              } else if (state.status == VerifyPhoneEmailStatus.success) {
                context.push(
                  verify,
                  extra: VerifyRouteData(
                    type: widget.type,
                    email: widget.email,
                    id: widget.id,
                    name: widget.name,
                    photoUrl: widget.photoUrl,
                    country: widget.country,
                    phoneNo: widget.phoneno,
                  ),
                );
              } else if (state.status == VerifyPhoneEmailStatus.alreadyexists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "another ${widget.type} email already linked to this phone number try a different number or login with ${state.regEmail} "),
                  ),
                );
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.push(splash);
                }
              } else if (state.status == VerifyPhoneEmailStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('login failed'),
                  ),
                );
                context.push(signUp);
              }
            },
            child: const PageLoading(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

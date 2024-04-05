import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/02_login_screens/bloc/verify_otp/verifiy_otp_bloc.dart';

class VerifyOTPS extends StatelessWidget {
  final String type;
  final String country;
  final String phoneno;
  final int otp;
  final String name;
  final String googleEmail;
  final String googleId;
  final String googlePhotoUrl;
  final int googlePhotoValid;
  final String microsoftEmail;
  final String microsoftId;
  final String microsoftName;

  const VerifyOTPS(
      {super.key,
      required this.country,
      required this.phoneno,
      required this.otp,
      required this.name,
      required this.googleEmail,
      required this.googleId,
      required this.googlePhotoUrl,
      required this.googlePhotoValid,
      required this.type,
      required this.microsoftEmail,
      required this.microsoftId,
      required this.microsoftName});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VerifyOTPBloc()),
      ],
      child: VerifyOTP(
          country: country,
          phoneno: phoneno,
          otp: otp,
          name: name,
          googleEmail: googleEmail,
          googleId: googleId,
          googlePhotoUrl: googlePhotoUrl,
          googlePhotoValid: googlePhotoValid,
          type: type,
          microsoftEmail: microsoftEmail,
          microsoftId: microsoftId,
          microsoftName: microsoftName),
    );
  }
}

class VerifyOTP extends StatefulWidget {
  final String type;
  final String country;
  final String phoneno;
  final int otp;
  final String name;
  final String googleEmail;
  final String googleId;
  final String googlePhotoUrl;
  final int googlePhotoValid;
  final String microsoftEmail;
  final String microsoftId;
  final String microsoftName;

  const VerifyOTP(
      {super.key,
      required this.type,
      required this.country,
      required this.phoneno,
      required this.otp,
      required this.name,
      required this.googleEmail,
      required this.googleId,
      required this.googlePhotoUrl,
      required this.googlePhotoValid,
      required this.microsoftEmail,
      required this.microsoftId,
      required this.microsoftName});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  @override
  void initState() {
    super.initState();
    if (widget.microsoftEmail != "") {
      context.read<VerifyOTPBloc>().add(
            VerifyOTPForValidPhNoMicrosoft(
                country: widget.country,
                phoneno: widget.phoneno,
                otp: widget.otp,
                microsoftName: widget.microsoftName,
                microsoftEmail: widget.microsoftEmail,
                microsoftId: widget.microsoftId),
          );
    } else if (widget.googleEmail != "") {
      context.read<VerifyOTPBloc>().add(
            VerifyOTPForValidPhNo(
                country: widget.country,
                phoneno: widget.phoneno,
                otp: widget.otp,
                name: widget.name,
                googleEmail: widget.googleEmail,
                googleId: widget.googleId,
                googlePhotoUrl: widget.googlePhotoUrl,
                googlePhotoValid: widget.googlePhotoValid),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          BlocListener<VerifyOTPBloc, VerifyOTPState>(
            listener: (context, state) {
              //print(state.status);
              if (state.status == VerifyOTPStatus.loading) {
              } else if (state.status == VerifyOTPStatus.success) {
                context.push(home);
              } else if (state.status == VerifyOTPStatus.failure) {
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

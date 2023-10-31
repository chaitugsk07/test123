import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/01_splash/bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<SplashBloc>().add(const SplashCheckLoginStatus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          BlocListener<SplashBloc, SplashState>(
            listener: (context, state) {
              print(state.status);
              if (state.status == SplashStatus.isloggedin) {
                context.push(signUp);
              } else if (state.status == SplashStatus.isloginskipped) {
              } else if (state.status == SplashStatus.isnotloggedin) {
                context.push(signUp);
              } else if (state.status == SplashStatus.error) {}
            },
            child: const PageLoading(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

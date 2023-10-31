import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v001/core/asset_gen/assets.gen.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/01_splash/bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

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
          Center(
            child: SizedBox(
                child: Assets.images.logo.image(), width: 100, height: 100),
          ),
          BlocListener<SplashBloc, SplashState>(
            listener: (context, state) {
              if (state.status == SplashStatus.isloggedin) {
                context.push(home);
              } else if (state.status == SplashStatus.isloginskipped) {
                context.push(home);
              } else if (state.status == SplashStatus.isnotloggedin) {
                context.push(login);
              } else if (state.status == SplashStatus.error) {
                context.push(splash);
              }
            },
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

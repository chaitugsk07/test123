import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/features/01_splash/bloc_splash/splash_bloc.dart';

class ArticleGroupDeep extends StatelessWidget {
  final int articleGroupid;

  const ArticleGroupDeep({super.key, required this.articleGroupid});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashBloc()),
      ],
      child: ArticleGroupDeep11(
        articleGroupid: articleGroupid,
      ),
    );
  }
}

class ArticleGroupDeep11 extends StatefulWidget {
  final int articleGroupid;

  const ArticleGroupDeep11({super.key, required this.articleGroupid});

  @override
  State<ArticleGroupDeep11> createState() => _ArticleGroupDeep11State();
}

class _ArticleGroupDeep11State extends State<ArticleGroupDeep11> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const SplashCheckLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 55, 61, 70),
              Color.fromARGB(255, 92, 117, 126),
            ],
            stops: [
              0.5,
              1.0,
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            BlocListener<SplashBloc, SplashState>(
              listener: (context, state) {
                if (state.status == SplashStatus.initial) {
                } else if (state.status == SplashStatus.isloggedin) {
                  context.push(
                    detail,
                    extra: DetailData(
                        articleGroupid: widget.articleGroupid, type: 2),
                  );
                } else {
                  context.push(
                    detailNo,
                    extra: DetailData(
                        articleGroupid: widget.articleGroupid, type: 2),
                  );
                }
              },
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Animate(
                    autoPlay: true,
                    onComplete: (controller) {
                      controller.reverse();
                      controller.loop();
                    },
                    effects: [
                      FadeEffect(
                          delay: 100.milliseconds,
                          duration: 3000.milliseconds,
                          curve: Curves.bounceInOut),
                    ],
                    child: Image.asset(ImageConstant.imgLogo),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

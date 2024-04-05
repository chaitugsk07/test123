import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:synopse/features/05_article_details/bloc_article_followup/article_followup_bloc.dart';

class ArticleFollowUp111 extends StatelessWidget {
  final int articleId;
  final String title;

  const ArticleFollowUp111(
      {super.key, required this.articleId, required this.title});

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
        BlocProvider(
          create: (context) => ArticleFollowupBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: ArticleFollowUp11(
        articleId: articleId,
        title: title,
      ),
    );
  }
}

class ArticleFollowUp11 extends StatefulWidget {
  final int articleId;
  final String title;

  const ArticleFollowUp11(
      {super.key, required this.articleId, required this.title});

  @override
  State<ArticleFollowUp11> createState() => _ArticleFollowUp11State();
}

class _ArticleFollowUp11State extends State<ArticleFollowUp11> {
  final TextEditingController _textEditingController = TextEditingController();
  late final ScrollController _scrollController;
  late List<String> _followUpQuestions;
  late List<String> _followUpAnswers;
  late String _photoURL;
  late String _userName;
  late String _initials;
  late String _token;
  late String _text1 = '';
  @override
  void initState() {
    super.initState();
    _followUpQuestions = [];
    _followUpAnswers = [];
    _photoURL = 'na';
    _userName = 'na';
    _token = 'na';
    _text1 = '';
    _scrollController = ScrollController();
    _getAccountFromSharedPreferences();
    _textEditingController.addListener(() {
      setState(() {});
    });
    context.read<ArticleFollowupBloc>().add(
          ArticleFollowupFetch(articleFollowup: widget.articleId),
        );
    final articleFollowupBloc = BlocProvider.of<ArticleFollowupBloc>(context);
    articleFollowupBloc.stream.listen(
      (state) {
        if (state.status == ArticleFollowupStatus.success) {
          for (final item in state.synopseRealtimeVV10UsersFollowUp) {
            _followUpQuestions.add(item.query);
            _followUpAnswers.add(item.reply);
          }
          setState(() {});
        }
      },
    );
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _photoURL = prefs.getString('userLevePhotoURL') ?? 'na';
        _userName = prefs.getString('userName') ?? 'na';
        _token = prefs.getString('loginToken') ?? 'na';
        _initials = getInitials(_userName);
      },
    );
  }

  String getInitials(String text) {
    List<String> words = text.split(' ');
    if (words.length > 1) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    } else {
      return words[0][0].toUpperCase() +
          words[0][words[0].length - 1].toUpperCase();
    }
  }

  void makeRequest(String text) async {
    var url = Uri.parse(
        'https://icrispjgfllulboelvhw.supabase.co/functions/v1/chat_stream_v1');
    var headers = {"Content-Type": "application/json"};
    var body = jsonEncode(
        {"query": text, "article_id": widget.articleId, "token": _token});

    final request = http.StreamedRequest('POST', url)
      ..headers.addAll(headers)
      ..sink.add(utf8.encode(body));
    unawaited(request.sink.close());
    final response = await http.Client().send(request);

    response.stream.transform(utf8.decoder).listen((value) {
      setState(() {
        _text1 += value;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }, onDone: () {
      _followUpAnswers.add(_text1);
      context.read<UserEventBloc>().add(
            UserEventArticleFoollowUpOutputSet(
                out1: _text1, followUpId: widget.articleId),
          );
      _text1 = '';
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Please try again later.",
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.bg),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_followUpQuestions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Row(
                              children: [
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 200.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5),
                                    child: CircleAvatar(
                                      radius: 21,
                                      backgroundColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: SweepGradient(
                                              center: FractionalOffset.center,
                                              startAngle: 0.0,
                                              endAngle: 3.14 * 2,
                                              colors: <Color>[
                                                Color.fromARGB(
                                                    255, 252, 165, 124),
                                                Color.fromARGB(
                                                    255, 114, 170, 220),
                                                Color.fromARGB(
                                                    255, 196, 141, 193),
                                                Color.fromARGB(
                                                    255, 116, 220, 244),
                                                Color.fromARGB(
                                                    255, 210, 184, 166),
                                              ],
                                              stops: <double>[
                                                0.0,
                                                0.15,
                                                0.35,
                                                0.65,
                                                1.0
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              SvgConstant.aiIco,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Hi, I am AI. I am here to help you. Ask me anything related to the article \n ${widget.title}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_followUpQuestions.isNotEmpty)
                          ListView.builder(
                            controller: _scrollController,
                            itemCount: _followUpQuestions.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  children: [
                                    if (index == 0)
                                      Row(
                                        children: [
                                          Animate(
                                            effects: [
                                              FadeEffect(
                                                  delay: 200.milliseconds,
                                                  duration: 1000.milliseconds)
                                            ],
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 5),
                                              child: CircleAvatar(
                                                radius: 21,
                                                backgroundColor: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: SweepGradient(
                                                        center: FractionalOffset
                                                            .center,
                                                        startAngle: 0.0,
                                                        endAngle: 3.14 * 2,
                                                        colors: <Color>[
                                                          Color.fromARGB(255,
                                                              252, 165, 124),
                                                          Color.fromARGB(255,
                                                              114, 170, 220),
                                                          Color.fromARGB(255,
                                                              196, 141, 193),
                                                          Color.fromARGB(255,
                                                              116, 220, 244),
                                                          Color.fromARGB(255,
                                                              210, 184, 166),
                                                        ],
                                                        stops: <double>[
                                                          0.0,
                                                          0.15,
                                                          0.35,
                                                          0.65,
                                                          1.0
                                                        ],
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        SvgConstant.aiIco,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Colors.white,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Hi, I am AI. I am here to help you. Ask me anything related to the article \n ${widget.title}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        children: [
                                          if (_photoURL != "na")
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 5),
                                              child: CircleAvatar(
                                                radius: 21,
                                                backgroundImage:
                                                    NetworkImage(_photoURL),
                                              ),
                                            ),
                                          if (_photoURL == "na")
                                            Animate(
                                              effects: [
                                                FadeEffect(
                                                    delay: 200.milliseconds,
                                                    duration: 1000.milliseconds)
                                              ],
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5),
                                                child: CircleAvatar(
                                                  radius: 21,
                                                  backgroundColor: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Container(
                                                      width: 40.0,
                                                      height: 40.0,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient:
                                                            LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Colors.grey,
                                                            Colors.black
                                                          ],
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          _initials,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            child: Text(
                                              _followUpQuestions[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index < _followUpAnswers.length)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Animate(
                                            effects: [
                                              FadeEffect(
                                                  delay: 200.milliseconds,
                                                  duration: 1000.milliseconds)
                                            ],
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 5),
                                              child: CircleAvatar(
                                                radius: 21,
                                                backgroundColor: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: SweepGradient(
                                                        center: FractionalOffset
                                                            .center,
                                                        startAngle: 0.0,
                                                        endAngle: 3.14 * 2,
                                                        colors: <Color>[
                                                          Color.fromARGB(255,
                                                              252, 165, 124),
                                                          Color.fromARGB(255,
                                                              114, 170, 220),
                                                          Color.fromARGB(255,
                                                              196, 141, 193),
                                                          Color.fromARGB(255,
                                                              116, 220, 244),
                                                          Color.fromARGB(255,
                                                              210, 184, 166),
                                                        ],
                                                        stops: <double>[
                                                          0.0,
                                                          0.15,
                                                          0.35,
                                                          0.65,
                                                          1.0
                                                        ],
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        SvgConstant.aiIco,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Colors.white,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _followUpAnswers[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (_text1 != '' &&
                                        index == _followUpAnswers.length)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Animate(
                                            effects: [
                                              FadeEffect(
                                                  delay: 200.milliseconds,
                                                  duration: 1000.milliseconds)
                                            ],
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 50),
                                              child: CircleAvatar(
                                                radius: 21,
                                                backgroundColor: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: SweepGradient(
                                                        center: FractionalOffset
                                                            .center,
                                                        startAngle: 0.0,
                                                        endAngle: 3.14 * 2,
                                                        colors: <Color>[
                                                          Color.fromARGB(255,
                                                              252, 165, 124),
                                                          Color.fromARGB(255,
                                                              114, 170, 220),
                                                          Color.fromARGB(255,
                                                              196, 141, 193),
                                                          Color.fromARGB(255,
                                                              116, 220, 244),
                                                          Color.fromARGB(255,
                                                              210, 184, 166),
                                                        ],
                                                        stops: <double>[
                                                          0.0,
                                                          0.15,
                                                          0.35,
                                                          0.65,
                                                          1.0
                                                        ],
                                                      ),
                                                    ),
                                                    child: const Center(
                                                        child: FaIcon(
                                                      FontAwesomeIcons
                                                          .handSparkles,
                                                      size: 20,
                                                      color: Colors.white,
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _text1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (index == _followUpQuestions.length - 1)
                                      const SizedBox(
                                        height: 100,
                                      )
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Animate(
                  effects: [
                    SlideEffect(
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0),
                      duration: 300.milliseconds,
                      curve: Curves.easeInOutCubic,
                    ),
                  ],
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Row(
                          children: [
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      const FaIcon(
                                        FontAwesomeIcons.handSparkles,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: _textEditingController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines:
                                              null, // This allows for multiple lines
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          cursorColor: Colors.grey,
                                          decoration: InputDecoration(
                                            hintText: "Ask Follow Up Questions",
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10),
                                          ),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                200), // limits to 250 characters
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (_textEditingController.text.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  _followUpQuestions
                                      .add(_textEditingController.text);

                                  FocusScope.of(context).unfocus();
                                  makeRequest(_textEditingController.text);
                                  _textEditingController.clear();
                                  setState(() {});
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withAlpha(150),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 10,
                                        blurRadius: 15,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            if (_textEditingController.text.isEmpty)
                              const SizedBox(
                                height: 40,
                                width: 40,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

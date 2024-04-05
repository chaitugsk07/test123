import 'dart:async';
import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/02_login_screens/bloc/login_api.dart';
import 'package:synopse/features/04_home/bloc/user_events/user_event_bloc.dart';
import 'package:synopse/features/09_external_user/bloc/ext_user_metadata/ext_user_bloc.dart';

class UserProfileUpdate extends StatelessWidget {
  const UserProfileUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExtUserBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UserEventBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const UserM(),
    );
  }
}

class UserM extends StatefulWidget {
  const UserM({super.key});

  @override
  State<UserM> createState() => _UserMState();
}

class _UserMState extends State<UserM> {
  late String account;
  @override
  void initState() {
    super.initState();
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        account = prefs.getString('account') ?? '';
        context.read<ExtUserBloc>().add(ExtUserFetch(account: account));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Animate(
            effects: [
              FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
            ],
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.push(splash);
                }
              },
            ),
          ),
          actions: [
            Animate(
              effects: [
                FadeEffect(delay: 200.milliseconds, duration: 1000.milliseconds)
              ],
              child: IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Handle share button press
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const Spacer(),
            BlocBuilder<ExtUserBloc, ExtUserState>(
              builder: (context, extUserState) {
                if (extUserState.status == ExtUserStatus.success) {
                  return User(
                    bio: extUserState.synopseRealtimeVUserMetadatum[0]
                        .userToLevel!.userToLink!.bio,
                    name: extUserState.synopseRealtimeVUserMetadatum[0]
                        .userToLevel!.userToLink!.name,
                    username: extUserState.synopseRealtimeVUserMetadatum[0]
                        .userToLevel!.userToLink!.username,
                    photoUrl: extUserState.synopseRealtimeVUserMetadatum[0]
                                .userToLevel!.userToLink!.photourl ==
                            ""
                        ? "na"
                        : extUserState.synopseRealtimeVUserMetadatum[0]
                            .userToLevel!.userToLink!.photourl,
                    account: account,
                  );
                } else {
                  return Container();
                }
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class User extends StatefulWidget {
  final String username;
  final String name;
  final String bio;
  final String photoUrl;
  final String account;

  const User(
      {super.key,
      required this.username,
      required this.name,
      required this.bio,
      required this.photoUrl,
      required this.account});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  int _isValid = 0;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _nameController = TextEditingController();
    _usernameController.text = widget.username;
    _bioController.text = widget.bio;
    _nameController.text = widget.name;
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 100,
        maxHeight: 100);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 100,
        maxHeight: 100);

    setState(() {
      _image = image;
    });
  }

  void _onUsernameChanged() {
    setState(() {
      String value = _usernameController.text;
      if (value.length < 8) {
        _isValid = 1;
      } else {
        _isValid = 10;
      }
    });
  }

  Future<bool> uploadImage(String filename) async {
    const url =
        'https://acceptable-etty-chaitugsk07.koyeb.app/upload/profile'; // replace with your API endpoint
    final request = http.MultipartRequest('POST', Uri.parse(url));
    final newFileName = '$filename.jpg';
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      _image!.path,
      filename: newFileName,
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static final Config config = Config(
    tenant: '4ce54642-fd13-4892-88a9-729f6b45f3f1',
    clientId: 'a6e335f0-95eb-4b4a-959d-e4aeb4c742b0',
    scope: 'openid profile offline_access',
    navigatorKey: router.routerDelegate.navigatorKey,
    loader: const SizedBox(),
    appBar: AppBar(
      title: const Text('AAD OAuth Demo'),
    ),
  );
  final AadOAuth oauth = AadOAuth(config);
  void signOut() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('isOnboardingSkip', false);
    prefs.setBool('isLoggedIn', false);
    prefs.setBool('isLoginSkipped', false);
    prefs.setString('loginToken', "");
    prefs.setString('account', "");
    prefs.setString('exp', "");
    if (prefs.getBool("isMicrosoftLoggedIn") ?? false) {
      await oauth.logout();
      prefs.setBool("isMicrosoftLoggedIn", false);
    }
    if (prefs.getBool("isGoogleLoggedIn") ?? false) {
      await LoginApi.signOut();
      prefs.setBool("isGoogleLoggedIn", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Animate(
              effects: [
                FadeEffect(delay: 400.milliseconds, duration: 1000.milliseconds)
              ],
              child: Container(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    style: MyTypography.t12,
                    children: [
                      const TextSpan(text: "Complete Your @"),
                      TextSpan(
                        text: "Profile ",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900,
                            color: Colors.teal.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Spacer(),
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 500.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: DottedBorder(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                    strokeWidth: 1,
                    borderType: BorderType.Circle,
                    child: SizedBox(
                      height: 100,
                      width: 200,
                      child: Center(
                        child: Stack(
                          children: [
                            if (widget.photoUrl != "na" && _image == null)
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(widget.photoUrl),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            if (widget.photoUrl == "na" && _image == null)
                              FaIcon(
                                FontAwesomeIcons.userPlus,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                size: 25,
                              ),
                            if (_image != null)
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: kIsWeb
                                      ? Image.network(
                                          _image!.path,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(_image!.path),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 500.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.1),
                          ),
                          onPressed: () {
                            getImageFromCamera();
                          },
                          child: Text(
                            "Camera",
                            style: MyTypography.t12.copyWith(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 500.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.1),
                          ),
                          onPressed: () {
                            getImageFromGallery();
                          },
                          child: Text(
                            "Gallery",
                            style: MyTypography.t12.copyWith(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Animate(
              effects: [
                FadeEffect(delay: 500.milliseconds, duration: 1000.milliseconds)
              ],
              child: const Text(
                "Add profile picture",
                style: MyTypography.s3,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Animate(
              effects: [
                FadeEffect(delay: 500.milliseconds, duration: 1000.milliseconds)
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _nameController,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(50),
                            ], // Only numbers can be entered
                            showCursor: true,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name",
                              isDense: true,
                              alignLabelWithHint: true,
                              hintStyle: MyTypography.t12.copyWith(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            style: MyTypography.body.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Animate(
              effects: [
                FadeEffect(delay: 500.milliseconds, duration: 1000.milliseconds)
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const SizedBox(
                        width: 10,
                        child: Text(
                          "@",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _usernameController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9a-zA-Z._]")),
                              LengthLimitingTextInputFormatter(15),
                            ], // Only numbers can be entered
                            showCursor: true,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "  Enter your Username",
                              isDense: true,
                              alignLabelWithHint: true,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 15,
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (_isValid != 10)
              Animate(
                effects: [
                  FadeEffect(
                      delay: 700.milliseconds, duration: 1000.milliseconds)
                ],
                child: Stack(
                  children: [
                    Visibility(
                      visible: _isValid == 1,
                      child: SizedBox(
                        height: 20,
                        child: Center(
                          child: Text(
                            'Username should contain at least 8 characters',
                            style: MyTypography.r1.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isValid == 10)
              const SizedBox(
                height: 20,
              ),
            Animate(
              effects: [
                FadeEffect(delay: 700.milliseconds, duration: 1000.milliseconds)
              ],
              child: const Text(
                "Real names are encouraged so other people recognize you.",
                style: MyTypography.s3,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Animate(
              effects: [
                FadeEffect(delay: 500.milliseconds, duration: 1000.milliseconds)
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _bioController,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(150),
                            ], // Only numbers can be entered
                            showCursor: true,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Bio",
                              isDense: true,
                              alignLabelWithHint: true,
                              hintStyle: MyTypography.t12.copyWith(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            style: MyTypography.body.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Animate(
              effects: [
                FadeEffect(delay: 700.milliseconds, duration: 1000.milliseconds)
              ],
              child: Text(
                "Let People know where you work and what you do.",
                style: MyTypography.body.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Animate(
              effects: [
                FadeEffect(
                    delay: 1000.milliseconds, duration: 1000.milliseconds)
              ],
              child: SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.1),
                  ),
                  onPressed: () {
                    if (widget.username != _usernameController.text &&
                        _isValid == 10) {
                      context.read<UserEventBloc>().add(
                            UserEventUsername(
                                username: _usernameController.text),
                          );
                    }
                    if (widget.name != _nameController.text) {
                      context.read<UserEventBloc>().add(
                            UserEventName(name: _nameController.text),
                          );
                    }
                    if (widget.bio != _bioController.text) {
                      context.read<UserEventBloc>().add(
                            UserEventBio(bio: _bioController.text),
                          );
                    }
                    if (_image != null) {
                      uploadImage(widget.account);
                      context.read<UserEventBloc>().add(
                            const UserEventPhoto(photo: 1),
                          );
                    }
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.push(splash);
                    }
                  },
                  child: Text(
                    "Submit",
                    style: MyTypography.t12.copyWith(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Animate(
              effects: [
                FadeEffect(
                    delay: 1000.milliseconds, duration: 1000.milliseconds)
              ],
              child: SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.redAccent.withOpacity(0.5),
                  ),
                  onPressed: () {
                    signOut();
                    context.push(splash);
                  },
                  child: Text(
                    "Sign Out",
                    style: MyTypography.t12.copyWith(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

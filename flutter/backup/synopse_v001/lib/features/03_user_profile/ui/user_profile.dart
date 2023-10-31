import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/features/03_user_profile/01_models_repo/source_user_profile_api.dart';
import 'package:synopse_v001/features/03_user_profile/bloc/user_profile_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserProfileBloc>(
          create: (context) => UserProfileBloc(
            userProfileService: UserProfileService(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const User(),
    );
  }
}

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  int _isValid = 0;

  @override
  void initState() {
    super.initState();

    context.read<UserProfileBloc>().add(const UserProfileGet());
    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.stream.listen((state) {
      if (state.status == UserProfileStatus.success) {
        if (state.authAuth1User[0].username != "") {
          _usernameController.text = state.authAuth1User[0].username.toString();
        }
        if (state.authAuth1User[0].bio != "") {
          _bioController.text = state.authAuth1User[0].bio.toString();
        }
      }
    });
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
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
      int numCount = value.replaceAll(RegExp(r'[^0-9]'), '').length;
      if (value.length < 8) {
        _isValid = 1;
      } else if (numCount < 1) {
        _isValid = 2;
      } else {
        _isValid = 10;
      }
    });
  }

  Future<bool> uploadImage(String filename) async {
    const url =
        'https://acceptable-etty-chaitugsk07.koyeb.app/upload/profile'; // replace with your API endpoint
    final request = http.MultipartRequest('POST', Uri.parse(url));
    final newFileName = filename + '.jpg';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Animate(
          effects: [
            FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
          ],
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
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
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userProfileState) {
          if (userProfileState.status == UserProfileStatus.initial) {
            return Scaffold(
              body: Center(
                child: SpinKitSpinningLines(
                  color: Colors.teal.shade700,
                  size: 200,
                  lineWidth: 3,
                ),
              ),
            );
          } else if (userProfileState.status == UserProfileStatus.success) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 400.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Container(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 20,
                                  ),
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
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 300.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Stack(
                          children: [
                            DottedBorder(
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
                                      if (userProfileState
                                                  .authAuth1User[0].userPhoto ==
                                              1 &&
                                          _image == null)
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                'https://pub-4297a5d1f32d43b4a18134d76942de8d.r2.dev/' +
                                                    userProfileState
                                                        .authAuth1User[0]
                                                        .account
                                                        .toString() +
                                                    ".jpg",
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      if (userProfileState
                                                  .authAuth1User[0].userPhoto ==
                                              0 &&
                                          _image == null)
                                        FaIcon(
                                          FontAwesomeIcons.userPlus,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
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
                            Positioned(
                              top: 0,
                              child: FloatingActionButton(
                                onPressed: getImageFromCamera,
                                tooltip: 'Open Camera. Take a Photo',
                                hoverColor: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.2),
                                mini: true,
                                child: Center(
                                  child: DottedBorder(
                                    padding: const EdgeInsets.all(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    strokeWidth: 1,
                                    borderType: BorderType.Circle,
                                    child: const FaIcon(FontAwesomeIcons.camera,
                                        size: 10),
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: FloatingActionButton(
                                onPressed: getImageFromGallery,
                                tooltip: 'Open Gallery. Select a Photo',
                                hoverColor: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.2),
                                mini: true,
                                child: Center(
                                  child: DottedBorder(
                                    padding: const EdgeInsets.all(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    strokeWidth: 1,
                                    borderType: BorderType.Circle,
                                    child: const FaIcon(FontAwesomeIcons.image,
                                        size: 10),
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            if (userProfileState.authAuth1User[0].userPhoto ==
                                1)
                              Positioned(
                                right: 0,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                  },
                                  tooltip: 'Delete your Profile Picture',
                                  hoverColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.2),
                                  mini: true,
                                  child: Center(
                                    child: DottedBorder(
                                      padding: const EdgeInsets.all(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      strokeWidth: 1,
                                      borderType: BorderType.Circle,
                                      child: const FaIcon(
                                        FontAwesomeIcons.deleteLeft,
                                        size: 10,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                          ],
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
                        child: Text(
                          "Add profile picture",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 10,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 500.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
                                delay: 700.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Stack(
                            children: [
                              Visibility(
                                visible: _isValid == 1,
                                child: const SizedBox(
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      'Username should contain at least 8 characters with 1 digit',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isValid == 2,
                                child: const SizedBox(
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      'Username should contain at least 1 digit',
                                      style: TextStyle(
                                        color: Colors.red,
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
                          FadeEffect(
                              delay: 700.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Text(
                          "Real names are encouraged so other people recognize you.",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 500.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 700.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Text(
                          "Let People know where you work and what you do.",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 1000.milliseconds,
                              duration: 1000.milliseconds)
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
                            onPressed: () async {
                              bool userName = false;
                              String userNameData = '';
                              bool bio = false;
                              String bioData = '';
                              bool userPhoto = false;
                              int userPhotoData = 0;

                              if (userProfileState.authAuth1User[0].username !=
                                      _usernameController.text &&
                                  _isValid == 10) {
                                userName = true;
                                userNameData = _usernameController.text;
                              }
                              if (userProfileState.authAuth1User[0].bio !=
                                  _bioController.text) {
                                bio = true;
                                bioData = _bioController.text;
                              }
                              if (_image != null) {
                                userPhoto = true;
                                userPhotoData = 1;
                                await uploadImage(userProfileState
                                    .authAuth1User[0].account
                                    .toString());
                              }
                              final bloc = context.read<UserProfileBloc>();
                              bloc.add(
                                UserProfileSet(
                                  userName: userName,
                                  userNameData: userNameData,
                                  bio: bio,
                                  bioData: bioData,
                                  userPhoto: userPhoto,
                                  userPhotoData: userPhotoData,
                                ),
                              );
                              context.pop();
                            },
                            child: Text(
                              "Submit",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontFamily: 'Roboto Condensed',
                                      fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Something went wrong"),
              ),
            );
            Navigator.pop(context);
            return const Scaffold(
              body: Center(
                child: SpinKitSpinningLines(
                  color: Colors.deepPurpleAccent,
                  size: 200,
                  lineWidth: 3,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

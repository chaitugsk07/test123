import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/06_user_profile/01_models_repo/source_user_profile_api.dart';
import 'package:synopse_v001/features/06_user_profile/bloc/user_profile_bloc.dart';

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
      child: User(),
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

  String _username = '';
  String _bio = '';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _bio = prefs.getString('bio') ?? '';
      _usernameController.text = _username;
      _bioController.text = _bio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              const SizedBox(
                height: 200,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 60,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {}); // rebuild the widget tree
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        hintText: 'Bio',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {}); // rebuild the widget tree
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.5),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('username', _usernameController.text);
                    await prefs.setString('bio', _bioController.text);
                    print('$_usernameController.text, $_bioController.text');
                    context
                        .read<UserProfileBloc>()
                        .add(UserProfileSet(userProfile: _username, bio: _bio));
                    // Raise the UserProfileSet event
                  },
                  child: Text(
                    "Save Profile",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Roboto Condensed', fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 50,
              color: Colors.black,
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.push(home);
                    },
                    icon: const Icon(
                      Icons.login,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.push(user);
                    },
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

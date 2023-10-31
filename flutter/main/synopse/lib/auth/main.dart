import 'package:flutter/material.dart';
import 'package:synopse/auth/login_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Google'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var user = await LoginApi.loginWithGoogle();
                  if (user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuccessLogin(
                                  name: user.displayName!,
                                  email: user.email,
                                  photoUrl: user.photoUrl ??
                                      "https://i.pravatar.cc/300",
                                  hashcode: user.hashCode,
                                  id: user.id,
                                  ServerAuthCode: user.serverAuthCode ?? "null",
                                  runtimeType: user.runtimeType,
                                )));
                  }
                },
                child: const Text("Login Google")),
          ],
        ),
      ),
    );
  }
}

class SuccessLogin extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final int hashcode;
  final String id;
  final String ServerAuthCode;
  final Type runtimeType;
  const SuccessLogin(
      {Key? key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.hashcode,
      required this.id,
      required this.ServerAuthCode,
      required this.runtimeType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Success")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(photoUrl),
          Text("Name: $name"),
          Text("Email: $email"),
          Text("Hashcode: $hashcode"),
          Text("Id: $id"),
          Text("ServerAuthCode: $ServerAuthCode"),
          Text("runtimeType: $runtimeType"),
          ElevatedButton(
              onPressed: () async {
                await LoginApi.signOut();
                Navigator.of(context).pop();
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:synopse_v001/features/06_comments/ui/widgets/comments_scaffold.dart';

class ExtUsers extends StatelessWidget {
  final String account;

  const ExtUsers({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return ExtUser(
      account: account,
    );
  }
}

class ExtUser extends StatefulWidget {
  final String account;

  const ExtUser({super.key, required this.account});

  @override
  State<ExtUser> createState() => _ExtUserState();
}

class _ExtUserState extends State<ExtUser> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: SAppBar(
          title: 'User Profile',
        ),
        body: Center(
          child: Text('ExtUser'),
        ),
      ),
    );
  }
}

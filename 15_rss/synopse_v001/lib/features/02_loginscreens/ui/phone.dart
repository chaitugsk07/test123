import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse_v001/core/asset_gen/assets.gen.dart';
import 'package:synopse_v001/core/theme/bloc/theme_bloc.dart';
import 'package:synopse_v001/core/utils/router.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "91";
    phoneNoController.text = "9652007006";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ThemeBloc, ThemeData>(
                builder: (context, themeData) {
                  return CupertinoSwitch(
                      value: themeData == ThemeData.dark(),
                      onChanged: (bool val) {
                        BlocProvider.of<ThemeBloc>(context)
                            .add(ThemeSwitchEvent());
                      });
                },
              ),
              Container(
                child: Assets.images.logo.image(width: 100, height: 100),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Roboto Condensed',
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Roboto Condensed',
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
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
                        "+",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: TextFormField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {}); // rebuild the widget tree
                        },
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: phoneNoController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone Number",
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (phoneNoController.text.length == 10)
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
                    onPressed: () {
                      context.push(verify,
                          extra: int.parse(
                              countryController.text + phoneNoController.text));
                    },
                    child: Text(
                      "send code",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Roboto Condensed', fontSize: 15),
                    ),
                  ),
                ),
              if (phoneNoController.text.length != 10)
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 45,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            30), // set the background color to blue
                      ),
                      child: Text(
                        "enter valid phone number",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                            fontFamily: 'Roboto Condensed',
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: GestureDetector(
                    child: Container(
                      width: 100,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "skip for now",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Roboto Condensed',
                            ),
                      ),
                    ),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoginSkipped', true);

                      context.push(splash);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    String pattern = r'^\d{10}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(phoneNumber);
  }
}

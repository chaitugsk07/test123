import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUserLoginInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('loginToken') ?? '';
  List<String> parts = token.split(".");
  if (parts.length != 3) {
    throw Exception("Invalid token");
  }

  String payloadPart = parts[1];
  String normalizedPayload = base64Url.normalize(payloadPart);
  String payloadString = utf8.decode(base64Url.decode(normalizedPayload));

  Map<String, dynamic> payload = jsonDecode(payloadString);

  String? userId = payload["https://hasura.io/jwt/claims"]["x-hasura-user-id"];
  int? exp = payload["exp"];
  DateTime dateTimeFromEpoch =
      DateTime.fromMillisecondsSinceEpoch(exp! * 1000, isUtc: true);

  DateTime oneDayEarlier = dateTimeFromEpoch.subtract(const Duration(days: 1));
  prefs.setString('loginToken', token);
  prefs.setString('account', userId.toString());
  prefs.setString('exp', oneDayEarlier.toIso8601String());
  prefs.setBool('isLoggedIn', true);
}

Future<void> logintokenvalidity() async {
  final prefs = await SharedPreferences.getInstance();
  String? expDateString = prefs.getString('exp');
  DateTime? expDate;
  if (expDateString != null) {
    expDate = DateTime.parse(expDateString);
  }
  if (expDate != null) {
    if (expDate.isAfter(DateTime.now())) {
      prefs.setBool('isLoggedIn', true);
    } else {
      const url =
          'https://acceptable-etty-chaitugsk07.koyeb.app/v1/verifyToken';

      final loginToken = prefs.getString('loginToken');

      Uri uri = Uri.parse('$url?token=$loginToken');
      try {
        var response = await http.post(uri);
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data.substring(0, 6) == "Bearer") {
            prefs.setString('loginToken', data);
            storeUserLoginInfo();
            prefs.setBool('isLoggedIn', true);
          } else {
            prefs.setBool('isLoggedIn', true);
          }
        } else {
          prefs.setBool('isLoggedIn', false);
        }
      } catch (error) {
        prefs.setBool('isLoggedIn', false);
      }
      prefs.setBool('isLoggedIn', true);
    }
  } else {
    prefs.setBool('isLoggedIn', false);
  }
}

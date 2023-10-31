import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'verifiy_otp_event.dart';
part 'verifiy_otp_state.dart';

enum VerifyOTPStatus { loading, success, failure }

class VerifyOTPBloc extends Bloc<VerifyOTPEvent, VerifyOTPState> {
  VerifyOTPBloc()
      : super(const VerifyOTPState(status: VerifyOTPStatus.loading)) {
    // Initial Event
    on<VerifyOTPForValidPhNo>(
      _onVerifyOTP,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onVerifyOTP(
      VerifyOTPForValidPhNo event, Emitter<VerifyOTPState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('phoneNumber', event.phoneNumber);
    const url = 'https://acceptable-etty-chaitugsk07.koyeb.app/v1/verifyOTP';
    final phoneNumber = event.phoneNumber;
    Uri uri = Uri.parse('$url?phone=$phoneNumber&otp=${event.otp}');
    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data == "request fail") {
          emit(state.copyWith(status: VerifyOTPStatus.failure));
        } else if (data.toString().length > 200) {
          print(data.toString());
          await prefs.setString('auth', data);
          await prefs.setBool('isLoggedIn', true);
          await prefs.setBool('isLoginSkipped', false);

          emit(state.copyWith(status: VerifyOTPStatus.success));
        } else {
          emit(state.copyWith(status: VerifyOTPStatus.failure));
        }
      } else {
        emit(state.copyWith(status: VerifyOTPStatus.failure));
      }
    } catch (error) {
      emit(state.copyWith(status: VerifyOTPStatus.failure));
    }
  }
}

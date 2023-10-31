import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show debugPrint, immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'send_otp_event.dart';
part 'send_otp_state.dart';

enum SendOTPStatus { loading, success, failure }

class SendOTPBloc extends Bloc<SendOTPEvent, SendOTPState> {
  SendOTPBloc() : super(const SendOTPState(status: SendOTPStatus.loading)) {
    // Initial Event
    on<SendOTPForValidPhNo>(
      _onSendOTP,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSendOTP(
      SendOTPForValidPhNo event, Emitter<SendOTPState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('phoneNumber', event.phoneNumber);
    const url = 'https://acceptable-etty-chaitugsk07.koyeb.app/v1/otp1';
    final phoneNumber = event.phoneNumber;
    Uri uri = Uri.parse('$url?phone=$phoneNumber');
    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data == "success") {
          emit(state.copyWith(status: SendOTPStatus.success));
        } else {
          emit(state.copyWith(status: SendOTPStatus.failure));
        }
      } else {
        emit(state.copyWith(status: SendOTPStatus.failure));
      }
    } catch (error) {
      emit(state.copyWith(status: SendOTPStatus.failure));
    }
  }
}

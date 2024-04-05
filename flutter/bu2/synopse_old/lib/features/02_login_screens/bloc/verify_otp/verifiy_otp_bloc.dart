import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/set_token.dart';

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

    on<VerifyOTPForValidPhNoMicrosoft>(
      _onVerifyOTPMicrosoft,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onVerifyOTP(
      VerifyOTPForValidPhNo event, Emitter<VerifyOTPState> emit) async {
    const url = 'https://acceptable-etty-chaitugsk07.koyeb.app/v1/verifyOTP';
    final country = event.country;
    final phoneno = event.phoneno;
    final otp = event.otp;
    final name = event.name;
    final googleEmail = event.googleEmail;
    final googleId = event.googleId;
    final googlePhotoUrl = event.googlePhotoUrl;
    final googlePhotoValid = event.googlePhotoValid;
    Uri uri = Uri.parse(
        '$url?country=$country&phone=$phoneno&otp=$otp&name=$name&google_email=$googleEmail&google_id=$googleId&google_photo_url=$googlePhotoUrl&google_photo_valid=$googlePhotoValid');
    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.substring(0, 6) == "Bearer") {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('loginToken', data);
          storeUserLoginInfo();
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

  FutureOr<void> _onVerifyOTPMicrosoft(VerifyOTPForValidPhNoMicrosoft event,
      Emitter<VerifyOTPState> emit) async {
    const url =
        'https://acceptable-etty-chaitugsk07.koyeb.app/v1/verifyOTPMicrosoft';
    final country = event.country;
    final phoneno = event.phoneno;
    final otp = event.otp;
    final microsoftname = event.microsoftName;
    final microsofEmail = event.microsoftEmail;
    final microsoftId = event.microsoftId;
    Uri uri = Uri.parse(
        '$url?country=$country&phone=$phoneno&otp=$otp&microsoft_name=$microsoftname&microsoft_email=$microsofEmail&microsoft_id=$microsoftId');
    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.substring(0, 6) == "Bearer") {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('loginToken', data);
          storeUserLoginInfo();
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

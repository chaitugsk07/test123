import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'verify_phone_email_event.dart';
part 'verify_phone_email_state.dart';

enum VerifyPhoneEmailStatus {
  loading,
  success,
  account,
  alreadyexists,
  failure
}

class VerifyPhoneEmailBloc
    extends Bloc<VerifyPhoneEmailEvent, VerifyPhoneEmailState> {
  VerifyPhoneEmailBloc()
      : super(const VerifyPhoneEmailState(
            status: VerifyPhoneEmailStatus.loading)) {
    // Initial Event
    on<VerifyPhoneEmailForValidPhNo>(
      _onVerifyPhoneEmail,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onVerifyPhoneEmail(VerifyPhoneEmailForValidPhNo event,
      Emitter<VerifyPhoneEmailState> emit) async {
    const url = 'https://acceptable-etty-chaitugsk07.koyeb.app/v1/useraccounts';
    final country = event.country;
    final phoneno = event.phoneno;
    Uri uri = Uri.parse('$url?country=$country&phone=$phoneno');
    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        int numberOfItems = data.length;
        if (numberOfItems == 0 ||
            (event.accountType == "google" && data['google'] == "na") ||
            (event.accountType == "microsoft" && data['microsoft'] == "na")) {
          emit(state.copyWith(status: VerifyPhoneEmailStatus.success));
        } else if (event.accountType == "google" &&
            event.email != data['google']) {
          emit(state.copyWith(
              status: VerifyPhoneEmailStatus.alreadyexists,
              regEmail: data['google']));
        } else if (event.accountType == "microsoft" &&
            event.email != data['microsoft']) {
          emit(state.copyWith(
              status: VerifyPhoneEmailStatus.alreadyexists,
              regEmail: data['microsoft']));
        } else {
          emit(state.copyWith(status: VerifyPhoneEmailStatus.failure));
        }
      } else {
        emit(state.copyWith(status: VerifyPhoneEmailStatus.failure));
      }
    } catch (error) {
      emit(state.copyWith(status: VerifyPhoneEmailStatus.failure));
    }
  }
}

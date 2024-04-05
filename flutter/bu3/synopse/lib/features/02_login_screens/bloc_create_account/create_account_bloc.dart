import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/set_token.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

enum CreateAccountStatus { loading, success, failure }

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc()
      : super(const CreateAccountState(status: CreateAccountStatus.loading)) {
    on<CreateAccountForValidGmail>(
      _onCreateAccount,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onCreateAccount(CreateAccountForValidGmail event,
      Emitter<CreateAccountState> emit) async {
    const url = 'https://acceptable-etty-chaitugsk07.koyeb.app/v1/creategmail';
    final name = event.name;
    final googleEmail = event.googleEmail;
    final googleId = event.googleId;
    final googlePhotoUrl = event.googlePhotoUrl;
    final googlePhotoValid = event.googlePhotoValid;
    Uri uri = Uri.parse(
        '$url?name=$name&google_email=$googleEmail&google_id=$googleId&google_photo_url=$googlePhotoUrl&google_photo_valid=$googlePhotoValid');
    try {
      var response = await http.post(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.substring(0, 6) == "Bearer") {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('loginToken', data);
          storeUserLoginInfo();
          emit(state.copyWith(status: CreateAccountStatus.success));
        } else {
          emit(state.copyWith(status: CreateAccountStatus.failure));
        }
      } else {
        emit(state.copyWith(status: CreateAccountStatus.failure));
      }
    } catch (error) {
      emit(state.copyWith(status: CreateAccountStatus.failure));
    }
  }
}

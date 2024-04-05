import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/set_token.dart';

part 'check_user_event.dart';
part 'check_user_state.dart';

enum CheckUserStatus { loading, phone, loggedin, failure }

class CheckUserBloc extends Bloc<CheckUserEvent, CheckUserState> {
  CheckUserBloc()
      : super(const CheckUserState(status: CheckUserStatus.loading)) {
    // Initial Event
    on<CheckUserExistsOrNot>(
      _onCheckUserExistsOrNot,
      transformer: droppable(),
    );
  }

  void _onCheckUserExistsOrNot(
      CheckUserExistsOrNot event, Emitter<CheckUserState> emit) async {
    const url = 'https://acceptable-etty-chaitugsk07.koyeb.app/v1/3/account';
    final type = event.type;
    final email = event.email;
    final id = event.id;
    Uri uri = Uri.parse('$url?type=$type&email=$email&id=$id');
    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data == "no valid account") {
          emit(state.copyWith(status: CheckUserStatus.phone));
        } else if (data.substring(0, 6) == "Bearer") {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('loginToken', data);
          storeUserLoginInfo();
          emit(state.copyWith(status: CheckUserStatus.loggedin));
        } else {
          emit(state.copyWith(status: CheckUserStatus.failure));
        }
      } else {
        emit(state.copyWith(status: CheckUserStatus.failure));
      }
    } catch (error) {
      emit(state.copyWith(status: CheckUserStatus.failure));
    }
  }
}

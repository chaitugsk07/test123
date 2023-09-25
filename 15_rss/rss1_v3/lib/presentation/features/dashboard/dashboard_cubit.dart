import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rss1_v3/core/utils/ui_state.dart';
import 'package:rss1_v3/presentation/model/characters/ui_character.dart';
import 'package:rss1_v3/presentation/model/characters/ui_character_mapper.dart';

class DashboardCubit extends Cubit<UiState<UiCharacterList>> {
  DashboardCubit() : super(Initial()) {
    loadDashboard();
  }
  final uiCharacterMapper = GetIt.I.get<UiCharacterMapper>();

  void loadDashboard() {
    emit(Loading());
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rss1_v3/core/presentation/core/widgets/platform_scaffold.dart';
import 'package:rss1_v3/core/utils/ui_state.dart';
import 'package:rss1_v3/presentation/features/characters/characters_page.dart';
import 'package:rss1_v3/presentation/features/dashboard/dashboard_cubit.dart';
import 'package:rss1_v3/presentation/features/locations/locations_page.dart';
import 'package:rss1_v3/presentation/model/characters/ui_character.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: BlocListener<DashboardCubit, UiState<UiCharacterList>>(
        child: const TabBarPage(),
        listener: (context, state) {},
      ),
    );
  }
}

class TabBarPage extends StatelessWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: RmScaffold(
        androidAppBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('Characters')),
              Tab(child: Text('Locations')),
              Tab(child: Text('Episodes')),
            ],
          ),
          title: text(),
        ),
        iosNavBar: CupertinoNavigationBar(
          middle: text(),
        ),
        body: BlocBuilder<DashboardCubit, UiState<UiCharacterList>>(
          builder: (context, state) {
            return const TabBarView(
              children: [
                CharactersPage(),
                LocationsPage(),
                Icon(Icons.directions_bike),
              ],
            );
          },
        ),
      ),
    );
  }

  Text text() => const Text('Rick & Morty');
}

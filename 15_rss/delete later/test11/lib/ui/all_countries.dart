import 'package:flutter/material.dart';
import 'package:graphql_example/bloc/countries_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountriesPage extends StatelessWidget {
  const CountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countries')),
      body: Center(
        child: BlocBuilder<CountriesBloc, CountriesState>(
          builder: (context, state) {
            if (state is CountriesLoadInProgress) {
              return const CircularProgressIndicator();
            }
            if (state is CountriesLoadSuccess) {
              return ListView.builder(
                itemCount: state.countries.length,
                itemBuilder: (context, index) {
                  final country = state.countries[index];
                  return ListTile(
                    key: Key(country.native),
                    title: Text(country.name),
                    trailing: Text(country.emoji),
                    subtitle: Text(country.capital),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => ));
                    },
                  );
                },
              );
            }
            return const Text('Oops something went wrong!');
          },
        ),
      ),
    );
  }
}

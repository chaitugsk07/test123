import 'package:bloc/bloc.dart';
import 'package:graphql_example/api/country_api_client.dart';
import 'package:graphql_example/api/models/models.dart';
import 'package:meta/meta.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc({required CountriesApiClient countriesApiClient})
      : _countriesApiClient = countriesApiClient,
        super(CountriesLoadInProgress()) {
    on<CountriesFetchStarted>(_onCountriesFetchStarted);
  }

  final CountriesApiClient _countriesApiClient;

  Future<void> _onCountriesFetchStarted(
      CountriesFetchStarted event, Emitter<CountriesState> emit) async {
    emit(CountriesLoadInProgress());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final countries = await _countriesApiClient.getCountries();
      final singleCountry = await _countriesApiClient.getCountryById("UZ");
      print("COUNTRY NAME:${singleCountry.name}");
      emit(CountriesLoadSuccess(countries));
    } catch (error) {
      print("ERRROR:$error");
      emit(CountiresLoadFailure());
    }
  }
}

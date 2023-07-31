import 'package:bloc/bloc.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_event.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_state.dart';
import 'package:poc_supero_btt/models/person.dart';
import 'package:poc_supero_btt/models/city.dart';
import 'package:poc_supero_btt/models/state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(const PersonDefaultState(person: Person.empty())) {
    on<PersonEventUpdate>(_onPersonEventUpdate);
  }

  Person _person = const Person.empty();

  Person get person => _person;

  void _onPersonEventUpdate(PersonEventUpdate event, Emitter<PersonState> emit) {
    _updatePerson(
      name: event.name,
      cpf: event.cpf,
      nomeMae: event.nomeMae,
      selectedState: event.selectedState,
      stateAddress: event.stateAddress,
      stateId: event.stateId,
      selectedCity: event.selectedCity,
      city: event.city,
      cityId: event.cityId,
      photoBase64: event.photoBase64,
      photoPath: event.photoPath,
      nomePai: event.nomePai,
      address: event.address,
    );
    emit(PersonDefaultState(person: _person));
  }

  _updatePerson({
    String? name,
    String? cpf,
    String? nomeMae,
    StateData? selectedState,
    String? stateAddress,
    int? stateId,
    CityData? selectedCity,
    String? city,
    int? cityId,
    String? photoBase64,
    String? photoPath,
    String? nomePai,
    String? address,
  }) {
    _person = _person.copyWith(
      name: name,
      cpf: cpf,
      nomeMae: nomeMae,
      selectedState: selectedState,
      stateAddress: stateAddress,
      stateId: stateId,
      selectedCity: selectedCity,
      city: city,
      cityId: cityId,
      photoBase64: photoBase64,
      photoPath: photoPath,
      nomePai: nomePai,
      address: address,
    );
  }
}

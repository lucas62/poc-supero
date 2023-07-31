import 'package:equatable/equatable.dart';
import 'package:poc_supero_btt/models/city.dart';
import 'package:poc_supero_btt/models/state.dart';

abstract class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object?> get props => [];
}

class PersonEventUpdate extends PersonEvent {
  final String? name;
  final String? cpf;
  final String? nomeMae;
  final StateData? selectedState;
  final String? stateAddress;
  final int? stateId;
  final CityData? selectedCity;
  final String? city;
  final int? cityId;
  final String? photoBase64;
  final String? photoPath;
  final String? nomePai;
  final String? address;

  const PersonEventUpdate({
    this.name,
    this.cpf,
    this.nomeMae,
    this.selectedState,
    this.stateAddress,
    this.stateId,
    this.selectedCity,
    this.city,
    this.cityId,
    this.photoBase64,
    this.photoPath,
    this.nomePai,
    this.address,
  });

  @override
  List<Object?> get props => [
    name,
    cpf,
    nomeMae,
    selectedState,
    stateAddress,
    stateId,
    selectedCity,
    city,
    cityId,
    photoBase64,
    photoPath,
    nomePai,
    address,
  ];
}

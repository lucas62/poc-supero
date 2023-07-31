import 'package:equatable/equatable.dart';
import 'package:poc_supero_btt/models/city.dart';
import 'package:poc_supero_btt/models/state.dart';

class Person extends Equatable {
  final String name;
  final String cpf;
  final String nomeMae;
  final StateData? selectedState;
  final String stateAddress;
  final int stateId;
  final CityData? selectedCity;
  final String city;
  final int cityId;
  final String photoBase64;
  final String photoPath;
  final String nomePai;
  final String address;

  const Person({
    required this.name,
    required this.cpf,
    required this.nomeMae,
    this.selectedState,
    required this.stateAddress,
    required this.stateId,
    this.selectedCity,
    required this.city,
    required this.cityId,
    required this.photoBase64,
    required this.photoPath,
    required this.nomePai,
    required this.address,
  });

  const Person.empty({
    this.name = '',
    this.cpf = '',
    this.nomeMae = '',
    this.selectedState,
    this.stateAddress = '',
    this.stateId = 0,
    this.selectedCity,
    this.city = '',
    this.cityId = 0,
    this.photoBase64 = '',
    this.photoPath = '',
    this.nomePai = '',
    this.address = '',
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      nomeMae: json['nomeMae'] as String,
      stateAddress: json['stateAddress'] as String,
      stateId: json['stateId'] as int,
      city: json['city'] as String,
      cityId: json['cityId'] as int,
      photoBase64: json['photoBase64'] as String,
      photoPath: json['photoPath'] as String,
      nomePai: json['nomePai'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cpf': cpf,
      'nomeMae': nomeMae,
      'stateAddress': stateAddress,
      'stateId': stateId,
      'city': city,
      'cityId': cityId,
      'photoBase64': photoBase64,
      'photoPath': photoPath,
      'nomePai': nomePai,
      'address': address,
    };
  }

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

  Person copyWith({
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
    return Person(
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      nomeMae: nomeMae ?? this.nomeMae,
      selectedState: selectedState ?? this.selectedState,
      stateAddress: stateAddress ?? this.stateAddress,
      stateId: stateId ?? this.stateId,
      selectedCity: selectedCity ?? this.selectedCity,
      city: city ?? this.city,
      cityId: cityId ?? this.cityId,
      photoBase64: photoBase64 ?? this.photoBase64,
      photoPath: photoPath ?? this.photoPath,
      nomePai: nomePai ?? this.nomePai,
      address: address ?? this.address,
    );
  }
}

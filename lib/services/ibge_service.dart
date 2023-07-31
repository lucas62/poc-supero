import 'package:dio/dio.dart';

import '../models/state.dart';
import '../models/city.dart';

class IbgeService {
  final Dio _dio = Dio();

  Future<List<StateData>> fetchStatesData() async {
    try {
      final response = await _dio.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome');

      final List<dynamic> data = response.data;
      final List<StateData> states = data.map((json) => StateData.fromJson(json as Map<String, dynamic>)).toList();

      return states;
    } catch (error) {
      print('Error while fetching states data: $error');
      return [];
    }
  }

  Future<List<CityData>> fetchCitiesData(int stateId) async {
    try {
      final response = await _dio.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados/$stateId/municipios');

      final List<dynamic> data = response.data;
      final List<CityData> cities = data.map((json) => CityData.fromJson(json as Map<String, dynamic>)).toList();

      // Ordenar a lista de cidades por ordem alfabética
      cities.sort((a, b) => a.nome.compareTo(b.nome));

      return cities;
    } catch (error) {
      print('Error while fetching cities data: $error');
      return [];
    }
  }
}

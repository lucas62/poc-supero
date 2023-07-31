import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:poc_supero_btt/models/person.dart';
import 'package:poc_supero_btt/config/auth_manager.dart';

import '../database/database.dart';

class ApiService {
  final Dio _dio = Dio();
  final AuthManager _authManager = GetIt.instance<AuthManager>();

  ApiService() {
    _authManager.initSharedPreferences();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add the token to the request header
        final token = _authManager.authToken;

        print(token);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        // Log the request headers for debugging purposes
        print('Request headers: ${options.headers}');
        return handler.next(options);
      },
    ));
  }

  Future<void> postPersonForm(Person person) async {
    try {
      final response = await _dio
          .post('https://testapi.io/api/lucasapr/resource/person', data: {
        'name': person.name,
        'cpf': person.cpf,
        'nomeMae': person.nomeMae,
        'state': person.stateAddress,
        'city': person.city,
        'stateId': person.stateId,
        'cityId': person.cityId,
        'photo': person.photoBase64,
        'nomePai': person.nomePai,
        'address': person.address,
      });

      // Handle the response if needed
    } catch (error) {
      print('Error during form submission: $error');

      // If there's an error during form submission, save the person data to the local database.
      final DbManager dbManager = GetIt.instance<DbManager>();
      await dbManager.insertModel(person);
    }
  }

  Future<List<Person>> getPersonForm(Person person) async {
    try {
      final response =
          await _dio.get('https://testapi.io/api/lucasapr/resource/person');

      final List<dynamic> data = response.data;
      final List<Person> personsList = data
          .map((json) => Person.fromJson(json as Map<String, dynamic>))
          .toList();

      return personsList;
    } catch (error) {
      print(error);
      return [];
    }
  }
}

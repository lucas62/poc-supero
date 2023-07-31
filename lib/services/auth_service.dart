import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:poc_supero_btt/config/auth_manager.dart';

class AuthService {
  final AuthManager _authManager = GetIt.instance<AuthManager>();
  final Dio _dio = Dio(); // Create an instance of Dio

  Future<void> authenticateUser() async {
    try {
      final response = await _dio.get('https://testapi.io/api/lucasapr/login');

      final responseData = response.data;
      var responseJson = json.decode(responseData);
      String token = responseJson['token'];

      await _authManager.saveAuthToken(token);
    } catch (error) {
      print('Authentication error: $error');
    }
  }

  Future<void> logout() async {
    await _authManager.clearAuthToken();
  }
}

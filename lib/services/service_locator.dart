import 'package:get_it/get_it.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_bloc.dart';
import 'package:poc_supero_btt/config/auth_manager.dart';
import 'package:poc_supero_btt/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database.dart';
import 'auth_service.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Registrando as dependências aqui
  serviceLocator.registerLazySingleton<PersonBloc>(() => PersonBloc());
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService());
  serviceLocator.registerLazySingleton<AuthManager>(() => AuthManager());
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());

  serviceLocator.registerLazySingleton<DbManager>(() => DbManager());
}

Future<void> setupSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
}

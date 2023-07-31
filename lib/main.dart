import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_bloc.dart';
import 'package:poc_supero_btt/pages/person_info_page.dart';
import 'package:poc_supero_btt/services/api_services.dart';
import 'package:poc_supero_btt/services/auth_service.dart';
import 'package:poc_supero_btt/services/service_locator.dart';

import 'database/database.dart';
import 'models/person.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupSharedPreferences();
  setupServiceLocator();

  try {
    // Get the instance of AuthService from GetIt
    final AuthService authService = GetIt.instance<AuthService>();

    // Call the authenticateUser function
    await authService.authenticateUser();

    // Get the instance of DbManager from GetIt
    final DbManager dbManager = GetIt.instance<DbManager>();

    // Open the database
    await dbManager.openDb();

    startDataSendingTimer(dbManager);
  } catch (e) {
    print(e);
  }

  runApp(const MyApp());
}

void startDataSendingTimer(DbManager dbManager) {
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    // Get the data from the local database
    final List<Person> dataToSend = await dbManager.getModelList();

    // If there is data in the database, try to resend it using ApiService
    if (dataToSend.isNotEmpty) {
      final ApiService apiService = ApiService();

      for (final person in dataToSend) {
        await apiService.postPersonForm(person);

        // After successfully sending, remove the data from the local database
        await dbManager.deleteModel(person);
      }
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PersonBloc>(
            create: (BuildContext context) => PersonBloc(),
          )
        ],
        child: MaterialApp(
          title: 'Cadastro Pessoa Física',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const PersonInfoPage(),
        ));
  }
}

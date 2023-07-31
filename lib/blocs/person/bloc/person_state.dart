import 'package:poc_supero_btt/models/person.dart';

abstract class PersonState {
  const PersonState();
}

class PersonInitial extends PersonState {}

class PersonDefaultState extends PersonState {
  final Person person;

  const PersonDefaultState({
    required this.person,
  });
}
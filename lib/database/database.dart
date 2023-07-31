import 'dart:async';
import 'package:path/path.dart';
import 'package:poc_supero_btt/models/person.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "person_database.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE person( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, cpf TEXT, nomeMae TEXT, stateAddress TEXT, stateId INTEGER, city TEXT, cityId INTEGER, photoBase64 TEXT, photoPath TEXT, nomePai TEXT, address TEXT);",
      );
    });
    return _database;
  }

  Future insertModel(Person model) async {
    await openDb();
    return await _database.insert('person', model.toJson());
  }

  Future<List<Person>> getModelList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('person');

    return List.generate(maps.length, (i) {
      return Person(
          name: maps[i]['name'],
          cpf: maps[i]['cpf'],
          nomeMae: maps[i]['nomeMae'],
          stateAddress: maps[i]['stateAddress'],
          stateId: maps[i]['stateId'],
          city: maps[i]['city'],
          cityId: maps[i]['cityId'],
          photoBase64: maps[i]['photoBase64'],
          photoPath: maps[i]['photoPath'],
          nomePai: maps[i]['nomePai'],
          address: maps[i]['address']);
    });
  }

  Future<int> updateModel(Person model) async {
    await openDb();
    return await _database.update('person', model.toJson(),
        where: "cpf = ?", whereArgs: [model.cpf]);
  }

  Future<void> deleteModel(Person model) async {
    await openDb();
    await _database.delete('person', where: "cpf = ?", whereArgs: [model.cpf]);
  }
}

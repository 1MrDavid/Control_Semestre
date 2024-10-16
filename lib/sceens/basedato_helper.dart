import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

var path;

class BasedatoHelper {
  Future<Database> _openDatabase() async {
    final dataBasePath = await getDatabasesPath();
    path = join(dataBasePath, 'mydatabase.db');

    return openDatabase(path, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE notas_estudiante (id INTEGER PRIMARY KEY, ESTMAT TEXT, ESTNOT INT, ESTPRF TEXT)',
      );
    }, version: 2);
  }

  Future<void> addData(materia, nota, profesor) async {
    final database = await _openDatabase();
    await database.insert('notas_estudiante',
        {'ESTMAT': materia, 'ESTNOT': nota, 'ESTPRF': profesor},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await database.close();
  }

  Future<List<Map<String, dynamic>>> mostrar() async {
    final database = await _openDatabase();
    final data = await database.query('notas_estudiante');
    await database.close();
    return data;
  }

  Future<void> updateData(
      int id, String newName, int newGrade, String newProfessor) async {
    final database = await _openDatabase();
    await database.update(
      'notas_estudiante',
      {'ESTMAT': newName, 'ESTNOT': newGrade, 'ESTPRF': newProfessor},
      where: 'id = ?',
      whereArgs: [id],
    );
    await database.close();
  }

  Future<void> deleteData(int id) async {
    final database = await _openDatabase();

    await database.delete(
      'notas_estudiante',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double?> mostrarPromedio() async {
    final database = await _openDatabase();
    var query = Sqflite.firstIntValue(await database
        .rawQuery('SELECT sum(ESTNOT)/count(*) from notas_estudiante'));
    return query?.toDouble();
  }
}

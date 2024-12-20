import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

var path;

class BasedatoHelper {
  Future<Database> _openDatabase() async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, 'mydatabase.db');

    return openDatabase(path, onCreate: (db, version) async {
      // Crear tablas
      await db.execute(
        'CREATE TABLE IF NOT EXISTS notas_estudiante (id INTEGER PRIMARY KEY, ESTMAT TEXT, ESTNOT INT, ESTPRF TEXT, ESTCOD TEXT)',
      );

      await db.execute(
        'CREATE TABLE IF NOT EXISTS materias (MATID INTEGER PRIMARY KEY, MATNOM TEXT, MATSEM TEXT, MATSEC TEXT, MATNT1 INT, MATNT2 INT, MATNT3 INT)',
      );

      await db.execute(
          'CREATE TABLE IF NOT EXISTS tareas (TARTID INTEGER PRIMARY KEY, TARMID INTEGER, TARMNO TEXT, TARDES TEXT, TARFEC INTEGER, TARSTS TEXT)');

      await db.execute(
          'CREATE TABLE IF NOT EXISTS journal_secciones (SECCID INTEGER PRIMARY KEY, SECCOD TEXT, SECFES INT, SECFET INT, SECSTS TEXT)');
    }, version: 4);
  }

  Future<List<Map<String, dynamic>>> mostrar() async {
    final database = await _openDatabase();
    final data = await database.rawQuery('''
      SELECT 
        notas_estudiante.id,
        notas_estudiante.ESTMAT,
        notas_estudiante.ESTNOT,
        notas_estudiante.ESTPRF,
        materias.MATNT1,
        materias.MATNT2,
        materias.MATNT3
      FROM notas_estudiante
      INNER JOIN materias ON notas_estudiante.ESTMAT = materias.MATNOM
      ''');
    await database.close();
    return data;
  }

  Future<List<Map<String, dynamic>>> mostrarUno(id) async {
    final database = await _openDatabase();
    final data = await database.rawQuery('''
      SELECT 
        notas_estudiante.id,
        notas_estudiante.ESTMAT,
        notas_estudiante.ESTNOT,
        notas_estudiante.ESTPRF,
        materias.MATNT1,
        materias.MATNT2,
        materias.MATNT3,
        materias.MATSEC,
        materias.MATSEM
      FROM notas_estudiante
      INNER JOIN materias ON notas_estudiante.ESTMAT = materias.MATNOM
      where notas_estudiante.id = ?
      ''', [id]);
    await database.close();
    return data;
  }

  Future<List<Map<String, dynamic>>> mostrarSeccionActual() async {
    final database = await _openDatabase();

    final data = await database.rawQuery('''
      SELECT 
        notas_estudiante.id,
        notas_estudiante.ESTMAT,
        notas_estudiante.ESTNOT,
        notas_estudiante.ESTPRF,
        materias.MATNT1,
        materias.MATNT2,
        materias.MATNT3
      FROM notas_estudiante
      INNER JOIN materias ON notas_estudiante.ESTMAT = materias.MATNOM
      INNER JOIN journal_secciones ON notas_estudiante.ESTCOD = journal_secciones.SECCOD
      WHERE SECSTS = 'S'
      ''');
    await database.close();
    return data;
  }

  Future<List<Map<String, dynamic>>> mostrarPorSeccion(id) async {
    final database = await _openDatabase();
    final data = await database.rawQuery('''
      SELECT 
        notas_estudiante.id,
        notas_estudiante.ESTMAT,
        notas_estudiante.ESTNOT,
        notas_estudiante.ESTPRF,
        materias.MATNT1,
        materias.MATNT2,
        materias.MATNT3
      FROM notas_estudiante
      INNER JOIN materias ON notas_estudiante.ESTMAT = materias.MATNOM
      INNER JOIN journal_secciones ON notas_estudiante.ESTCOD = journal_secciones.SECCOD
      WHERE SECCOD = ?
      ''', [id]);
    await database.close();
    return data;
  }

  Future<void> addData(String materia, String profesor, int corte1, int corte2,
      int corte3, String seccion, String semestre) async {
    // Comprueba que las notas no sean negativas
    if (corte1 < 0 || corte2 < 0 || corte3 < 0) {
      throw Exception("Las notas no pueden ser negativas");
    }

    final database = await _openDatabase();

    // Inserta datos de la materia
    await database.insert('materias', {
      'MATNOM': materia, // Nombre de la materia
      'MATSEC': seccion, // Seccion correspondiente al periodo academico
      'MATSEM': semestre, // Semestre al que pertenece la materia
      'MATNT1': corte1, // Nota del corte 1
      'MATNT2': corte2, // Nota del corte 2
      'MATNT3': corte3 // Nota del corte 3
    });

    // Inserta datos de la materia
    await database.insert(
        'notas_estudiante',
        {
          'ESTMAT': materia, // Nombre de la materia
          'ESTPRF': profesor, // Nombre del profesor
          'ESTNOT': corte1 + corte2 + corte3, // Nota total
          'ESTCOD': seccion
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateData(
      int id,
      String newMateria,
      String newProfessor,
      int newCorte1,
      int newCorte2,
      int newCorte3,
      String newSeccion,
      String newSemestre) async {
    final database = await _openDatabase();

    await database.update(
      'materias',
      {
        'MATNOM': newMateria,
        'MATNT1': newCorte1,
        'MATNT2': newCorte2,
        'MATNT3': newCorte3,
        'MATSEC': newSeccion,
        'MATSEM': newSemestre,
      },
      where: 'MATID = ?',
      whereArgs: [id],
    );

    await database.update(
      'notas_estudiante',
      {
        'ESTMAT': newMateria,
        'ESTPRF': newProfessor,
        'ESTNOT': newCorte1 + newCorte2 + newCorte3
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteData(int id) async {
    final database = await _openDatabase();

    await database.delete(
      'materias',
      where: 'MATID = ?',
      whereArgs: [id],
    );

    await database.delete(
      'notas_estudiante',
      where: 'id = ?',
      whereArgs: [id],
    );

    await database.delete(
      'tareas',
      where: 'TARMID = ?',
      whereArgs: [id],
    );
  }

  Future<double?> mostrarPromedio() async {
    final database = await _openDatabase();
    var query = Sqflite.firstIntValue(await database
        .rawQuery('SELECT sum(ESTNOT)/count(*) from notas_estudiante'));
    return query?.toDouble();
  }

  Future<double?> mostrarPromedioSeccionActual() async {
    final database = await _openDatabase();

    // Obtenemos el código de la sección activa
    var seccionActivaQuery = await database.rawQuery('''
    SELECT SECCOD FROM journal_secciones WHERE SECSTS = 'S' LIMIT 1
  ''');

    // Verificamos si se encontró una sección activa
    if (seccionActivaQuery.isEmpty) {
      return null; // No hay sección activa
    }

    // Obtenemos el código de la sección activa y lo convertimos a String
    String seccionActiva = seccionActivaQuery[0]['SECCOD'] as String;

    // Ahora usamos ese código en la consulta para calcular el promedio
    var query = Sqflite.firstIntValue(await database.rawQuery('''
    SELECT SUM(ESTNOT) / COUNT(*) 
    FROM notas_estudiante 
    INNER JOIN journal_secciones ON notas_estudiante.ESTCOD = journal_secciones.SECCOD 
    WHERE journal_secciones.SECCOD = ?
  ''', [seccionActiva]));

    return query?.toDouble();
  }

  Future<double?> mostrarPromedioPorSeccion(seccion) async {
    final database = await _openDatabase();

    var query = Sqflite.firstIntValue(await database.rawQuery('''
    SELECT SUM(ESTNOT) / COUNT(*) 
    FROM notas_estudiante 
    INNER JOIN journal_secciones ON notas_estudiante.ESTCOD = journal_secciones.SECCOD 
    WHERE journal_secciones.SECCOD = ?
  ''', [seccion]));

    return query?.toDouble();
  }

  Future<double?> contarSecciones() async {
    final database = await _openDatabase();
    var query = Sqflite.firstIntValue(
        await database.rawQuery('SELECT count(*) from journal_secciones'));
    return query?.toDouble();
  }

  Future<void> addTask(String materiaNombre, String descripcion, int fecha,
      String estatus) async {
    // Validaciones de los parámetros
    if (materiaNombre.isEmpty) {
      throw Exception("El nombre de la materia no puede estar vacío");
    }
    if (descripcion.isEmpty) {
      throw Exception("La descripción de la tarea no puede estar vacía");
    }
    if (fecha.toString().length != 8) {
      throw Exception(
          "La fecha debe tener exactamente 8 dígitos en formato DDMMAAAA");
    }
    if (!['pendiente', 'finalizada', 'incompleta']
        .contains(estatus.toLowerCase())) {
      throw Exception(
          "El estatus debe ser 'pendiente', 'finalizada' o 'incompleta'");
    }

    final database = await _openDatabase();

    // Obtener el ID de la materia a través del nombre de la materia
    final List<Map<String, dynamic>> materiaResult = await database.query(
      'materias',
      where: 'MATNOM = ?',
      whereArgs: [materiaNombre],
    );

    if (materiaResult.isEmpty) {
      throw Exception("Materia con el nombre '$materiaNombre' no encontrada.");
    }

    final materiaId = materiaResult[0]['MATID']; // Obtener el ID de la materia

    // Inserta datos en la tabla `tareas`
    await database.insert('tareas', {
      'TARMID': materiaId, // ID de la materia obtenido de la consulta
      'TARMNO': materiaNombre, // Nombre de la materia
      'TARDES': descripcion, // Descripción o título de la tarea
      'TARFEC': fecha, // Fecha de entrega en formato DDMMAAAA
      'TARSTS': estatus // Estatus de la tarea
    });
  }

  Future<List<Map<String, dynamic>>> mostrarTareas() async {
    final database = await _openDatabase();
    final data = await database.rawQuery('''
    SELECT 
      TARTID,
      TARMNO,  
      TARDES,    
      TARFEC,    
      TARSTS     
    FROM tareas
    ORDER BY TARFEC DESC
    ''');
    await database.close();
    return data;
  }

  Future<List<Map<String, dynamic>>> mostrarTareasSeccionActual() async {
    final database = await _openDatabase();

    // Obtenemos el código de la sección activa
    var seccionActivaQuery = await database.rawQuery('''
    SELECT SECCOD FROM journal_secciones WHERE SECSTS = 'S' LIMIT 1
  ''');

    // Obtenemos el código de la sección activa y lo convertimos a String
    String seccionActiva = seccionActivaQuery[0]['SECCOD'] as String;

    final data = await database.rawQuery('''
    SELECT 
      TARTID,
      TARMNO,  
      TARDES,    
      TARFEC,    
      TARSTS     
    FROM tareas
    INNER JOIN materias on tareas.TARMID = materias.MATID
    INNER JOIN notas_estudiante on materias.MATNOM = notas_estudiante.ESTMAT
    INNER JOIN Journal_Secciones on notas_estudiante.ESTCOD = Journal_Secciones.SECCOD
    WHERE SECCOD = ?
    ORDER BY TARFEC DESC
    ''', [seccionActiva]);
    await database.close();
    return data;
  }

  Future<List<Map<String, dynamic>>> mostrarTareasPorSeccion(seccion) async {
    final database = await _openDatabase();

    final data = await database.rawQuery('''
    SELECT 
      TARTID,
      TARMNO,  
      TARDES,    
      TARFEC,    
      TARSTS     
    FROM tareas
    INNER JOIN materias on tareas.TARMID = materias.MATID
    INNER JOIN notas_estudiante on materias.MATNOM = notas_estudiante.ESTMAT
    INNER JOIN Journal_Secciones on notas_estudiante.ESTCOD = Journal_Secciones.SECCOD
    WHERE SECCOD = ?
    ORDER BY TARFEC DESC
    ''', [seccion]);
    await database.close();
    return data;
  }

  // Método para obtener todos los nombres de materias
  Future<List<String>> obtenerNombresMaterias() async {
    final database = await _openDatabase();

    // Consulta que selecciona solo los nombres de las materias
    final List<Map<String, dynamic>> resultados =
        await database.query('materias', columns: ['MATNOM']);

    // Convertir los resultados en una lista de strings (nombres de materias)
    return List.generate(resultados.length, (index) {
      return resultados[index]['MATNOM'] as String;
    });
  }

  Future<void> deleteTask(int id) async {
    final database = await _openDatabase();

    await database.delete(
      'tareas',
      where: 'TARTID = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTask(
    int id,
    String newMateria,
    String newDescription,
    int newDate,
    String newSTS,
  ) async {
    final database = await _openDatabase();

    // Obtener el ID de la materia a través del nombre de la materia
    final List<Map<String, dynamic>> materiaResult = await database.query(
      'materias',
      where: 'MATNOM = ?',
      whereArgs: [newMateria],
    );

    if (materiaResult.isEmpty) {
      throw Exception("Materia con el nombre '$newMateria' no encontrada.");
    }

    final newMateriaID = materiaResult[0]['MATID'];

    await database.update(
      'tareas',
      {
        'TARMID': newMateriaID,
        'TARMNO': newMateria,
        'TARDES': newDescription,
        'TARFEC': newDate,
        'TARSTS': newSTS,
      },
      where: 'TARTID = ?',
      whereArgs: [id],
    );
  }

  Future<void> addSection(codigo, fechaInicio, fechaFin, esActiva) async {
    final database = await _openDatabase();

    if (esActiva == 'S') {
      await database.update(
        'journal_secciones',
        {'SECSTS': 'N'}, // Cambiar el estado de todas las secciones a 'N'
        where: 'SECSTS = ?',
        whereArgs: ['S'],
      );
    }

    // Inserta datos de la seccion
    await database.insert('journal_secciones', {
      'SECCOD': codigo,
      'SECFES': fechaInicio,
      'SECFET': fechaFin,
      'SECSTS': esActiva
    });
  }

  Future<void> deleteSection() async {
    final database = await _openDatabase();

    await database.delete(
      'journal_secciones',
    );
  }

  Future<void> deleteMaterias() async {
    final database = await _openDatabase();

    await database.delete(
      'materias',
    );
  }

  Future<List<String>> getSecciones() async {
    final database = await _openDatabase();

    // Consulta que selecciona solo las secciones
    // Primero la activa y luego las inactivas
    final List<Map<String, dynamic>> resultados = await database.query(
      'journal_secciones',
      columns: ['SECCOD'],
      orderBy:
          "CASE WHEN SECSTS = 'S' THEN 0 ELSE 1 END, SECCID", // Asegura que la sección activa aparezca primero
    );

    // Convertir los resultados en una lista de strings
    return List.generate(resultados.length, (index) {
      return resultados[index]['SECCOD'] as String;
    });
  }
}

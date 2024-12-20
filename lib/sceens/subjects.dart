import 'package:control_semestres/sceens/form_edit.dart';
import 'package:flutter/material.dart';
import 'basedato_helper.dart';
import 'functions_helper.dart';

class SubjectsScreen extends StatefulWidget {
  final int id;

  const SubjectsScreen({
    super.key,
    required this.id,
  });

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final dbHelper = BasedatoHelper();
  final fnHelper = FunctionsHelper();

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho total de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materia Detallada'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.mostrarUno(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            final Map<String, dynamic> data = snapshot.data!.first;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bloque para Código de Sección y Semestre en una fila
                  fnHelper.buildRow(
                    'Sección:',
                    'Semestre:',
                    isHeader: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Tarjeta para Sección
                      Expanded(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['MATSEC'], // Código de la sección
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16), // Espaciado entre las tarjetas

                      // Tarjeta para Semestre
                      Expanded(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['MATSEM'], // Nombre del semestre
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Espacio después de las tarjetas

                  // Bloque para Materia
                  const Text(
                    'Materia:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth, // Ocupar todo el ancho de la pantalla
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          data['ESTMAT'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16), // Espacio entre las tarjetas

                  // Bloque para Profesor
                  const Text(
                    'Profesor:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth, // Ocupar todo el ancho de la pantalla
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          data['ESTPRF'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16), // Espacio entre las tarjetas

                  // Bloque para los Cortes de la Materia
                  const Text(
                    'Cortes de la materia:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  fnHelper.buildThreeElementRow(
                    'Corte 1',
                    'Corte 2',
                    'Corte 3',
                    isHeader: true,
                  ),

                  // Fila para mostrar los tres cortes
                  SizedBox(
                    width: screenWidth,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: fnHelper.buildThreeElementRow(
                          '${data['MATNT1']}',
                          '${data['MATNT2']}',
                          '${data['MATNT3']}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.mostrarUno(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data!.isNotEmpty) {
            final data = snapshot.data!.first;

            return FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormEdit(
                      id: widget.id,
                      materia: data[
                          'ESTMAT'], // Datos actuales desde la base de datos
                      profesor: data[
                          'ESTPRF'], // Datos actuales desde la base de datos
                      corte1: data[
                          'MATNT1'], // Datos actuales desde la base de datos
                      corte2: data[
                          'MATNT2'], // Datos actuales desde la base de datos
                      corte3: data[
                          'MATNT3'], // Datos actuales desde la base de datos
                      seccion: data[
                          'MATSEC'], // Datos actuales desde la base de datos
                      semestre: data[
                          'MATSEM'], // Datos actuales desde la base de datos
                    ),
                  ),
                );

                // Si el resultado no es nulo, significa que los datos han sido actualizados
                if (result == true) {
                  setState(() {});
                }
              },
              child: const Icon(Icons.edit),
            );
          } else {
            return Container(); // No muestra el botón si no hay datos cargados
          }
        },
      ),
    );
  }
}

import 'form_edit.dart';
import 'package:flutter/material.dart';
import 'basedato_helper.dart';
import 'form_add.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradesScreen> {
  final dbHelper = BasedatoHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Carga de datos de la base de datos
        future: dbHelper.mostrar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            final List<Map<String, dynamic>> data = snapshot.data!;

            return Column(
              children: [
                // Encabezado de la tabla
                _buildRow('Materia', 'Nota', isHeader: true),
                const Divider(),

                // Filas de los datos
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // Navega a la pantalla de edición con los datos de la fila seleccionada
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormEdit(
                                    id: data[index]['id'],
                                    materia: data[index]['ESTMAT'],
                                    nota: data[index]['ESTNOT'],
                                    profesor: data[index]['ESTPRF'],
                                  ),
                                ),
                              );
                              setState(() {}); // Carga los datos cuando vuelve
                            },
                            child: _buildRow(
                              data[index]['ESTMAT'],
                              data[index]['ESTNOT'].toString(),
                              isHeader: false,
                              profesor: data[index]
                                  ['ESTPRF'], // Pasamos el nombre del profesor
                            ),
                          ),
                          const SizedBox(height: 4), // Espacio entre filas
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),

                // Fila de promedio
                FutureBuilder<double?>(
                  future: dbHelper.mostrarPromedio(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildRow('Promedio',
                          'Cargando...'); // Muestra un mensaje mientras carga
                    } else if (snapshot.hasError) {
                      return _buildRow(
                          'Promedio', 'Error'); // Muestra si hubo un error
                    } else if (snapshot.hasData) {
                      final promedio = snapshot.data ??
                          0.0; // Si el valor es nulo, se establece en 0
                      return _buildRow(
                        'Promedio',
                        promedio.toString(),
                      ); // Sin profesor para la fila de promedio
                    } else {
                      return _buildRow('Promedio', 'N/A');
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Widget107()),
          );
          if (result == true) {
            setState(() {}); // Refresca los datos al regresar
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Función para crear una fila (ya sea de encabezado, datos o promedio)
  Widget _buildRow(String leftText, String rightText,
      {bool isHeader = false, String? profesor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                rightText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (profesor != null) // Si hay un nombre de profesor, lo mostramos
            Padding(
              padding: const EdgeInsets.only(top: 4.0), // Espaciado superior
              child: Text(
                'Profesor: $profesor', // Mostrar el profesor en fuente más pequeña
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

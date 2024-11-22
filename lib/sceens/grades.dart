import 'form_edit_task.dart';
import 'form_add_task.dart';
import 'package:flutter/material.dart';
import 'basedato_helper.dart';
import 'form_add.dart';
import 'functions_helper.dart';
import 'subjects.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradesScreen> {
  final dbHelper = BasedatoHelper();
  final fnHelper = FunctionsHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
      ),
      body: SingleChildScrollView(
        // Agregar scroll para toda la pantalla
        child: FutureBuilder<List<Map<String, dynamic>>>(
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
                  fnHelper.buildRow('Materia', 'Nota', isHeader: true),
                  const Divider(),

                  // Filas de los datos
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Desactiva el scroll del ListView para que no interfiera
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
                                  builder: (context) => SubjectsScreen(
                                    id: data[index]['id'],
                                  ),
                                ),
                              );
                              setState(() {}); // Carga los datos cuando vuelve
                            },
                            child: fnHelper.buildRow(
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

                  // Fila de promedio
                  FutureBuilder<double?>(
                    future: dbHelper.mostrarPromedio(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return fnHelper.buildRow('Promedio', 'Cargando...');
                      } else if (snapshot.hasError) {
                        return fnHelper.buildRow('Promedio', 'Error');
                      } else if (snapshot.hasData) {
                        final promedio = snapshot.data ?? 0.0;
                        return fnHelper.buildRow(
                          'Promedio',
                          promedio.toString(),
                        );
                      } else {
                        return fnHelper.buildRow('Promedio', 'N/A');
                      }
                    },
                  ),

                  const Divider(),

                  // Sección de tareas
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tareas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddTaskScreen()),
                            );
                            if (result == true) {
                              setState(() {});
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                'Añadir',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // Mostramos las tareas
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: dbHelper.mostrarTareas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No hay tareas disponibles'));
                      } else {
                        final List<Map<String, dynamic>> tareas =
                            snapshot.data!;

                        return Column(
                          children: [
                            const SizedBox(
                                height: 16), // Espacio entre título y tarjetas
                            ...tareas.map((tarea) {
                              // Determinar el color según el estatus de la tarea
                              Color cardColor;
                              switch (tarea['TARSTS']) {
                                case 'pendiente':
                                  cardColor = Colors.grey[300]!;
                                  break;
                                case 'finalizada':
                                  cardColor = Colors.green[300]!;
                                  break;
                                case 'incompleta':
                                  cardColor = Colors.red[300]!;
                                  break;
                                default:
                                  cardColor = Colors.white;
                              }

                              String fecha = tarea['TARFEC'].toString();

                              return GestureDetector(
                                onTap: () {
                                  // Navegación a la pantalla de edición
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskEditScreen(
                                        id: tarea['TARTID'],
                                        materia: tarea['TARMNO'],
                                        descripcion: tarea['TARDES'],
                                        fecha: int.parse(fecha),
                                        estatus: tarea['TARSTS'],
                                      ),
                                    ),
                                  ).then((wasUpdated) {
                                    // Refrescar la lista si se realizó un cambio
                                    if (wasUpdated == true) {
                                      setState(
                                          () {}); // Esto recargará el FutureBuilder
                                    }
                                  });
                                },
                                child: Align(
                                  alignment: Alignment
                                      .centerLeft, // Alinea las tarjetas a la izquierda
                                  child: Card(
                                    color:
                                        cardColor, // Solo cambia el color de la tarjeta
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Título de la tarea (descripción)
                                          Text(
                                            '${tarea['TARDES']}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          // Fecha y Materia con los estilos normales
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${tarea['TARMNO']}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${fecha.substring(0, 2)}/${fecha.substring(2, 4)}/${fecha.substring(4, 8)}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }
                    },
                  )
                ],
              );
            }
          },
        ),
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
}

import 'package:flutter/material.dart';
import 'basedato_helper.dart';

class Widget107 extends StatefulWidget {
  Widget107({Key? key}) : super(key: key);

  @override
  _Widget107State createState() => _Widget107State();
}

class _Widget107State extends State<Widget107> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _materiaController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();
  final TextEditingController _profesorController = TextEditingController();

  // Variable para obtener los métodos de la base de datos
  final dbHelper = BasedatoHelper();

  // Limpiar los controladores cuando ya no se necesiten
  @override
  void dispose() {
    _materiaController.dispose();
    _notaController.dispose();
    _profesorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Añadir padding alrededor del formulario
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinear los bloques a la izquierda
            children: [
              // Bloque 1: Materia
              const Text(
                'Materia',
                style: TextStyle(
                  fontSize: 16, // Tamaño de la fuente del título
                  fontWeight: FontWeight.bold, // Hacer el título en negritas
                ),
              ),
              TextFormField(
                controller:
                    _materiaController, // Controlador para el campo de materia
                decoration: const InputDecoration(
                  hintText:
                      'Introduce la materia', // Texto de ayuda en el campo
                  border:
                      OutlineInputBorder(), // Añadir borde alrededor del cuadro de texto
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce la materia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // Espacio entre los bloques

              // Bloque 2: Nota
              const Text(
                'Nota',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller:
                    _notaController, // Controlador para el campo de nota
                keyboardType: TextInputType.number, // Tipo de teclado numérico
                decoration: const InputDecoration(
                  hintText: 'Introduce la nota',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce la nota';
                  } else if (int.tryParse(value) == null) {
                    return 'Introduce un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // Espacio entre los bloques

              // Bloque 3: Profesor
              const Text(
                'Profesor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller:
                    _profesorController, // Controlador para el campo de profesor
                decoration: const InputDecoration(
                  hintText: 'Introduce el nombre del profesor',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el nombre del profesor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24), // Espacio antes de los botones

              // Colocamos los botones en una fila
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Espacio entre los botones
                children: [
                  // Botón para agregar los datos
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Obtener los valores ingresados en los controladores
                        final String materia = _materiaController.text;
                        final int nota = int.parse(_notaController.text);
                        final String profesor = _profesorController.text;

                        // Llamar a la función para agregar los datos a la base de datos
                        dbHelper.addData(materia, nota, profesor);

                        // Mostrar un SnackBar con los datos ingresados
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Datos guardados: $materia, $nota, $profesor')),
                        );

                        // Regresar a la pantalla anterior después de guardar
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Agregar'),
                  ),

                  // Botón para regresar a la pantalla anterior
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Regresar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

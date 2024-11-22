import 'package:flutter/material.dart';
import 'basedato_helper.dart';
import 'functions_helper.dart';

class Widget107 extends StatefulWidget {
  Widget107({Key? key}) : super(key: key);

  @override
  Widget107State createState() => Widget107State();
}

class Widget107State extends State<Widget107> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _materiaController = TextEditingController();
  final TextEditingController _profesorController = TextEditingController();
  final TextEditingController _corte1Controller = TextEditingController();
  final TextEditingController _corte2Controller = TextEditingController();
  final TextEditingController _corte3Controller = TextEditingController();

  // Variable para obtener los métodos de la base de datos
  final dbHelper = BasedatoHelper();
  final functionsHelper = FunctionsHelper();

  // Limpiar los controladores cuando ya no se necesiten
  @override
  void dispose() {
    _materiaController.dispose();
    _profesorController.dispose();
    _corte1Controller.dispose();
    _corte2Controller.dispose();
    _corte3Controller.dispose();
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

              // Bloque 2: Profesor
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
              const SizedBox(height: 24), // Espacio antes de las notas

              functionsHelper.buildThreeElementRow(
                'Corte 1',
                'Corte 2',
                'Corte 3',
                isHeader: true,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _corte1Controller, // Controlador para Corte 1
                      keyboardType: TextInputType.number, // Teclado numérico
                      decoration: const InputDecoration(
                        hintText: 'Corte 1',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce la nota del corte 1';
                        } else if (int.tryParse(value) == null) {
                          return 'Número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8), // Espacio entre los campos

                  Expanded(
                    child: TextFormField(
                      controller: _corte2Controller, // Controlador para Corte 2
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Corte 2',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce la nota del Corte 2';
                        } else if (int.tryParse(value) == null) {
                          return 'Número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8), // Espacio entre los campos

                  Expanded(
                    child: TextFormField(
                      controller: _corte3Controller, // Controlador para Corte 3
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Corte 3',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce la nota del Corte 3';
                        } else if (int.tryParse(value) == null) {
                          return 'Número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24), // Espacio antes de los botones

              // Colocamos los botones en una fila
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Espacio entre los botones
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Obtener los valores ingresados en los controladores
                        final String materia = _materiaController.text;
                        final String profesor = _profesorController.text;
                        final int corte1 = int.parse(_corte1Controller.text);
                        final int corte2 = int.parse(_corte2Controller.text);
                        final int corte3 = int.parse(_corte3Controller.text);

                        // Insertar en las dos tablas
                        dbHelper.addData(materia, profesor, corte1, corte2,
                            corte3); // Para la tabla notas_estudiante

                        // Mostrar un SnackBar con los datos ingresados
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Datos guardados: $materia, $profesor, $corte1, $corte2, $corte3')),
                        );

                        // Regresar a la pantalla anterior después de guardar
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Agregar'),
                  ),
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

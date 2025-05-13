import 'package:flutter/material.dart';
import 'basedato_helper.dart';
import 'functions_helper.dart';

class Widget107 extends StatefulWidget {
  const Widget107({Key? key}) : super(key: key);

  @override
  Widget107State createState() => Widget107State();
}

class Widget107State extends State<Widget107> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _semestreController = TextEditingController();
  final TextEditingController _seccionController = TextEditingController();
  final TextEditingController _materiaController = TextEditingController();
  final TextEditingController _profesorController = TextEditingController();
  final TextEditingController _corte1Controller = TextEditingController();
  final TextEditingController _corte2Controller = TextEditingController();
  final TextEditingController _corte3Controller = TextEditingController();

  // Variables para el DropdownButton de las periodos
  List<String> _periodos = [];
  String? _periodoSeleccionado;

  // Instancias de helpers
  final dbHelper = BasedatoHelper();
  final functionsHelper = FunctionsHelper();

  @override
  void initState() {
    super.initState();
    _cargarPeriodos(); // Cargar las periodos al iniciar
  }

  Future<void> _cargarPeriodos() async {
    final periodos = await dbHelper.getPeriodos();
    setState(() {
      _periodos = periodos;
      if (_periodos.isNotEmpty) {
        _periodoSeleccionado =
            _periodos.first; // Seleccionar la primera por defecto
      }
    });
  }

  @override
  void dispose() {
    // Limpiar controladores al cerrar la pantalla
    _semestreController.dispose();
    _seccionController.dispose();
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Bloque 1: Periodo y Semestre
              Row(
                children: [
                  // Dropdown para la sección
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sección',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          value: _periodoSeleccionado,
                          items: _periodos.map((periodo) {
                            return DropdownMenuItem<String>(
                              value: periodo,
                              child: Text(periodo),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _periodoSeleccionado = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12), // Ajustar padding interno
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecciona un periodo';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Espacio entre los widgets

                  // TextField para el semestre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Semestre',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _semestreController,
                          decoration: const InputDecoration(
                            hintText: 'Semestre',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Introduce el semestre';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bloque 2: Materia
              const Text(
                'Materia',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _materiaController,
                decoration: const InputDecoration(
                  hintText: 'Introduce la materia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce la materia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bloque 3: Seccion
              const Text(
                'Seccion',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _seccionController,
                decoration: const InputDecoration(
                  hintText: 'Introduce la sección',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce la sección';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bloque 4: Profesor
              const Text(
                'Profesor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _profesorController,
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
              const SizedBox(height: 24),

              // Bloque 5: Cortes (Notas)
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
                      controller: _corte1Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Corte 1',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce la nota del Corte 1';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _corte2Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Corte 2',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce la nota del Corte 2';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _corte3Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Corte 3',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce la nota del Corte 3';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Obtener los valores ingresados en los controladores
                        final String periodo = _periodoSeleccionado ?? '';
                        final String semestre = _semestreController.text;
                        final String seccion = _seccionController.text;
                        final String materia = _materiaController.text;
                        final String profesor = _profesorController.text;
                        final int corte1 = int.parse(_corte1Controller.text);
                        final int corte2 = int.parse(_corte2Controller.text);
                        final int corte3 = int.parse(_corte3Controller.text);

                        if (periodo.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Por favor, selecciona una sección'),
                            ),
                          );
                          return;
                        }

                        // Llamar al método addData con todos los parámetros
                        dbHelper
                            .addData(materia, profesor, corte1, corte2, corte3,
                                periodo, semestre, seccion)
                            .then((_) {
                          // Mostrar un SnackBar con los datos ingresados
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Datos guardados: $materia, $profesor, $corte1, $corte2, $corte3, $periodo, $semestre'),
                            ),
                          );

                          // Regresar a la pantalla anterior después de guardar
                          Navigator.pop(context, true);
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error al guardar los datos: ${error.toString()}'),
                            ),
                          );
                        });
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

import 'package:control_semestres/sceens/functions_helper.dart';
import 'package:control_semestres/sceens/grades.dart';
import 'package:flutter/material.dart';
import 'basedato_helper.dart';

class FormEdit extends StatefulWidget {
  final int id;
  final String materia;
  final String profesor;
  final int corte1;
  final int corte2;
  final int corte3;

  const FormEdit({
    Key? key,
    required this.id,
    required this.materia,
    required this.profesor,
    required this.corte1,
    required this.corte2,
    required this.corte3,
  }) : super(key: key);

  @override
  FormEditState createState() => FormEditState();
}

class FormEditState extends State<FormEdit> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = BasedatoHelper();
  final functionsHelper = FunctionsHelper();

  // Controladores para los campos de texto
  late TextEditingController _materiaController;
  late TextEditingController _profesorController;
  late TextEditingController _corte1Controller;
  late TextEditingController _corte2Controller;
  late TextEditingController _corte3Controller;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos recibidos
    _materiaController = TextEditingController(text: widget.materia);
    _profesorController = TextEditingController(text: widget.profesor);
    _corte1Controller = TextEditingController(text: widget.corte1.toString());
    _corte2Controller = TextEditingController(text: widget.corte2.toString());
    _corte3Controller = TextEditingController(text: widget.corte3.toString());
  }

  @override
  void dispose() {
    // Limpiar los controladores al salir
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
        title: const Text('Editar Materia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Añadir padding alrededor del formulario
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bloque de Materia
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

              // Bloque de Profesor
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
              const SizedBox(height: 16),

              // Bloque para Cortes
              functionsHelper.buildThreeElementRow(
                'Corte 1',
                'Corte 2',
                'Corte 3',
                isHeader: true,
              ),
              Row(
                children: [
                  // Corte 1
                  Expanded(
                    child: TextFormField(
                      controller: _corte1Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce un valor para Corte 1';
                        } else if (int.tryParse(value) == null) {
                          return 'Introduce un número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8), // Espacio entre los campos

                  // Corte 2
                  Expanded(
                    child: TextFormField(
                      controller: _corte2Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce un valor para Corte 2';
                        } else if (int.tryParse(value) == null) {
                          return 'Introduce un número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8), // Espacio entre los campos

                  // Corte 3
                  Expanded(
                    child: TextFormField(
                      controller: _corte3Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce un valor para Corte 3';
                        } else if (int.tryParse(value) == null) {
                          return 'Introduce un número válido';
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
                  // Botón para guardar cambios
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final String newMateria = _materiaController.text;
                        final String newProfesor = _profesorController.text;
                        final int newCorte1 = int.parse(_corte1Controller.text);
                        final int newCorte2 = int.parse(_corte2Controller.text);
                        final int newCorte3 = int.parse(_corte3Controller.text);

                        // Actualizar los datos en la base de datos
                        await dbHelper.updateData(
                          widget.id,
                          newMateria,
                          newProfesor,
                          newCorte1,
                          newCorte2,
                          newCorte3,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Datos actualizados')),
                        );

                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Guardar'),
                  ),

                  // Botón para borrar
                  ElevatedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmar eliminación'),
                            content: const Text(
                                '¿Estás seguro de que deseas eliminar este registro?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true && mounted) {
                        await dbHelper.deleteData(widget.id);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dato eliminado')),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GradesScreen(), // Asegúrate de que esta sea la pantalla correcta
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Borrar'),
                  ),

                  // Botón para cancelar
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
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

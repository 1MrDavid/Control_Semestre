import 'package:flutter/material.dart';
import 'basedato_helper.dart';

class FormEdit extends StatefulWidget {
  final int id;
  final String materia;
  final int nota;
  final String profesor;

  const FormEdit({
    Key? key,
    required this.id,
    required this.materia,
    required this.nota,
    required this.profesor,
  }) : super(key: key);

  @override
  _FormEditState createState() => _FormEditState();
}

class _FormEditState extends State<FormEdit> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = BasedatoHelper();

  // Controladores para los campos de texto
  late TextEditingController _materiaController;
  late TextEditingController _notaController;
  late TextEditingController _profesorController;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos recibidos
    _materiaController = TextEditingController(text: widget.materia);
    _notaController = TextEditingController(text: widget.nota.toString());
    _profesorController = TextEditingController(text: widget.profesor);
  }

  @override
  void dispose() {
    // Limpiar los controladores al salir
    _materiaController.dispose();
    _notaController.dispose();
    _profesorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Añadimos padding alrededor del formulario
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

              // Bloque de Nota
              const Text(
                'Nota',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _notaController,
                keyboardType: TextInputType.number,
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
              const SizedBox(height: 24),

              // Colocamos los botones en una fila
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón para guardar cambios
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final String newMateria = _materiaController.text;
                        final int newNota = int.parse(_notaController.text);
                        final String newProfesor = _profesorController.text;

                        dbHelper.updateData(
                          widget.id,
                          newMateria,
                          newNota,
                          newProfesor,
                        ); // Función para actualizar los datos

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Datos actualizados')),
                        );

                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Guardar'),
                  ),

                  // Botón para borrar el registro
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

                          Navigator.pop(context, true);
                        }
                      }
                    },
                    child: const Text('Borrar'),
                  ),

                  // Botón para cancelar y volver atrás
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

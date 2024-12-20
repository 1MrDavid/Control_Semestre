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
  final String seccion;
  final String semestre;

  const FormEdit({
    Key? key,
    required this.id,
    required this.materia,
    required this.profesor,
    required this.corte1,
    required this.corte2,
    required this.corte3,
    required this.seccion,
    required this.semestre,
  }) : super(key: key);

  @override
  FormEditState createState() => FormEditState();
}

class FormEditState extends State<FormEdit> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = BasedatoHelper();
  final functionsHelper = FunctionsHelper();

  late TextEditingController _materiaController;
  late TextEditingController _profesorController;
  late TextEditingController _corte1Controller;
  late TextEditingController _corte2Controller;
  late TextEditingController _corte3Controller;
  late TextEditingController _semestreController;

  String? _seccionSeleccionada;
  List<String> _secciones = [];

  @override
  void initState() {
    super.initState();
    _materiaController = TextEditingController(text: widget.materia);
    _profesorController = TextEditingController(text: widget.profesor);
    _corte1Controller = TextEditingController(text: widget.corte1.toString());
    _corte2Controller = TextEditingController(text: widget.corte2.toString());
    _corte3Controller = TextEditingController(text: widget.corte3.toString());
    _semestreController = TextEditingController(text: widget.semestre);
    _seccionSeleccionada = widget.seccion;
    _cargarDatosSecciones();
  }

  Future<void> _cargarDatosSecciones() async {
    final secciones = await dbHelper.getSecciones();

    setState(() {
      _secciones = secciones;
    });
  }

  @override
  void dispose() {
    _materiaController.dispose();
    _profesorController.dispose();
    _corte1Controller.dispose();
    _corte2Controller.dispose();
    _corte3Controller.dispose();
    _semestreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Materia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección
                DropdownButtonFormField<String>(
                  value: _seccionSeleccionada,
                  items: _secciones.map((seccion) {
                    return DropdownMenuItem<String>(
                      value: seccion,
                      child: Text(seccion),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _seccionSeleccionada = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Sección',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una sección';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Semestre (Texto)
                TextFormField(
                  controller: _semestreController,
                  decoration: const InputDecoration(
                    labelText: 'Semestre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce el semestre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Materia
                TextFormField(
                  controller: _materiaController,
                  decoration: const InputDecoration(
                    labelText: 'Materia',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce el nombre de la materia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Profesor
                TextFormField(
                  controller: _profesorController,
                  decoration: const InputDecoration(
                    labelText: 'Profesor',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce el nombre del profesor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Cortes
                functionsHelper.buildThreeElementRow(
                    'Corte 1', 'Corte 2', 'Corte 3',
                    isHeader: true),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _corte1Controller,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduce Corte 1';
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
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduce Corte 2';
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
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduce Corte 3';
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _guardarCambios();
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
                                    const GradesScreen(), // Asegúrate de que esta sea la pantalla correcta
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Borrar'),
                    ),
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
      ),
    );
  }

  Future<void> _guardarCambios() async {
    await dbHelper.updateData(
      widget.id,
      _materiaController.text,
      _profesorController.text,
      int.parse(_corte1Controller.text),
      int.parse(_corte2Controller.text),
      int.parse(_corte3Controller.text),
      _seccionSeleccionada!,
      _semestreController.text, // Aquí se usa el texto ingresado
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados')),
    );

    Navigator.pop(context, true);
  }
}

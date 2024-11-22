import 'grades.dart';
import 'package:flutter/material.dart';
import 'basedato_helper.dart';

class TaskEditScreen extends StatefulWidget {
  final int id;
  final String materia;
  final String descripcion;
  final int fecha;
  final String estatus;

  const TaskEditScreen({
    Key? key,
    required this.id,
    required this.materia,
    required this.descripcion,
    required this.fecha,
    required this.estatus,
  }) : super(key: key);

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = BasedatoHelper();

  // Controladores
  late TextEditingController _descripcionController;
  late TextEditingController _diaController;
  late TextEditingController _mesController;
  late TextEditingController _anioController;
  late String _estatusSeleccionado;
  String? _materiaSeleccionada;

  List<String> nombresMaterias = [];

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(text: widget.descripcion);
    _estatusSeleccionado = widget.estatus;

    // Separar la fecha (DDMMAAAA)
    String fechaStr = widget.fecha.toString().padLeft(8, '0');
    _diaController = TextEditingController(text: fechaStr.substring(0, 2));
    _mesController = TextEditingController(text: fechaStr.substring(2, 4));
    _anioController = TextEditingController(text: fechaStr.substring(4, 8));
    _cargarNombresMaterias();
    _materiaSeleccionada = widget.materia;
  }

  void _cargarNombresMaterias() async {
    final nombres = await dbHelper.obtenerNombresMaterias();
    setState(() {
      nombresMaterias = nombres;
    });
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _diaController.dispose();
    _mesController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  int _obtenerFechaEntera() {
    final dia = int.tryParse(_diaController.text) ?? 0;
    final mes = int.tryParse(_mesController.text) ?? 0;
    final anio = int.tryParse(_anioController.text) ?? 0;
    return (dia * 1000000) + (mes * 10000) + anio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menú desplegable de Materia
                const Text(
                  'Materia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  value: _materiaSeleccionada,
                  items: nombresMaterias.map((materia) {
                    return DropdownMenuItem<String>(
                      value: materia,
                      child: Text(materia),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _materiaSeleccionada = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una materia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de descripción
                const Text(
                  'Descripción',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    hintText: 'Describe la tarea',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce la descripción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campos de fecha
                const Text(
                  'Fecha (DD/MM/AAAA)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _diaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Día',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduce el día';
                          } else if (int.tryParse(value) == null) {
                            return 'Número válido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _mesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Mes',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduce el mes';
                          } else if (int.tryParse(value) == null) {
                            return 'Número válido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _anioController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Año',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduce el año';
                          } else if (int.tryParse(value) == null) {
                            return 'Número válido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Dropdown de Estatus
                const Text(
                  'Estatus',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  value: _estatusSeleccionado,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  items: ['pendiente', 'finalizada', 'incompleta']
                      .map((estatus) => DropdownMenuItem(
                            value: estatus,
                            child: Text(estatus),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _estatusSeleccionado = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona un estatus';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await dbHelper.updateTask(
                            widget.id,
                            _materiaSeleccionada!,
                            _descripcionController.text,
                            _obtenerFechaEntera(),
                            _estatusSeleccionado,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tarea actualizada')),
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
                          await dbHelper.deleteTask(widget.id);

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
}

import 'package:flutter/material.dart';
import 'basedato_helper.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _diaController = TextEditingController();
  final TextEditingController _mesController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  String? _estatusSeleccionado;
  String? _materiaSeleccionada; // Para almacenar la materia seleccionada

  // Base de datos
  final dbHelper = BasedatoHelper();

  List<String> nombresMaterias = []; // Lista de nombres de materias

  @override
  void initState() {
    super.initState();
    _cargarNombresMaterias();
  }

  // Función para cargar todos los nombres de materias al inicio
  void _cargarNombresMaterias() async {
    final nombres = await dbHelper
        .obtenerNombresMaterias(); // Método que obtiene todos los nombres de materias
    setState(() {
      nombresMaterias = nombres;
    });
  }

  // Función para concatenar día, mes y año en un único entero
  int _obtenerFechaEntera() {
    final dia = int.tryParse(_diaController.text) ?? 0;
    final mes = int.tryParse(_mesController.text) ?? 0;
    final anio = int.tryParse(_anioController.text) ?? 0;
    return (dia * 1000000) +
        (mes * 10000) +
        anio; // Concatenamos en formato DDMMAAAA
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown para seleccionar la materia
              const Text(
                'Materia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _materiaSeleccionada,
                items: nombresMaterias.map((String materia) {
                  return DropdownMenuItem<String>(
                    value: materia,
                    child: Text(materia),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _materiaSeleccionada =
                        value; // Almacenar la materia seleccionada
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Selecciona la materia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona una materia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descripción
              const Text(
                'Descripción de la Tarea',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  hintText: 'Introduce la descripción de la tarea',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce la descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fecha de entrega: Día, Mes, Año
              const Text(
                'Fecha de Entrega (DD/MM/AAAA)',
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

              // Estatus
              const Text(
                'Estatus',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _estatusSeleccionado,
                items: const [
                  DropdownMenuItem(
                      value: 'pendiente', child: Text('Pendiente')),
                  DropdownMenuItem(
                      value: 'finalizada', child: Text('Finalizada')),
                  DropdownMenuItem(
                      value: 'incompleta', child: Text('Incompleta')),
                ],
                onChanged: (value) {
                  setState(() {
                    _estatusSeleccionado = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona un estatus';
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
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _materiaSeleccionada != null) {
                        final descripcion = _descripcionController.text;
                        final fecha = _obtenerFechaEntera(); // Concatenar fecha
                        final estatus = _estatusSeleccionado!;
                        final materia = _materiaSeleccionada!;

                        dbHelper.addTask(
                          materia,
                          descripcion,
                          fecha,
                          estatus,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tarea guardada: $materia'),
                          ),
                        );

                        Navigator.pop(context, true);
                      } else if (_materiaSeleccionada == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, selecciona una materia'),
                          ),
                        );
                      }
                    },
                    child: const Text('Agregar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
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

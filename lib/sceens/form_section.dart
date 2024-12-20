import 'package:flutter/material.dart';
import 'basedato_helper.dart';

class AddSeccionForm extends StatefulWidget {
  @override
  AddSeccionFormState createState() => AddSeccionFormState();
}

class AddSeccionFormState extends State<AddSeccionForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _diaInicioController = TextEditingController();
  final TextEditingController _mesInicioController = TextEditingController();
  final TextEditingController _anioInicioController = TextEditingController();
  final TextEditingController _diaFinController = TextEditingController();
  final TextEditingController _mesFinController = TextEditingController();
  final TextEditingController _anioFinController = TextEditingController();

  bool _esActiva = false;

  // Instancia del helper de base de datos
  final dbHelper = BasedatoHelper();

  @override
  void dispose() {
    // Limpiar los controladores
    _codigoController.dispose();
    _diaInicioController.dispose();
    _mesInicioController.dispose();
    _anioInicioController.dispose();
    _diaFinController.dispose();
    _mesFinController.dispose();
    _anioFinController.dispose();
    super.dispose();
  }

  // Función para generar la fecha en formato AAAAMMDD
  int _obtenerFechaAAAAMMDD(String dia, String mes, String anio) {
    final diaInt = int.tryParse(dia.padLeft(2, '0')) ?? 0;
    final mesInt = int.tryParse(mes.padLeft(2, '0')) ?? 0;
    final anioInt = int.tryParse(anio) ?? 0;

    return (anioInt * 10000) + (mesInt * 100) + diaInt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Sección'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Código de la sección
              const Text(
                'Código de la Sección',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  hintText: 'Ejemplo: 2025-I',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el código de la sección.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fecha de inicio
              const Text(
                'Fecha de Inicio (DD/MM/AAAA)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _diaInicioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Día',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce el día';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _mesInicioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Mes',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce el mes';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _anioInicioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Año',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce el año';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Fecha de fin
              const Text(
                'Fecha de Fin (DD/MM/AAAA)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _diaFinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Día',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce el día';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _mesFinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Mes',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce el mes';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _anioFinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Año',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Introduce el año';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Checkbox para sección activa
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '¿Es la sección activa?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Checkbox(
                    value: _esActiva,
                    onChanged: (bool? value) {
                      setState(() {
                        _esActiva = value ?? false;
                      });
                    },
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
                        final String codigo = _codigoController.text;
                        final int fechaInicio = _obtenerFechaAAAAMMDD(
                          _diaInicioController.text,
                          _mesInicioController.text,
                          _anioInicioController.text,
                        );
                        final int fechaFin = _obtenerFechaAAAAMMDD(
                          _diaFinController.text,
                          _mesFinController.text,
                          _anioFinController.text,
                        );
                        final String esActiva = _esActiva ? 'S' : 'N';

                        // Insertar en la base de datos
                        dbHelper.addSection(
                          codigo,
                          fechaInicio,
                          fechaFin,
                          esActiva,
                        );

                        // Mostrar mensaje y regresar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Sección agregada con éxito')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Guardar'),
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
    );
  }
}

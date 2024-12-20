import 'package:control_semestres/sceens/basedato_helper.dart';
import 'package:control_semestres/sceens/form_section.dart';
import 'package:control_semestres/sceens/grades_all.dart';
import 'package:control_semestres/sceens/grades_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme_provider.dart';

class CustomDrawer extends StatelessWidget {
  final dbHelper = BasedatoHelper();

  CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: FutureBuilder<List<String>>(
        // Usamos FutureBuilder para esperar el resultado de la consulta
        future: dbHelper.getSecciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                // Encabezado del Drawer
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Añadir Sección'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_auto),
                  title: const Text('Cambiar Tema'),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            );
          }

          List<String> secciones = snapshot.data!;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Encabezado del Drawer
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Mostrar las secciones creadas
              ...secciones.map((seccion) {
                return ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(seccion),
                  onTap: () {
                    // Lógica al presionar una sección
                    Navigator.pop(context); // Cierra el Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GradesSectionScreen(seccion: seccion),
                      ),
                    );
                  },
                );
              }),

              // Botón para añadir nueva sección
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Añadir Sección'),
                onTap: () {
                  // Lógica al presionar "Añadir Sección"
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSeccionForm(),
                    ),
                  ).then((_) {
                    // Cierra la barra lateral al volver
                    Navigator.pop(context);
                  });
                  // Aquí puedes abrir un formulario o una pantalla para añadir una nueva sección
                },
              ),

              // Otras opciones del menú
              ListTile(
                leading: const Icon(Icons.book_rounded),
                title: const Text('Materias'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GradesAllScreen(),
                    ),
                  ).then((_) {
                    // Cierra la barra lateral al volver
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_auto),
                title: const Text('Cambiar Tema'),
                onTap: () {
                  themeProvider.toggleTheme();
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.logout),
              //   title: const Text('Cerrar Sesión'),
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          );
        },
      ),
    );
  }
}

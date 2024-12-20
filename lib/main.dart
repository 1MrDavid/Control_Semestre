import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './sceens/theme_provider.dart';
import './sceens/grades.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Tema claro
      darkTheme: ThemeData.dark(), // Tema oscuro
      themeMode: themeProvider.themeMode, // Aplicar el modo de tema
      home: const GradesScreen(),
    );
  }
}

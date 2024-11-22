import 'package:flutter/material.dart';

class FunctionsHelper {
  // Función para crear una fila (ya sea de encabezado, datos o promedio)
  Widget buildRow(String leftText, String rightText,
      {bool isHeader = false, String? profesor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                rightText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (profesor != null) // Si hay un nombre de profesor, lo mostramos
            Padding(
              padding: const EdgeInsets.only(top: 4.0), // Espaciado superior
              child: Text(
                'Profesor: $profesor', // Mostrar el profesor en fuente más pequeña
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // Función para crear una fila con tres elementos (izquierda, centro y derecha)
  Widget buildThreeElementRow(
      String leftText, String centerText, String rightText,
      {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1, // El primer texto alineado a la izquierda
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                leftText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1, // El segundo texto alineado al centro
            child: Align(
              alignment: Alignment.center,
              child: Text(
                centerText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1, // El tercer texto alineado a la derecha
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                rightText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

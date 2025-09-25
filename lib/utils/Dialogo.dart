import 'package:flutter/material.dart';

class Dialogo {
  // Control para diálogo abierto
  bool _dialogoAbierto = false;
  BuildContext? _context;

  // Método para mostrar diálogo
  void mostrarDialogo(String mensaje, BuildContext context) {
    if (_dialogoAbierto) return;
    
    _dialogoAbierto = true;
    _context = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(mensaje)),
          ],
        ),
      ),
    ).then((_) {
      _dialogoAbierto = false;
      _context = null;
    });
  }

  // Método para cerrar diálogo
  void cerrarDialogo() {
    if (_dialogoAbierto && _context != null && Navigator.canPop(_context!)) {
      Navigator.of(_context!, rootNavigator: true).pop();
      _dialogoAbierto = false;
      _context = null;
    }
  }
}
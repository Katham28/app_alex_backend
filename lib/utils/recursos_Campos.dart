import 'package:flutter/material.dart';



Widget campoMaterno(String label, TextEditingController controller,Icon icon,
    {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon:  icon,
      ),
      //alidator: (value) => value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    ),
  );
}

Widget campocorreo(String label, TextEditingController controller,Icon icon,
    {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon:  icon,
      ),
            validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          if (value.contains('@') == false) {
                            return 'El correo electrónico no es válido';
                          }
                          return null;
                        },
    ),
  );
}

Widget camponumerico(String label, TextEditingController controller,Icon icon,
    {bool isPassword = false, TextInputType keyboardType = TextInputType.number}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon:  icon,
      ),
      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Debe contener solo números';
                          }
                         
                          return null;
                        },

    ),
  );
}

Widget campotelefonico(String label, TextEditingController controller,Icon icon,
    {bool isPassword = false, TextInputType keyboardType = TextInputType.number}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon:  icon,
      ),
      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Debe contener solo números';
                          }
                          if (value.length != 10) {
                            return 'Debe tener 10 dígitos';
                          }

                          
                          return null;
                        },

    ),
  );
}

Widget titulo(String text, Icon icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 8), // este sí puede ser const
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    ),
  );
}

Widget campoTexto(String label, TextEditingController controller,Icon icon,
    {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon:  icon,
      ),
      validator: (value) => value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    ),
  );
}

  
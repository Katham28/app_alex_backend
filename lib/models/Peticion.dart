class Peticion {
  String _name = '';
  String _habitacion = '';
  int _prioridad = 1;
  String _peticion = '';

 
  Peticion ({
    required name,
    required habitacion,
    required prioridad,
    required peticion,

  }): _name = name,
      _habitacion = habitacion,
      _prioridad = prioridad,
      _peticion = peticion;


// Getters 
String get name => _name;
String get habitacion => _habitacion;
int get prioridad => _prioridad;
String get peticion => _peticion;


// Setters 
set name(String value) => _name = value;
set habitacion(String value) => _habitacion = value;
set prioridad(int value) => _prioridad = value;
set peticion(String value) => _peticion = value;


@override
String toString() {
  return 'Peticion('
         'name: $_name, '
         'habitacion: $_habitacion, '
         'prioridad: $_prioridad, '
         'peticion: $_peticion, '

         ')';
}

 factory Peticion.fromJson(Map<String, dynamic> json) => Peticion(
        name: json['name'] ?? '',
        habitacion: json['habitacion'] ?? '',
        prioridad: json['prioridad'] ?? 2,
        peticion: json['peticion'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'habitacion': habitacion,
        'prioridad': prioridad,
        'peticion': peticion,
      };






}
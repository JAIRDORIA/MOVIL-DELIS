class Cliente {
  final int id;
  final String nombre;
  final String telefono;
  final String direccion;
  final String email;
  final bool activo;
  final DateTime createdat;
  final DateTime updatedat;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.email,
    required this.activo,
    required this.createdat,
    required this.updatedat,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      nombre: json['nombre'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      email: json['email'],
      activo: json['activo'] == true || json['activo'] == 1,
      createdat: DateTime.parse(json['created_at']),
      updatedat: DateTime.parse(json['updated_at']),
    );
  }
}
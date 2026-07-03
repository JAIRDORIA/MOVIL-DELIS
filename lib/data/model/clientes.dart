class Cliente {
  final int id;
  final String nombre;
  final String identificacion;
  final String telefono;
  final String direccion;
  final String email;
  final bool activo;
  final DateTime createdat;
  final DateTime updatedat;

  Cliente({
    required this.id,
    required this.nombre,
    required this.identificacion,
    required this.telefono,
    required this.direccion,
    required this.email,
    required this.activo,
    required this.createdat,
    required this.updatedat,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] ?? '',
      identificacion: json['identificacion']?.toString() ?? '',
      telefono: json['telefono'] ?? '',
      direccion: json['direccion'] ?? '',
      email: json['email'] ?? '',
      activo: json['activo'] == true || json['activo'] == 1,
      createdat: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedat: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'identificacion': identificacion,
      'telefono': telefono,
      'direccion': direccion,
      'email': email,
      'activo': activo,
    };
  }
}
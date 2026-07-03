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
      id: json['ID_Cliente'],
      nombre: json['Cli_Nombre'] ?? '',
      identificacion: json['Cli_identificacion'] ?? '',
      telefono: json['Cli_Telefono'] ?? '',
      direccion: json['Cli_Direccion'] ?? '',
      email: json['Cli_email'] ?? '',
      activo: json['Cli_Activo'] == 1,
      createdat: DateTime.parse(json['Cli_Creado']),
      updatedat: DateTime.parse(json['Cli_Actualizado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Cli_Nombre': nombre,
      'Cli_identificacion': identificacion,
      'Cli_Telefono': telefono,
      'Cli_Direccion': direccion,
      'Cli_email': email,
      'Cli_Activo': activo ? 1 : 0,
    };
  }
}
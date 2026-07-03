import 'dart:io';

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

  /// Claves reales del backend desplegado (snackflow-api en Render):
  /// ID_Cliente, Cli_Nombre, Cli_identificacion, Cli_Telefono,
  /// Cli_Direccion, Cli_email, Cli_Activo, Cli_Creado, Cli_Actualizado.
  /// Las fechas vienen en formato RFC 1123 (ej: "Thu, 02 Jul 2026 15:01:05 GMT").
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['ID_Cliente'] is int
          ? json['ID_Cliente']
          : int.tryParse(json['ID_Cliente']?.toString() ?? '') ?? 0,
      nombre: json['Cli_Nombre'] ?? '',
      identificacion: json['Cli_identificacion']?.toString() ?? '',
      telefono: json['Cli_Telefono']?.toString() ?? '',
      direccion: json['Cli_Direccion'] ?? '',
      email: json['Cli_email'] ?? '',
      activo: json['Cli_Activo'] == true || json['Cli_Activo'] == 1,
      createdat: _parseFecha(json['Cli_Creado']),
      updatedat: _parseFecha(json['Cli_Actualizado']),
    );
  }

  static DateTime _parseFecha(dynamic valor) {
    if (valor == null) return DateTime.now();
    final texto = valor.toString();
    try {
      // Formato RFC 1123: "Thu, 02 Jul 2026 15:01:05 GMT"
      return HttpDate.parse(texto);
    } catch (_) {
      return DateTime.tryParse(texto) ?? DateTime.now();
    }
  }

  /// Lo que se envía al crear/actualizar sigue siendo en minúscula
  /// (nombre, identificacion, telefono, direccion, email) porque así
  /// funcionó al crear "camilo" y "Luis" — el backend mapea esas claves de
  /// entrada distinto a como nombra las de salida.
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

class ClientesResponse {
  final List<Cliente> clientes;
  final int total;
  final int pagina;
  final int totalPaginas;

  ClientesResponse({
    required this.clientes,
    required this.total,
    required this.pagina,
    required this.totalPaginas,
  });

  factory ClientesResponse.fromJson(Map<String, dynamic> json) {
    return ClientesResponse(
      clientes: (json['items'] as List)
          .map((e) => Cliente.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      pagina: json['page'] ?? 1,
      totalPaginas: ((json['total'] ?? 0) / (json['per_page'] ?? 20)).ceil(),
    );
  }
}
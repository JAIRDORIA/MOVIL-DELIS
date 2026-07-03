class Compra {
  final int id;
  final int proveedorId;
  final int corteId;
  final int usuarioId;
  final DateTime fecha;
  final double total;
  final String descripcion;
  final bool eliminada;
  final DateTime createdAt;
  final DateTime updatedAt;

  Compra({
    required this.id,
    required this.proveedorId,
    required this.corteId,
    required this.usuarioId,
    required this.fecha,
    required this.total,
    required this.descripcion,
    required this.eliminada,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Compra.fromJson(Map<String, dynamic> json) {
    return Compra(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      proveedorId: json['proveedor_id'] is int ? json['proveedor_id'] : int.parse(json['proveedor_id']),
      corteId: json['corte_id'] is int ? json['corte_id'] : int.parse(json['corte_id']),
      usuarioId: json['usuario_id'] is int ? json['usuario_id'] : int.parse(json['usuario_id']),
      fecha: DateTime.parse(json['fecha']),
      total: double.parse(json['total'].toString()),
      descripcion: json['descripcion'],
      eliminada: json['eliminada'] == true || json['eliminada'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
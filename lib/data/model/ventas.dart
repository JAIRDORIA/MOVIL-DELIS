class Venta {
  final int id;
  final int clienteId;
  final int corteId;
  final int usuarioId;
  final String nombreCliente;
  final DateTime fechaVenta;
  final DateTime fechaEntrega;
  final double total;
  final double totalAbonado;
  final double saldoPendiente;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool eliminada;

  Venta({
    required this.id,
    required this.clienteId,
    required this.corteId,
    required this.usuarioId,
    required this.nombreCliente,
    required this.fechaVenta,
    required this.fechaEntrega,
    required this.total,
    required this.totalAbonado,
    required this.saldoPendiente,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.eliminada,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      clienteId: json['cliente_id'] is int ? json['cliente_id'] : int.parse(json['cliente_id']),
      corteId: json['corte_id'] is int ? json['corte_id'] : int.parse(json['corte_id']),
      usuarioId: json['usuario_id'] is int ? json['usuario_id'] : int.parse(json['usuario_id']),
      nombreCliente: json['nombre_cliente'],
      fechaVenta: DateTime.parse(json['fecha_venta']),
      fechaEntrega: DateTime.parse(json['fecha_entrega']),
      total: double.parse(json['total'].toString()),
      totalAbonado: double.parse(json['total_abonado'].toString()),
      saldoPendiente: double.parse(json['saldo_pendiente'].toString()),
      estado: json['estado'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      eliminada: json['eliminada'] == true || json['eliminada'] == 1,
    );
  }
}
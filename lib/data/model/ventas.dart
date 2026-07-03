class Venta {
  final int idVenta;
  final int clienteId;
  final String nombreCliente;
  final int corteId;
  final int? corteNumero;       // Puede ser null si el backend no lo envía
  final int usuarioId;
  final String? fechaVenta;     // DateTime en formato string
  final String? fechaEntrega;
  final double total;
  final double totalAbonado;
  final double saldoPendiente;
  final String estado;          // 'pendiente', 'entregada', 'anulada'
  final String? medioPago;      // Puede venir si se enriquece desde el store

  Venta({
    required this.idVenta,
    required this.clienteId,
    required this.nombreCliente,
    required this.corteId,
    this.corteNumero,
    required this.usuarioId,
    this.fechaVenta,
    this.fechaEntrega,
    required this.total,
    required this.totalAbonado,
    required this.saldoPendiente,
    required this.estado,
    this.medioPago,
  });

  /// Crea una instancia de Venta desde un mapa JSON
  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['id_venta'] ?? json['id'] ?? 0,
      clienteId: json['cliente_id'] ?? 0,
      nombreCliente: json['nombre_cliente'] ?? '',
      corteId: json['corte_id'] ?? 0,
      corteNumero: json['corte_numero'], // Puede ser null
      usuarioId: json['usuario_id'] ?? 0,
      fechaVenta: json['fecha_venta'],
      fechaEntrega: json['fecha_entrega'],
      total: (json['total'] ?? 0).toDouble(),
      totalAbonado: (json['total_abonado'] ?? 0).toDouble(),
      saldoPendiente: (json['saldo_pendiente'] ?? 0).toDouble(),
      estado: json['estado'] ?? 'pendiente',
      medioPago: json['medio_pago'],
    );
  }

  /// Convierte la instancia a un mapa JSON (útil para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'id_venta': idVenta,
      'cliente_id': clienteId,
      'nombre_cliente': nombreCliente,
      'corte_id': corteId,
      'corte_numero': corteNumero,
      'usuario_id': usuarioId,
      'fecha_venta': fechaVenta,
      'fecha_entrega': fechaEntrega,
      'total': total,
      'total_abonado': totalAbonado,
      'saldo_pendiente': saldoPendiente,
      'estado': estado,
      'medio_pago': medioPago,
    };
  }
}

/// Modelo para la respuesta paginada del backend
class VentasResponse {
  final List<Venta> ventas;
  final int total;
  final int pagina;
  final int limite;
  final int totalPaginas;

  VentasResponse({
    required this.ventas,
    required this.total,
    required this.pagina,
    required this.limite,
    required this.totalPaginas,
  });

  factory VentasResponse.fromJson(Map<String, dynamic> json) {
    final datos = json['datos'] as List<dynamic>? ?? [];
    return VentasResponse(
      ventas: datos.map((item) => Venta.fromJson(item)).toList(),
      total: json['total'] ?? 0,
      pagina: json['pagina'] ?? 1,
      limite: json['limite'] ?? 20,
      totalPaginas: json['total_paginas'] ?? 0,
    );
  }
}
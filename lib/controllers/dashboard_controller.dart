import 'package:movil_delis/core/services/api_service.dart';
import 'package:movil_delis/data/model/clientes.dart';
import 'package:movil_delis/data/model/compras.dart';
import 'package:movil_delis/data/model/ventas.dart';

class DashboardController {

  Future<List<Cliente>> obtenerClientes() async {
    final respuesta = await ApiService.get('/clientes');

    return (respuesta['datos'] as List)
        .map((e) => Cliente.fromJson(e))
        .toList();
  }

  Future<List<Venta>> obtenerVentas() async {
    final respuesta = await ApiService.get('/ventas');

    return (respuesta['datos'] as List)
        .map((e) => Venta.fromJson(e))
        .toList();
  }

  Future<List<Compra>> obtenerCompras() async {
    final respuesta = await ApiService.get('/compras');

    return (respuesta['datos'] as List)
        .map((e) => Compra.fromJson(e))
        .toList();
  }
}
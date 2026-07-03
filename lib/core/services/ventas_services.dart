import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ruta.dart';
import '../../data/model/ventas.dart';

class VentasService {
  // Obtener listado de ventas con paginación y filtro por corte
  Future<VentasResponse> obtenerVentas({
    int pagina = 1,
    int limite = 20,
    int? corteId,
  }) async {
    String url = "${Ruta.baseUrl}/ventas/?pagina=$pagina&limite=$limite";
    if (corteId != null) {
      url += "&corte_id=$corteId";
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return VentasResponse.fromJson(jsonData);
    } else {
      throw Exception('Error al cargar ventas (${response.statusCode})');
    }
  }

  // Obtener detalle completo de una venta (productos + abonos)
  Future<Map<String, dynamic>> obtenerDetalleVenta(int id) async {
    final response = await http.get(
      Uri.parse("${Ruta.baseUrl}/ventas/$id/detalle"),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar detalle de venta');
    }
  }

  // Crear una nueva venta
  Future<Map<String, dynamic>> crearVenta(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("${Ruta.baseUrl}/ventas/"),
      headers: await _headers(),
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear venta');
    }
  }

  // Actualizar fecha de entrega o estado de una venta
  Future<Map<String, dynamic>> actualizarVenta(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("${Ruta.baseUrl}/ventas/$id"),
      headers: await _headers(),
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al actualizar venta');
    }
  }

  // Anular una venta
  Future<Map<String, dynamic>> anularVenta(int id) async {
    final response = await http.put(
      Uri.parse("${Ruta.baseUrl}/ventas/$id/anulacion"),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al anular venta');
    }
  }

  // Obtener o generar el comprobante de una venta
  Future<Map<String, dynamic>> obtenerComprobante(int id) async {
    final response = await http.get(
      Uri.parse("${Ruta.baseUrl}/ventas/$id/comprobante"),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar comprobante');
    }
  }

  // Cabeceras HTTP con token de autenticación (si está disponible)
  Future<Map<String, String>> _headers() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    // Aquí puedes agregar el token JWT si ya tienes el login implementado
    // final token = await AuthService.getToken();
    // if (token != null) {
    //   headers['Authorization'] = 'Bearer $token';
    // }
    return headers;
  }
}
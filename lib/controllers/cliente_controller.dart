import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/ruta.dart';
import '../data/model/clientes.dart';

/// Controlador encargado de comunicarse con tu backend Flask para las
/// operaciones CRUD de Cliente. Sin autenticación (app de prueba, sin login).
///
/// Rutas reales del backend (blueprint con url_prefix='/clientes'):
///   GET    /clientes/        -> listado paginado
///   POST   /clientes/        -> crear cliente
///   PUT    /clientes/<id>    -> actualizar cliente
///   DELETE /clientes/<id>    -> eliminar (borrado lógico)
class ClienteController {
  final String _baseUrl = Ruta.baseUrl;

  /// Obtiene el listado de clientes. El backend pagina la respuesta
  /// (recibe page/per_page), así que pedimos un per_page alto para traer
  /// "todos" en una sola pantalla simple. Si luego quieres paginación real
  /// en la UI, se puede ajustar fácilmente.
  Future<List<Cliente>> obtenerClientes({int page = 1, int perPage = 100}) async {
    final uri = Uri.parse('$_baseUrl/clientes/?page=$page&per_page=$perPage');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        _extraerMensajeError(response.body) ??
            'No se pudo obtener el listado de clientes (${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    final listaJson = _extraerLista(decoded);
    return listaJson.map((json) => Cliente.fromJson(json)).toList();
  }

  /// Confirmado con tu backend: la respuesta trae la forma
  /// {"items": [...], "total": N, "page": N, "per_page": N}.
  /// Se busca automáticamente el primer valor que sea una lista (en este
  /// caso "items"), así que si el nombre de la clave cambia en el futuro
  /// esto sigue funcionando sin tocar código.
  List<dynamic> _extraerLista(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      for (final value in decoded.values) {
        if (value is List) return value;
      }
    }
    throw Exception('No se reconoció el formato de la respuesta del listado de clientes');
  }

  /// Crea un cliente nuevo. El backend exige las claves: nombre,
  /// identificacion, telefono, direccion, email (email puede ir vacío).
  Future<void> crearCliente(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/clientes/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extraerMensajeError(response.body) ??
            'No se pudo crear el cliente (${response.statusCode})',
      );
    }
  }

  /// Actualiza un cliente existente. El backend exige TODOS los campos
  /// (nombre, identificacion, telefono, direccion, email) sin vacíos.
  Future<void> actualizarCliente(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/clientes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception(
        _extraerMensajeError(response.body) ??
            'No se pudo actualizar el cliente (${response.statusCode})',
      );
    }
  }

  /// Elimina (borrado lógico, según tu backend) un cliente por id.
  Future<void> eliminarCliente(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/clientes/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        _extraerMensajeError(response.body) ??
            'No se pudo eliminar el cliente (${response.statusCode})',
      );
    }
  }

  /// Tu backend siempre responde errores como {"mensaje": "..."},
  /// así que mostramos ese mensaje real en vez de uno genérico.
  String? _extraerMensajeError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> && decoded['mensaje'] != null) {
        return decoded['mensaje'].toString();
      }
    } catch (_) {
      // body no era JSON válido, se ignora y se usa el mensaje genérico
    }
    return null;
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/ruta.dart';
import '../../data/model/clientes.dart';

/// Service de clientes: llamadas HTTP puras, sin manejar estado de UI.
///
/// Rutas reales del backend (blueprint con url_prefix='/clientes'):
///   GET    /clientes/        -> listado paginado
///   POST   /clientes/        -> crear cliente
///   PUT    /clientes/<id>    -> actualizar cliente (requiere token)
///   DELETE /clientes/<id>    -> eliminar / borrado lógico (requiere token)
class ClientesService {
  Future<ClientesResponse> obtenerClientes({int pagina = 1, int limite = 20}) async {
    final url = "${Ruta.baseUrl}/clientes/?page=$pagina&per_page=$limite";
    final response = await _ejecutar(() => http.get(Uri.parse(url)));

    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response));
    }
    return ClientesResponse.fromJson(jsonDecode(response.body));
  }

  Future<void> crearCliente(Map<String, dynamic> data) async {
    final response = await _ejecutar(() => http.post(
          Uri.parse("${Ruta.baseUrl}/clientes/"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        ));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(_mensajeError(response));
    }
  }

  Future<void> actualizarCliente(int id, Map<String, dynamic> data) async {
    final response = await _ejecutar(() => http.put(
          Uri.parse("${Ruta.baseUrl}/clientes/$id"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        ));

    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response));
    }
  }

  Future<void> eliminarCliente(int id) async {
    final response = await _ejecutar(() => http.delete(Uri.parse("${Ruta.baseUrl}/clientes/$id")));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_mensajeError(response));
    }
  }

  /// Ejecuta la petición HTTP atrapando fallas de red/timeouts y
  /// convirtiéndolas en mensajes claros, no en excepciones técnicas crudas.
  Future<http.Response> _ejecutar(Future<http.Response> Function() peticion) async {
    try {
      return await peticion().timeout(const Duration(seconds: 20));
    } on SocketException {
      throw Exception('No hay conexión con el servidor. Revisa tu internet o si el backend está caído.');
    } on TimeoutException {
      throw Exception('El servidor tardó demasiado en responder. Puede estar "despertando" (Render) o sin conexión; intenta de nuevo en unos segundos.');
    } on FormatException {
      throw Exception('El servidor respondió con un formato inesperado (no era JSON válido).');
    } on HttpException {
      throw Exception('Ocurrió un error de comunicación con el servidor.');
    } catch (e) {
      throw Exception('Error inesperado al conectar con el servidor: $e');
    }
  }

  /// Traduce el código HTTP + el mensaje real del backend (clave "mensaje")
  /// a un texto entendible, en vez de solo mostrar el número.
  String _mensajeError(http.Response response) {
    final mensajeBackend = _extraerMensajeBackend(response.body);

    switch (response.statusCode) {
      case 400:
        return mensajeBackend ?? 'Los datos enviados no son válidos. Revisa el formulario.';
      case 401:
        return 'No tienes permiso para hacer esta acción (falta o venció el token de autenticación).';
      case 403:
        return 'Acceso denegado: no tienes permisos suficientes para esta acción.';
      case 404:
        return 'El cliente que buscas no existe o ya fue eliminado.';
      case 409:
        return mensajeBackend ?? 'Ya existe un registro con esos datos (posible duplicado).';
      case 422:
        return mensajeBackend ?? 'Los datos enviados no pudieron procesarse. Revisa el formulario.';
      case 500:
        return 'Ocurrió un error interno en el servidor. Intenta más tarde.';
      case 502:
      case 503:
        return 'El servidor no está disponible en este momento (puede estar reiniciándose). Intenta en unos segundos.';
      case 504:
        return 'El servidor tardó demasiado en responder. Intenta de nuevo.';
      default:
        return mensajeBackend ?? 'Ocurrió un error inesperado (código ${response.statusCode}).';
    }
  }

  String? _extraerMensajeBackend(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> && decoded['mensaje'] != null) {
        return decoded['mensaje'].toString();
      }
    } catch (_) {}
    return null;
  }
}
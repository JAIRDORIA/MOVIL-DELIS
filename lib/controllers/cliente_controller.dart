import 'package:flutter/foundation.dart';
import '../core/services/clientes_services.dart';
import '../data/model/clientes.dart';

/// Controller de clientes como ChangeNotifier, igual patrón que
/// VentasController: guarda el estado (lista, carga, error, paginación,
/// búsqueda) y delega las llamadas HTTP al ClientesService.
class ClienteController extends ChangeNotifier {
  final ClientesService _service = ClientesService();

  List<Cliente> _clientes = [];
  List<Cliente> _clientesFiltrados = [];
  int _total = 0;
  int _pagina = 1;
  int _totalPaginas = 1;
  bool _cargando = false;
  String? _error;
  String _busqueda = '';

  List<Cliente> get clientes => _clientesFiltrados;
  int get total => _total;
  int get pagina => _pagina;
  int get totalPaginas => _totalPaginas;
  bool get cargando => _cargando;
  String? get error => _error;
  String get busqueda => _busqueda;
  bool get haySiguiente => _pagina < _totalPaginas;
  bool get hayAnterior => _pagina > 1;

  Future<void> cargarClientes({int? pagina}) async {
    if (pagina != null) _pagina = pagina;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.obtenerClientes(pagina: _pagina, limite: 20);
      _clientes = response.clientes;
      _total = response.total;
      _totalPaginas = response.totalPaginas;
      _aplicarFiltro();
      _cargando = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> siguientePagina() async {
    if (haySiguiente) await cargarClientes(pagina: _pagina + 1);
  }

  Future<void> anteriorPagina() async {
    if (hayAnterior) await cargarClientes(pagina: _pagina - 1);
  }

  Future<void> refrescar() async {
    await cargarClientes(pagina: 1);
  }

  void buscar(String texto) {
    _busqueda = texto;
    _aplicarFiltro();
    notifyListeners();
  }

  void _aplicarFiltro() {
    if (_busqueda.isEmpty) {
      _clientesFiltrados = List.from(_clientes);
    } else {
      final query = _busqueda.toLowerCase();
      _clientesFiltrados = _clientes.where((c) {
        return c.nombre.toLowerCase().contains(query) ||
            c.identificacion.toLowerCase().contains(query) ||
            c.telefono.contains(query) ||
            c.email.toLowerCase().contains(query);
      }).toList();
    }
  }

  /// Crea un cliente y refresca el listado. Lanza excepción con el mensaje
  /// real del backend si algo falla (ej. identificación duplicada).
  Future<void> crearCliente(Map<String, dynamic> data) async {
    await _service.crearCliente(data);
    await refrescar();
  }

  Future<void> actualizarCliente(int id, Map<String, dynamic> data) async {
    await _service.actualizarCliente(id, data);
    await refrescar();
  }

  Future<void> eliminarCliente(int id) async {
    await _service.eliminarCliente(id);
    await refrescar();
  }
}
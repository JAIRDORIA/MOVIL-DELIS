import 'package:flutter/foundation.dart';
import '../core/services/ventas_services.dart';
import '../data/model/ventas.dart';

class VentasController extends ChangeNotifier {
  final VentasService _ventasService = VentasService();

  List<Venta> _ventas = [];
  List<Venta> _ventasFiltradas = [];
  int _total = 0;
  int _pagina = 1;
  int _totalPaginas = 1;
  bool _cargando = false;
  String? _error;
  String _busqueda = '';
  int? _corteId;

  // Getters
  List<Venta> get ventas => _ventasFiltradas;
  List<Venta> get todasLasVentas => _ventas;
  int get total => _total;
  int get pagina => _pagina;
  int get totalPaginas => _totalPaginas;
  bool get cargando => _cargando;
  String? get error => _error;
  String get busqueda => _busqueda;
  bool get haySiguiente => _pagina < _totalPaginas;
  bool get hayAnterior => _pagina > 1;

  // Cargar ventas desde el backend
  Future<void> cargarVentas({int? pagina, int? corteId}) async {
    if (pagina != null) _pagina = pagina;
    if (corteId != null) _corteId = corteId;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _ventasService.obtenerVentas(
        pagina: _pagina,
        limite: 20,
        corteId: _corteId,
      );

      _ventas = response.ventas;
      _total = response.total;
      _totalPaginas = response.totalPaginas;

      _aplicarFiltro();
      _cargando = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _cargando = false;
      notifyListeners();
    }
  }

  // Siguiente página
  Future<void> siguientePagina() async {
    if (haySiguiente) {
      await cargarVentas(pagina: _pagina + 1);
    }
  }

  // Página anterior
  Future<void> anteriorPagina() async {
    if (hayAnterior) {
      await cargarVentas(pagina: _pagina - 1);
    }
  }

  // Ir a una página específica
  Future<void> irPagina(int pagina) async {
    if (pagina >= 1 && pagina <= _totalPaginas) {
      await cargarVentas(pagina: pagina);
    }
  }

  // Filtrar por corte
  Future<void> filtrarPorCorte(int? corteId) async {
    _corteId = corteId;
    await cargarVentas(pagina: 1);
  }

  // Búsqueda local por nombre de cliente o ID
  void buscar(String texto) {
    _busqueda = texto;
    _aplicarFiltro();
    notifyListeners();
  }

  // Aplicar filtro de búsqueda local
  void _aplicarFiltro() {
    if (_busqueda.isEmpty) {
      _ventasFiltradas = List.from(_ventas);
    } else {
      final query = _busqueda.toLowerCase();
      _ventasFiltradas = _ventas.where((venta) {
        return venta.nombreCliente.toLowerCase().contains(query) ||
            venta.idVenta.toString().contains(query) ||
            venta.estado.toLowerCase().contains(query);
      }).toList();
    }
  }

  // Filtros por estado (para futura implementación)
  String? _filtroEstado;
  String? get filtroEstado => _filtroEstado;

  void filtrarPorEstado(String? estado) {
    _filtroEstado = estado;
    if (estado == null || estado == 'Todos') {
      _ventasFiltradas = List.from(_ventas);
    } else {
      _ventasFiltradas = _ventas
          .where((venta) => venta.estado.toLowerCase() == estado.toLowerCase())
          .toList();
    }
    notifyListeners();
  }

  // Limpiar filtros
  void limpiarFiltros() {
    _filtroEstado = null;
    _busqueda = '';
    _ventasFiltradas = List.from(_ventas);
    notifyListeners();
  }

  // Actualizar después de crear una venta
  Future<void> refrescar() async {
    await cargarVentas(pagina: 1);
  }
}
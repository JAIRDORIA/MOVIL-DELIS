import 'package:flutter/material.dart';
import '../../controllers/cliente_controller.dart';
import '../../data/model/clientes.dart';
import 'formulario_cliente_screen.dart';

class ListadoClientesScreen extends StatefulWidget {
  const ListadoClientesScreen({super.key});

  @override
  State<ListadoClientesScreen> createState() => _ListadoClientesScreenState();
}

class _ListadoClientesScreenState extends State<ListadoClientesScreen> {
  final ClienteController _controller = ClienteController();
  List<Cliente> _clientes = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final lista = await _controller.obtenerClientes();
      setState(() {
        _clientes = lista;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudieron cargar los clientes.\n$e';
        _cargando = false;
      });
    }
  }

  Future<void> _irAFormulario({Cliente? cliente}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioClienteScreen(cliente: cliente),
      ),
    );
    if (resultado == true) {
      _cargarClientes();
    }
  }

  Future<void> _confirmarEliminar(Cliente cliente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text(
          '¿Seguro que deseas eliminar a "${cliente.nombre}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await _controller.eliminarCliente(cliente.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente "${cliente.nombre}" eliminado')),
      );
      _cargarClientes();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargando ? null : _cargarClientes,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _irAFormulario(),
        tooltip: 'Agregar cliente',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _cargarClientes,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_clientes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('No hay clientes registrados'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _irAFormulario(),
              icon: const Icon(Icons.add),
              label: const Text('Agregar cliente'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarClientes,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _clientes.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final cliente = _clientes[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: cliente.activo ? Colors.green : Colors.grey,
              child: Text(
                cliente.nombre.isNotEmpty ? cliente.nombre[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(cliente.nombre),
            subtitle: Text('${cliente.telefono}\n${cliente.email}'),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Editar',
                  onPressed: () => _irAFormulario(cliente: cliente),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Eliminar',
                  onPressed: () => _confirmarEliminar(cliente),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
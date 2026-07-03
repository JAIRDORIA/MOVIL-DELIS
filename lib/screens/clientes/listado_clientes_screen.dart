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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.cargarClientes();
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Color _colorEstado(bool activo) {
    return activo ? Colors.green.shade100 : Colors.grey.shade200;
  }

  Color _textoColorEstado(bool activo) {
    return activo ? Colors.green.shade700 : Colors.grey.shade700;
  }

  Future<void> _irAFormulario({Cliente? cliente}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormularioClienteScreen(cliente: cliente)),
    );
    if (resultado == true) {
      _controller.refrescar();
    }
  }

  Future<void> _confirmarEliminar(Cliente cliente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text('¿Seguro que deseas eliminar a "${cliente.nombre}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Clientes',
          style: TextStyle(color: Color(0xFF1B1D2E), fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _irAFormulario(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nuevo Cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _controller.buscar(value),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, identificación, teléfono o email...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(child: _buildBody()),
          if (_controller.totalPaginas > 1) _buildPaginacion(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_controller.error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _controller.cargarClientes(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller.clientes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('No se encontraron clientes', style: TextStyle(color: Colors.grey)),
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
      onRefresh: () => _controller.refrescar(),
      child: ListView.builder(
        itemCount: _controller.clientes.length,
        itemBuilder: (context, index) => _buildClienteCard(_controller.clientes[index]),
      ),
    );
  }

  Widget _buildClienteCard(Cliente cliente) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          cliente.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _colorEstado(cliente.activo),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cliente.activo ? 'activo' : 'inactivo',
                          style: TextStyle(color: _textoColorEstado(cliente.activo), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'editar':
                        _irAFormulario(cliente: cliente);
                        break;
                      case 'eliminar':
                        _confirmarEliminar(cliente);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'editar',
                      child: ListTile(leading: Icon(Icons.edit), title: Text('Editar')),
                    ),
                    const PopupMenuItem(
                      value: 'eliminar',
                      child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Eliminar', style: TextStyle(color: Colors.red))),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.badge_outlined, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(cliente.identificacion, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(cliente.telefono, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    cliente.email,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    cliente.direccion,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginacion() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mostrando ${_controller.clientes.length} de ${_controller.total} clientes',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _controller.hayAnterior ? () => _controller.anteriorPagina() : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text('${_controller.pagina} / ${_controller.totalPaginas}', style: const TextStyle(fontSize: 13)),
              IconButton(
                onPressed: _controller.haySiguiente ? () => _controller.siguientePagina() : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
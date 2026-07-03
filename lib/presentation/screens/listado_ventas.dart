import 'package:flutter/material.dart';
import '../../controllers/ventas_controller.dart';
import '../../data/model/ventas.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final VentasController _controller = VentasController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.cargarVentas();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Estados con colores
  Color _colorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'entregada':
        return Colors.green.shade100;
      case 'pendiente':
        return Colors.orange.shade100;
      case 'anulada':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _textoColorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'entregada':
        return Colors.green.shade700;
      case 'pendiente':
        return Colors.orange.shade700;
      case 'anulada':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
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
          'Ventas',
          style: TextStyle(
            color: Color(0xFF1B1D2E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          // Botón nueva venta
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Abrir modal/formulario de nueva venta
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nueva Venta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _controller.buscar(value),
              decoration: InputDecoration(
                hintText: 'Buscar por cliente, ID o estado...',
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

          // Tabla
          Expanded(
            child: _controller.cargando
                ? const Center(child: CircularProgressIndicator())
                : _controller.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 12),
                            Text(_controller.error!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _controller.cargarVentas(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    : _controller.ventas.isEmpty
                        ? const Center(
                            child: Text('No se encontraron ventas', style: TextStyle(color: Colors.grey)),
                          )
                        : RefreshIndicator(
                            onRefresh: () => _controller.refrescar(),
                            child: ListView.builder(
                              itemCount: _controller.ventas.length,
                              itemBuilder: (context, index) {
                                final venta = _controller.ventas[index];
                                return _buildVentaCard(venta);
                              },
                            ),
                          ),
          ),

          // Paginación
          if (_controller.totalPaginas > 1)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mostrando ${_controller.ventas.length} de ${_controller.total} ventas',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _controller.hayAnterior ? () => _controller.anteriorPagina() : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        '${_controller.pagina} / ${_controller.totalPaginas}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      IconButton(
                        onPressed: _controller.haySiguiente ? () => _controller.siguientePagina() : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Tarjeta individual de venta (para móvil)
  Widget _buildVentaCard(Venta venta) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: ID, estado y acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '#${venta.idVenta.toString().padLeft(3, '0')}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _colorEstado(venta.estado),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        venta.estado,
                        style: TextStyle(
                          color: _textoColorEstado(venta.estado),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                // Botones de acción
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'ver':
                        // TODO: Ver detalle
                        break;
                      case 'editar':
                        // TODO: Editar venta
                        break;
                      case 'anular':
                        // TODO: Anular venta
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'ver', child: ListTile(leading: Icon(Icons.visibility), title: Text('Ver detalle'))),
                    if (venta.estado == 'pendiente')
                      const PopupMenuItem(value: 'editar', child: ListTile(leading: Icon(Icons.edit), title: Text('Editar'))),
                    if (venta.estado != 'anulada')
                      const PopupMenuItem(value: 'anular', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Anular', style: TextStyle(color: Colors.red)))),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Cliente y total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  venta.nombreCliente,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  '\$${venta.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Fecha y medio de pago
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  venta.fechaEntrega ?? 'Sin fecha',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(width: 16),
                if (venta.medioPago != null) ...[
                  Icon(Icons.payment, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    venta.medioPago!,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ],
            ),

            // Indicador de pagada/pendiente
            if (venta.saldoPendiente > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Pendiente: \$${venta.saldoPendiente.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 11),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Pagada',
                  style: TextStyle(color: Colors.green.shade700, fontSize: 11),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:movil_delis/screens/clientes/listado_clientes_screen.dart';
import 'package:movil_delis/presentation/screens/listado_ventas.dart';
import 'package:movil_delis/core/services/clientes_services.dart';
import 'package:movil_delis/core/services/ventas_services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ClientesService _clientesService = ClientesService();
  final VentasService _ventasService = VentasService();
  String _totalVentas = '...';
  String _totalClientes = '...';
  

  final String _totalCompras = '0';

  @override
  void initState() {
    super.initState();
    _cargarTotalClientes();
    _cargarTotalVentas();
  }

  Future<void> cargarDatos() async {
  await _cargarTotalClientes();
}

  Future<void> _cargarTotalClientes() async {
    try {
      // Solo pedimos 1 registro: no necesitamos la lista completa en el
      // dashboard, solo el campo "total" que ya trae la respuesta paginada.
      final response = await _clientesService.obtenerClientes(pagina: 1, limite: 1);
      if (!mounted) return;
      setState(() => _totalClientes = response.total.toString());
    } catch (_) {
      if (!mounted) return;
      setState(() => _totalClientes = '0');
    }
  }

  Future<void> _irAClientesYActualizar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListadoClientesScreen()),
    );
    // Al volver del listado (por si crearon/eliminaron clientes), refresca el contador.
    _cargarTotalClientes();
  }

  Future<void> _cargarTotalVentas() async {
  try {
    final response = await _ventasService.obtenerVentas(
      pagina: 1,
      limite: 1, // solo necesitamos el total
    );

    setState(() {
      _totalVentas = response.total.toString();
    });
  } catch (e) {
    setState(() {
      _totalVentas = '0';
    });
  }
}

Future<void> _irAVentasYActualizar() async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const VentasScreen()),
  );

  _cargarTotalVentas();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text("Dashboard Delis"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: cargarDatos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "¡Bienvenido!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Información general del negocio",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: tarjetaInfo("Clientes", _totalClientes, Icons.people, Colors.blue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: tarjetaInfo("Compras", _totalCompras, Icons.shopping_cart, Colors.green),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: tarjetaInfo("Ventas", _totalVentas, Icons.trending_up, Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Módulos",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            moduloCard(
              context,
              "Clientes",
              "Gestiona tus clientes",
              Icons.people,
              Colors.blue,
              _irAClientesYActualizar,
            ),
            moduloCard(
              context,
              "Compras",
              "Gestiona tus compras",
              Icons.shopping_cart,
              Colors.green,
              () {
                // Navegar a compras
              },
            ),
            moduloCard(
              context,
              "Ventas",
              "Gestiona tus ventas",
              Icons.bar_chart,
              Colors.purple,
              _irAVentasYActualizar,
            ),
          ],
        ),
      ),
    );
  }

  Widget tarjetaInfo(String titulo, String cantidad, IconData icono, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(
              icono,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              cantidad,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget moduloCard(
    BuildContext context,
    String titulo,
    String subtitulo,
    IconData icono,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            icono,
            color: color,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
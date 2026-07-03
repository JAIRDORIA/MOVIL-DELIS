import 'package:flutter/material.dart';
import 'package:movil_delis/controllers/dashboard_controller.dart';
import 'package:movil_delis/screens/clientes/listado_clientes_screen.dart';
import 'package:movil_delis/presentation/screens/listado_ventas.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController controller = DashboardController();

  int totalClientes = 0;
  int totalCompras = 0;
  int totalVentas = 0;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final clientes = await controller.obtenerClientes();
      final compras = await controller.obtenerCompras();
      final ventas = await controller.obtenerVentas();

      setState(() {
        totalClientes = clientes.length;
        totalCompras = compras.length;
        totalVentas = ventas.length;
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
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
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Información general del negocio",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: tarjetaInfo(
                    "Clientes",
                    totalClientes.toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: tarjetaInfo(
                    "Compras",
                    totalCompras.toString(),
                    Icons.shopping_cart,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: tarjetaInfo(
                    "Ventas",
                    totalVentas.toString(),
                    Icons.trending_up,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Módulos",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),    
            ),

            const SizedBox(height: 15),

            moduloCard(
              context,
              "Clientes",
              "Gestiona tus clientes",
              Icons.people,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListadoClientesScreen(),
                  ),
                );
              },
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
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VentasScreen(),
                  ),
                );
                // Navegar a ventas
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget tarjetaInfo(
    String titulo,
    String cantidad,
    IconData icono,
    Color color,
  ) {
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
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              cantidad,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
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
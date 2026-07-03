import 'package:flutter/material.dart';
import '../presentation/screens/listado_ventas.dart';

class AppRoutes {
  // Rutas estáticas para facilitar la navegación
  static const String home = '/';
  static const String ventas = '/ventas';

  // Mapa de rutas: asocia cada path con su pantalla
  static Map<String, WidgetBuilder> routes = {
    home: (_) => const VentasScreen(),   // Pantalla principal de ventas
  };
}
// static , no es es necesario crear un objeto para acceder a esos recursos
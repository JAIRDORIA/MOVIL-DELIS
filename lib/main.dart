import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:movil_delis/screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movil Delis',
      home: Dashboard(),
    );
  }
}
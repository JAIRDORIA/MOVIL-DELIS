import 'package:flutter/material.dart';
import 'screens/clientes/listado_clientes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Lenguajes(),
    );
  }
}

class Lenguajes extends StatelessWidget {
  const Lenguajes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ej Contenedor"),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Clientes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ListadoClientesScreen()),
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        height: 150,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
             Tarjeta(Colors.red, "Java"),
             Tarjeta(Colors.greenAccent, "c++"),
             Tarjeta(Colors.pink.shade100,"Pseint"),
          ],),
      )   
    );
  }

  Widget Tarjeta(Color c, String texto){
    return  Container(
         margin: const EdgeInsets.all(5),
         padding: const EdgeInsets.all(10),
         width: 150,
         height: 150,
         decoration:  BoxDecoration(
           color: c,
           borderRadius: BorderRadius.all(Radius.circular(20)),
         ),
         child:   Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texto, style: TextStyle(fontSize: 25),),
                Text("30 post", style: TextStyle(fontSize: 20),),
              ],
         ),
      )  ;
  }
}
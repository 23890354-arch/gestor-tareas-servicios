import 'package:flutter/material.dart';
// import 'pantallas/pantalla_form_tarea.dart';
import 'pantallas/pantalla_lista_tareas.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor Tareas Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const PantallaFormularioTarea(),
      home: const PantallaListaTareas(),
    );
  }
}

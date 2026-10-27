import 'package:flutter/material.dart';
import '../modelos/modelo_tarea.dart';
import 'pantalla_form_tarea.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

class PantallaListaTareas extends StatefulWidget {
  const PantallaListaTareas({super.key});

  @override
  State<PantallaListaTareas> createState() => _PantallaListaTareasState();
}

class _PantallaListaTareasState extends State<PantallaListaTareas> {
  // Lista local en memoria que almacenará los objetos Tarea
  final List<Tarea> _listaDeTareas = [];

      // Clave con la que se guarda la lista en el almacenamiento local
    static const String _claveTareas = 'lista_tareas';

    @override
    void initState() {
      super.initState();
      _cargarTareas(); // Al abrir la pantalla, recupera las tareas guardadas
    }

    // Convierte cada Tarea a JSON y guarda la lista completa
    Future<void> _guardarTareas() async {
      final prefs = await SharedPreferences.getInstance();
      final listaJson =
          _listaDeTareas.map((t) => jsonEncode(t.toMap())).toList();
      await prefs.setStringList(_claveTareas, listaJson);
    }

    // Lee la lista guardada y reconstruye los objetos Tarea
    Future<void> _cargarTareas() async {
      final prefs = await SharedPreferences.getInstance();
      final listaJson = prefs.getStringList(_claveTareas) ?? [];
      if (!mounted) return; // Evita usar setState si la pantalla ya se cerró
      setState(() {
        _listaDeTareas
          ..clear()
          ..addAll(listaJson.map(
            (texto) => Tarea.fromMap(jsonDecode(texto) as Map<String, dynamic>),
          ));
      });
    }

   // 2) Navegación asíncrona hacia el formulario

    // Inicia nuevo método: Navegación asíncrona hacia el formulario
    Future<void> _abrirFormulario() async {
      // Navigator.push envía al usuario a la nueva pantalla y ESPERA un resultado
      final Tarea? tareaCreada = await Navigator.push<Tarea>(
        context,
        MaterialPageRoute(
          builder: (context) => const PantallaFormularioTarea(),
        ),
      );

      // Si el usuario guardó la tarea (retornó un objeto no nulo)
      if (tareaCreada != null) {
        setState(() {
          _listaDeTareas.add(tareaCreada);
        });
        await _guardarTareas(); // <-- NUEVO: persiste la lista actualizada
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Tareas y Servicios'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _listaDeTareas.isEmpty
          ? const Center(
              child: Text(
                'No hay tareas registradas.\n¡Presiona + para agregar una!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          // 3) Renderización dinámica de la lista.
  : ListView.builder(
              itemCount: _listaDeTareas.length,
              itemBuilder: (context, index) {
                final tarea = _listaDeTareas[index];
                
                // Formateo de fecha para la tarjeta
                final fechaTexto =
                    '${tarea.fechaLimite.day}/${tarea.fechaLimite.month}/${tarea.fechaLimite.year}';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: tarea.rutaFoto != null
                        ? CircleAvatar(
                            radius: 28,
                            backgroundImage: FileImage(File(tarea.rutaFoto!)),
                          )
                        : CircleAvatar(
                            backgroundColor: tarea.estaCompletada
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            child: Icon(
                              tarea.estaCompletada
                                  ? Icons.check_circle
                                  : Icons.pending_actions,
                              color: tarea.estaCompletada
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),

                    title: Text(
                      tarea.titulo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: tarea.estaCompletada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      '${tarea.descripcion}\nFecha límite: $fechaTexto',
                    ),
                    isThreeLine: true,
                    // Etiqueta visual de Prioridad en el extremo derecho
                    trailing: Chip(
                      label: Text(
                        tarea.prioridad,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: tarea.prioridad == 'Alta'
                          ? Colors.red.shade100
                          : tarea.prioridad == 'Media'
                              ? Colors.amber.shade100
                              : Colors.blue.shade100,
                    ),
                  ),
                );
              },
            ),

        floatingActionButton: FloatingActionButton(
        onPressed:_abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}
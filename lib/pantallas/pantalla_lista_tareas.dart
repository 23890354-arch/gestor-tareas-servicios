import 'package:flutter/material.dart';
import '../modelos/modelo_tarea.dart';
import 'pantalla_form_tarea.dart';

class PantallaListaTareas extends StatefulWidget {
  const PantallaListaTareas({super.key});

  @override
  State<PantallaListaTareas> createState() => _PantallaListaTareasState();
}

class _PantallaListaTareasState extends State<PantallaListaTareas> {
  // Lista local en memoria que almacenará los objetos Tarea
  final List<Tarea> _listaDeTareas = [];

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
                    // Ícono lateral según el estado de la tarea
                    leading: CircleAvatar(
                      backgroundColor: tarea.estaCompletada
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      child: Icon(
                        tarea.estaCompletada
                            ? Icons.check_circle
                            : Icons.pending_actions,
                        color: tarea.estaCompletada ? Colors.green : Colors.orange,
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
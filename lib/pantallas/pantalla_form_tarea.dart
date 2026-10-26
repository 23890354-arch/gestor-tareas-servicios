import 'package:flutter/material.dart';
import '../modelos/modelo_tarea.dart';

class PantallaFormularioTarea extends StatefulWidget {
  const PantallaFormularioTarea({super.key});

  @override
  State<PantallaFormularioTarea> createState() => _PantallaFormularioTareaState();
}

class _PantallaFormularioTareaState extends State<PantallaFormularioTarea> {
  // 1. Clave global para identificar y validar el formulario
  final _llaveFormulario = GlobalKey<FormState>();

  // 2. Variables para almacenar los datos ingresados
  String _titulo = '';
  String _descripcion = '';
  String _prioridad = 'Media';

  final List<String> _prioridades = ['Baja', 'Media', 'Alta'];

  // nuevas variables de estado (3.3 uso de controles)
  bool _estaCompletada = false;
  DateTime _fechaSeleccionada = DateTime.now();

  // Método para abrir el selector de fecha nativo de Android/iOS

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaElegida = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now(), // No permite seleccionar fechas pasadas
      lastDate: DateTime(2030),
    );

    if (fechaElegida != null && fechaElegida != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = fechaElegida;
      });
    }
  }


  // Reemplaza el código de la función _guardarFormulario() por esta versión actualizada:

 void _guardarFormulario() {
    // 1. Ejecuta la validación de los TextFormField
    if (_llaveFormulario.currentState!.validate()) {
      // 2. Ejecuta los métodos onSaved de cada campo de texto
      _llaveFormulario.currentState!.save();

      // 3. Instancia la clase Tarea con TODOS los controles (Formularios y controles)
      final nuevaTarea = Tarea(
        titulo: _titulo,
        descripcion: _descripcion,
        prioridad: _prioridad,
        estaCompletada: _estaCompletada,      // <-- NUEVO: Valor del SwitchListTile
        fechaLimite: _fechaSeleccionada,     // <-- NUEVO: Valor del DatePicker
      );

      // 4. Formatea la fecha para mostrarla limpiamente en el mensaje
      final fechaTexto = '${nuevaTarea.fechaLimite.day}/${nuevaTarea.fechaLimite.month}/${nuevaTarea.fechaLimite.year}';
      final estadoTexto = nuevaTarea.estaCompletada ? 'Completada' : 'Pendiente';

      // 5. Muestra la retroalimentación visual al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tarea "${nuevaTarea.titulo}" creada ($estadoTexto). Entrega: $fechaTexto',
          ),
          backgroundColor: Colors.green[700],
        ),
      );

      // Se mantiene comentado temporalmente hasta el tema de Navegación
      Navigator.pop(context, nuevaTarea);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Tarea / Servicio'),
      ),
      // SingleChildScrollView evita que el teclado oculte los elementos
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _llaveFormulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo Título
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título de la tarea',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.task),
                ),
                textInputAction: TextInputAction.next,
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
                onSaved: (valor) => _titulo = valor!,
              ),
              const SizedBox(height: 16),

              // Campo Descripción
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descripción detallada',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (valor) {
                  if (valor == null || valor.trim().length < 5) {
                    return 'La descripción debe tener al menos 5 caracteres';
                  }
                  return null;
                },
                onSaved: (valor) => _descripcion = valor!,
              ),
              const SizedBox(height: 16),

              // Campo Selección de Prioridad (Dropdown)
              DropdownButtonFormField<String>(
                initialValue: _prioridad,
                decoration: const InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: _prioridades.map((prioridad) {
                  return DropdownMenuItem(
                    value: prioridad,
                    child: Text(prioridad),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _prioridad = valor!;
                  });
                },
              ),
              const SizedBox(height: 24),

              //3) Incorporación de SwitchListTile y selector de fecha en la interfaz (UI)

              // CONTROL 1: Interruptor de Estado (SwitchListTile)
             
              SwitchListTile(
                title: const Text('¿Tarea completada?'),
                subtitle: Text(_estaCompletada ? 'Estado: Finalizada' : 'Estado: Pendiente'),
                value: _estaCompletada,
                secondary: Icon(
                  _estaCompletada ? Icons.check_circle : Icons.pending,
                  color: _estaCompletada ? Colors.green : Colors.orange,
                ),
                onChanged: (bool valor) {
                  setState(() {
                    _estaCompletada = valor;
                  });
                },
              ),
              const SizedBox(height: 16),

              
              // CONTROL 2: Selector de Fecha (DatePicker via ListTile + OutlinedButton)
              
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Fecha límite de entrega'),
                  subtitle: Text(
                    '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                  ),
                  trailing: OutlinedButton(
                    onPressed: () => _seleccionarFecha(context),
                    child: const Text('Cambiar'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
          

              // Botón Guardar
              ElevatedButton.icon(
                onPressed: _guardarFormulario,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Tarea'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

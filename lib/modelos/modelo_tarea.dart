class Tarea {
  String titulo;
  String descripcion;
  String prioridad; // 'Alta', 'Media', 'Baja'
  bool estaCompletada;
  DateTime fechaLimite; // Nuevo: control de fecha


  Tarea({
    required this.titulo,
    required this.descripcion,
    this.prioridad = 'Media',
    this.estaCompletada = false,
    required this.fechaLimite, // Nuevo: campo obligatorio
  });
}

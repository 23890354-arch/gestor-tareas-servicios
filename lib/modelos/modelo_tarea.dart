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

    // Convierte el objeto a un Map para poder guardarlo como JSON
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'estaCompletada': estaCompletada,
      'fechaLimite': fechaLimite.toIso8601String(), // DateTime -> texto
    };
  }

  // Reconstruye un objeto Tarea a partir de un Map
  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      prioridad: map['prioridad'] as String,
      estaCompletada: map['estaCompletada'] as bool,
      fechaLimite: DateTime.parse(map['fechaLimite'] as String), // texto -> DateTime
    );
  }
}

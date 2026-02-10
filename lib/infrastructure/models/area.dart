class Area {
  final String nombre;
  final String descripcion;
  final double x;
  final double y;
  final List<String> horario;
  final List<String> servicios;
  final List<String>? reglas;
  final List<String> galeria;
  final List<String> palabrasClave;

  final bool? sePuedeRentar;
  final String? infoRenta;
  final int? piso;
  final String categoria;
  final bool esUbicacionActual;

  // 🔹 Nueva propiedad para la imagen de reglamentos
  final String? imagenReglamento;

  Area({
    required this.nombre,
    required this.descripcion,
    required this.x,
    required this.y,
    required this.horario,
    required this.servicios,
    this.reglas,
    required this.galeria,
    required this.categoria,
    required this.palabrasClave,
    this.esUbicacionActual = false,
    this.sePuedeRentar,
    this.infoRenta,
    this.piso,
    this.imagenReglamento, // Añadido al constructor
  });

  /// 🔹 ACTUALIZADO CON IMAGEN DE REGLAMENTO Y PALABRAS CLAVE
  Area copyWith({
    int? piso,
    String? categoria,
    bool? esUbicacionActual,
    List<String>? palabrasClave,
    String? imagenReglamento, // Añadido al copyWith
  }) {
    return Area(
      nombre: nombre,
      descripcion: descripcion,
      x: x,
      y: y,
      horario: horario,
      servicios: servicios,
      reglas: reglas,
      galeria: galeria,
      sePuedeRentar: sePuedeRentar,
      infoRenta: infoRenta,
      categoria: categoria ?? this.categoria,
      piso: piso ?? this.piso,
      esUbicacionActual: esUbicacionActual ?? this.esUbicacionActual,
      palabrasClave: palabrasClave ?? this.palabrasClave,
      imagenReglamento: imagenReglamento ?? this.imagenReglamento,
    );
  }
}

class Area {
  final String nombre;
  final String descripcion;
  final double x;
  final double y;
  final String horario;
  final List<String> servicios;
  final List<String> reglas;
  final List<String> galeria;
  final bool? sePuedeRentar;
  final String? infoRenta;
  final int? piso;
  final String categoria; // 🔹 AGREGADO: Para los filtros (ej: 'Baños', 'Libros')

  Area({
    required this.nombre,
    required this.descripcion,
    required this.x,
    required this.y,
    required this.horario,
    required this.servicios,
    required this.reglas,
    required this.galeria,
    required this.categoria, // 🔹 REQUERIDO AHORA
    this.sePuedeRentar,
    this.infoRenta,
    this.piso,
  });

  /// 🔹 ACTUALIZADO CON CATEGORIA
  Area copyWith({
    int? piso,
    String? categoria,
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
    );
  }
}
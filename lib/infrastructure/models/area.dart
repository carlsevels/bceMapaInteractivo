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

  Area({
    required this.nombre,
    required this.descripcion,
    required this.x,
    required this.y,
    required this.horario,
    required this.servicios,
    required this.reglas,
    required this.galeria,
    this.sePuedeRentar,
    this.infoRenta,
  });
}

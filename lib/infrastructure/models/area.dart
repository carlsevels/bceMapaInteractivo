import 'package:get/get.dart';
import 'package:mapa_interactivo/presentation/detallesArea/areaTraslations.dart';

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
  final String? imagenReglamento;

  // --- GETTERS DE TRADUCCIÓN ---

  /// Traduce el nombre (Usa 'nombre' como llave)
  String get displayName => AreaTranslations.get(nombre);

  /// Traduce la descripción (¡IMPORTANTE: También usa 'nombre' como llave!)
  String get displayDescription {
    if (Get.locale?.languageCode == 'es') return descripcion;
    // Buscamos en el diccionario usando el nombre de la sala, pero pedimos la descripción (isDesc: true)
    return AreaTranslations.get(nombre, isDesc: true);
  }

  /// Traduce la categoría
  String get displayCategory => AreaTranslations.translateCategory(categoria);

  /// Traduce la info de renta
  String? get displayInfoRenta {
    if (infoRenta == null) return null;
    if (Get.locale?.languageCode == 'es') return infoRenta;
    return "Request via email 2 weeks in advance."; 
  }

  // --- CONSTRUCTOR ---

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
    this.imagenReglamento,
  });

  // --- MÉTODOS ---

  Area copyWith({
    int? piso,
    String? categoria,
    bool? esUbicacionActual,
    List<String>? palabrasClave,
    String? imagenReglamento,
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
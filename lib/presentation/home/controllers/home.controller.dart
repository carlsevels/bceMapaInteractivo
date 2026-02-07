import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';

class HomeController extends GetxController {
  final RxInt missionStep = 0.obs;
  final RxBool isMenuOpen = true.obs;
  final TextEditingController searchController = TextEditingController();
  final Rx<Area?> selectedArea = Rx<Area?>(null);
  final Rx<Area?> visibleArea = Rx<Area?>(null);
  final RxBool isPanelOpen = false.obs;
  final RxInt pisoActual = 1.obs;
  final RxString query = ''.obs;
  final RxList<Area> sugerencias = <Area>[].obs;
  final RxString categoriaSeleccionada = ''.obs;

  // 🔹 CONTROL DE ZOOM
  final RxInt zoomLevel = 0.obs;
  final int maxZoomClicks = 5;
  final TransformationController transformationController =
      TransformationController();

  final Map<int, List<Area>> pisos = {
    1: [
      Area(
        nombre: 'Módulo de información',
        x: 820,
        y: 700,
        categoria: 'Información',
        descripcion: 'Punto principal de orientación para visitantes.',
        horario: 'Lunes a Viernes · 9:00 AM – 8:00 PM',
        servicios: ['Orientación', 'Apoyo catálogo'],
        reglas: ['Formar fila', 'No alimentos'],
        galeria: ['modulo/imagen1.jpeg', 'modulo/imagen2.jpeg'],
      ),
      Area(
        nombre: 'Área de inclusión',
        x: 370,
        y: 730,
        categoria: 'Inclusión',
        descripcion: 'Acceso equitativo a la información.',
        horario: 'Lunes a Sábado · 9:00 AM – 7:00 PM',
        servicios: ['Braille', 'Audiolibros'],
        reglas: ['Prioridad discapacidad'],
        galeria: [
          'inclusion/imagen1.jpeg',
          'inclusion/imagen2.jpeg',
          'inclusion/imagen3.jpeg',
        ],
      ),
      Area(
        nombre: 'Sala multipropósito',
        x: 230,
        y: 780,
        categoria: 'Cultura',
        descripcion: 'Actividades culturales y talleres.',
        horario: 'Según programación',
        servicios: ['Talleres', 'Conferencias'],
        reglas: ['Acceso con eventos'],
        galeria: ['multiproposito/imagen1.jpeg', 'multiproposito/imagen2.jpeg'],
      ),
      Area(
        nombre: 'Sala de juntas',
        x: 370,
        y: 850,
        categoria: 'Estudio',
        descripcion: 'Reuniones de trabajo y académicas.',
        horario: 'Lunes a Viernes · 10:00 AM – 6:00 PM',
        servicios: ['Reservación'],
        reglas: ['No alimentos'],
        galeria: ['salaDeJuntas/imagen1.jpeg'],
      ),
      Area(
        nombre: 'Cafetería',
        x: 620,
        y: 920,
        categoria: 'Alimentos',
        descripcion: 'Consumo de alimentos y bebidas.',
        horario: '8:30 AM – 7:30 PM',
        servicios: ['Venta alimentos'],
        reglas: ['Limpieza'],
        galeria: [],
      ),
      Area(
        nombre: 'Legado N.L.',
        x: 970,
        y: 170,
        categoria: 'Cultura',
        descripcion: 'Patrimonio histórico de Nuevo León.',
        horario: 'Martes a Domingo · 10:00 AM – 6:00 PM',
        servicios: ['Exposiciones'],
        reglas: ['No tocar'],
        galeria: [
          'legadoNL/imagen1.jpeg',
          'legadoNL/imagen2.jpeg',
          'legadoNL/imagen3.jpeg',
        ],
      ),
      Area(
        nombre: 'Acervo',
        x: 200,
        y: 200,
        categoria: 'Cultura',
        descripcion: 'Patrimonio histórico de Nuevo León.',
        horario: 'Martes a Domingo · 10:00 AM – 6:00 PM',
        servicios: ['Exposiciones'],
        reglas: ['No tocar'],
        galeria: [
          'acervo/imagen1.jpeg',
          "acervo/imagen2.jpeg",
          "acervo/imagen3.jpeg",
          "acervo/imagen4.jpeg",
        ],
      ),
      Area(
        nombre: 'Cubiculos',
        x: 510,
        y: 70,
        categoria: 'Estudio',
        descripcion: 'Patrimonio histórico de Nuevo León.',
        horario: 'Martes a Domingo · 10:00 AM – 6:00 PM',
        servicios: ['Exposiciones'],
        reglas: ['No tocar'],
        galeria: ['cubiculos/imagen1.jpeg', "cubiculos/imagen2.jpeg"],
      ),
      Area(
        nombre: 'MEZZANINE',
        x: 820,
        y: 340,
        categoria: 'Estudio',
        descripcion: 'Patrimonio histórico de Nuevo León.',
        horario: 'Martes a Domingo · 10:00 AM – 6:00 PM',
        servicios: ['Exposiciones'],
        reglas: ['No tocar'],
        galeria: ['mezzanine/imagen1.jpeg', "mezzanine/imagen2.jpeg"],
      ),
    ],
    2: [
      Area(
        nombre: 'Punto de Consulta Principal',
        x: 700,
        y: 160,
        categoria: 'Ubicación',
        descripcion: 'Te encuentras en el punto de consulta del segundo piso.',
        horario: 'Disponible 24/7',
        esUbicacionActual: true,
        servicios: ['Mapa interactivo', 'Búsqueda de libros'],
        reglas: ['Uso preferente para visitantes'],
        galeria: ['assets/multimedia/vr_1.png'],
      ),
      Area(
        nombre: 'Sala juvenil',
        x: 550,
        y: 120,
        categoria: 'Estudio',
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: [
          'salaJuvenil/imagen1.jpeg',
          'salaJuvenil/imagen2.jpeg',
          'salaJuvenil/imagen3.jpeg',
          'salaJuvenil/imagen4.jpeg',
        ],
      ),
      Area(
        nombre: 'Auditorio',
        x: 150,
        y: 140,
        categoria: 'Cultura',
        descripcion: 'Espacio amplio destinado a conferencias y eventos.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Escenario', 'Sonido'],
        reglas: ['No alimentos'],
        galeria: [
          'auditorio/imagen1.jpeg',
          'auditorio/imagen2.jpeg',
          'auditorio/imagen3.jpeg',
          'auditorio/imagen4.jpeg',
        ],
        sePuedeRentar: true,
        infoRenta: 'Solicitar vía correo con 2 semanas de anticipación.',
      ),
      Area(
        nombre: 'Comicteca',
        x: 990,
        y: 170,
        categoria: 'Cultura',
        descripcion: 'Colección de cómics y novelas gráficas.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Lectura'],
        reglas: ['Cuidar materiales'],
        galeria: ['comicteca/imagen1.jpeg', 'comicteca/imagen2.jpeg'],
      ),
      Area(
        nombre: 'Primera infancia',
        x: 350,
        y: 750,
        categoria: 'Infantil',
        descripcion: 'Área para los más pequeños.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Juegos didácticos'],
        reglas: ['Supervisión adultos'],
        galeria: [
          'primeraInfancia/imagen1.jpeg',
          'primeraInfancia/imagen2.jpeg',
          'primeraInfancia/imagen3.jpeg',
        ],
      ),
      Area(
        nombre: 'Cine infantil/Coliseo',
        x: 400,
        y: 850,
        categoria: 'Infantil',
        descripcion: 'Proyecciones y cuentacuentos.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Cine'],
        reglas: ['Orden'],
        galeria: [
          'cineInfantil/imagen1.jpeg',
          'cineInfantil/imagen2.jpeg',
          'cineInfantil/imagen3.jpeg',
          'cineInfantil/imagen4.jpeg',
        ],
      ),
      Area(
        nombre: 'Ludoteca',
        x: 580,
        y: 960,
        categoria: 'Infantil',
        descripcion: 'Espacio de juegos.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Juguetes'],
        reglas: ['Compartir'],
        galeria: [
          'ludoteca/imagen1.jpeg',
          'ludoteca/imagen2.jpeg',
          'ludoteca/imagen3.jpeg',
          'ludoteca/imagen4.jpeg',
        ],
      ),
      Area(
        nombre: 'Zona multimedia',
        x: 800,
        y: 650,
        categoria: 'Tecnología',
        descripcion: 'Acceso a computadoras e internet.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Internet'],
        reglas: ['Tiempo limitado'],
        galeria: [
          'multimedia/imagen1.jpeg',
          'multimedia/imagen2.jpeg',
          "multimedia/imagen3.jpeg",
        ],
      ),
      Area(
        nombre: 'Realidad virtual',
        x: 800,
        y: 930,
        categoria: 'Tecnología',
        descripcion: 'Experiencias inmersivas.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Gafas VR'],
        reglas: ['Uso responsable'],
        galeria: [
          'realidadVirtual/imagen1.jpeg',
          'realidadVirtual/imagen2.jpeg',
        ],
      ),
      Area(
        nombre: 'Impresión 3D',
        x: 950,
        y: 820,
        categoria: 'Tecnología',
        descripcion: 'Laboratorio de fabricación digital.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Modelado 3D'],
        reglas: ['Costo material'],
        galeria: [],
      ),
      Area(
        nombre: 'Cabina podcast',
        x: 480,
        y: 240,
        categoria: 'Tecnología',
        descripcion: 'Grabación de audio profesional.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Grabación'],
        reglas: ['Reservación'],
        galeria: [
          'podcast/imagen1.jpeg',
          'podcast/imagen2.jpeg',
          'podcast/imagen3.jpeg',
        ],
        sePuedeRentar: true,
      ),
    ],
  };

  @override
  void onInit() {
    super.onInit();

    // 🔹 SINCRONIZACIÓN TOUCH/GESTOS -> zoomLevel
    transformationController.addListener(() {
      final double scale = transformationController.value.getMaxScaleOnAxis();

      // Mapeamos la escala física al rango de zoomLevel (-5 a 5)
      // Ajustado para que scale 2.5 sea nivel 5 y scale 0.4 sea nivel -5
      if (scale > 1.0) {
        zoomLevel.value = ((scale - 1.0) / (2.5 - 1.0) * maxZoomClicks)
            .round()
            .clamp(0, maxZoomClicks);
      } else if (scale < 1.0) {
        zoomLevel.value = -((1.0 - scale) / (1.0 - 0.4) * maxZoomClicks)
            .round()
            .clamp(0, maxZoomClicks);
      } else {
        zoomLevel.value = 0;
      }
    });

    ever(pisoActual, (_) {
      if (missionStep.value == 1) missionStep.value = 2;
    });
    ever(query, (String val) {
      if (missionStep.value == 2 && val.length > 1) missionStep.value = 3;
    });
  }

  void iniciarTutorial() {
    missionStep.value = 1;
    isMenuOpen.value = true;
    resetZoom();
  }

  void cancelarTutorial() {
    missionStep.value = 0;
    searchController.clear();
    query.value = '';
    Get.snackbar(
      "Tutorial cancelado",
      "Puedes volver a iniciarlo cuando gustes.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  void onAreaSelected(Area area) {
    visibleArea.value = area;
    selectedArea.value = area;
    isPanelOpen.value = true;

    if (missionStep.value == 3) {
      missionStep.value = 0;
      Get.snackbar(
        "¡MISIÓN COMPLETADA!",
        "Has aprendido a navegar por el mapa.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
        icon: const Icon(Icons.emoji_events, color: Colors.black, size: 35),
      );
    }
  }

  void closePanel() {
    isPanelOpen.value = false;
    Future.delayed(const Duration(milliseconds: 800), () {
      visibleArea.value = null;
      selectedArea.value = null;
    });
  }

  void buscarSugerencias(String val) {
    query.value = val;
    if (val.trim().isEmpty) {
      sugerencias.clear();
      return;
    }
    final normalizedQuery = normalize(val);
    final List<Area> resultados = [];
    pisos.forEach((piso, areas) {
      for (final area in areas) {
        if (normalize(area.nombre).contains(normalizedQuery)) {
          resultados.add(area.copyWith(piso: piso));
        }
      }
    });
    sugerencias.assignAll(resultados);
  }

  void seleccionarDesdeSugerencia(Area area) async {
    if (pisoActual.value != area.piso) {
      pisoActual.value = area.piso!;
      await Future.delayed(const Duration(milliseconds: 50));
    }

    query.value = area.nombre;
    searchController.text = area.nombre;
    sugerencias.clear();

    _aplicarZoomAutomatico(area);
    //onAreaSelected(area);
  }

  void _aplicarZoomAutomatico(Area area) {
    const double zoomScale = 2.5;
    final Size screenSize = Get.size;

    double centerX = screenSize.width / 2;
    if (isMenuOpen.value) {
      centerX -= 175;
    }

    final double x = centerX - (area.x * zoomScale);
    final double y = (screenSize.height / 2) - (area.y * zoomScale);

    transformationController.value = Matrix4.identity()
      ..translate(x, y)
      ..scale(zoomScale);

    // Al centrar automáticamente, el listener actualizará el zoomLevel
  }

  String normalize(String text) {
    const withAccents = 'áéíóúüñÁÉÍÓÚÜÑ';
    const withoutAccents = 'aeiouunAEIOUUN';
    for (int i = 0; i < withAccents.length; i++) {
      text = text.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return text.toLowerCase();
  }

  // 🔹 MÉTODOS DE ZOOM CON LÍMITES DE CLIC
  void zoomIn() {
    if (zoomLevel.value < maxZoomClicks) {
      transformationController.value = transformationController.value.clone()
        ..scale(1.2);
    }
  }

  void zoomOut() {
    if (zoomLevel.value > -maxZoomClicks) {
      transformationController.value = transformationController.value.clone()
        ..scale(0.8);
    }
  }

  void resetZoom() {
    transformationController.value = Matrix4.identity();
    zoomLevel.value = 0;
  }

  void setCategoria(String cat) {
    categoriaSeleccionada.value = (categoriaSeleccionada.value == cat)
        ? ''
        : cat;
  }
}

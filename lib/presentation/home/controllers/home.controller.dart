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
  var menuWidth = 320.0.obs; // ancho inicial
  var isDragging = false.obs;
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
        galeria: ['assets/modulo/imagen1.jpeg', 'assets/modulo/imagen2.jpeg'],
        palabrasClave: [
          'informacion',
          'información',
          'info',
          'ayuda',
          'ayudar',
          'orientacion',
          'orientación',
          'recepcion',
          'recepción',
          'entrada',
          'inicio',
          'empezar',
          'comienzo',
          'preguntas',
          'preguntar',
          'atencion',
          'atención',
          'mapa',
          'mapita',
          'guia',
          'guía',
          'soporte',
          'consulta',
          'mostrador',
          'bienvenida',
          'ayuda por favor',
          'informes',
          'orientador',
          'visitor',
          'help',
          'help desk',
          'information',
          'front desk',
        ],
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
          'assets/inclusion/imagen1.jpeg',
          'assets/inclusion/imagen2.jpeg',
          'assets/inclusion/imagen3.jpeg',
        ],
        palabrasClave: [
          'inclusion',
          'inclusión',
          'accesibilidad',
          'acceso',
          'ayuda especial',
          'discapacidad',
          'capacidades diferentes',
          'personas mayores',
          'braille',
          'libros braille',
          'audiolibros',
          'audio',
          'escuchar',
          'lectura auditiva',
          'apoyo',
          'equidad',
          'igualdad',
          'inclusivo',
          'adaptado',
          'lenguaje',
          'señas',
          'lenguaje de señas',
          'facil acceso',
          'ayuda discapacidad',
          'apoyo especial',
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
        galeria: [
          'assets/multiproposito/imagen1.jpeg',
          'assets/multiproposito/imagen2.jpeg',
        ],
        palabrasClave: [
          'sala',
          'salon',
          'salón',
          'multiproposito',
          'multipropósito',
          'eventos',
          'evento',
          'talleres',
          'taller',
          'conferencias',
          'charlas',
          'platicas',
          'actividades',
          'reuniones',
          'juntas',
          'cultura',
          'presentaciones',
          'exposiciones',
          'capacitaciones',
          'uso multiple',
          'uso general',
          'actividades culturales',
        ],
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
        galeria: ['assets/salaDeJuntas/imagen1.jpeg'],
        palabrasClave: [
          'sala de juntas',
          'juntas',
          'reuniones',
          'meeting',
          'trabajo',
          'oficina',
          'equipo',
          'grupo',
          'academico',
          'académico',
          'escuela',
          'universidad',
          'presentacion',
          'presentación',
          'reservar',
          'agenda',
          'planeacion',
          'planeación',
          'cita',
          'oficina reuniones',
        ],
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
        palabrasClave: [
          'cafeteria',
          'cafetería',
          'cafe',
          'café',
          'comida',
          'comer',
          'alimentos',
          'bebidas',
          'snacks',
          'antojitos',
          'desayuno',
          'almuerzo',
          'merienda',
          'tomar cafe',
          'descanso',
          'break',
          'comida rapida',
          'coffee',
          'food',
          'eat',
          'drink',
        ],
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
          'assets/legadoNL/imagen1.jpeg',
          'assets/legadoNL/imagen2.jpeg',
          'assets/legadoNL/imagen3.jpeg',
        ],
        palabrasClave: [
          'legado',
          'nuevo leon',
          'nl',
          'historia',
          'historico',
          'histórico',
          'patrimonio',
          'estado',
          'exposicion',
          'exposición',
          'cultura',
          'museo',
          'regional',
          'historia local',
          'cosas antiguas',
          'pasado',
          'tradiciones',
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
          'assets/acervo/imagen1.jpeg',
          'assets/acervo/imagen2.jpeg',
          'assets/acervo/imagen3.jpeg',
          'assets/acervo/imagen4.jpeg',
        ],
        palabrasClave: [
          'acervo',
          'archivo',
          'archivos',
          'coleccion',
          'colección',
          'documentos',
          'papeles',
          'libros antiguos',
          'historico',
          'histórico',
          'patrimonio',
          'fondos',
          'resguardo',
          'guardado',
          'almacen',
          'investigacion',
          'consulta documentos',
        ],
      ),
      Area(
        nombre: 'Cubiculos',
        x: 510,
        y: 70,
        categoria: 'Estudio',
        descripcion: 'Espacios individuales de estudio.',
        horario: 'Martes a Domingo · 10:00 AM – 6:00 PM',
        servicios: ['Estudio individual'],
        reglas: ['Silencio'],
        galeria: [
          'assets/cubiculos/imagen1.jpeg',
          'assets/cubiculos/imagen2.jpeg',
        ],
        palabrasClave: [
          'cubiculo',
          'cubículo',
          'cubiculos',
          'privado',
          'individual',
          'estudio',
          'estudiar',
          'leer',
          'lectura',
          'concentracion',
          'concentración',
          'trabajo',
          'lugar tranquilo',
          'mesa sola',
          'estudio privado',
        ],
      ),
      Area(
        nombre: 'MEZZANINE',
        x: 820,
        y: 340,
        categoria: 'Estudio',
        descripcion: 'Área abierta de estudio.',
        horario: 'Martes a Domingo · 10:00 AM – 6:00 PM',
        servicios: ['Lectura'],
        reglas: ['Silencio'],
        galeria: [
          'assets/mezzanine/imagen1.jpeg',
          'assets/mezzanine/imagen2.jpeg',
        ],
        palabrasClave: [
          'mezzanine',
          'mezanine',
          'entrepiso',
          'estudio',
          'leer',
          'lectura',
          'zona tranquila',
          'silencio',
          'trabajo',
          'abierto',
          'area abierta',
          'estudiar arriba',
        ],
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
        esUbicacionActual: false,
        servicios: ['Mapa interactivo', 'Búsqueda de libros'],
        reglas: ['Uso preferente para visitantes'],
        galeria: [],
        palabrasClave: [
          'ubicacion',
          'ubicación',
          'estoy aqui',
          'estoy aquí',
          'aqui',
          'aqui estoy',
          'inicio',
          'mapa',
          'mapita',
          'consulta',
          'punto',
          'referencia',
          'posicion',
          'posición',
          'donde estoy',
          'donde estoy yo',
          'you are here',
          'here',
          'location',
        ],
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
          'assets/salaJuvenil/imagen1.jpeg',
          'assets/salaJuvenil/imagen2.jpeg',
          'assets/salaJuvenil/imagen3.jpeg',
          'assets/salaJuvenil/imagen4.jpeg',
        ],
        palabrasClave: [
          'juvenil',
          'jóvenes',
          'adolescentes',
          'chavos',
          'estudio',
          'tareas',
          'escuela',
          'secundaria',
          'prepa',
          'homework',
          'mesas',
          'estudiar',
          'lugar joven',
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
          'assets/auditorio/imagen1.jpeg',
          'assets/auditorio/imagen2.jpeg',
          'assets/auditorio/imagen3.jpeg',
          'assets/auditorio/imagen4.jpeg',
        ],
        sePuedeRentar: true,
        infoRenta: 'Solicitar vía correo con 2 semanas de anticipación.',
        palabrasClave: [
          'auditorio',
          'eventos',
          'evento',
          'conferencias',
          'charlas',
          'escenario',
          'sonido',
          'presentaciones',
          'foro',
          'renta',
          'platicas',
          'teatro',
          'funciones',
        ],
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
        galeria: [
          'assets/comicteca/imagen1.jpeg',
          'assets/comicteca/imagen2.jpeg',
        ],
        palabrasClave: [
          'comicteca',
          'comics',
          'comic',
          'historietas',
          'manga',
          'anime',
          'dibujos',
          'caricaturas',
          'novela grafica',
          'novela gráfica',
          'marvel',
          'dc',
          'superheroes',
          'lectura divertida',
          'cultura pop',
        ],
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
          'assets/primeraInfancia/imagen1.jpeg',
          'assets/primeraInfancia/imagen2.jpeg',
          'assets/primeraInfancia/imagen3.jpeg',
        ],
        palabrasClave: [
          'bebes',
          'bebés',
          'niños',
          'ninos',
          'peques',
          'infantil',
          'jugar',
          'juegos',
          'estimulación',
          'familia',
          'niños pequeños',
          'area niños',
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
          'assets/cineInfantil/imagen1.jpeg',
          'assets/cineInfantil/imagen2.jpeg',
          'assets/cineInfantil/imagen3.jpeg',
          'assets/cineInfantil/imagen4.jpeg',
        ],
        palabrasClave: [
          'cine',
          'peliculas',
          'películas',
          'pelis',
          'cuentos',
          'proyecciones',
          'funciones',
          'infantil',
          'niños',
          'ver peliculas',
          'cine niños',
          'videos',
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
          'assets/ludoteca/imagen1.jpeg',
          'assets/ludoteca/imagen2.jpeg',
          'assets/ludoteca/imagen3.jpeg',
          'assets/ludoteca/imagen4.jpeg',
        ],
        palabrasClave: [
          'ludoteca',
          'juegos',
          'jugar',
          'juguetes',
          'diversion',
          'diversión',
          'niños',
          'familia',
          'recreacion',
          'recreación',
          'area de juegos',
          'jugar niños',
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
          'assets/multimedia/imagen1.jpeg',
          'assets/multimedia/imagen2.jpeg',
          'assets/multimedia/imagen3.jpeg',
        ],
        palabrasClave: [
          'computadoras',
          'computadora',
          'pc',
          'internet',
          'wifi',
          'navegar',
          'tecnologia',
          'tecnología',
          'multimedia',
          'investigar',
          'usar computadora',
          'buscar en internet',
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
          'assets/realidadVirtual/imagen1.jpeg',
          'assets/realidadVirtual/imagen2.jpeg',
        ],
        palabrasClave: [
          'vr',
          'virtual',
          'realidad virtual',
          'videojuegos',
          'juegos virtuales',
          'experiencia',
          'inmersivo',
          'lentes',
          'gafas',
          'jugar vr',
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
        palabrasClave: [
          'impresion 3d',
          'impresión 3d',
          '3d',
          'impresora',
          'modelado',
          'prototipos',
          'fabricacion',
          'fabricación',
          'crear objetos',
          'imprimir figuras',
        ],
      ),
      Area(
        nombre: 'Cabina de podcast',
        x: 480,
        y: 240,
        categoria: 'Tecnología',
        descripcion: 'Grabación de audio profesional.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Grabación'],
        reglas: ['Reservación'],
        galeria: [
          'assets/podcast/imagen1.jpeg',
          'assets/podcast/imagen2.jpeg',
          'assets/podcast/imagen3.jpeg',
        ],
        sePuedeRentar: true,
        palabrasClave: [
          'podcast',
          'grabacion',
          'grabación',
          'audio',
          'microfono',
          'micrófono',
          'estudio',
          'renta',
          'grabar voz',
          'radio',
          'grabacion audio',
        ],
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
    isPanelOpen.value = false;
    categoriaSeleccionada.value = "";
    resetZoom();

    if (val.trim().isEmpty) {
      sugerencias.clear();
      return;
    }

    final normalizedQuery = normalize(val);
    final Map<String, Area> resultadosUnicos = {};

    pisos.forEach((piso, areas) {
      for (final area in areas) {
        final areaConPiso = area.copyWith(piso: piso);

        final nombreMatch = normalize(area.nombre).contains(normalizedQuery);

        final palabrasClaveMatch = area.palabrasClave.any(
          (p) => normalize(p).contains(normalizedQuery),
        );

        if (nombreMatch || palabrasClaveMatch) {
          resultadosUnicos[area.nombre] = areaConPiso;
        }
      }
    });

    sugerencias.assignAll(resultadosUnicos.values.toList());
  }

  void seleccionarDesdeSugerencia(Area area) async {
    if (pisoActual.value != area.piso) {
      pisoActual.value = area.piso!;
      await Future.delayed(const Duration(milliseconds: 50));
    }

    query.value = area.nombre;
    searchController.text = area.nombre;
    sugerencias.clear();
    Get.back();
    _aplicarZoomAutomatico(area);
  }

  void _aplicarZoomAutomatico(Area area) {
    const double zoomScale = 1.5;
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

class _ResultadoBusqueda {
  final Area area;
  final int score;

  _ResultadoBusqueda({required this.area, required this.score});
}

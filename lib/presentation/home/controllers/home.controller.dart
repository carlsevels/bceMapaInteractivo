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
  var menuWidth = 320.0.obs;
  var isDragging = false.obs;
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
        descripcion:
            '''Este espacio es el primer contacto al entrar a la Biblioteca Central del Estado, en este lugar se da orientación a lo que necesite el usuario que entra a la biblioteca, además el personal que se encuentra en el módulo realiza el trámite de credencialización de los usuarios, lo cual les permite hacer préstamo de libros, y de igual manera en este espacio se realiza el proceso de préstamo, devolución y renovación de libros y material bibliográfico, por lo tanto se cuenta con equipos de cómputo para dichos tramites y un espacio pequeño para alojar el material bibliográfico (libros) que se devuelven.''',
        horario: ['Lunes a Viernes · 8:30 AM - 8:30 PM'],
        servicios: ['Orientación', 'Apoyo catálogo'],
        galeria: ['assets/modulo/imagen1.jpeg', 'assets/modulo/imagen2.jpeg'],
        palabrasClave: [
          'informacion',
          'ayuda',
          'orientacion',
          'information',
          'help',
          'front desk',
        ],
      ),
      Area(
        nombre: 'Área de inclusión',
        x: 370,
        y: 730,
        categoria: 'Inclusión',
        descripcion:
            'Acceso equitativo a la información a través de recursos especializados.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Braille', 'Audiolibros'],
        galeria: [
          'assets/inclusion/imagen1.jpeg',
          'assets/inclusion/imagen2.jpeg',
        ],
        palabrasClave: [
          'inclusion',
          'braille',
          'discapacidad',
          'accessibility',
          'special needs',
        ],
      ),
      Area(
        nombre: 'Sala multipropósito',
        x: 230,
        y: 780,
        categoria: 'Cultura',
        descripcion:
            'Espacio para actividades culturales, talleres y reuniones comunitarias.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Talleres', 'Conferencias'],
        galeria: [
          'assets/multiproposito/imagen1.jpeg',
          'assets/multiproposito/imagen2.jpeg',
        ],
        palabrasClave: ['sala', 'talleres', 'cultura', 'events', 'workshop'],
      ),
      Area(
        nombre: 'Sala de juntas',
        x: 370,
        y: 850,
        categoria: 'Estudio',
        descripcion:
            'Espacio profesional para reuniones de trabajo, académicas y colaboración grupal.',
        horario: [
          'Lunes a Viernes · 08:30 AM - 8:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Reservación'],
        galeria: ['assets/salaDeJuntas/imagen1.jpeg'],
        palabrasClave: ['juntas', 'reuniones', 'trabajo', 'meeting', 'office'],
      ),
      Area(
        nombre: 'Cafetería',
        x: 620,
        y: 920,
        categoria: 'Alimentos',
        descripcion:
            '''En esta área se realizan lo catering o coffebreak en las ocasiones que se tienen eventos en nuestra biblioteca como presentaciones de libros o eventos especiales, de igual manera también tiene la función como el comedor de los trabajadores y personal de Servicio Social de la Biblioteca Central, así como también de usuarios que lleguen a requerirlo.''',
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Venta alimentos'],
        galeria: [],
        palabrasClave: [
          'cafe',
          'comida',
          'alimentos',
          'cafeteria',
          'food',
          'coffee',
        ],
      ),
      Area(
        nombre: 'Legado N.L.',
        x: 970,
        y: 170,
        categoria: 'Cultura',
        descripcion:
            '''Un espacio de gran valor tanto nuestra biblioteca como para la comunidad Nuevoleonesa, esta área cuenta con una colección muy amplia y variada de títulos especializados en historia de estado, cada uno de los municipios o temáticas específicas de la región como: historia de los barrios, calles, flora y fauna de la región, comida norestense, platillos tipos de nuevo león, etc., la sala de fondo Nuevo León es comúnmente visitada por historiadores del estado para complementar investigaciones, además que esta este espacio se realizan círculos de lectura al igual de charlas y presentaciones relacionados a los temas de nuestro estado.''',
        horario: [
          'Lunes a Viernes · 08:30 AM - 08:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Exposiciones'],
        galeria: [
          'assets/legadoNL/imagen1.jpeg',
          'assets/legadoNL/imagen2.jpeg',
        ],
        palabrasClave: [
          'historia',
          'nuevo leon',
          'patrimonio',
          'heritage',
          'history',
        ],
      ),
      Area(
        nombre: 'Acervo',
        x: 200,
        y: 200,
        categoria: 'Cultura',
        descripcion:
            '''La sala general es el espacio de lectura predilecto para los usuarios que nos visitan, cuenta con un gran espacio de lectura y mobiliario para trabajo y estudio, además de tener una gran vista a la macroplaza gracias al ventanal que acompaña la sala, este espacio cuenta con la colección de general de libros que abarca los siguientes temas: historia, novelas, leyendas, literatura clásica y contemporánea, geografía, psicología, educación, religión y bellas artes; en este espacio los bibliotecarios comúnmente planean tertulias literarias además de charlas de diversos temas a tratar que llevan como nombre distintivo “Sociedad del Conocimiento”.''',
        horario: [
          'Lunes a Viernes · 08:30 AM - 08:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Exposiciones'],
        galeria: ['assets/acervo/imagen1.jpeg', 'assets/acervo/imagen2.jpeg'],
        palabrasClave: [
          'acervo',
          'libros',
          'coleccion',
          'general collection',
          'books',
        ],
      ),
      Area(
        nombre: 'Cubiculos',
        x: 510,
        y: 70,
        categoria: 'Estudio',
        descripcion:
            'Espacios individuales diseñados para el estudio profundo, lectura y trabajo privado.',
        horario: [
          'Lunes a Viernes · 08:30 AM - 08:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Estudio individual'],
        galeria: ['assets/cubiculos/imagen1.jpeg'],
        palabrasClave: ['cubiculo', 'estudio', 'privado', 'study', 'cubicles'],
      ),
      Area(
        nombre: 'MEZZANINE',
        x: 820,
        y: 340,
        categoria: 'Cultura',
        descripcion:
            '''Espacio de gran amplitud para exhibición de obras plásticas, demostraciones teatrales y musicales, presentaciones de libros y lecturas en voz alta. Alberga el mural principal de la biblioteca.''',
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Lectura'],
        galeria: ['assets/mezzanine/imagen1.jpeg'],
        palabrasClave: ['mezzanine', 'mural', 'eventos', 'art', 'exhibition'],
      ),
    ],
    2: [
      Area(
        nombre: 'Punto de Consulta Principal',
        x: 700,
        y: 160,
        categoria: 'Ubicación',
        descripcion: 'Te encuentras en el punto de consulta del segundo piso.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Mapa interactivo'],
        galeria: [],
        palabrasClave: ['ubicacion', 'aqui', 'location', 'here'],
      ),
      Area(
        nombre: 'Sala juvenil',
        x: 550,
        y: 120,
        categoria: 'Estudio',
        descripcion:
            'Espacio tranquilo dedicado a adolescentes y jóvenes estudiantes para tareas y lectura.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Mesas'],
        galeria: ['assets/salaJuvenil/imagen1.jpeg'],
        imagenReglamento: 'assets/reglamentos/salaJuvenil.png',
        palabrasClave: ['juvenil', 'jovenes', 'tareas', 'youth', 'teenagers'],
      ),
      Area(
        nombre: 'Auditorio',
        x: 150,
        y: 140,
        categoria: 'Cultura',
        descripcion:
            '''Bello espacio para proyecciones y presentaciones teatrales o musicales. Equipado con sistema de sonido profesional y proyector. Disponible para ciclos de cine y reuniones de trabajo.''',
        horario: [
          'Lunes a Viernes · 8:30 AM - 08:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Escenario', 'Sonido'],
        galeria: ['assets/auditorio/imagen1.jpeg'],
        sePuedeRentar: true,
        palabrasClave: [
          'auditorio',
          'cine',
          'conferencias',
          'theater',
          'auditorium',
        ],
      ),
      Area(
        nombre: 'Comicteca',
        x: 990,
        y: 170,
        categoria: 'Cultura',
        descripcion:
            'Colección especializada de cómics, manga y novelas gráficas.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 06:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Lectura'],
        galeria: ['assets/comicteca/imagen1.jpeg'],
        palabrasClave: [
          'comics',
          'manga',
          'anime',
          'comic library',
          'graphic novel',
        ],
      ),
      Area(
        nombre: 'Primera infancia',
        x: 350,
        y: 750,
        categoria: 'Infantil',
        descripcion:
            'Espacio seguro para niños (0-6 años) con materiales adecuados y talleres de estimulación temprana.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Juegos didácticos'],
        galeria: ['assets/primeraInfancia/imagen1.jpeg'],
        imagenReglamento: "assets/reglamentos/salaInfancias.png",
        palabrasClave: [
          'bebes',
          'niños',
          'estimulacion',
          'kids',
          'early childhood',
        ],
      ),
      Area(
        nombre: 'Cine infantil/Coliseo',
        x: 400,
        y: 850,
        categoria: 'Infantil',
        descripcion:
            'Proyecciones de cine y actividades de cuentacuentos para niños.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Cine'],
        galeria: ['assets/cineInfantil/imagen1.jpeg'],
        imagenReglamento: "assets/reglamentos/salaInfancias.png",
        palabrasClave: ['cine', 'peliculas', 'niños', 'cinema', 'kids'],
      ),
      Area(
        nombre: 'Ludoteca',
        x: 580,
        y: 960,
        categoria: 'Infantil',
        descripcion:
            'Espacio recreativo con juguetes educativos y juegos para familias.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Juguetes'],
        galeria: ['assets/ludoteca/imagen1.jpeg'],
        imagenReglamento: "assets/reglamentos/salaInfancias.png",
        palabrasClave: ['jugar', 'niños', 'diversion', 'playroom', 'toys'],
      ),
      Area(
        nombre: 'Zona multimedia',
        x: 800,
        y: 650,
        categoria: 'Tecnología',
        descripcion:
            'Área digital con acceso a computadoras para navegación por internet y procesamiento de datos.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 06:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Internet'],
        galeria: ['assets/multimedia/imagen1.jpeg'],
        imagenReglamento: 'assets/reglamentos/multimedia.png',
        palabrasClave: [
          'computadoras',
          'internet',
          'wifi',
          'computers',
          'tech',
        ],
      ),
      Area(
        nombre: 'Realidad virtual',
        x: 800,
        y: 930,
        categoria: 'Tecnología',
        descripcion:
            'Experiencias digitales inmersivas y contenido educativo en realidad virtual.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 06:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Gafas VR'],
        galeria: ['assets/realidadVirtual/imagen1.jpeg'],
        palabrasClave: ['vr', 'realidad virtual', 'lentes', 'virtual reality'],
      ),
      Area(
        nombre: 'Impresión 3D',
        x: 950,
        y: 820,
        categoria: 'Tecnología',
        descripcion:
            'Laboratorio de fabricación digital para modelado 3D y prototipado.',
        horario: ['Lunes a Viernes · 8:30 AM - 04:00 PM'],
        servicios: ['Modelado 3D'],
        galeria: [],
        palabrasClave: ['3d', 'impresora', 'modelado', '3d printing'],
      ),
      Area(
        nombre: 'Cabina de podcast',
        x: 480,
        y: 240,
        categoria: 'Tecnología',
        descripcion:
            'Estudio profesional de grabación de audio para la creación de contenido digital.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Grabación'],
        galeria: ['assets/podcast/imagen1.jpeg'],
        sePuedeRentar: true,
        palabrasClave: ['podcast', 'audio', 'grabacion', 'recording', 'booth'],
      ),
    ],
  };

  @override
  void onInit() {
    super.onInit();

    transformationController.addListener(() {
      final double scale = transformationController.value.getMaxScaleOnAxis();
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

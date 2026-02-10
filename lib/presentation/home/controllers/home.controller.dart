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
        galeria: ['modulo/imagen1.jpeg', 'modulo/imagen2.jpeg'],
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
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Braille', 'Audiolibros'],
        galeria: [
          'inclusion/imagen1.jpeg',
          'inclusion/imagen2.jpeg',
          'inclusion/imagen3.jpeg',
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
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Talleres', 'Conferencias'],
        galeria: [
          'multiproposito/imagen1.jpeg',
          'multiproposito/imagen2.jpeg',
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
        horario: [
          'Lunes a Viernes · 08:30 AM - 8:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Reservación'],
        galeria: ['salaDeJuntas/imagen1.jpeg'],
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
        descripcion:
            '''En esta área se realizan lo catering o coffebreak en las ocasiones que se tienen eventos en nuestra biblioteca como presentaciones de libros o eventos especiales, de igual manera también tiene la función como el comedor de los trabajadores y personal de Servicio Social de la Biblioteca Central, así como también de usuarios que lleguen a requerirlo.''',
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Venta alimentos'],
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
        descripcion:
            '''Un espacio de gran valor tanto nuestra biblioteca como para la comunidad Nuevoleonesa, esta área cuenta con una colección muy amplia y variada de títulos especializados en historia de estado, cada uno de los municipios o temáticas específicas de la región como: historia de los barrios, calles, flora y fauna de la región, comida norestense, platillos tipos de nuevo león, etc., la sala de fondo Nuevo León es comúnmente visitada por historiadores del estado para complementar investigaciones, además que esta este espacio se realizan círculos de lectura al igual de charlas y presentaciones relacionados a los temas de nuestro estado.''',
        horario: [
          'Lunes a Viernes · 08:30 AM - 08:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Exposiciones'],
        galeria: [
          'legadoNL/imagen1.jpeg',
          'legadoNL/imagen2.jpeg',
          'legadoNL/imagen3.jpeg',
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
        descripcion:
            '''La sala general es el espacio de lectura predilecto para los usuarios que nos visitan, cuenta con un gran espacio de lectura y mobiliario para trabajo y estudio, además de tener una gran vista a la macroplaza gracias al ventanal que acompaña la sala, este espacio cuenta con la colección de general de libros que abarca los siguientes temas: historia, novelas, leyendas, literatura clásica y contemporánea, geografía, psicología, educación, religión y bellas artes; en este espacio los bibliotecarios comúnmente planean tertulias literarias además de charlas de diversos temas a tratar que llevan como nombre distintivo “Sociedad del Conocimiento”, el área presenta mobiliario suficiente para que un gran número de usuarios pueda permanecer en la sala con las mejores condiciones, esta sala cuenta en su espacio la segunda parte de todo el acervo con el que cuenta la Biblioteca Central del Estado.''',
        horario: [
          'Lunes a Viernes · 08:30 AM - 08:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Exposiciones'],
        galeria: [
          'acervo/imagen1.jpeg',
          'acervo/imagen2.jpeg',
          'acervo/imagen3.jpeg',
          'acervo/imagen4.jpeg',
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
        horario: [
          'Lunes a Viernes · 08:30 AM - 08:30 PM',
          'Sabados · 09:00 AM - 02:00 PM',
        ],
        servicios: ['Estudio individual'],
        galeria: [
          'cubiculos/imagen1.jpeg',
          'cubiculos/imagen2.jpeg',
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
        categoria:
            '''Espacio de gran amplitud, en este lugar de la biblioteca se desarrollan la gran parte de eventos que se planean en nuestra biblioteca, es espacio sirve como área de exhibición de obras plásticas, demostraciones teatrales y musicales, así como presentación de libros, tertulias o lecturas en voz alta, además de ser el espacio que alberga el mural que engalana nuestra biblioteca.''',
        descripcion: 'Área abierta de estudio.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Lectura'],
        galeria: [
          'mezzanine/imagen1.jpeg',
          'mezzanine/imagen2.jpeg',
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
        horario: [
          'Lunes a Viernes · 8:30 AM - 8:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        esUbicacionActual: false,
        servicios: ['Mapa interactivo', 'Búsqueda de libros'],
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
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Mesas'],
        galeria: [
          'salaJuvenil/imagen1.jpeg',
          'salaJuvenil/imagen2.jpeg',
          'salaJuvenil/imagen3.jpeg',
          'salaJuvenil/imagen4.jpeg',
        ],
        imagenReglamento: 'assets/reglamentos/salaJuvenil.png',
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
        descripcion:
            '''Es un bello espacio utilizado para diversas presentaciones y proyecciones, el área cuenta con sistema de sonido propio, también cuenta con una cabina de sonido la cual es equipada por una consola/ mezcladora para operar el sonido del auditorio y ahí mismo se encuentra un centro de carga independiente con el cual se controla la iluminación y corriente eléctrica del espacio total, el espacio también cuenta con un proyector para proyección si es necesario, en nuestro auditorio también se realizan actividades como presentaciones teatrales, recitales musicales y cabe mencionar que al ser un espacio público el auditorio puede llegar a ser solicitado por diversos usuarios para varios fines, entre los cuales están: ciclos de cine, reuniones de equipos de trabajo e incluso llega a ser solicitado por dependencias de gobierno para reuniones como: licitaciones, reuniones de jubilados, juntas informativas y charlas o talleres de formación continua.''',
        horario: [
          'Lunes a Viernes · 8:30 AM - 08:30 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Escenario', 'Sonido'],
        galeria: [
          'auditorio/imagen1.jpeg',
          'auditorio/imagen2.jpeg',
          'auditorio/imagen3.jpeg',
          'auditorio/imagen4.jpeg',
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
        horario: [
          'Lunes a Viernes · 8:30 AM - 06:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Lectura'],
        galeria: [
          'comicteca/imagen1.jpeg',
          'comicteca/imagen2.jpeg',
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
        descripcion:
            '''Espacio dedicado a los niños y niñas de edades de 0 meses a 6 años, está área cuenta con materiales de lectura adecuado a las edades mencionadas, así como mobiliario y tatamis en el suelo que hacen la sala más amigable para los niños y niñas quela visitan, además en este espacio se imparte el taller de “Primera Infancia” que es en colaboración con la Secretaria de Cultura.''',
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Juegos didácticos'],
        galeria: [
          'primeraInfancia/imagen1.jpeg',
          'primeraInfancia/imagen2.jpeg',
          'primeraInfancia/imagen3.jpeg',
        ],
        imagenReglamento: "assets/reglamentos/salaInfancias.png",
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
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Cine'],
        galeria: [
          'cineInfantil/imagen1.jpeg',
          'cineInfantil/imagen2.jpeg',
          'cineInfantil/imagen3.jpeg',
          'cineInfantil/imagen4.jpeg',
        ],
        imagenReglamento: "assets/reglamentos/salaInfancias.png",
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
        imagenReglamento: "assets/reglamentos/salaInfancias.png",
        categoria: 'Infantil',
        descripcion: 'Espacio de juegos.',
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Juguetes'],
        galeria: [
          'ludoteca/imagen1.jpeg',
          'ludoteca/imagen2.jpeg',
          'ludoteca/imagen3.jpeg',
          'ludoteca/imagen4.jpeg',
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
        descripcion:
            '''Es un área con una gran circulación de usuarios, en este espacio se da el servicio de préstamo de computadoras en la cuales se puede trabajar en los diversos programas de procesador de datos, así como navegar en internet y las diferentes plataformas de entretenimiento digital.''',
        horario: [
          'Lunes a Viernes · 8:30 AM - 06:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Internet'],
        galeria: [
          'multimedia/imagen1.jpeg',
          'multimedia/imagen2.jpeg',
          'multimedia/imagen3.jpeg',
        ],
        imagenReglamento: "assets/reglamentos/multimedia.png",
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
        horario: [
          'Lunes a Viernes · 8:30 AM - 06:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Gafas VR'],
        galeria: [
          'realidadVirtual/imagen1.jpeg',
          'realidadVirtual/imagen2.jpeg',
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
        horario: ['Lunes a Viernes · 8:30 AM - 04:00 PM'],
        servicios: ['Modelado 3D'],
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
        horario: [
          'Lunes a Viernes · 8:30 AM - 05:00 PM',
          'Sábado · 9:00 AM - 02:00 PM',
        ],
        servicios: ['Grabación'],
        galeria: [
          'podcast/imagen1.jpeg',
          'podcast/imagen2.jpeg',
          'podcast/imagen3.jpeg',
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

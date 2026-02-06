import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final RxInt missionStep = 0.obs;
  final RxBool isMenuOpen = true.obs;

  final TextEditingController searchController = TextEditingController();

  final Rx<Area?> selectedArea = Rx<Area?>(null);

  // 🔥 ESTE ES EL FIX CLAVE
  final Rx<Area?> visibleArea = Rx<Area?>(null);

  final RxBool isPanelOpen = false.obs;

  final RxInt pisoActual = 1.obs;
  final RxString query = ''.obs;
  final RxList<Area> sugerencias = <Area>[].obs;

  final count = 0.obs;

  final Map<int, List<Area>> pisos = {
    1: [
      Area(
        nombre: 'Módulo de información',
        x: 820,
        y: 700,
        categoria: 'Información', // <--- Agregado
        descripcion: 'Punto principal de orientación para visitantes.',
        horario: 'Lunes a Viernes · 9:00 AM – 8:00 PM',
        servicios: ['Orientación', 'Apoyo catálogo'],
        reglas: ['Formar fila', 'No alimentos'],
        galeria: ['assets/multimedia/vr_1.png', 'assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
      ),
    ],
    2: [
      Area(
        nombre: 'Auditorio',
        x: 150,
        y: 140,
        categoria: 'Cultura',
        descripcion: 'Espacio amplio destinado a conferencias y eventos.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Escenario', 'Sonido'],
        reglas: ['No alimentos'],
        galeria: ['assets/multimedia/vr_1.png'],
        sePuedeRentar: true,
        infoRenta: 'Solicitar vía correo con 2 semanas de anticipación.',
      ),
      Area(
        nombre: 'Sala juvenil',
        x: 720,
        y: 160,
        categoria: 'Estudio',
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
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
        galeria: ['assets/multimedia/vr_1.png'],
        sePuedeRentar: true,
      ),
    ],
  };
  void closePanel() {
    isPanelOpen.value = false;

    Future.delayed(const Duration(milliseconds: 800), () {
      visibleArea.value = null;
      selectedArea.value = null;
    });
  }

  void onAreaSelected(Area area) {
    visibleArea.value = area;
    selectedArea.value = area;
    isPanelOpen.value = true;

    if (missionStep.value == 3) {
      missionStep.value = 0;
      Get.snackbar(
        "¡MISIÓN COMPLETADA!",
        "Has encontrado el área correctamente.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
        icon: const Icon(Icons.emoji_events, color: Colors.black, size: 35),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void seleccionarDesdeSugerencia(Area area) {
    // Cambiar piso si es necesario
    if (pisoActual.value != area.piso) {
      pisoActual.value = area.piso!;
    }

    // Limpiar buscador
    query.value = area.nombre;
    searchController.text = area.nombre;
    sugerencias.clear();

    // Seleccionar área
    onAreaSelected(area);
  }

  /// 🔹 BUSCAR
  void buscarSugerencias(String query) {
    if (query.trim().isEmpty) {
      sugerencias.clear();
      return;
    }

    final normalizedQuery = normalize(query);

    final List<Area> resultados = [];

    pisos.forEach((piso, areas) {
      for (final area in areas) {
        final nombreNormalizado = normalize(area.nombre);
        final descripcionNormalizada = normalize(area.descripcion);

        if (nombreNormalizado.contains(normalizedQuery) ||
            descripcionNormalizada.contains(normalizedQuery)) {
          resultados.add(area.copyWith(piso: piso));
        }
      }
    });

    sugerencias.assignAll(resultados);
  }

  String normalize(String text) {
    const withAccents = 'áéíóúüñÁÉÍÓÚÜÑ';
    const withoutAccents = 'aeiouunAEIOUUN';

    for (int i = 0; i < withAccents.length; i++) {
      text = text.replaceAll(withAccents[i], withoutAccents[i]);
    }

    return text.toLowerCase();
  }

  // En tu HomeController
  final TransformationController transformationController =
      TransformationController();

  void zoomIn() {
    final Matrix4 current = transformationController.value;
    // Multiplicamos la escala actual por 1.2
    transformationController.value = current.clone()..scale(1.2);
  }

  void zoomOut() {
    final Matrix4 current = transformationController.value;
    // Multiplicamos la escala actual por 0.8
    transformationController.value = current.clone()..scale(0.8);
  }

  void resetZoom() {
    // Volvemos a la matriz identidad (escala 1:1, posición 0,0)
    transformationController.value = Matrix4.identity();
  }

  var categoriaSeleccionada = ''.obs; // Observable para el filtro

  void filtrarPorCategoria(String categoria) {
    if (categoriaSeleccionada.value == categoria) {
      categoriaSeleccionada.value = ''; // Si toca la misma, limpiamos filtro
    } else {
      categoriaSeleccionada.value = categoria;
    }
  }

  void setCategoria(String cat) {
    if (categoriaSeleccionada.value == cat) {
      categoriaSeleccionada.value = ''; // Limpiar filtro si toca el mismo
    } else {
      categoriaSeleccionada.value = cat;
    }
  }
}

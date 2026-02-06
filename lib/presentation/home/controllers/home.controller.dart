import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final RxInt missionStep = 0.obs;
  final RxBool isMenuOpen = true.obs;
  final TextEditingController searchController = TextEditingController();
  final Rx<Area?> selectedArea = Rx<Area?>(null);
  final RxInt pisoActual = 1.obs;
  final RxString query = ''.obs;

  final count = 0.obs;

  // Datos mantenidos íntegramente
  final Map<int, List<Area>> pisos = {
    1: [
      Area(
        nombre: 'Módulo de información',
        x: 820,
        y: 700,
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
        descripcion:
            'Espacio amplio destinado a conferencias, presentaciones culturales y eventos académicos.',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Escenario', 'Sistema de sonido', 'Proyector', 'Butacas'],
        reglas: [
          'Mantener orden durante el evento',
          'No introducir alimentos',
          'Respetar horarios asignados',
        ],
        galeria: ['assets/multimedia/vr_1.png', 'assets/multimedia/vr_2.png'],
        sePuedeRentar: true,
        infoRenta:
            'Disponible con al menos 2 semanas de anticipación. Solicitar vía correo electrónico en recepcion@biblioteca.gob.mx',
      ),
      Area(
        nombre: 'Sala juvenil',
        x: 720,
        y: 160,
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
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: ['assets/multimedia/vr_1.png'],
      ),
      Area(
        nombre: 'Primera infancia',
        x: 350,
        y: 750,
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: ['assets/multimedia/vr_1.png'],
      ),
      Area(
        nombre: 'Cine infantil/Coliseo',
        x: 400,
        y: 850,
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: ['assets/multimedia/vr_1.png'],
      ),
      Area(
        nombre: 'Ludoteca',
        x: 580,
        y: 960,
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: ['assets/multimedia/vr_1.png'],
      ),
      Area(
        nombre: 'Zona multimedia',
        x: 800,
        y: 650,
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: ['assets/multimedia/vr_1.png'],
      ),
      Area(
        nombre: 'Realidad virtual',
        x: 800,
        y: 930,
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: ['assets/multimedia/vr_1.png'],
      ),
      Area(
        nombre: 'Impresión 3D',
        x: 950,
        y: 820,
        descripcion: 'Espacio tranquilo...',
        horario: '9:00 AM – 8:00 PM',
        servicios: ['Mesas'],
        reglas: ['Silencio'],
        galeria: ['assets/multimedia/vr_1.png'],
      ),
      Area(
        nombre: 'Cabina podcast',
        x: 480,
        y: 240,
        descripcion:
            'Espacio acondicionado para grabación de audio, entrevistas y producción de contenido digital.',
        horario: '9:00 AM – 8:00 PM',
        servicios: [
          'Micrófonos profesionales',
          'Aislamiento acústico',
          'Mesa de grabación',
          'Equipo básico de audio',
        ],
        reglas: [
          'Uso exclusivo con reservación',
          'No alimentos ni bebidas',
          'Cuidar el equipo',
        ],
        galeria: ['assets/multimedia/vr_1.png', 'assets/multimedia/vr_3.png'],
        sePuedeRentar: true,
        infoRenta:
            'Requiere solicitud con al menos 2 semanas de anticipación. Enviar correo a recepcion@biblioteca.gob.mx',
      ),
    ],
  };

  void onAreaSelected(Area area) {
    query.value = "";
    searchController.clear();
    selectedArea.value = area;

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
}

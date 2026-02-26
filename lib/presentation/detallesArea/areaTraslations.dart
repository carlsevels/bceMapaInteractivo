import 'package:get/get.dart';

class AreaTranslations {
  /// ===============================
  /// 🌍 TRADUCCIÓN DE CATEGORÍAS
  /// ===============================
  static String translateCategory(String categoria) {
    final isSpanish = Get.locale?.languageCode == 'es';

    if (isSpanish) return categoria;

    const categories = {
      'Información': 'Information',
      'Inclusión': 'Inclusion',
      'Cultura': 'Culture',
      'Estudio': 'Study',
      'Alimentos': 'Food & Dining',
      'Tecnología': 'Technology',
      'Infantil': 'Kids Area',
      'Ubicación': 'Location',
    };

    return categories[categoria] ?? categoria;
  }

  /// ===============================
  /// 📚 DATA DE ÁREAS
  /// ===============================
  static final Map<String, Map<String, String>> data = {
    'Módulo de información': {
      'en': 'Information Desk',
      'desc_es':
          'Este espacio es el primer punto de contacto al ingresar a la Biblioteca Central del Estado...',
      'desc_en':
          'This space is the first point of contact upon entering the State Central Library...',
    },
    'Área de inclusión': {
      'en': 'Inclusion Area',
      'desc_es':
          'Acceso equitativo a la información mediante recursos especializados.',
      'desc_en':
          'Equitable access to information through specialized resources.',
    },
    'Sala multipropósito': {
      'en': 'Multipurpose Room',
      'desc_es':
          'Espacio para actividades culturales, talleres y reuniones comunitarias.',
      'desc_en':
          'Space for cultural activities, workshops, and community meetings.',
    },
    'Sala de juntas': {
      'en': 'Meeting Room',
      'desc_es':
          'Espacio profesional para trabajo, reuniones académicas y colaboración grupal.',
      'desc_en':
          'Professional space for work, academic meetings, and group collaboration.',
    },
    'Cafetería': {
      'en': 'Cafeteria',
      'desc_es':
          'Área destinada para coffee break y alimentos durante eventos.',
      'desc_en':
          'Catering and coffee break area for library events and visitors.',
    },
    'Legado N.L.': {
      'en': 'N.L. Heritage',
      'desc_es':
          'Espacio dedicado a la historia y cultura de Nuevo León.',
      'desc_en':
          'A space dedicated to the history and culture of Nuevo León.',
    },
    'Acervo': {
      'en': 'General Collection',
      'desc_es':
          'Sala principal con colección general de libros.',
      'desc_en':
          'Main reading area with the general book collection.',
    },
    'Cubiculos': {
      'en': 'Study Cubicles',
      'desc_es':
          'Espacios individuales para estudio profundo.',
      'desc_en':
          'Individual spaces designed for deep study.',
    },
    'MEZZANINE': {
      'en': 'Mezzanine',
      'desc_es':
          'Espacio amplio donde se realizan la mayoría de los eventos.',
      'desc_en':
          'Large open space where most library events take place.',
    },
    'Punto de Consulta Principal': {
      'en': 'Main Consultation Point',
      'desc_es':
          'Punto de consulta ubicado en el segundo piso.',
      'desc_en':
          'Consultation point located on the second floor.',
    },
    'Sala juvenil': {
      'en': 'Youth Room',
      'desc_es':
          'Espacio dedicado a jóvenes estudiantes.',
      'desc_en':
          'Quiet space dedicated to teenagers and young students.',
    },
    'Auditorio': {
      'en': 'Auditorium',
      'desc_es':
          'Espacio equipado para presentaciones y proyecciones.',
      'desc_en':
          'Equipped space for presentations and screenings.',
    },
    'Comicteca': {
      'en': 'Comic Library',
      'desc_es':
          'Colección especializada en cómics y manga.',
      'desc_en':
          'Specialized collection of comics and manga.',
    },
    'Primera infancia': {
      'en': 'Early Childhood',
      'desc_es':
          'Área dedicada a niños de 0 a 6 años.',
      'desc_en':
          'Area dedicated to children from 0 to 6 years old.',
    },
    'Cine infantil/Coliseo': {
      'en': 'Kids Cinema',
      'desc_es':
          'Proyecciones y actividades audiovisuales para niños.',
      'desc_en':
          'Film screenings and storytelling for children.',
    },
    'Ludoteca': {
      'en': 'Playroom',
      'desc_es':
          'Espacio recreativo con juegos educativos.',
      'desc_en':
          'Recreational space with educational toys and games.',
    },
    'Zona multimedia': {
      'en': 'Multimedia Zone',
      'desc_es':
          'Área con computadoras y acceso digital.',
      'desc_en':
          'Area with computers and digital access.',
    },
    'Realidad virtual': {
      'en': 'Virtual Reality',
      'desc_es':
          'Experiencias digitales inmersivas.',
      'desc_en':
          'Immersive digital experiences.',
    },
    'Impresión 3D': {
      'en': '3D Printing',
      'desc_es':
          'Laboratorio de fabricación digital.',
      'desc_en':
          'Digital fabrication laboratory.',
    },
    'Cabina de podcast': {
      'en': 'Podcast Booth',
      'desc_es':
          'Estudio profesional de grabación.',
      'desc_en':
          'Professional audio recording studio.',
    },
  };

  /// ===============================
  /// 🏷 TRADUCCIÓN DE TÍTULO
  /// ===============================
  static String getTitle(String nombreArea) {
    final isSpanish = Get.locale?.languageCode == 'es';

    if (isSpanish) return nombreArea;

    return data[nombreArea]?['en'] ?? nombreArea;
  }

  /// ===============================
  /// 📝 TRADUCCIÓN DE DESCRIPCIÓN
  /// ===============================
  static String getDescription(String nombreArea) {
    final isSpanish = Get.locale?.languageCode == 'es';

    if (isSpanish) {
      return data[nombreArea]?['desc_es'] ?? nombreArea;
    }

    return data[nombreArea]?['desc_en'] ?? nombreArea;
  }

  /// ===============================
  /// 🔥 MÉTODO GENERAL (opcional)
  /// ===============================
  static String get(String nombreArea, {bool isDesc = false}) {
    return isDesc
        ? getDescription(nombreArea)
        : getTitle(nombreArea);
  }
}
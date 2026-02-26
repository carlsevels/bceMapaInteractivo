import 'package:get/get.dart';

class AreaTranslations {
  static String translateCategory(String categoria) {
    if (Get.locale?.languageCode == 'es') return categoria;
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

  static Map<String, Map<String, String>> data = {
    'Módulo de información': {
      'en': 'Information Desk',
      'desc_en': 'This space is the first point of contact upon entering the State Central Library. In this place, guidance is provided for whatever the user needs. Additionally, the staff at the module handles user credentialing, which allows for book loans. Likewise, the process of loaning, returning, and renewing books and bibliographic material is carried out here; therefore, it has computer equipment for these procedures and a small space to house returned bibliographic material (books).',
    },
    'Área de inclusión': {
      'en': 'Inclusion Area',
      'desc_en': 'Equitable access to information through specialized resources.',
    },
    'Sala multipropósito': {
      'en': 'Multipurpose Room',
      'desc_en': 'Space for cultural activities, workshops, and community meetings.',
    },
    'Sala de juntas': {
      'en': 'Meeting Room',
      'desc_en': 'Professional space for work, academic meetings, and group collaboration.',
    },
    'Cafetería': {
      'en': 'Cafeteria',
      'desc_en': 'In this area, catering or coffee breaks are provided for library events such as book presentations or special events. Likewise, it also functions as the dining area for workers and social service personnel of the Central Library, as well as for users who may require it.',
    },
    'Legado N.L.': {
      'en': 'N.L. Heritage',
      'desc_en': 'A space of great value for both our library and the Nuevo León community. This area has a very wide and varied collection of titles specialized in state history, each of the municipalities, or specific regional themes such as: history of neighborhoods, streets, flora and fauna of the region, Northeastern food, typical dishes of Nuevo León, etc. The Nuevo León collection room is commonly visited by state historians to complement research; furthermore, reading circles as well as talks and presentations related to our state\'s topics are held in this space.',
    },
    'Acervo': {
      'en': 'General Collection',
      'desc_en': 'The general room is the favorite reading space for visiting users. It features a large reading area and furniture for work and study, in addition to having a great view of the Macroplaza thanks to the large window that accompanies the room. This space holds the general collection of books covering the following topics: history, novels, legends, classical and contemporary literature, geography, psychology, education, religion, and fine arts. In this space, librarians commonly plan literary gatherings as well as talks on various topics called "Society of Knowledge". The area has enough furniture for a large number of users to remain in the room under the best conditions; this room holds the second part of all the collection of the State Central Library.',
    },
    'Cubiculos': {
      'en': 'Study Cubicles',
      'desc_en': 'Individual spaces designed for deep study, reading, and private work.',
    },
    'MEZZANINE': {
      'en': 'Mezzanine',
      'desc_en': 'A space of great amplitude where most of the events planned in our library take place. This space serves as an exhibition area for visual arts, theatrical and musical demonstrations, as well as book presentations, gatherings, or aloud readings, in addition to being the space that houses the mural that graces our library.',
    },
    'Punto de Consulta Principal': {
      'en': 'Main Consultation Point',
      'desc_en': 'You are at the consultation point on the second floor.',
    },
    'Sala juvenil': {
      'en': 'Youth Room',
      'desc_en': 'Quiet space dedicated to teenagers and young students for homework and reading.',
    },
    'Auditorio': {
      'en': 'Auditorium',
      'desc_en': 'It is a beautiful space used for various presentations and screenings. The area has its own sound system and a sound booth equipped with a mixer to operate the auditorium sound. There is also an independent load center that controls the total space\'s lighting and electricity. The space also features a projector; activities such as theatrical presentations and musical recitals are held here. As a public space, it can be requested by various users for film cycles, work meetings, or government gatherings such as bids and informative talks.',
    },
    'Comicteca': {
      'en': 'Comic Library',
      'desc_en': 'Specialized collection of comics, manga, and graphic novels.',
    },
    'Primera infancia': {
      'en': 'Early Childhood',
      'desc_en': 'Space dedicated to boys and girls from 0 months to 6 years old. This area has reading materials suitable for these ages, as well as furniture and floor mats that make the room friendlier for the children who visit. Furthermore, the "Early Childhood" workshop is taught here in collaboration with the Ministry of Culture.',
    },
    'Cine infantil/Coliseo': {
      'en': 'Kids\' Cinema',
      'desc_en': 'Film screenings and storytelling for children.',
    },
    'Ludoteca': {
      'en': 'Playroom',
      'desc_en': 'Recreational space with educational toys and games for families.',
    },
    'Zona multimedia': {
      'en': 'Multimedia Zone',
      'desc_en': 'It is an area with high user circulation. In this space, computer loan service is provided to work on various data processing programs, as well as to browse the internet and different digital entertainment platforms.',
    },
    'Realidad virtual': {
      'en': 'Virtual Reality',
      'desc_en': 'Immersive digital experiences and educational VR content.',
    },
    'Impresión 3D': {
      'en': '3D Printing',
      'desc_en': 'Digital fabrication laboratory for 3D modeling and prototyping.',
    },
    'Cabina de podcast': {
      'en': 'Podcast Booth',
      'desc_en': 'Professional audio recording studio for creating digital content.',
    },
  };

  static String get(String nombreArea, {bool isDesc = false}) {
    if (Get.locale?.languageCode == 'es') return nombreArea;
    var entry = data[nombreArea];
    if (entry == null) return nombreArea;
    return isDesc ? (entry['desc_en'] ?? nombreArea) : (entry['en'] ?? nombreArea);
  }
}
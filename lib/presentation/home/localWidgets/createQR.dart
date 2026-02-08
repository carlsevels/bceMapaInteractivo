import 'package:flutter/material.dart';
import 'package:mapa_interactivo/presentation/home/controllers/home.controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

Widget buildQrReservaFuncional(HomeController controller) {
  final String email = 'redestataldebibliotecasnl@gmail.com';
  final String nombreSala = controller.visibleArea.value?.nombre ?? 'Sala';

  final Uri mailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': 'Reserva de espacio: $nombreSala',
      'body': 'Hola, quiero reservar esta sala.',
    },
  );

  final String qrData = mailUri.toString();

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 180.0,
          gapless: true,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.circle,
            color: Color(0xFFE27D18),
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'ESCANEA PARA AUTO-COMPLETAR',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    ],
  );
}

Widget buildQrReservaWhatsApp(HomeController controller) {
  // ⚠️ Número con código de país, SIN + ni espacios
  final String phoneNumber = '8117948943'; // <-- CAMBIA ESTO

  final String nombreSala = controller.visibleArea.value?.nombre ?? 'Sala';

  String _articuloPara(String nombreSala) {
    final nombre = nombreSala.toLowerCase();

    if (nombre.contains('auditorio')) return 'el';
    if (nombre.contains('cabina')) return 'la';

    return 'la';
  }

  final String articulo = _articuloPara(nombreSala);

  final Uri whatsappUri = Uri(
    scheme: 'https',
    host: 'wa.me',
    path: phoneNumber,
    queryParameters: {'text': 'Hola, quiero reservar $articulo $nombreSala'},
  );

  final String qrData = whatsappUri.toString();

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 180.0,
          gapless: true,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.circle,
            color: Color(0xFF25D366), // Verde WhatsApp
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: Color(0xFF1E1E1E),
          ),
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'ESCANEA PARA ENVIAR WHATSAPP',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF25D366),
        ),
      ),
    ],
  );
}

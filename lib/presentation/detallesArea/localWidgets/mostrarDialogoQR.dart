import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';

void mostrarDialogoQR(Area area, {required String tipo}) {
    String contenidoQR;
    bool esWhatsApp = tipo == "WhatsApp";

    // 🔹 Aquí es donde se inyecta dinámicamente el nombre: "Cabina de podcast", "Auditorio", etc.
    if (esWhatsApp) {
      final phone = "8120209239";
      // Usamos encodeComponent para que espacios y caracteres especiales no rompan el QR
      final mensaje = "Hola, quiero reservar el espacio: ${area.nombre}";
      contenidoQR = "https://wa.me/$phone?text=${Uri.encodeComponent(mensaje)}";
    } else {
      final email = "redestataldebibliotecasnl@gob.com";
      final asunto = "Reserva de ${area.nombre}";
      final cuerpo = "Hola, me interesa solicitar una reserva para el espacio: ${area.nombre}";
      
      contenidoQR = "mailto:$email?subject=${Uri.encodeComponent(asunto)}&body=${Uri.encodeComponent(cuerpo)}";
    }

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: esWhatsApp ? const Color(0xFF25D366) : Colors.orange,
                      child: Icon(esWhatsApp ? Icons.phone : Icons.email, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Escanea para reservar',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 10),
                // 🔹 Subtítulo que confirma qué espacio se está reservando
                Text(
                  area.nombre.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w800, 
                    color: Colors.grey.shade600,
                    letterSpacing: 1.1
                  ),
                ),
                const SizedBox(height: 25),
                
                // Generador de QR
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: contenidoQR,
                    version: QrVersions.auto,
                    size: 200.0,
                    gapless: false,
                  ),
                ),
                
                const SizedBox(height: 20),
                Text(
                  "Apunta con la cámara de tu celular",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: esWhatsApp ? const Color(0xFF25D366) : Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Finalizar", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
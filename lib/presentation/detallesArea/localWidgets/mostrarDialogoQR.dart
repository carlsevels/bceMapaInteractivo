
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';

void mostrarDialogoQR(Area area, {required String tipo}) {
    String contenidoQR;
    bool esWhatsApp = tipo == "WhatsApp";

    if (esWhatsApp) {
      final phone = "9283838382";
      contenidoQR = Uri.encodeFull(
        "https://wa.me/$phone?text=Hola,%20quiero%20reservar%20el%20${area.nombre}",
      );
    } else {
      final email = "redestataldebibliotecasnl@gob.com";
      contenidoQR = Uri.encodeFull(
        "mailto:$email?subject=Reservar%20${area.nombre}&body=Hola,%20quiero%20reservar%20el%20${area.nombre}",
      );
    }

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: esWhatsApp
                          ? const Color(0xFF25D366)
                          : Colors.orange,
                      child: Icon(
                        esWhatsApp ? Icons.phone : Icons.email_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Escanea para $tipo',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  esWhatsApp ? 'WHATSAPP' : 'CORREO ELECTRÓNICO',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: esWhatsApp ? const Color(0xFF25D366) : Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: esWhatsApp
                          ? const Color(0xFF25D366)
                          : Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

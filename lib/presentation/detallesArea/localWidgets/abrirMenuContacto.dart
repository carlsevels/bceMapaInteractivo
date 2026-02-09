  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';
import 'package:mapa_interactivo/presentation/detallesArea/localWidgets/mostrarDialogoQR.dart';
import 'package:mapa_interactivo/presentation/detallesArea/localWidgets/titleContact.dart';

void abrirMenuContacto(Area area) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Reservar ${area.nombre}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            titleContact(
              icon: Icons.phone,
              title: "WhatsApp",
              value: "9283838382",
              color: const Color(0xFF25D366),
              onTap: () => mostrarDialogoQR(area, tipo: "WhatsApp"),
            ),
            const SizedBox(height: 12),
            titleContact(
              icon: Icons.alternate_email_rounded,
              title: "Correo Electrónico",
              value: "redestataldebibliotecasnl@gob.com",
              color: Colors.orange,
              onTap: () => mostrarDialogoQR(area, tipo: "Correo"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
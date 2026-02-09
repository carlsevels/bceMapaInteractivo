  // Este método abre la imagen en pantalla completa
  import 'package:flutter/material.dart';
import 'package:mapa_interactivo/infrastructure/globalViews/galeriaScreen.dart';

void abrirImagenPantallaCompleta(
    BuildContext context,
    List<String> imagenes,
    int initialIndex,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => GaleriaScreen(
          imagenes: imagenes,
          initialIndex: initialIndex,
          title: title,
        ),
      ),
    );
  }

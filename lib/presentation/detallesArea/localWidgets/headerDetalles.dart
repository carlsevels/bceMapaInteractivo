import 'package:flutter/material.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';

Widget headerDetalles(Area area) {
  const Color colorAccent = Color(0xFF00ACC1);

  return SliverAppBar(
    actionsPadding: EdgeInsets.zero,
    expandedHeight: area.galeria.isNotEmpty ? 180 : 50,
    automaticallyImplyLeading: false,
    pinned: true,
    backgroundColor: colorAccent,
    flexibleSpace: FlexibleSpaceBar(
      title: Text(
        area.nombre,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      titlePadding: const EdgeInsetsDirectional.only(start: 12, bottom: 12),
      background: Stack(
        fit: StackFit.expand,
        children: [
          area.galeria.isNotEmpty
              ? Image.asset(area.galeria.first, fit: BoxFit.cover)
              : Container(color: Colors.cyan),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

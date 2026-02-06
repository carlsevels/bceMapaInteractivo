import 'package:flutter/material.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'dart:math';

/// Auxiliar para normalizar texto en búsquedas
String _removeAccents(String text) {
  var withDia = 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜ';
  var withoutDia = 'aeiouAEIOUaeiouAEIOU';
  for (int i = 0; i < withDia.length; i++) {
    text = text.replaceAll(withDia[i], withoutDia[i]);
  }
  return text.toLowerCase();
}

class MapaPiso extends StatelessWidget {
  final String image;
  final List<Area> areas;
  final String currentQuery;
  final String? selectedCategory;
  final int missionStep;
  final Function(Area) onAreaTap;
  final TransformationController transformationController;

  const MapaPiso({
    Key? key,
    required this.image,
    required this.areas,
    required this.currentQuery,
    this.selectedCategory,
    required this.missionStep,
    required this.onAreaTap,
    required this.transformationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);

      return Stack(
        children: [
          // 1. CAPA DEL MAPA (InteractiveViewer)
          InteractiveViewer(
            transformationController: transformationController,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(2000),
            minScale: 0.1,
            maxScale: 5.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(image, fit: BoxFit.none),

                // Renderizado de todos los puntos
                ...areas.map((area) {
                  final bool isFound = currentQuery.isNotEmpty &&
                      _removeAccents(area.nombre).contains(_removeAccents(currentQuery));

                  return Positioned(
                    left: area.x,
                    top: area.y,
                    child: GestureDetector(
                      onTap: () => onAreaTap(area),
                      child: _PulseMarker(
                        nombre: area.nombre,
                        isHighlighted: isFound,
                        isUserLocation: area.esUbicacionActual,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // 2. CAPA DE LA FLECHA GUÍA (Solo para esUbicacionActual)
          AnimatedBuilder(
            animation: transformationController,
            builder: (context, child) {
              // 🔹 Lógica Filtrada: Buscar solo el punto de ubicación actual
              final List<Area> userPoints = areas.where((a) => a.esUbicacionActual == true).toList();
              
              if (userPoints.isEmpty) return const SizedBox.shrink();

              final targetArea = userPoints.first;

              // Convertir coordenadas del mapa a píxeles de pantalla
              final vmath.Vector3 targetPosInScreen = transformationController.value
                  .transform3(vmath.Vector3(targetArea.x, targetArea.y, 0));
              
              const double margin = 50.0;

              // Determinar si el punto de ubicación está fuera de la vista del usuario
              bool isOutside = targetPosInScreen.x < margin || 
                               targetPosInScreen.x > size.width - margin || 
                               targetPosInScreen.y < margin || 
                               targetPosInScreen.y > size.height - margin;

              // Si es visible en pantalla, no mostramos la flecha
              if (!isOutside) return const SizedBox.shrink();

              // Posicionar la flecha en los bordes
              final double arrowX = targetPosInScreen.x.clamp(margin, size.width - margin);
              final double arrowY = targetPosInScreen.y.clamp(margin, size.height - margin);

              final double angle = atan2(
                targetPosInScreen.y - arrowY, 
                targetPosInScreen.x - arrowX
              );

              return Positioned(
                left: arrowX - 25,
                top: arrowY - 25,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.rotate(
                      angle: angle + (pi / 2),
                      child: const Icon(
                        Icons.navigation,
                        size: 40,
                        color: Colors.redAccent,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
                      ),
                      child: const Text(
                        "ESTÁS AQUÍ",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 10, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}

class _PulseMarker extends StatefulWidget {
  final String nombre;
  final bool isHighlighted;
  final bool isUserLocation;

  const _PulseMarker({
    required this.nombre,
    required this.isHighlighted,
    this.isUserLocation = false,
  });

  @override
  State<_PulseMarker> createState() => _PulseMarkerState();
}

class _PulseMarkerState extends State<_PulseMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = widget.isUserLocation
        ? Colors.redAccent
        : (widget.isHighlighted ? Colors.amber : Colors.indigo);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isHighlighted || widget.isUserLocation)
              FadeTransition(
                opacity: Tween(begin: 0.5, end: 0.0).animate(_controller),
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 2.5).animate(_controller),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: mainColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(
                widget.isUserLocation ? Icons.person_pin : Icons.location_on,
                color: Colors.white,
                size: (widget.isHighlighted || widget.isUserLocation) ? 22 : 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: widget.isUserLocation
                ? Colors.redAccent
                : (widget.isHighlighted ? Colors.amber : Colors.black87),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.nombre.toUpperCase(),
            style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
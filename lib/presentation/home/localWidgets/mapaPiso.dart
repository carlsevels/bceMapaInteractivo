import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

class MapaPiso extends StatelessWidget {
  final String image;
  final List<Area> areas;
  final String currentQuery;
  final String? selectedCategory;
  final int missionStep;
  final Function(Area) onAreaTap;
  final TransformationController transformationController;
  final double paddingRight;
  final double paddingTop;

  const MapaPiso({
    Key? key,
    required this.image,
    required this.areas,
    required this.currentQuery,
    this.selectedCategory,
    required this.missionStep,
    required this.onAreaTap,
    required this.transformationController,
    this.paddingRight = 20.0,
    this.paddingTop = 20.0, // 🔹 Valor por defecto
  }) : super(key: key);

  String _removeAccents(String text) {
    var withDia = 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜ';
    var withoutDia = 'aeiouAEIOUaeiouAEIOU';
    for (int i = 0; i < withDia.length; i++) {
      text = text.replaceAll(withDia[i], withoutDia[i]);
    }
    return text.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        final visibleAreas = areas.where((area) {
          if (area.esUbicacionActual) return true;
          if (selectedCategory != null && selectedCategory!.isNotEmpty) {
            return area.categoria == selectedCategory;
          }
          return true;
        }).toList();

        return Stack(
          children: [
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
                  ...visibleAreas.map((area) {
                    final bool isHighlighted =
                        currentQuery.isNotEmpty &&
                        _removeAccents(
                          area.nombre,
                        ).contains(_removeAccents(currentQuery));

                    return Positioned(
                      left: area.x,
                      top: area.y,
                      child: GestureDetector(
                        onTap: () => onAreaTap(area),
                        child: _PulseMarker(
                          nombre: area.nombre,
                          isHighlighted: isHighlighted,
                          isUserLocation: area.esUbicacionActual,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            AnimatedBuilder(
              animation: transformationController,
              builder: (context, child) {
                final userLocation = areas.firstWhere(
                  (a) => a.esUbicacionActual,
                  orElse: () => Area(
                    nombre: '',
                    descripcion: '',
                    x: -1000,
                    y: -1000,
                    horario: [],
                    servicios: [],
                    reglas: [],
                    galeria: [],
                    categoria: '',
                    palabrasClave: [],
                  ),
                );

                if (userLocation.x == -1000) return const SizedBox.shrink();

                final vmath.Vector3 posInScreen = transformationController.value
                    .transform3(
                      vmath.Vector3(userLocation.x, userLocation.y, 0),
                    );

                const double margin = 60.0;
                final double limitRight = size.width - paddingRight;
                final double limitTop = paddingTop;

                bool isOutside =
                    posInScreen.x < margin ||
                    posInScreen.x > limitRight ||
                    posInScreen.y < limitTop ||
                    posInScreen.y > size.height - margin;

                if (!isOutside) return const SizedBox.shrink();

                final double arrowX = posInScreen.x.clamp(margin, limitRight);
                final double arrowY = posInScreen.y.clamp(
                  limitTop,
                  size.height - margin,
                );
                final double angle = atan2(
                  posInScreen.y - arrowY,
                  posInScreen.x - arrowX,
                );

                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutQuart,
                  left: arrowX - 25,
                  top: arrowY - 25,
                  child: IgnorePointer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: angle + (pi / 2),
                          child: const Icon(
                            Icons.navigation,
                            size: 45,
                            color: Colors.redAccent,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 6),
                            ],
                          ),
                          child: const Text(
                            "ESTÁS AQUÍ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
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

class _PulseMarkerState extends State<_PulseMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
        : (widget.isHighlighted ? Colors.orange : Colors.indigo);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isHighlighted || widget.isUserLocation)
              FadeTransition(
                opacity: Tween(begin: 0.6, end: 0.0).animate(_controller),
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 3.0).animate(_controller),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: mainColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5),
              child: Icon(
                widget.isUserLocation ? Icons.person_pin : Icons.location_on,
                color: Colors.white,
                size: (widget.isHighlighted || widget.isUserLocation) ? 24 : 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.isUserLocation
                ? Colors.redAccent
                : (widget.isHighlighted ? Colors.orange : Colors.black87),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Text(
            widget.nombre.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';

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
    final visibleAreas = areas.where((area) {
      // 🔹 IMPORTANTE: Siempre mostrar la ubicación actual aunque haya filtros
      if (area.esUbicacionActual) return true; 
      
      if (currentQuery.isNotEmpty) return true;
      if (selectedCategory != null && selectedCategory!.isNotEmpty) {
        return area.categoria == selectedCategory;
      }
      return true;
    }).toList();

    return InteractiveViewer(
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
            final bool isFound = currentQuery.isNotEmpty &&
                _removeAccents(area.nombre).contains(_removeAccents(currentQuery));

            return Positioned(
              left: area.x,
              top: area.y,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onAreaTap(area),
                // 🔹 PASAMOS EL NUEVO CAMPO AL MARCADOR
                child: _PulseMarker(
                  nombre: area.nombre, 
                  isHighlighted: isFound,
                  isUserLocation: area.esUbicacionActual, // <--- Nueva propiedad
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _PulseMarker extends StatefulWidget {
  final String nombre;
  final bool isHighlighted;
  final bool isUserLocation; // 🔹 Detectar si es el "Usted está aquí"

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
    // 🔹 LÓGICA DE COLORES: Si es ubicación es Rojo, si es búsqueda es Ámbar, sino Índigo.
    final Color mainColor = widget.isUserLocation 
        ? Colors.redAccent 
        : (widget.isHighlighted ? Colors.amber : Colors.indigo);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // El pulso animado se activa si es encontrado O si es la ubicación actual
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
              // 🔹 ICONO DIFERENTE: Personita para ubicación, pin para lo demás
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
            style: TextStyle(
              fontSize: 8, 
              color: (widget.isHighlighted || widget.isUserLocation) ? Colors.white : Colors.white, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
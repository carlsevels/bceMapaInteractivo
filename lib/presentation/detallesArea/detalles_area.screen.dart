import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/globalViews/tituloSection.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';
import 'package:mapa_interactivo/presentation/detallesArea/localWidgets/bannerSeparar.dart';
import 'package:mapa_interactivo/presentation/detallesArea/localWidgets/galeria.dart';
import 'package:mapa_interactivo/presentation/detallesArea/localWidgets/headerDetalles.dart';
import 'package:mapa_interactivo/presentation/home/controllers/home.controller.dart';

class DetallesAreaScreen extends StatelessWidget {
  final Area? area;
  DetallesAreaScreen({super.key, this.area});

  static const Color colorAccent = Color(0xFF00ACC1);
  static const Color colorNaranja = Colors.orange;
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final Area? areaFinal = area ?? Get.arguments as Area?;

    if (areaFinal == null) return const SizedBox.shrink();
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              headerDetalles(areaFinal),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuickStats(areaFinal),
                      const SizedBox(height: 28),
                      tituloSection("Acerca del espacio"),
                      const SizedBox(height: 12),
                      Text(
                        areaFinal.descripcion,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                          height: 1.6,
                        ),
                      ),
                      if (areaFinal.galeria.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 28),
                            tituloSection("Galería visual"),
                            const SizedBox(height: 12),
                            galeria(areaFinal.galeria, areaFinal.nombre),
                          ],
                        ),
                      const SizedBox(height: 28),

                      // Modificado para incluir la lógica de la imagen de reglamento
                      _buildCompactInfoRow(context, areaFinal),

                      if (areaFinal.sePuedeRentar == true) ...[
                        const SizedBox(height: 32),
                        bannerSeparar(areaFinal),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: FloatingActionButton.small(
                onPressed: isMobile ? Get.back : controller.closePanel,
                backgroundColor: Colors.white.withOpacity(0.9),
                elevation: 4,
                child: const Icon(Icons.close, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(Area area) {
    return Column(
      children: [
        _miniStat(
          Icons.access_time_filled_rounded,
          area.horario.isNotEmpty ? area.horario : ["Horario no disponible"],
          colorNaranja,
        ),
        const SizedBox(height: 8),
        _miniStat(Icons.location_on_rounded, [
          "Ubicación",
          "Piso ${controller.pisoActual}",
        ], colorAccent),
      ],
    );
  }

  Widget _miniStat(IconData icon, List<String> text, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 22, color: color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text.isNotEmpty ? text[0] : "",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1C1E),
                            ),
                          ),
                          if (text.length > 1) ...[
                            const SizedBox(height: 2),
                            Text(
                              text[1],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (resto del código igual arriba)

  Widget _buildCompactInfoRow(BuildContext context, Area area) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildSimpleListTile(
            "Servicios",
            area.servicios,
            Icons.bolt_rounded,
            colorAccent,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          if (area.reglas != null)
            _buildSimpleListTile(
              "Reglas del espacio",
              area.reglas ?? [],
              Icons.gavel_rounded,
              Colors.redAccent,
            ),

          // 🔹 Sección de Imagen del Reglamento Corregida
          if (area.imagenReglamento != null &&
              area.imagenReglamento!.isNotEmpty) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () =>
                  _showFullScreenImage(context, area.imagenReglamento!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reglamento oficial:",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.network(
                            area.imagenReglamento!,
                            // 🔹 Quitamos la altura fija y usamos BoxFit.contain para verla completa
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 150,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: colorAccent,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 100,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                      // Badge decorativo
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorAccent.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.zoom_in_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Expandir",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ... (El resto del método _showFullScreenImage y _buildSimpleListTile se mantienen igual)
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleListTile(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          const Text(
            "No especificado",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

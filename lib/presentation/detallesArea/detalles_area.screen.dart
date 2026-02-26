import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/globalViews/tituloSection.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';
import 'package:mapa_interactivo/l10n/app_localizations.dart';
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
      // Envolvemos el cuerpo en Obx para que reaccione al cambio de idioma global
      body: Obx(() {
        // Detectamos el idioma actual para etiquetas estáticas
        final String lang = Get.locale?.languageCode ?? 'es';

        return Stack(
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
                        _buildQuickStats(areaFinal, context, lang),
                        const SizedBox(height: 28),

                        // Título traducido
                        tituloSection(
                          lang == 'es'
                              ? "Acerca del espacio"
                              : "About this space",
                        ),
                        const SizedBox(height: 12),

                        // Descripción traducida mediante el getter del modelo Area
                        Text(
                          areaFinal.displayDescription,
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
                              tituloSection(
                                lang == 'es'
                                    ? "Galería visual"
                                    : "Visual Gallery",
                              ),
                              const SizedBox(height: 12),
                              galeria(areaFinal.galeria, areaFinal.displayName),
                            ],
                          ),
                        const SizedBox(height: 28),

                        _buildCompactInfoRow(context, areaFinal, lang),

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

            // Botón de cerrar
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
        );
      }),
    );
  }

  Widget _buildQuickStats(Area area, BuildContext context, String lang) {
    return Column(
      children: [
        _miniStat(
          Icons.access_time_filled_rounded,
          area.horario.isNotEmpty
              ? area.horario
              : [
                  lang == 'es'
                      ? "Horario no disponible"
                      : "Hours not available",
                ],
          colorNaranja,
        ),
        const SizedBox(height: 8),
        _miniStat(Icons.location_on_rounded, [
          lang == 'es' ? "Ubicación" : "Location",
          "${AppLocalizations.of(context)!.floor} ${controller.pisoActual.value}",
        ], colorAccent),
      ],
    );
  }

  Widget _buildCompactInfoRow(BuildContext context, Area area, String lang) {
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
            lang == 'es' ? "Servicios" : "Services",
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
              lang == 'es' ? "Reglas del espacio" : "Space Rules",
              area.reglas ?? [],
              Icons.gavel_rounded,
              Colors.redAccent,
            ),

          if (area.imagenReglamento != null &&
              area.imagenReglamento!.isNotEmpty) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () =>
                  _showFullScreenImage(context, area.imagenReglamento!, lang),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang == 'es'
                        ? "Reglamento oficial:"
                        : "Official Regulations:",
                    style: const TextStyle(
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
                          child: Image.asset(
                            area.imagenReglamento!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.zoom_in_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lang == 'es' ? "Expandir" : "Expand",
                              style: const TextStyle(
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

  void _showFullScreenImage(
    BuildContext context,
    String imageUrl,
    String lang,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: Image.asset(imageUrl, fit: BoxFit.contain),
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
                  ],
                ),
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

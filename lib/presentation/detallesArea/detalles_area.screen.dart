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
    return Container(
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              headerDetalles(areaFinal),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuickStats(areaFinal),
                      const SizedBox(height: 24),
                      tituloSection("Acerca del espacio"),
                      const SizedBox(height: 8),
                      Text(
                        areaFinal.descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      if (areaFinal.galeria.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            tituloSection("Galería visual"),
                            const SizedBox(height: 8),
                            galeria(areaFinal.galeria, areaFinal.nombre),
                          ],
                        ),
                      const SizedBox(height: 24),
                      _buildCompactInfoRow(areaFinal),
                      if (areaFinal.sePuedeRentar == true) ...[
                        const SizedBox(height: 24),
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
                child: const Icon(Icons.close, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(Area area) {
    return Row(
      children: [
        _miniStat(Icons.access_time_filled, area.horario, colorNaranja),
        const SizedBox(width: 12),
        _miniStat(
          Icons.location_on,
          "Piso ${controller.pisoActual}",
          colorAccent,
        ),
      ],
    );
  }

  Widget _miniStat(IconData icon, String text, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoRow(Area area) {
    return Column(
      children: [
        _buildSimpleListTile(
          "Servicios",
          area.servicios,
          Icons.bolt,
          colorAccent,
        ),
        const Divider(height: 20),
        _buildSimpleListTile(
          "Reglas",
          area.reglas,
          Icons.gavel_rounded,
          Colors.redAccent,
        ),
      ],
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
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          children: items
              .map(
                (e) => Text(
                  "• $e",
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

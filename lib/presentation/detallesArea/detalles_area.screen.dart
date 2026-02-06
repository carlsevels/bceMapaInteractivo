import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';
import 'package:mapa_interactivo/presentation/home/controllers/home.controller.dart';

class DetallesAreaScreen extends StatelessWidget {
  final Area? area;
  DetallesAreaScreen({Key? key, this.area}) : super(key: key);

  static const Color colorAccent = Color(0xFF00ACC1);
  static const Color colorNaranja = Colors.orange;
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // Si usas Get.arguments, lo recuperamos, si no, usamos el del constructor
    final Area? areaFinal = area ?? Get.arguments as Area?;

    if (areaFinal == null) return const SizedBox.shrink();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
      ),
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildCompactHeader(areaFinal),
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

                      _buildSectionLabel("Acerca del espacio"),
                      const SizedBox(height: 8),
                      Text(
                        areaFinal.descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),
                      _buildSectionLabel("Galería visual"),
                      const SizedBox(height: 8),
                      _buildCompactGallery(areaFinal.galeria),

                      const SizedBox(height: 24),
                      _buildCompactInfoRow(areaFinal),

                      if (areaFinal.sePuedeRentar == true) ...[
                        const SizedBox(height: 24),
                        _buildRentaBanner(areaFinal),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Botón cerrar flotante para no depender del AppBar
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: FloatingActionButton.small(
                onPressed: () => controller.selectedArea.value = null,
                backgroundColor: Colors.white.withOpacity(0.9),
                child: const Icon(Icons.close, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES DE DISEÑO UNIFICADOS ---

  Widget _buildCompactHeader(Area area) {
    return SliverAppBar(
      expandedHeight: 180,
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
                : Container(color: Colors.grey.shade300),
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

  Widget _buildCompactGallery(List<String> imagenes) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagenes.isEmpty ? 1 : imagenes.length,
        itemBuilder: (context, index) => GestureDetector(
          // Al tocar, abrimos la pantalla completa
          onTap: () => _abrirImagenPantallaCompleta(imagenes, index),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imagenes.isEmpty
                  ? const Icon(Icons.image_outlined)
                  : Hero(
                      tag: 'img_$index', // Animación fluida al abrir
                      child: Image.asset(imagenes[index], fit: BoxFit.cover),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _abrirImagenPantallaCompleta(List<String> imagenes, int initialIndex) {
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: PageView.builder(
          controller: PageController(initialPage: initialIndex),
          itemCount: imagenes.length,
          itemBuilder: (context, index) {
            return Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Hero(
                  tag: 'img_$index',
                  child: Image.asset(
                    imagenes[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      fullscreenDialog: true,
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

  // --- LÓGICA DE CONTACTO Y RENTA (TUYA REFORMATEADA) ---

  Widget _buildRentaBanner(Area area) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade700],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "DISPONIBLE PARA RENTA",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _abrirMenuContacto(area),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green.shade700,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "RESERVAR AHORA",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirMenuContacto(Area area) {
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
            _buildContactTile(
              icon: Icons.chat_bubble_rounded,
              title: "WhatsApp",
              value: "928 383 8382",
              color: const Color(0xFF25D366),
              onTap: () => _mostrarDialogoQR('wp.png', "WhatsApp"),
            ),
            const SizedBox(height: 12),
            _buildContactTile(
              icon: Icons.alternate_email_rounded,
              title: "Correo Electrónico",
              value: "correo@gob.com",
              color: Colors.blueAccent,
              onTap: () => _mostrarDialogoQR('gmail.png', "Correo"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.qr_code, size: 20),
      tileColor: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _mostrarDialogoQR(String qrPath, String titulo) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320, // Ajustado para que quepa bien en el panel
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Escanea para $titulo",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(qrPath, width: 200, height: 200),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text("CERRAR"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.grey.shade500,
        letterSpacing: 1,
      ),
    );
  }
}

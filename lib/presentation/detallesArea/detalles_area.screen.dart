import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';
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
                      if (areaFinal.galeria.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            _buildSectionLabel("Galería visual"),
                            const SizedBox(height: 8),
                            _buildCompactGallery(
                              areaFinal.galeria,
                              areaFinal.nombre,
                            ),
                          ],
                        ),
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

  Widget _buildCompactHeader(Area area) {
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

  Widget _buildCompactGallery(List<String> imagenes, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(Get.context!).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagenes.isEmpty ? 1 : imagenes.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _abrirImagenPantallaCompleta(
                  context,
                  imagenes,
                  index,
                  title,
                ),
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
                            tag: 'img_$index',
                            child: Image.asset(
                              imagenes[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Este método abre la imagen en pantalla completa
  void _abrirImagenPantallaCompleta(
    BuildContext context,
    List<String> imagenes,
    int initialIndex,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => GaleriaAvanzadaScreen(
          imagenes: imagenes,
          initialIndex: initialIndex,
          title: title,
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
            children: const [
              Icon(Icons.stars, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
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
              icon: Icons.phone,
              title: "WhatsApp",
              value: "9283838382",
              color: const Color(0xFF25D366),
              onTap: () => _mostrarDialogoQR(area, tipo: "WhatsApp"),
            ),
            const SizedBox(height: 12),
            _buildContactTile(
              icon: Icons.alternate_email_rounded,
              title: "Correo Electrónico",
              value: "redestataldebibliotecasnl@gob.com",
              color: Colors.orange,
              onTap: () => _mostrarDialogoQR(area, tipo: "Correo"),
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

  void _mostrarDialogoQR(Area area, {required String tipo}) {
    String contenidoQR;
    bool esWhatsApp = tipo == "WhatsApp";

    if (esWhatsApp) {
      final phone = "9283838382";
      contenidoQR = Uri.encodeFull(
        "https://wa.me/$phone?text=Hola,%20quiero%20reservar%20el%20${area.nombre}",
      );
    } else {
      final email = "redestataldebibliotecasnl@gob.com";
      contenidoQR = Uri.encodeFull(
        "mailto:$email?subject=Reservar%20${area.nombre}&body=Hola,%20quiero%20reservar%20el%20${area.nombre}",
      );
    }

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: esWhatsApp
                          ? const Color(0xFF25D366)
                          : Colors.orange,
                      child: Icon(
                        esWhatsApp ? Icons.phone : Icons.email_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Escanea para $tipo',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  esWhatsApp ? 'WHATSAPP' : 'CORREO ELECTRÓNICO',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: esWhatsApp ? const Color(0xFF25D366) : Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: esWhatsApp
                          ? const Color(0xFF25D366)
                          : Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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

class GaleriaAvanzadaScreen extends StatefulWidget {
  final List<String> imagenes;
  final int initialIndex;
  final String title;

  const GaleriaAvanzadaScreen({
    super.key,
    required this.imagenes,
    required this.initialIndex,
    required this.title,
  });

  @override
  State<GaleriaAvanzadaScreen> createState() => _GaleriaAvanzadaScreenState();
}

class _GaleriaAvanzadaScreenState extends State<GaleriaAvanzadaScreen> {
  late PageController _pageController;
  late int _currentIndex;
  double _currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _currentPageValue = widget.initialIndex.toDouble();
    _pageController = PageController(initialPage: widget.initialIndex);

    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page!;
        _currentIndex = _currentPageValue.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isMobile
                  ? "${_currentIndex + 1} / ${widget.imagenes.length}"
                  : widget.title.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 16 : 13,
                fontWeight: isMobile ? FontWeight.w600 : FontWeight.w900,
                letterSpacing: isMobile ? 0 : 3.0,
              ),
            ),
            if (isMobile)
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          isMobile ? _buildMobileView(size) : _buildDesktopView(size),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- VISTA MÓVIL (Facebook style) ---
  Widget _buildMobileView(Size size) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 500) Navigator.pop(context);
      },
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagenes.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: true,    // permite arrastrar la imagen
            scaleEnabled: true,  // habilita zoom
            minScale: 1.0,
            maxScale: 4.0,
            child: Center(
              child: Hero(
                tag: 'img_$index',
                child: Image.asset(
                  widget.imagenes[index],
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- VISTA DESKTOP ---
  Widget _buildDesktopView(Size size) {
    return Stack(
      children: [
        // Fondo desenfocado
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Container(
            key: ValueKey(widget.imagenes[_currentIndex]),
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagenes[_currentIndex]),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
        ),

        // Carrusel con soporte swipe y zoom
        Center(
          child: SizedBox(
            height: size.height * 0.85,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: widget.imagenes.length,
              itemBuilder: (context, index) {
                double diff = (index - _currentPageValue);
                double baseScale = (1 - (diff.abs() * 0.25)).clamp(0.75, 1.0);
                double opacity = (1 - (diff.abs() * 0.5)).clamp(0.3, 1.0);

                return Center(
                  child: Transform.scale(
                    scale: baseScale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: InteractiveViewer(
                            panEnabled: true,
                            scaleEnabled: true,
                            minScale: 1.0,
                            maxScale: 4.0,
                            child: Image.asset(
                              widget.imagenes[index],
                              fit: BoxFit.contain,
                              height: size.height * 0.85,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

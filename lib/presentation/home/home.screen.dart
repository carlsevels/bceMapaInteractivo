import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/presentation/home/controllers/home.controller.dart';
import 'package:mapa_interactivo/presentation/home/localWidgets/createQR.dart';
import 'package:mapa_interactivo/presentation/home/localWidgets/mapaPiso.dart';
import 'package:mapa_interactivo/presentation/screens.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key) {
    Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FA,
      ), // Gris muy claro para resaltar capas
      body: Stack(
        children: [
          /// --- CAPA DEL MAPA Y CONTROLES FLOTANTES ---
          Obx(
            () => AnimatedPadding(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              padding: EdgeInsets.only(
                left: controller.isMenuOpen.value ? 350 : 0,
                right: controller.isPanelOpen.value ? 450 : 0,
              ),
              child: Stack(
                children: [
                  MapaPiso(
                    key: ValueKey(controller.pisoActual.value),
                    image: 'assets/piso_${controller.pisoActual.value}.png',
                    areas: controller.pisos[controller.pisoActual.value] ?? [],
                    currentQuery: controller.query.value,
                    selectedCategory: controller.categoriaSeleccionada.value,
                    missionStep: controller.missionStep.value,
                    onAreaTap: controller.onAreaSelected,
                    transformationController:
                        controller.transformationController,
                  ),

                  _buildCategoryFilterBar(),
                  _buildFloatingFloorIndicator(),
                  _buildZoomControls(),
                  _buildFloatingMenuButton(),
                  _buildMissionBanner(),
                ],
              ),
            ),
          ),

          /// --- MENÚ LATERAL IZQUIERDO ---
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              left: controller.isMenuOpen.value ? 0 : -350,
              top: 0,
              bottom: 0,
              width: 350,
              child: _buildSideNavigation(),
            ),
          ),

          /// --- PANEL DE DETALLES DERECHO ---
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              right: controller.isPanelOpen.value ? 0 : -450,
              top: 0,
              bottom: 0,
              width: 450,
              child: controller.visibleArea.value == null
                  ? const SizedBox.shrink()
                  : DetallesAreaScreen(area: controller.visibleArea.value!),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES DE ZOOM ---

  Widget _buildZoomControls() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: Column(
        children: [
          Obx(
            () => _miniFab(
              Icons.add,
              controller.zoomLevel.value >= controller.maxZoomClicks
                  ? null
                  : () => controller.zoomIn(),
            ),
          ),
          const SizedBox(height: 12),
          _miniFab(Icons.fullscreen_exit, () => controller.resetZoom()),
          const SizedBox(height: 12),
          Obx(
            () => _miniFab(
              Icons.remove,
              controller.zoomLevel.value <= -controller.maxZoomClicks
                  ? null
                  : () => controller.zoomOut(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniFab(IconData i, VoidCallback? call) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: FloatingActionButton(
      heroTag: null,
      mini: true,
      elevation: 0,
      highlightElevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: call == null ? Colors.grey[100] : Colors.white,
      onPressed: call,
      child: Icon(i, color: call == null ? Colors.grey : Colors.cyan[800]),
    ),
  );

  Widget _buildSideNavigation() {
    return Container(
      width: 320,
      decoration: const BoxDecoration(color: Colors.cyan),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Image.asset("logos/bce2.png", width: 110),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "BCE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Biblioteca Central de Estado",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Fray Servando Teresa de Mier",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
                    
              const SizedBox(height: 16),
                    
              /// BUSCADOR
              Obx(
                () => _tutorialHighlight(
                  isActive: controller.missionStep.value == 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: _buildSearchSection(),
                  ),
                ),
              ),
                    
              const SizedBox(height: 30),
                    
              /// TITULO SECCIÓN
              Row(
                children: const [
                  Icon(Icons.layers_rounded, color: Colors.white70, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Selecciona nivel',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
                    
              const SizedBox(height: 12),
                    
              /// LISTA DE NIVELES
              Container(
                height: 170,
                child: Obx(
                  () => _tutorialHighlight(
                    isActive: controller.missionStep.value == 1,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: _buildFloorList(),
                    ),
                  ),
                ),
              ),
                    
              const SizedBox(height: 18),
                    
              /// AYUDA
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildHelpButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tutorialHighlight({required bool isActive, required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: isActive ? const EdgeInsets.all(8) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? Colors.white : Colors.transparent,
          width: 2,
        ),
      ),
      child: child,
    );
  }

  final LayerLink searchLayerLink = LayerLink();
  final OverlayPortalController overlayController = OverlayPortalController();
  Widget _buildSearchSection() {
    return CompositedTransformTarget(
      link: searchLayerLink,
      child: OverlayPortal(
        controller: overlayController,
        overlayChildBuilder: (context) {
          return CompositedTransformFollower(
            link: searchLayerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 8), // Espacio entre el buscador y la lista
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 15,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width:
                      306, // Ajusta al ancho interno de tu buscador (350 - paddings)
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Obx(
                    () => controller.sugerencias.isEmpty
                        ? const SizedBox.shrink()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: controller.sugerencias.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, index) {
                                final area = controller.sugerencias[index];
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.orange,
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                      children: _buildHighlightedText(
                                        area.nombre,
                                        controller.query.value,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    controller.seleccionarDesdeSugerencia(area);
                                    overlayController
                                        .hide(); // Cerramos al seleccionar
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ),
          );
        },
        child: TextField(
          controller: controller.searchController,
          onChanged: (val) {
            controller.buscarSugerencias(val);
            if (val.isNotEmpty) {
              overlayController.show();
            } else {
              overlayController.hide();
            }
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "¿Qué buscas hoy?",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.15),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: () {
                controller.searchController.clear();
                controller.buscarSugerencias('');
                overlayController.hide();
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return [
        TextSpan(
          text: text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ];
    }
    final normalizedText = controller.normalize(text);
    final normalizedQuery = controller.normalize(query);
    final matchIndex = normalizedText.indexOf(normalizedQuery);

    if (matchIndex == -1) return [TextSpan(text: text)];

    return [
      TextSpan(text: text.substring(0, matchIndex)),
      TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: text.substring(matchIndex + query.length)),
    ];
  }

  Widget _buildFloorList() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [2, 1].map((i) {
        return Obx(() {
          bool sel = controller.pisoActual.value == i;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controller.pisoActual.value = i;
                  controller.resetZoom();
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? Colors.white : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: sel ? Colors.white : Colors.white24,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        color: sel ? Colors.orange : Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "PISO $i",
                        style: TextStyle(
                          color: sel ? Colors.orange : Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      if (sel)
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange,
                          size: 14,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildMissionBanner() {
    return Obx(() {
      if (controller.missionStep.value == 0) return const SizedBox.shrink();
      String msg = "";
      IconData icon = Icons.info;
      switch (controller.missionStep.value) {
        case 1:
          msg = "PASO 1: Selecciona un piso en el menú lateral.";
          icon = Icons.touch_app_rounded;
          break;
        case 2:
          msg = "PASO 2: Escribe qué sala estás buscando.";
          icon = Icons.search_rounded;
          break;
        case 3:
          msg = "PASO 3: Toca el punto indicado en el mapa.";
          icon = Icons.location_on_rounded;
          break;
        case 4:
          msg = "¡Excelente! Has completado el recorrido.";
          icon = Icons.stars_rounded;
          break;
      }
      return Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E26).withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.amber.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.amber, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white38, size: 20),
                onPressed: () => controller.cancelarTutorial(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHelpButton() {
    return InkWell(
      onTap: () => controller.iniciarTutorial(),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        ),
        child: const Center(
          child: Text(
            'AYUDA / TUTORIAL',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterBar() {
    final categorias = [
      "Información",
      "Cultura",
      "Estudio",
      "Alimentos",
      "Inclusión",
    ];
    return Positioned(
      top: 85,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: categorias
              .map(
                (cat) => Obx(() {
                  bool sel = controller.categoriaSeleccionada.value == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: sel,
                      onSelected: (_) => controller.setCategoria(cat),
                      backgroundColor: Colors.white.withOpacity(0.9),
                      selectedColor: Colors.cyan[800],
                      labelStyle: TextStyle(
                        color: sel ? Colors.white : Colors.cyan[900],
                        fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      pressElevation: 0,
                    ),
                  );
                }),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFloatingFloorIndicator() => Positioned(
    top: 25,
    left: 20,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Obx(
            () => Text(
              "NIVEL ${controller.pisoActual.value}",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.cyan[900],
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildFloatingMenuButton() {
    return Positioned(
      bottom: 30,
      left: 30,
      child: Obx(() {
        bool tutorialActivo =
            controller.missionStep.value > 0 &&
            controller.missionStep.value < 4;
        return Opacity(
          opacity: tutorialActivo ? 0.5 : 1.0,
          child: FloatingActionButton.extended(
            heroTag: 'menu_fab',
            backgroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: tutorialActivo
                ? null
                : () => controller.isMenuOpen.toggle(),
            label: Text(
              controller.isMenuOpen.value ? "CERRAR" : "EXPLORAR",
              style: TextStyle(
                color: tutorialActivo ? Colors.grey : Colors.cyan[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(
              controller.isMenuOpen.value
                  ? Icons.close
                  : Icons.menu_open_rounded,
              color: tutorialActivo ? Colors.grey : Colors.cyan[800],
            ),
          ),
        );
      }),
    );
  }
}

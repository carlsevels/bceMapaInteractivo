import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/presentation/home/controllers/home.controller.dart';
import 'package:mapa_interactivo/presentation/home/localWidgets/mapaPiso.dart';
import 'package:mapa_interactivo/presentation/screens.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key) {
    Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// --- CAPA DEL MAPA Y CONTROLES FLOTANTES ---
          Obx(
            () => AnimatedPadding(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
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
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
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
          const SizedBox(height: 10),
          _miniFab(Icons.fullscreen_exit, () => controller.resetZoom()),
          const SizedBox(height: 10),
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

  Widget _miniFab(IconData i, VoidCallback? call) => FloatingActionButton(
    heroTag: null,
    mini: true,
    elevation: call == null ? 0 : 4,
    backgroundColor: call == null ? Colors.grey[200] : Colors.white,
    onPressed: call,
    child: Icon(i, color: call == null ? Colors.grey : Colors.cyan[800]),
  );

  // --- MENÚ LATERAL Y TUTORIAL ---

  Widget _buildSideNavigation() {
    return Container(
      color: Colors.orange[600],
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BIBLIOTECA\nINTERACTIVA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 40),
          Obx(
            () => _tutorialHighlight(
              isActive: controller.missionStep.value == 2,
              child: _buildSearchSection(),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'SELECCIONA NIVEL',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Obx(
            () => _tutorialHighlight(
              isActive: controller.missionStep.value == 1,
              child: _buildFloorList(),
            ),
          ),
          const Spacer(),
          _buildHelpButton(),
        ],
      ),
    );
  }

  Widget _tutorialHighlight({required bool isActive, required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      padding: isActive ? const EdgeInsets.all(10) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.white : Colors.transparent,
          width: 4,
        ),
      ),
      child: child,
    );
  }

  Widget _buildSearchSection() {
    return Column(
      children: [
        TextField(
          controller: controller.searchController,
          onChanged: (v) => controller.buscarSugerencias(v),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "¿Qué buscas hoy?",
            hintStyle: const TextStyle(color: Colors.white60),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.white12,
            suffixIcon: Obx(
              () => controller.query.value.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.buscarSugerencias(
                          '',
                        ); // Limpia sugerencias y query
                      },
                    ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        Obx(
          () => controller.sugerencias.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: controller.sugerencias
                        .map(
                          (area) => ListTile(
                            leading: const Icon(
                              Icons.location_searching,
                              color: Colors.orange,
                            ),
                            title: Text(
                              area.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () =>
                                controller.seleccionarDesdeSugerencia(area),
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFloorList() {
    return Column(
      children: [2, 1]
          .map(
            (i) => Obx(() {
              bool sel = controller.pisoActual.value == i;
              return GestureDetector(
                onTap: () {
                  controller.pisoActual.value = i;
                  controller.resetZoom();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: sel ? Colors.white : Colors.white10,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: sel
                        ? [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.layers,
                        color: sel ? Colors.orange : Colors.white,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "PISO $i",
                        style: TextStyle(
                          color: sel ? Colors.orange : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (sel) const Spacer(),
                      if (sel)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.orange,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              );
            }),
          )
          .toList(),
    );
  }

  Widget _buildMissionBanner() {
    return Obx(() {
      if (controller.missionStep.value == 0) return const SizedBox.shrink();
      String msg = "";
      IconData icon = Icons.info;
      switch (controller.missionStep.value) {
        case 1:
          msg = "PASO 1: Presiona un botón de 'PISO' en el menú naranja.";
          icon = Icons.touch_app;
          break;
        case 2:
          msg = "PASO 2: Escribe el nombre de una sala en el buscador.";
          icon = Icons.keyboard;
          break;
        case 3:
          msg = "PASO 3: Toca el icono que parpadea en el mapa.";
          icon = Icons.ads_click;
          break;
        case 4:
          msg = "¡LO LOGRASTE! Ya sabes usar el mapa.";
          icon = Icons.celebration;
          break;
      }
      return Positioned(
        bottom: 110,
        left: 40,
        right: 40,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber, width: 2),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.amber, size: 30),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
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
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Center(
          child: Text(
            'AYUDA / TUTORIAL',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      top: 80,
      left: 20,
      right: 20,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categorias
              .map(
                (cat) => Obx(() {
                  bool isSelected =
                      controller.categoriaSeleccionada.value == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      selectedColor: Colors.cyan[700],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.cyan[900],
                      ),
                      onSelected: (bool value) => controller.setCategoria(cat),
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
    top: 20,
    left: 20,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Obx(
        () => Text(
          "PISO ${controller.pisoActual.value}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.cyan[900],
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
            onPressed: tutorialActivo
                ? null
                : () => controller.isMenuOpen.toggle(),
            label: Text(
              controller.isMenuOpen.value ? "CERRAR" : "MENÚ",
              style: TextStyle(
                color: tutorialActivo ? Colors.grey : Colors.cyan,
              ),
            ),
            icon: Icon(
              Icons.menu,
              color: tutorialActivo ? Colors.grey : Colors.cyan,
            ),
          ),
        );
      }),
    );
  }
}

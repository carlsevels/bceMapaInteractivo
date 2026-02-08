import 'dart:ui';
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          /// --- CAPA DEL MAPA ---
          Obx(
            () => AnimatedPadding(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              padding: EdgeInsets.only(
                left: controller.isMenuOpen.value ? 350 : 0,
                right: 0,
              ),
              child: Stack(
                children: [
                  MapaPiso(
                    key: ValueKey(controller.pisoActual.value),
                    image: 'assets/piso_${controller.pisoActual.value}.png',
                    areas: controller.pisos[controller.pisoActual.value] ?? [],
                    currentQuery: controller.query.value,
                    selectedCategory:
                        controller.categoriaSeleccionada.value,
                    missionStep: controller.missionStep.value,
                    onAreaTap: controller.onAreaSelected,
                    transformationController:
                        controller.transformationController,
                  ),
                  _buildCategoryFilterBar(),
                  _buildFloatingFloorIndicator(),
                  _buildFloatingMenuButton(),
                  _buildMissionBanner(),
                ],
              ),
            ),
          ),

          /// --- CONTROLES DE ZOOM ---
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutQuart,
              right: controller.isPanelOpen.value ? 465 : 20,
              bottom: 20,
              child: _buildZoomControls(),
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

          /// --- PANEL DE DETALLES (MAPA SE MUEVE DESDE AQUÍ) ---
          Obx(() {
            final isOpen = controller.isPanelOpen.value;
            final area = controller.visibleArea.value;

            if (area == null) return const SizedBox.shrink();

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutQuart,
              right: isOpen ? 25 : -500,
              top: 25,
              bottom: 25,
              width: 420,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (details) {
                  final tc = controller.transformationController;
                  final Matrix4 matrix = tc.value.clone(); // 🔑 CLAVE: clonar
                  final double scale = matrix.getMaxScaleOnAxis();

                  matrix.translate(
                    details.delta.dx / scale,
                    details.delta.dy / scale,
                  );

                  tc.value = matrix;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 35,
                        spreadRadius: 5,
                        offset: const Offset(-5, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: DetallesAreaScreen(area: area),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- WIDGETS DE APOYO ---

  Widget _buildZoomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => _miniFab(
              Icons.add,
              controller.zoomLevel.value >= controller.maxZoomClicks
                  ? null
                  : () => controller.zoomIn(),
            )),
        const SizedBox(height: 12),
        _miniFab(Icons.fullscreen_exit, () => controller.resetZoom()),
        const SizedBox(height: 12),
        Obx(() => _miniFab(
              Icons.remove,
              controller.zoomLevel.value <= -controller.maxZoomClicks
                  ? null
                  : () => controller.zoomOut(),
            )),
      ],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: call == null ? Colors.grey[100] : Colors.white,
          onPressed: call,
          child: Icon(i, color: call == null ? Colors.grey : Colors.cyan[800]),
        ),
      );

  Widget _buildSideNavigation() {
    return Container(
      width: 350,
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
                    const SizedBox(height: 12),
                    const Text(
                      "BCE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4),
                    ),
                    const Text(
                      "Biblioteca Central del Estado",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Obx(() => _tutorialHighlight(
                    isActive: controller.missionStep.value == 2,
                    child: _buildSearchSection(),
                  )),
              const SizedBox(height: 30),
              const Text(
                'SELECCIONA NIVEL',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              SizedBox(height: 180, child: _buildFloorList()),
              const SizedBox(height: 30),
              _buildHelpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return TextField(
      controller: controller.searchController,
      onChanged: (val) => controller.buscarSugerencias(val),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "¿Qué buscas?",
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildFloorList() {
    return Obx(() => ListView(
          padding: EdgeInsets.zero,
          children: [2, 1].map((i) {
            bool sel = controller.pisoActual.value == i;
            return GestureDetector(
              onTap: () => controller.pisoActual.value = i,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sel ? Colors.white : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "PISO $i",
                  style: TextStyle(
                      color: sel ? Colors.cyan[800] : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildCategoryFilterBar() {
    final categorias = ["Información", "Cultura", "Estudio", "Alimentos", "Inclusión"];
    return Positioned(
      top: 85,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: categorias.map((cat) => Obx(() {
                bool sel = controller.categoriaSeleccionada.value == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: sel,
                    onSelected: (_) => controller.setCategoria(cat),
                    selectedColor: Colors.cyan[800],
                    labelStyle: TextStyle(color: sel ? Colors.white : Colors.black87),
                  ),
                );
              })).toList(),
        ),
      ),
    );
  }

  Widget _buildFloatingFloorIndicator() => Positioned(
        top: 25,
        left: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(() => Text("NIVEL ${controller.pisoActual.value}",
              style: const TextStyle(fontWeight: FontWeight.bold))),
        ),
      );

  Widget _buildFloatingMenuButton() {
    return Positioned(
      bottom: 30,
      left: 30,
      child: Obx(() => FloatingActionButton.extended(
            heroTag: 'menu_fab',
            backgroundColor: Colors.white,
            onPressed: () => controller.isMenuOpen.toggle(),
            label: Text(controller.isMenuOpen.value ? "CERRAR" : "MENU",
                style: TextStyle(color: Colors.cyan[800], fontWeight: FontWeight.bold)),
            icon: Icon(controller.isMenuOpen.value ? Icons.close : Icons.menu, color: Colors.cyan[800]),
          )),
    );
  }

  Widget _buildMissionBanner() {
    return Obx(() {
      if (controller.missionStep.value == 0) return const SizedBox.shrink();
      return Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Paso ${controller.missionStep.value}: Sigue las instrucciones",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  Widget _buildHelpButton() {
    return OutlinedButton(
      onPressed: () => controller.iniciarTutorial(),
      style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24)),
      child: const Text("¿NECESITAS AYUDA?"),
    );
  }

  Widget _tutorialHighlight({required bool isActive, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isActive ? Colors.orange : Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}

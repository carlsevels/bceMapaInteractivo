import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mapa_interactivo/infrastructure/models/area.dart';
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
          /// MAPA + CONTENIDO CENTRAL
          Obx(
            () => AnimatedPadding(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: EdgeInsets.only(
                left: controller.isMenuOpen.value ? 350 : 0,
                right: controller.selectedArea.value != null ? 450 : 0,
              ),
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: MapaPiso(
                      key: ValueKey(controller.pisoActual.value),
                      image: 'assets/piso_${controller.pisoActual.value}.png',
                      areas: controller.pisos[controller.pisoActual.value] ?? [],
                      currentQuery: controller.query.value,
                      // 🔹 SE PASA LA CATEGORÍA PARA EL FILTRADO
                      selectedCategory: controller.categoriaSeleccionada.value,
                      missionStep: controller.missionStep.value,
                      onAreaTap: controller.onAreaSelected,
                      transformationController: controller.transformationController,
                    ),
                  ),

                  // 🔹 BARRA DE FILTROS POR CATEGORÍA
                  _buildCategoryFilterBar(),
                  
                  _buildFloatingFloorIndicator(),
                  _buildFloatingMenuButton(),
                  _buildZoomControls(),

                  Obx(
                    () => controller.missionStep.value > 0
                        ? _buildMissionBanner()
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),

          /// MENU IZQUIERDO
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              left: controller.isMenuOpen.value ? 0 : -350,
              top: 0,
              bottom: 0,
              width: 350,
              child: _buildSideNavigation(context),
            ),
          ),

          /// PANEL DERECHO
          Obx(() => _buildRightDetailPanel()),
        ],
      ),
    );
  }

  // 🔹 NUEVO MÉTODO: Barra de filtros horizontal
  Widget _buildCategoryFilterBar() {
    final categorias = ["Información", "Cultura", "Estudio", "Alimentos", "Tecnología", "Infantil"];
    
    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categorias.map((cat) => Obx(() {
                bool isSelected = controller.categoriaSeleccionada.value == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(cat),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    selectedColor: Colors.cyan[700],
                    backgroundColor: Colors.white.withOpacity(0.95),
                    checkmarkColor: Colors.white,
                    elevation: 4,
                    onSelected: (bool value) {
                      controller.setCategoria(cat);
                    },
                  ),
                );
              })).toList(),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _zoomButton(
            icon: Icons.add,
            tooltip: "Aumentar Zoom",
            onPressed: () => controller.zoomIn(),
          ),
          const SizedBox(height: 12),
          _zoomButton(
            icon: Icons.fullscreen_exit,
            tooltip: "Restaurar vista",
            onPressed: () => controller.resetZoom(),
          ),
          const SizedBox(height: 12),
          _zoomButton(
            icon: Icons.remove,
            tooltip: "Disminuir Zoom",
            onPressed: () => controller.zoomOut(),
          ),
        ],
      ),
    );
  }

  Widget _zoomButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      backgroundColor: Colors.white,
      elevation: 6,
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon, color: Colors.cyan[800], size: 22),
    );
  }

  Widget _buildRightDetailPanel() {
    final Area? area = controller.visibleArea.value;

    return Obx(
      () => AnimatedPositioned(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        right: controller.isPanelOpen.value ? 0 : -450,
        top: 0,
        bottom: 0,
        width: 450,
        child: IgnorePointer(
          ignoring: !controller.isPanelOpen.value,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.isPanelOpen.value ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(-5, 0),
                  ),
                ],
              ),
              child: area == null
                  ? const SizedBox.shrink()
                  : DetallesAreaScreen(area: area),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingFloorIndicator() {
    return Positioned(
      top: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Obx(
          () => Row(
            children: [
              Icon(Icons.explore_rounded, color: Colors.cyan[700], size: 22),
              const SizedBox(width: 10),
              Text(
                "PISO ${controller.pisoActual.value}",
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingMenuButton() {
    return Positioned(
      bottom: 30,
      left: 30,
      child: Obx(() {
        final locked = controller.missionStep.value > 0;

        return FloatingActionButton.extended(
          heroTag: "btnMenu",
          elevation: 8,
          backgroundColor: locked
              ? Colors.grey[800]
              : controller.isMenuOpen.value
              ? Colors.white
              : Colors.cyan,
          onPressed: () => _handleMenuToggle(locked),
          label: Text(
            controller.isMenuOpen.value ? "OCULTAR MENÚ" : "MOSTRAR MENÚ",
            style: TextStyle(
              color: locked
                  ? Colors.white38
                  : controller.isMenuOpen.value
                  ? Colors.cyan
                  : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(
            controller.isMenuOpen.value
                ? Icons.close_fullscreen
                : Icons.menu_open,
            color: locked
                ? Colors.white38
                : controller.isMenuOpen.value
                ? Colors.cyan
                : Colors.white,
          ),
        );
      }),
    );
  }

  void _handleMenuToggle(bool locked) {
    if (locked) {
      Get.snackbar(
        "¡Tutorial en curso!",
        "Finaliza el recorrido para cerrar el menú.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[700],
      );
    } else {
      controller.isMenuOpen.value = !controller.isMenuOpen.value;
    }
  }

  Widget _buildSideNavigation(BuildContext context) {
    return Container(
      color: Colors.orange[600],
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BIBLIOTECA\nINTERACTIVA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                height: 1.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Obx(() => _highlightArea(
                  active: controller.missionStep.value == 2,
                  child: _buildHugeSearch(),
                )),
            const SizedBox(height: 50),
            const Text(
              'SELECCIONA NIVEL',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => _highlightArea(
                  active: controller.missionStep.value == 1,
                  child: _buildFloorList(),
                )),
            const SizedBox(height: 30),
            _buildHelpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHugeSearch() {
    return Column(
      children: [
        TextField(
          controller: controller.searchController,
          onChanged: (value) {
            controller.query.value = value;
            controller.buscarSugerencias(value);
          },
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            hintText: '¿Qué buscas hoy?',
            hintStyle: const TextStyle(color: Colors.white60),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        Obx(() => controller.sugerencias.isEmpty
            ? const SizedBox.shrink()
            : Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: controller.sugerencias.map((area) {
                    return ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(area.nombre),
                      onTap: () => controller.seleccionarDesdeSugerencia(area),
                    );
                  }).toList(),
                ),
              )),
      ],
    );
  }

  Widget _buildFloorList() {
    return Column(
      children: [2, 1].map((i) {
        final sel = controller.pisoActual.value == i;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              controller.pisoActual.value = i;
              controller.query.value = '';
              controller.searchController.clear();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: sel ? Colors.white : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(i == 1 ? Icons.filter_1 : Icons.filter_2,
                      color: sel ? Colors.orange[600] : Colors.white),
                  const SizedBox(width: 15),
                  Text('PISO $i',
                      style: TextStyle(
                        color: sel ? Colors.orange[600] : Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _highlightArea({required bool active, required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: active ? const EdgeInsets.all(10) : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: active ? Colors.white.withOpacity(0.2) : Colors.transparent,
      ),
      child: child,
    );
  }

  Widget _buildMissionBanner() {
    String msg = "";
    if (controller.missionStep.value == 1) msg = "Dime en qué piso estás.";
    else if (controller.missionStep.value == 2) msg = "Escribe el área en el buscador.";
    else if (controller.missionStep.value == 3) msg = "Toca el marcador para ver los detalles.";

    return Positioned(
      bottom: 110,
      left: 100,
      right: 100,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildHelpButton() {
    return InkWell(
      onTap: () {
        controller.isMenuOpen.value = true;
        controller.missionStep.value = 1;
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white54, width: 2),
        ),
        child: const Center(child: Text('AYUDA / TUTORIAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    );
  }
}
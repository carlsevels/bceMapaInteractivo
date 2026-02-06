import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapa_interactivo/infrastructure/models/area.dart';
import 'package:mapa_interactivo/presentation/home/controllers/home.controller.dart';
import 'package:mapa_interactivo/presentation/home/localWidgets/mapaPiso.dart';
import 'package:mapa_interactivo/presentation/screens.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: controller.isMenuOpen.value ? 350 : 0,
              child: _buildSideNavigation(context),
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Obx(
                        () => MapaPiso(
                          image:
                              'assets/piso_${controller.pisoActual.value}.png',
                          areas:
                              controller.pisos[controller.pisoActual.value] ??
                                  [],
                          currentQuery: controller.query.value,
                          missionStep: controller.missionStep.value,
                          onAreaTap: controller.onAreaSelected,
                        ),
                      ),
                      _buildFloatingFloorIndicator(),
                      _buildFloatingMenuButton(),
                      Obx(
                        () => controller.missionStep.value > 0
                            ? _buildMissionBanner()
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                Obx(() => _buildRightDetailPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PANEL DERECHO ----------------

  Widget _buildRightDetailPanel() {
    if (controller.selectedArea.value == null) {
      return const SizedBox.shrink();
    }

    final Area areaSeleccionada = controller.selectedArea.value!;

    return Container(
      width: 450,
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
      child: DetallesAreaScreen(area: areaSeleccionada),
    );
  }

  // ---------------- FLOATING ----------------

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
        final bool locked = controller.missionStep.value > 0;
        return FloatingActionButton.extended(
          elevation: 8,
          backgroundColor: locked
              ? Colors.grey[800]
              : (controller.isMenuOpen.value ? Colors.white : Colors.cyan),
          onPressed: () => _handleMenuToggle(locked),
          label: Text(
            controller.isMenuOpen.value ? "OCULTAR MENÚ" : "MOSTRAR MENÚ",
            style: TextStyle(
              color: locked
                  ? Colors.white38
                  : (controller.isMenuOpen.value ? Colors.cyan : Colors.white),
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(
            controller.isMenuOpen.value
                ? Icons.close_fullscreen
                : Icons.menu_open,
            color: locked
                ? Colors.white38
                : (controller.isMenuOpen.value ? Colors.cyan : Colors.white),
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
        mainButton: TextButton(
          onPressed: () {
            controller.missionStep.value = 0;
            if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
          },
          child: const Text(
            "SALIR",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      controller.isMenuOpen.value = !controller.isMenuOpen.value;
    }
  }

  // ---------------- SIDE NAV ----------------

  Widget _buildSideNavigation(BuildContext context) {
    return Container(
      height: Get.size.height,
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

            Obx(
              () => _highlightArea(
                active: controller.missionStep.value == 2,
                child: _buildHugeSearch(),
              ),
            ),

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

            Obx(
              () => _highlightArea(
                active: controller.missionStep.value == 1,
                child: _buildFloorList(),
              ),
            ),

            const SizedBox(height: 30),
            _buildHelpButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- SEARCH + SUGERENCIAS ----------------

  Widget _buildHugeSearch() {
    return Column(
      children: [
        TextField(
          controller: controller.searchController,
          onChanged: (value) {
            controller.query.value = value;
            controller.buscarSugerencias(value);

            if (controller.missionStep.value == 2 && value.length >= 3) {
              controller.missionStep.value = 3;
            }
          },
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            hintText: '¿Qué buscas hoy?',
            hintStyle: const TextStyle(color: Colors.white60),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.white),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
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
                        subtitle: Text('Piso ${area.piso}'),
                        onTap: () =>
                            controller.seleccionarDesdeSugerencia(area),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  // ---------------- FLOORS ----------------

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
              controller.sugerencias.clear();
              if (controller.missionStep.value == 1) {
                controller.missionStep.value = 2;
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: sel ? Colors.white : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: sel ? Colors.white : Colors.white24,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    i == 1 ? Icons.filter_1 : Icons.filter_2,
                    color: sel ? Colors.orange[600] : Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'PISO $i',
                    style: TextStyle(
                      color: sel ? Colors.orange[600] : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (sel)
                    Icon(Icons.check_circle, color: Colors.orange[600]),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------- EXTRAS ----------------

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

    if (controller.missionStep.value == 1) {
      msg = "¡Hola! Para empezar, dime en qué piso estás.";
    }
    if (controller.missionStep.value == 2) {
      msg = "¿Qué área buscas? Escríbela en el buscador.";
    }
    if (controller.missionStep.value == 3) {
      msg = "¡Ya casi! Toca el marcador en el mapa para ver los detalles.";
    }

    return Positioned(
      bottom: 40,
      left: controller.isMenuOpen.value ? 380 : 150,
      right: 50,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        color: Colors.amber[400],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.black87, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.missionStep.value = 0,
                icon: const Icon(Icons.cancel, color: Colors.black54),
              ),
            ],
          ),
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'AYUDA / TUTORIAL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

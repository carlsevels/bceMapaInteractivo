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
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => AnimatedPadding(
                duration: const Duration(milliseconds: 50),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  left: controller.menuWidth.value,
                  right: 0,
                ),
                child: Stack(
                  children: [
                    MapaPiso(
                      key: ValueKey(controller.pisoActual.value),
                      image: 'piso_${controller.pisoActual.value}.png',
                      areas:
                          controller.pisos[controller.pisoActual.value] ?? [],
                      currentQuery: controller.query.value,
                      selectedCategory: controller.categoriaSeleccionada.value,
                      missionStep: controller.missionStep.value,
                      onAreaTap: controller.onAreaSelected,
                      transformationController:
                          controller.transformationController,
                      paddingRight: controller.isPanelOpen.value ? 495 : 60,
                      paddingTop: 150,
                    ),
                    _buildCategoryFilterBar(isMobile),
                    _buildFloatingFloorIndicator(isMobile),
                    _buildFloatingMenuButton(),
                  ],
                ),
              ),
            ),

            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutQuart,
                right: controller.isPanelOpen.value ? 465 : 20,
                bottom: isMobile ? 100 : 20,
                child: _buildZoomControls(),
              ),
            ),

            _buildSideNavigation(context),

            Obx(() {
              final isOpen = controller.isPanelOpen.value;
              final area = controller.visibleArea.value;
              if (area == null) return const SizedBox.shrink();

              if (isMobile) {
                // Si es móvil y el panel debería estar abierto, disparamos el BottomSheet
                if (isOpen) {
                  Future.microtask(() {
                    Get.bottomSheet(
                      // Contenedor de pantalla completa
                      Container(
                        height: Get.height,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: DetallesAreaScreen(area: area),
                      ),
                      isScrollControlled: true, // Permite pantalla completa
                      ignoreSafeArea: false,
                      enableDrag: true,
                    ).then((_) {
                      // Al cerrar el BottomSheet, sincronizamos el estado del controlador
                      controller.isPanelOpen.value = false;
                      controller.visibleArea.value = null;
                    });
                  });
                }
                return const SizedBox.shrink();
              }

              // Mantenemos tu diseño original para Desktop/Web
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutQuart,
                right: isOpen ? 25 : -500,
                top: 25,
                bottom: 25,
                width: 420,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final tc = controller.transformationController;
                    final matrix = tc.value.clone();
                    final scale = matrix.getMaxScaleOnAxis();

                    matrix.translate(
                      details.delta.dx / scale,
                      details.delta.dy / scale,
                    );

                    tc.value = matrix;
                  },
                  behavior: HitTestBehavior.translucent,
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

            /// --- 5. BANNER DE MISIÓN ---
            _buildMissionBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Column(
      children: [
        Obx(
          () => miniFab(
            Icons.add,
            controller.zoomLevel.value >= controller.maxZoomClicks
                ? null
                : () => controller.zoomIn(),
          ),
        ),
        const SizedBox(height: 12),
        miniFab(Icons.fullscreen_exit, () => controller.resetZoom()),
        const SizedBox(height: 12),
        Obx(
          () => miniFab(
            Icons.remove,
            controller.zoomLevel.value <= -controller.maxZoomClicks
                ? null
                : () => controller.zoomOut(),
          ),
        ),
      ],
    );
  }

  Widget _buildSideNavigation(BuildContext context) {
    return Obx(() {
      double currentWidth = controller.menuWidth.value;
      bool isMini = currentWidth < 160;
      bool isClosed = currentWidth < 10;
      bool isMobile = MediaQuery.of(context).size.width < 600;

      // --- LÓGICA PARA MÓVIL (BARRA INFERIOR) ---
      if (isMobile) {
        // Forzamos el ancho a 0 para que no estorbe al mapa
        if (currentWidth != 0) {
          Future.microtask(() => controller.menuWidth.value = 0);
        }

        return Stack(
          children: [
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Ayuda
                    IconButton(
                      icon: const Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () => controller.iniciarTutorial(),
                    ),
                    // Buscar
                    _tutorialHighlight(
                      isActive: controller.missionStep.value == 2,
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: () => _showSearchDialog(),
                      ),
                    ),
                    // Separador visual opcional o espacio
                    const SizedBox(width: 10),
                    // Selector de Pisos
                    _tutorialHighlight(
                      isActive: controller.missionStep.value == 1,
                      child: Row(
                        children: [
                          _buildMobileFloorButton("P1", 1),
                          const SizedBox(width: 10),
                          _buildMobileFloorButton("P2", 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      // --- LÓGICA PARA DESKTOP (MENU LATERAL) ---
      return AnimatedContainer(
        duration: Duration(milliseconds: controller.isDragging.value ? 0 : 250),
        curve: Curves.easeInOut,
        width: currentWidth,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.cyan,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
            child: Column(
              children: [
                // Header/Logo
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMini ? 8 : 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(isMini ? 12 : 22),
                        ),
                        child: Image.asset(
                          "assets/logos/bce2.png",
                          width: isMini ? 40 : 110,
                        ),
                      ),
                      if (!isMini) ...[
                        const SizedBox(height: 12),
                        const Text(
                          "BCE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Buscador
                _tutorialHighlight(
                  isActive: controller.missionStep.value == 2,
                  child: isMini
                      ? _buildMiniCircleButton(
                          Icons.search,
                          () => _showSearchDialog(),
                        )
                      : _buildSearchSection(),
                ),
                const SizedBox(height: 25),
                // Lista de Pisos
                Expanded(child: _buildFloorList(isMini)),
                const SizedBox(height: 20),
                // Ayuda
                _buildMiniCircleButton(
                  Icons.help_outline,
                  () => controller.iniciarTutorial(),
                ),
                const SizedBox(height: 15),
                // Flecha para cerrar (Abajo)
                if (!isClosed)
                  Center(
                    child: IconButton(
                      icon: Icon(
                        isMini ? Icons.chevron_right : Icons.chevron_left,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          controller.menuWidth.value = isMini ? 320 : 80,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMobileFloorButton(String label, int floorValue) {
    return Obx(() {
      bool isSelected = controller.pisoActual.value == floorValue;
      return GestureDetector(
        onTap: () => controller.pisoActual.value = floorValue,
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.cyan : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMiniCircleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // DIÁLOGO PARA BÚSQUEDA CENTRAL
  void _showSearchDialog() {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.cyan[800],
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 20),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Buscador",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSearchSection(),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- MODIFICADO PARA SOPORTAR P1 / PISO 1 ---
  Widget _buildFloorList(bool isMini) {
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isMini ? 5 : 20,
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
                    mainAxisAlignment: isMini
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        color: sel ? Colors.orange : Colors.white,
                        size: isMini ? 18 : 22,
                      ),
                      if (!isMini) const SizedBox(width: 15),
                      Text(
                        isMini ? "P$i" : "PISO $i",
                        style: TextStyle(
                          color: sel ? Colors.orange : Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: isMini ? 12 : 16,
                        ),
                      ),
                      if (!isMini && sel) ...[
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange,
                          size: 14,
                        ),
                      ],
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
            offset: const Offset(0, 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 15,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 306,
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
                                    overlayController.hide();
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

  Widget _buildCategoryFilterBar(isMobile) {
    final categorias = [
      "Información",
      "Cultura",
      "Estudio",
      "Alimentos",
      "Inclusión",
    ];
    return Positioned(
      top: isMobile ? 70 : 60,
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
                    ),
                  );
                }),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFloatingFloorIndicator(isMobil) => Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
    child: Positioned(
      child: Row(
        mainAxisAlignment: isMobil
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          isMobil
              ? SizedBox(width: 50, child: Image.asset("logos/bce2.png"))
              : SizedBox.shrink(),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Obx(
                  () => Text(
                    "PISO ${controller.pisoActual.value}",
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
        ],
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

        double currentWidth = controller.menuWidth.value;

        bool isFull = currentWidth > 200;
        bool isMini = currentWidth >= 10 && currentWidth <= 200;
        bool isClosed = currentWidth < 10;

        return Opacity(
          opacity: tutorialActivo ? 0.5 : 1.0,
          child: FloatingActionButton.extended(
            heroTag: 'menu_fab',
            backgroundColor: Colors.cyan,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: tutorialActivo
                ? null
                : () {
                    if (isClosed) {
                      controller.menuWidth.value = 320;
                      controller.isMenuOpen.value = true;
                    } else if (isFull) {
                      controller.menuWidth.value = 80;
                      controller.isMenuOpen.value = true;
                    } else {
                      controller.menuWidth.value = 0;
                      controller.isMenuOpen.value = false;
                    }
                  },
            label: Text(
              isFull ? "MINIMIZAR" : (isMini ? "CERRAR" : "EXPLORAR"),
              style: TextStyle(
                color: tutorialActivo ? Colors.white : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(
              isClosed
                  ? Icons.menu_open_rounded
                  : (isFull ? Icons.unfold_less_rounded : Icons.close),
              color: tutorialActivo ? Colors.white : Colors.white,
            ),
          ),
        );
      }),
    );
  }
}

Widget miniFab(IconData i, VoidCallback? call) => Container(
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

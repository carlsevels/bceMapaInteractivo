import 'dart:ui';

import 'package:flutter/material.dart';

class GaleriaScreen extends StatefulWidget {
  final List<String> imagenes;
  final int initialIndex;
  final String title;

  const GaleriaScreen({
    super.key,
    required this.imagenes,
    required this.initialIndex,
    required this.title,
  });

  @override
  State<GaleriaScreen> createState() => _GaleriaAvanzadaScreenState();
}

class _GaleriaAvanzadaScreenState extends State<GaleriaScreen> {
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

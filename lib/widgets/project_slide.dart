import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math; // <-- Importar 'dart:math' con alias 'math'

/// Soporte de drag con mouse en Desktop/Web (para arrastrar con el mouse):
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown,
      };
}

/// Modelo de datos para cada slide
class SlideData {
  final double slideWidth; // Ancho de este slide en píxeles
  final String type; // "sub" o "normal"
  final String image;
  final String title;
  final String subtitle;

  SlideData({
    required this.slideWidth,
    required this.type,
    required this.image,
    this.title = '',
    this.subtitle = '',
  });
}

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({Key? key}) : super(key: key);

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  // Lista base con sub-slides y slides normales
  final List<SlideData> baseSlides = [
    SlideData(
        slideWidth: 280,
        type: 'sub',
        image: 'assets/images/project1.png',
        title: 'DARK',
        subtitle: 'Soluciones para todas las plataformas'),
    SlideData(
      slideWidth: 350,
      type: 'normal',
      image: 'assets/images/project4.png',
    ),
    SlideData(
      slideWidth: 320,
      type: 'sub',
      image: 'assets/images/project2.png',
      title: 'MATTER',
      subtitle: 'Rendimiento Optimo',
    ),
    SlideData(
      slideWidth: 200,
      type: 'normal',
      image: 'assets/images/project5.png',
    ),
    SlideData(
      slideWidth: 300,
      type: 'sub',
      image: 'assets/images/project3.png',
      title: 'Code',
      subtitle: 'Eficiencia y Innovación',
    ),
    SlideData(
      slideWidth: 280,
      type: 'normal',
      image: 'assets/images/project6.png',
    ),
  ];

  // Ajustes del carrusel
  static const double carouselHeight = 400;
  static const double separation = 10; // Mayor separación horizontal
  static const int loopCount = 5; // Replicamos 5 veces => falso infinito
  static const double scrollSpeed = 1; // Velocidad del desplazamiento continuo

  final ScrollController _scrollController = ScrollController();
  Timer? _continuousTimer;

  late List<SlideData> _infiniteSlides;
  bool _userIsDragging =
      false; // Para pausar el auto-scroll mientras se arrastra

  @override
  void initState() {
    super.initState();
    _buildInfiniteSlides();
    _startContinuousScroll();
  }

  @override
  void dispose() {
    _continuousTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  /// Replicamos la lista base loopCount veces => “falso infinito”
  void _buildInfiniteSlides() {
    _infiniteSlides = [];
    for (int i = 0; i < loopCount; i++) {
      _infiniteSlides.addAll(baseSlides);
    }
  }

  /// Scroll continuo y sutil: avanza un poco el offset cada ~16ms (60fps)
  void _startContinuousScroll() {
    _continuousTimer?.cancel();
    _continuousTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_userIsDragging) {
        final newOffset = _scrollController.offset + scrollSpeed;
        _scrollController.jumpTo(newOffset);
        _maybeLoopResetByOffset(newOffset);
      }
    });
  }

  /// Si superamos el final => saltamos al medio
  void _maybeLoopResetByOffset(double offset) {
    final totalWidth = _calculateTotalWidthOf(_infiniteSlides);
    // Un “margen de seguridad” para reiniciar
    if (offset > totalWidth * 0.8) {
      // saltamos al medio
      final halfOffset = totalWidth * 0.4;
      _scrollController.jumpTo(halfOffset);
    }
  }

  /// Calcula el ancho total de todos los slides + separaciones
  /// (menos la última separación para no pasarnos).
  double _calculateTotalWidthOf(List<SlideData> slides) {
    double total = 0;
    for (int i = 0; i < slides.length; i++) {
      total += slides[i].slideWidth;
      if (i < slides.length - 1) {
        total += separation;
      }
    }
    return total;
  }

  /// Detectamos cuando el usuario empieza a arrastrar => pausar auto‐scroll
  /// y cuando suelta => retomar auto‐scroll + snap
  void _onPointerDown() {
    _userIsDragging = true;
  }

  void _onPointerUp() {
    _userIsDragging = false;
    _snapToClosestSlide();
  }

  /// Al soltar => snapping
  void _snapToClosestSlide() {
    final pos = _scrollController.offset;
    double bestDist = double.infinity;
    double bestCenter = 0;

    // Recorremos cada slide para encontrar el “centro” más cercano
    double offset = 0;
    for (int i = 0; i < _infiniteSlides.length; i++) {
      final slideWidth = _infiniteSlides[i].slideWidth;
      final center = offset + (slideWidth / 2);
      final dist = (center - pos).abs();
      if (dist < bestDist) {
        bestDist = dist;
        bestCenter = center;
      }
      offset += slideWidth + separation;
    }
    final targetOffset = math.max(
      0.0, // <-- usa 0.0 en vez de 0
      bestCenter - (carouselHeight / 2),
    );
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool toggle = false; // Alternador local
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      // Soporte de arrastre con mouse en Desktop/Web
      behavior: CustomScrollBehavior(),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Nuestros proyectos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: carouselHeight,
              child: Listener(
                // Detectamos cuando inicia y termina el arrastre
                onPointerDown: (_) => _onPointerDown(),
                onPointerUp: (_) => _onPointerUp(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_infiniteSlides.length, (index) {
                      final slide = _infiniteSlides[index];

                      return Container(
                        width: slide.slideWidth,
                        height: carouselHeight,
                        margin: EdgeInsets.only(right: separation),
                        color: Colors.transparent,
                        child: (slide.type == 'sub')
                            ? _buildSubSlide(slide, carouselHeight, toggle)
                            : _buildNormalSlide(slide),
                      );
                    }),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Footer
            Column(
              children: [
                const Text(
                  '¿Estás interesado en ver más proyectos?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // tu acción
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'VER TODOS',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Sub-slide con borde menor (5) y sin margenes verticales extra
  Widget _buildSubSlide(
      SlideData slide, double carouselHeight, bool isReversed) {
    List<Widget> columnChildren = [
      // Caja de texto
      Padding(
        padding: EdgeInsets.only(
            bottom: isReversed ? 0 : carouselHeight * 0.02,
            top: !isReversed ? 0 : carouselHeight * 0.02),
        child: Container(
          height: carouselHeight * 0.33,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(5), // borde menor
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),

      // Imagen, ocupa el resto
      if (slide.image.isNotEmpty)
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(slide.image, fit: BoxFit.cover),
            ),
          ),
        )
      else
        Expanded(
          child: Center(
            child: Text(
              'No Image',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
    ];
    toggle = !toggle;
    return Container(
      color: Colors.transparent,
      child: Column(
        children:
            isReversed ? columnChildren.reversed.toList() : columnChildren,
      ),
    );
  }

  /// Slide normal, sin margenes verticales y menor borde
  Widget _buildNormalSlide(SlideData slide) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5), // borde menor
      child: (slide.image.isNotEmpty)
          ? Image.asset(slide.image, fit: BoxFit.cover)
          : const Center(
              child: Text('No Image', style: TextStyle(color: Colors.white))),
    );
  }

  // (Opcional) Flechas => No se detiene, así que no es muy útil
  void _goToPreviousPage() {
    final newOffset = _scrollController.offset - 100; // retrocede 100 px
    if (newOffset < 0) return;
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextPage() {
    final newOffset = _scrollController.offset + 100;
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

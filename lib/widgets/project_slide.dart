import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Soporte de drag con mouse en Desktop/Web:
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

/// Representa cada "slide" en el carrusel:
class SlideData {
  final double slideWidth;
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
  /// Lista base (sub-slides + normales con anchos distintos).
  final List<SlideData> baseSlides = [
    SlideData(
      slideWidth: 280,
      type: 'sub',
      image: 'assets/images/project1.png',
      title: 'Sub #1',
      subtitle: 'Soluciones',
    ),
    SlideData(
      slideWidth: 350,
      type: 'normal',
      image: 'assets/images/project4.png',
    ),
    SlideData(
      slideWidth: 320,
      type: 'sub',
      image: 'assets/images/project2.png',
      title: 'Sub #2',
      subtitle: 'Innovación',
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
      title: 'Sub #3',
      subtitle: 'Eficiencia',
    ),
    SlideData(
      slideWidth: 280,
      type: 'normal',
      image: 'assets/images/project6.png',
    ),
  ];

  // Ajustes del carrusel
  static const double carouselHeight = 400;
  static const double minSeparation = 10; // MÁS separación entre slides
  // Aumentamos loopCount para que el salto final ocurra menos frecuentemente
  static const int loopCount = 5;
  final Duration autoPlayInterval = const Duration(seconds: 5);

  final ScrollController _scrollController = ScrollController();
  Timer? _autoPlayTimer;

  late List<SlideData> _infiniteSlides;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _buildInfiniteSlides();
    _startAutoPlay();
  }

  /// Replicamos la lista base 'loopCount' veces => "falso infinito"
  void _buildInfiniteSlides() {
    _infiniteSlides = [];
    for (int i = 0; i < loopCount; i++) {
      _infiniteSlides.addAll(baseSlides);
    }
  }

  /// Arranque de auto-play cada 5s
  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(autoPlayInterval, (_) {
      _goToNext();
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  /// Avanza al siguiente índice virtual
  void _goToNext() {
    setState(() => _currentIndex++);
    _snapToIndex(_currentIndex);
  }

  /// Anima el scroll al offset del slide [index]
  Future<void> _snapToIndex(int index) async {
    final targetOffset = _calculateItemOffset(index);
    await _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    _maybeLoopReset(index);
  }

  /// Si estamos cerca del final => saltamos al medio
  void _maybeLoopReset(int index) {
    final total = _infiniteSlides.length;
    final baseLen = baseSlides.length;
    if (index > total - baseLen) {
      final midStart = baseLen * (loopCount ~/ 2);
      final newIndex = midStart + (index % baseLen);
      _currentIndex = newIndex;
      final newOffset = _calculateItemOffset(newIndex);
      _scrollController.jumpTo(newOffset);
    }
  }

  /// Calcula offset sumando (slideWidth + minSeparation) para cada item previo
  double _calculateItemOffset(int index) {
    double offset = 0;
    for (int i = 0; i < index; i++) {
      offset += _infiniteSlides[i].slideWidth + minSeparation;
    }
    return offset;
  }

  /// Cuando se suelta el drag => calculamos el item más cercano
  void _onPanEnd() {
    final pos = _scrollController.offset;
    double bestDist = double.infinity;
    int bestIndex = 0;
    for (int i = 0; i < _infiniteSlides.length; i++) {
      final center =
          _calculateItemOffset(i) + (_infiniteSlides[i].slideWidth / 2);
      final dist = (center - pos).abs();
      if (dist < bestDist) {
        bestDist = dist;
        bestIndex = i;
      }
    }
    _currentIndex = bestIndex;
    _snapToIndex(bestIndex);
  }

  // =========================
  // Construcción principal
  // =========================
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      // 1) Habilitamos drag con mouse en Desktop/Web
      behavior: CustomScrollBehavior(),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título
            const Text(
              'Nuestros proyectos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Carrusel (SingleChildScrollView + Row)
            SizedBox(
              height: carouselHeight,
              child: Listener(
                onPointerUp: (_) => _onPanEnd(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_infiniteSlides.length, (index) {
                      final slide = _infiniteSlides[index];
                      return Container(
                        width: slide.slideWidth,
                        height: carouselHeight,
                        // mayor separación horizontal
                        margin: EdgeInsets.only(right: minSeparation),
                        color: Colors.transparent,
                        child: (slide.type == 'sub')
                            ? _buildSubSlide(slide)
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

  /// Sub-slide: texto + imagen con el mismo ancho
  Widget _buildSubSlide(SlideData slide) {
    // Para que la caja de texto y la imagen tengan el mismo ancho,
    // definimos Column con "width: double.infinity" => heredado del parent.
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          // Caja con título/subtítulo
          Container(
            width: double.infinity, // Mismo ancho que el "slideWidth"
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 22, // un poco más grande
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  slide.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16, // un poco más grande
                  ),
                ),
              ],
            ),
          ),

          // Imagen a full ancho
          if (slide.image.isNotEmpty)
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(slide.image, fit: BoxFit.cover),
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text('No Image', style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  /// Slide normal, ocupa todo el ancho y alto
  Widget _buildNormalSlide(SlideData slide) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: (slide.image.isNotEmpty)
          ? Image.asset(slide.image, fit: BoxFit.cover)
          : const Center(
              child: Text('No Image', style: TextStyle(color: Colors.white))),
    );
  }

  // Métodos de flechas (opcionales) si quieres
  void _goToPreviousPage() {
    setState(() {
      _currentIndex--;
      if (_currentIndex < 0) _currentIndex = 0;
    });
    _snapToIndex(_currentIndex);
  }

  void _goToNextPage() {
    setState(() => _currentIndex++);
    _snapToIndex(_currentIndex);
  }
}

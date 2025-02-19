import 'dart:async';
import 'package:dark_matter_page/lenguaje/localization.dart';
import 'package:dark_matter_page/widgets/view_project.dart';
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
  final List<String> relatedImages; // Imágenes relacionadas
  final String description; // Descripción del proyecto
  final double imageOpacity; // Opacidad de la imagen

  SlideData({
    required this.slideWidth,
    required this.type,
    required this.image,
    this.title = '',
    this.subtitle = '',
    this.relatedImages = const [],
    this.description = '',
    this.imageOpacity = 1.0, // Valor predeterminado de opacidad
  });
}

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({Key? key}) : super(key: key);

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  late List<SlideData> baseSlides;

  // Lista base con sub-slides y slides normales
  List<SlideData> _buildBaseSlides(BuildContext context) {
    final localizedStrings = AppLocalizations.of(context);
    return [
      SlideData(
          slideWidth: 280,
          type: 'sub',
          image: 'assets/images/matter.png',
          title: localizedStrings.translate('dark_title'),
          subtitle: localizedStrings.translate('dark_subtitle'),
          imageOpacity: 0.3),
      SlideData(
        slideWidth: 350,
        type: 'normal',
        title: "Pickup Workshop",
        description: localizedStrings.translate('pickup_corto'),
        subtitle: localizedStrings.translate('pickup_sub'),
        image: 'assets/images/pp0.png',
        relatedImages: [
          'assets/images/p00.png',
          'assets/images/p1.jpg',
          'assets/images/p2.jpg',
          'assets/images/p3.jpg',
          'assets/images/p4.jpg',
          'assets/images/p5.jpg',
          'assets/images/p6.jpg',
        ],
        imageOpacity: 0.1,
      ),
      SlideData(
        slideWidth: 320,
        type: 'sub',
        image: 'assets/images/dark.png',
        title: localizedStrings.translate('matter_title'),
        subtitle: localizedStrings.translate('matter_subtitle'),
        imageOpacity: 0.1,
      ),
      SlideData(
        slideWidth: 250,
        title: "Rodríguez Luna Import",
        type: 'normal',
        image: 'assets/images/luna.png',
        relatedImages: [
          'assets/images/l0.jpg',
          'assets/images/l1.jpg',
          'assets/images/l2.jpg',
          'assets/images/l3.jpg',
          'assets/images/l4.jpg',
        ],
        description: localizedStrings.translate('luna_corto'),
        subtitle: localizedStrings.translate('luna_sub'),
        imageOpacity: 0.3,
      ),
      SlideData(
        slideWidth: 300,
        type: 'sub',
        image: 'assets/images/code.jpg',
        title: localizedStrings.translate('code_title'),
        subtitle: localizedStrings.translate('code_subtitle'),
        imageOpacity: 0.3,
      ),
      SlideData(
        slideWidth: 300,
        title: "GRUPO JADE ROSARIO",
        description: localizedStrings.translate('jade_corto'),
        subtitle: localizedStrings.translate('jade_sub'),
        relatedImages: [
          'assets/images/jade1.jpg',
          'assets/images/jade2.jpg',
          'assets/images/jade3.jpg',
          'assets/images/jade4.jpg',
          'assets/images/jade5.jpg',
          'assets/images/jade6.jpg',
          'assets/images/jade7.jpg',
          'assets/images/jade8.jpg',
          'assets/images/jade9.jpg',
        ],
        type: 'normal',
        image: 'assets/images/jadep.png',
        imageOpacity: 0.3,
      ),
    ];
  }

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
    _startContinuousScroll();
  }

  /// Se usa `didChangeDependencies` en vez de `initState`
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    baseSlides = _buildBaseSlides(context); // 🔹 Mover la inicialización aquí
    _buildInfiniteSlides();
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
            Text(
              AppLocalizations.of(context).translate('our_projects'),
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
                Text(
                  AppLocalizations.of(context)
                      .translate('interested_in_more_projects'),
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
                    Navigator.pushNamed(
                      context,
                      '/projects',
                    );
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
                  child: Text(
                    AppLocalizations.of(context).translate('see_all'),
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
          child: GestureDetector(
            onTap: () {
              if (slide.relatedImages.isNotEmpty) {
                showProjectDetails(slide, context);
              }
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(slide.imageOpacity),
                    BlendMode.darken,
                  ),
                  child: Image.asset(slide.image, fit: BoxFit.cover),
                ),
              ),
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
    return slide.image.isNotEmpty
        ? GestureDetector(
            onTap: () => showProjectDetails(slide, context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5), // borde menor
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(slide.imageOpacity),
                  BlendMode.darken,
                ),
                child: Image.asset(slide.image, fit: BoxFit.cover),
              ),
            ),
          )
        : const Center(
            child: Text('No Image', style: TextStyle(color: Colors.white)));
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class SliderSection extends StatefulWidget {
  const SliderSection({Key? key}) : super(key: key);

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  // ======== INFINITE SLIDER CONFIG ========
  static const int kVirtualItemCount = 9999;
  static const int kInitialPage = 5001; // 5001 % 3 = 1 => Slide 'video'
  late final PageController _pageController;

  int _virtualPage = kInitialPage;
  int _currentRealIndex = 0;

  // Controlador único que cambia según el slide actual
  late VideoPlayerController? _videoController;
  bool _videoInitialized = false;

  Timer? _autoSlideTimer;

  // Slides reales. Cada slide de tipo 'video' podría tener su propia 'videoAsset'.
  final List<Map<String, String>> _slides = [
    {
      'title': 'Innovación',
      'description':
          'En Dark Matter, la innovación es nuestro motor principal...',
      'type': 'text',
      'image': 'assets/images/future_image.png',
    },
    {
      'title': 'Video Slide',
      'description':
          'Este es un slide de video genérico para mostrar la integración...',
      'type': 'video',
      'videoAsset': 'assets/images/slide.mp4',
    },
    {
      'title': 'Soluciones a medida',
      'description':
          'Entendemos que cada negocio tiene necesidades únicas. Por eso...',
      'type': 'text',
      'image': 'assets/images/future_image.png',
    },
    {
      'title': 'Otro Video Slide',
      'description': 'Aquí podrías mostrar un video distinto si quisieras...',
      'type': 'video',
      'videoAsset': 'assets/images/slide.mp4',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: kInitialPage);

    // No creamos _videoController aquí, lo haremos al cambiar slide.
    _videoController = null;

    // Iniciar auto-slide
    _startAutoSlideTimer();
  }

  void _startAutoSlideTimer() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _goToNextPage(autoPlay: true);
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    _disposeCurrentVideoController(); // Liberar si hay un video en uso
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fondo oscuro + Título
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: [
          const Text(
            '¿Por qué somos los indicados para ti?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Stack(
              children: [
                Row(
                  children: [
                    // === IZQUIERDA: PageView infinito (TEXTOS) ===
                    Expanded(
                      flex: 1,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: kVirtualItemCount,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final realIndex = index % _slides.length;
                          final slide = _slides[realIndex];
                          return _buildTextSide(
                            title: slide['title'] ?? '',
                            description: slide['description'] ?? '',
                          );
                        },
                      ),
                    ),

                    // === DERECHA: Video o Imagen, según slide actual ===
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.black,
                        margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * .035,
                          left: 10,
                        ),
                        child: _buildRightSide(_slides[_currentRealIndex]),
                      ),
                    ),
                  ],
                ),

                // FLECHA “anterior”
                Positioned(
                  left: 10,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 30),
                    onPressed: () => _goToPreviousPage(autoPlay: false),
                  ),
                ),

                // FLECHA “siguiente”
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 30),
                    onPressed: () => _goToNextPage(autoPlay: false),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================
  // Manejo de cambio de página
  // ================
  void _onPageChanged(int index) {
    _virtualPage = index;
    final realIndex = index % _slides.length;
    setState(() => _currentRealIndex = realIndex);

    // Reinicia timer si es swipe manual
    _startAutoSlideTimer();

    final slide = _slides[realIndex];
    print('onPageChanged -> $realIndex, type= ${slide['type']}');

    // 1) Dispose del video anterior (si existía)
    _disposeCurrentVideoController();

    // 2) Si el nuevo slide es "video", creamos un nuevo VideoPlayerController
    if (slide['type'] == 'video') {
      final videoAsset = slide['videoAsset'] ?? 'assets/images/slide.mp4';
      _initVideoController(videoAsset);
    }
    // Si es 'text', no creamos nada.
  }

  // Inicializa un nuevo VideoPlayerController para el asset provisto
  void _initVideoController(String assetPath) {
    _videoInitialized = false;

    final newController = VideoPlayerController.asset(assetPath);
    _videoController = newController;
    // Inicializamos
    newController.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _videoInitialized = true;
      });
      newController.setLooping(true);
      newController.setVolume(0);
      // Reproduces de inmediato
      newController.seekTo(Duration.zero);
      newController.play();
    });
  }

  // Limpia el video anterior si existía
  void _disposeCurrentVideoController() {
    if (_videoController != null) {
      _videoController!.pause();
      _videoController!.dispose();
      _videoController = null;
      _videoInitialized = false;
    }
  }

  // ======================
  // TEXT SIDE (izquierda)
  // ======================
  Widget _buildTextSide({
    required String title,
    required String description,
  }) {
    // Mantenemos tu LayoutBuilder y estilos
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth;
        final double maxH = constraints.maxHeight;

        final double horizontalPadding = maxW * 0.06;
        final double verticalPadding = maxH * 0.02;

        final double titleFontSize = (maxW * 0.05).clamp(22.0, 36.0);
        final double descFontSize = (maxW * 0.03).clamp(14.0, 24.0);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * 0.5,
              vertical: verticalPadding * 0.5,
            ),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: descFontSize),
                Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: descFontSize,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ======================
  // VIDEO o IMAGEN (derecha)
  // ======================
  Widget _buildRightSide(Map<String, String> slide) {
    final type = slide['type'];

    return LayoutBuilder(builder: (context, constraints) {
      final double maxW = constraints.maxWidth;
      final double maxH = constraints.maxHeight;

      if (type == 'video') {
        if (!_videoInitialized || _videoController == null) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        // Muestra el video actual
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: maxW,
              height: maxH,
              child: VideoPlayer(_videoController!),
            ),
          ),
        );
      } else {
        // Slide de texto => imagen
        final imagePath = slide['image'];
        if (imagePath != null && imagePath.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: maxW,
                height: maxH,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('No Image', style: TextStyle(color: Colors.white)),
          );
        }
      }
    });
  }

  // ===================
  // Página anterior
  // ===================
  void _goToPreviousPage({required bool autoPlay}) {
    _virtualPage--;
    _pageController.animateToPage(
      _virtualPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    if (!autoPlay) _startAutoSlideTimer();
  }

  // ===================
  // Página siguiente
  // ===================
  void _goToNextPage({required bool autoPlay}) {
    _virtualPage++;
    _pageController.animateToPage(
      _virtualPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    if (!autoPlay) _startAutoSlideTimer();
  }
}

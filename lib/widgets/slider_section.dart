import 'dart:async';
import 'package:dark_matter_page/lenguaje/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:dark_matter_page/language_provider.dart';

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
  late List<Map<String, String>> slides = [];
  bool _isSlidesInitialized = false; // Flag para verificar inicialización

  int _virtualPage = kInitialPage;
  int _currentRealIndex = 0;

  // Controlador único que cambia según el slide actual
  late VideoPlayerController? _videoController;
  bool _videoInitialized = false;

  Timer? _autoSlideTimer;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Evitar reinicialización si ya está configurado
    if (_isSlidesInitialized) return;
    final localizedStrings = AppLocalizations.of(context)!;
    setState(() {
      // Mueve la inicialización de slides aquí para evitar acceder a context en initState()
      slides = [
        {
          'title': localizedStrings.translate("slide_innovation_title"),
          'description':
              localizedStrings.translate("slide_innovation_description"),
          'type': 'text',
          'image': 'assets/images/innovation.webp',
        },
        {
          'title': localizedStrings.translate("slide_software_title"),
          'description':
              localizedStrings.translate("slide_software_description"),
          'type': 'video',
          'videoAsset': 'assets/images/software_development.webm',
        },
        {
          'title': localizedStrings.translate("slide_consulting_title"),
          'description':
              localizedStrings.translate("slide_consulting_description"),
          'type': 'text',
          'image': 'assets/images/it_consulting.webp',
        },
        {
          'title': localizedStrings.translate("slide_integration_title"),
          'description':
              localizedStrings.translate("slide_integration_description"),
          'type': 'text',
          'image': 'assets/images/hardware_software.webp',
        },
        {
          'title': localizedStrings.translate("slide_cybersecurity_title"),
          'description':
              localizedStrings.translate("slide_cybersecurity_description"),
          'type': 'video',
          'videoAsset': 'assets/images/cybersecurity.webm',
        },
        {
          'title': localizedStrings.translate("slide_ai_title"),
          'description': localizedStrings.translate("slide_ai_description"),
          'type': 'video',
          'videoAsset': 'assets/images/ai_automation.webm',
        },
        {
          'title': localizedStrings.translate("slide_experience_title"),
          'description':
              localizedStrings.translate("slide_experience_description"),
          'type': 'text',
          'image': 'assets/images/experience.webp',
        },
      ];
      _isSlidesInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        if (!_isSlidesInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        final localizedStrings = AppLocalizations.of(context);
        // Actualizar slides cuando cambia el idioma
        slides = [
          {
            'title': localizedStrings.translate("slide_innovation_title"),
            'description':
                localizedStrings.translate("slide_innovation_description"),
            'type': 'text',
            'image': 'assets/images/innovation.webp',
          },
          {
            'title': localizedStrings.translate("slide_software_title"),
            'description':
                localizedStrings.translate("slide_software_description"),
            'type': 'video',
            'videoAsset': 'assets/images/software_development.webm',
          },
          {
            'title': localizedStrings.translate("slide_consulting_title"),
            'description':
                localizedStrings.translate("slide_consulting_description"),
            'type': 'text',
            'image': 'assets/images/it_consulting.webp',
          },
          {
            'title': localizedStrings.translate("slide_integration_title"),
            'description':
                localizedStrings.translate("slide_integration_description"),
            'type': 'text',
            'image': 'assets/images/hardware_software.webp',
          },
          {
            'title': localizedStrings.translate("slide_cybersecurity_title"),
            'description':
                localizedStrings.translate("slide_cybersecurity_description"),
            'type': 'video',
            'videoAsset': 'assets/images/cybersecurity.webm',
          },
          {
            'title': localizedStrings.translate("slide_ai_title"),
            'description': localizedStrings.translate("slide_ai_description"),
            'type': 'video',
            'videoAsset': 'assets/images/ai_automation.webm',
          },
          {
            'title': localizedStrings.translate("slide_experience_title"),
            'description':
                localizedStrings.translate("slide_experience_description"),
            'type': 'text',
            'image': 'assets/images/experience.webp',
          },
        ];

        bool isVertical = MediaQuery.of(context).size.height >
            MediaQuery.of(context).size.width;

        return Container(
          width: double.infinity,
          color: Colors.transparent,
          child: Column(
            children: [
              Text(
                localizedStrings.translate('why_choose_us'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Stack(
                  children: [
                    isVertical
                        ? Column(
                            children: [
                              // === DERECHA: Video o Imagen, según slide actual ===
                              viewright(context, isVertical, slides),
                              // === IZQUIERDA: PageView infinito (TEXTOS) ===
                              viewleft(isVertical, slides),
                            ],
                          )
                        : Row(
                            children: [
                              // === IZQUIERDA: PageView infinito (TEXTOS) ===
                              viewleft(isVertical, slides),

                              // === DERECHA: Video o Imagen, según slide actual ===
                              viewright(context, isVertical, slides),
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
      },
    );
  }

  Expanded viewright(
      BuildContext context, bool isVertical, List<Map<String, String>> slides) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.black,
        margin: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * .035,
          left: 10,
        ),
        child: _buildRightSide(slides[_currentRealIndex], isVertical),
      ),
    );
  }

  Expanded viewleft(bool isVertical, List<Map<String, String>> slides) {
    return Expanded(
      flex: 1,
      child: PageView.builder(
        controller: _pageController,
        itemCount: kVirtualItemCount,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final realIndex = index % slides.length;
          final slide = slides[realIndex];
          return _buildTextSide(
            title: slide['title'] ?? '',
            description: slide['description'] ?? '',
          );
        },
      ),
    );
  }

  // ================
  // Manejo de cambio de página
  // ================
  void _onPageChanged(int index) {
    _virtualPage = index;
    final realIndex = index % slides.length;
    setState(() => _currentRealIndex = realIndex);

    // Reinicia timer si es swipe manual
    _startAutoSlideTimer();

    final slide = slides[realIndex];

    // 1) Dispose del video anterior (si existía)
    _disposeCurrentVideoController();

    // 2) Si el nuevo slide es "video", creamos un nuevo VideoPlayerController
    if (slide['type'] == 'video') {
      final videoAsset = slide['videoAsset'] ?? 'assets/images/slide.webm';
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
    bool isVertical = false,
  }) {
    // Mantenemos tu LayoutBuilder y estilos
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth;
        final double maxH =
            isVertical ? constraints.maxHeight * 0.4 : constraints.maxHeight;

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
  Widget _buildRightSide(Map<String, String> slide, bool isVertical) {
    final type = slide['type'];

    return LayoutBuilder(builder: (context, constraints) {
      final double maxW = constraints.maxWidth;
      final double maxH =
          isVertical ? constraints.maxHeight * 0.7 : constraints.maxHeight;

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

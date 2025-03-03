import 'package:dark_matter_page/home/componet/hero_text.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dark_matter_page/lenguaje/localization.dart';

class DesktopHero extends StatefulWidget {
  final VoidCallback onTapServices;
  DesktopHero({
    Key? key,
    required this.onTapServices,
  }) : super(key: key);

  @override
  _DesktopHeroState createState() => _DesktopHeroState();
}

class _DesktopHeroState extends State<DesktopHero> with WidgetsBindingObserver {
  late VideoPlayerController _backgroundController;
  bool _isBackgroundInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this); // <- OBSERVADOR
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // URL directa del video en Firebase Storage
      final videoUrl =
          'https://firebasestorage.googleapis.com/v0/b/dark-60a60.firebasestorage.app/o/fondo.mp4?alt=media&token=23f802af-0059-4668-aa9e-8169a511da50';

      _backgroundController = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {
            _isBackgroundInitialized = true;
          });
          _backgroundController.setLooping(true);
          _backgroundController.setVolume(0);
          _backgroundController.play();
        });
    } catch (e) {
      print('Error al cargar el video: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _backgroundController.dispose();
    super.dispose();
  }

  // Se llama cuando cambian las métricas de la ventana (ej: resize en web)
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setState(() {}); // fuerza el rebuild para recalcular tamaños
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final localizedStrings = AppLocalizations.of(context);

    return Stack(
      children: [
        // Video de fondo
        if (_isBackgroundInitialized)
          SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _backgroundController.value.size.width,
                height: _backgroundController.value.size.height,
                child: VideoPlayer(_backgroundController),
              ),
            ),
          )
        else
          Container(
            width: mediaQuery.width,
            height: mediaQuery.height,
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        // Contenido principal
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 20.0, horizontal: mediaQuery.width * 0.07),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 75.0),
                Center(
                  child: HeroText(
                      mediaQuery: mediaQuery,
                      onTapServices: widget.onTapServices),
                ),
                // Sección "tecno()" bien posicionada
                Padding(
                  padding:
                      EdgeInsets.only(top: mediaQuery.width < 600 ? 20 : 40),
                  child: tecno(localizedStrings),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget tecno(AppLocalizations localizedStrings) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final double width = constraints.maxWidth;

      double fontSize = 16;
      double imageSize = 123;
      double spacing = 123;

      if (width >= 1800) {
        fontSize = 24;
        imageSize = 153.8;
        spacing = 123;
      } else if (width >= 1500) {
        fontSize = 18;
        imageSize = 138.4;
        spacing = 107.7;
      } else if (width >= 1000 && width < 1500) {
        fontSize = 17;
        imageSize = 107.7;
        spacing = 76.9;
      } else if (width >= 600 && width < 1000) {
        fontSize = 16;
        imageSize = 92.3;
        spacing = 61.5;
      } else if (width >= 350 && width < 600) {
        fontSize = 14;
        imageSize = 76.9;
        spacing = 46.2;
      } else {
        fontSize = 12;
        imageSize = 61.5;
        spacing = 30.8;
      }

      return Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(83, 0, 0, 0),
              child: Text(
                localizedStrings.translate('connect_companies'),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: spacing,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                Image.asset('assets/images/flutter.webp',
                    width: imageSize, height: imageSize),
                Image.asset('assets/images/dart.webp',
                    width: imageSize, height: imageSize),
                Image.asset('assets/images/nodejs.webp',
                    width: imageSize, height: imageSize),
                Image.asset('assets/images/python.webp',
                    width: imageSize, height: imageSize),
                Image.asset('assets/images/github.webp',
                    width: imageSize, height: imageSize),
              ],
            ),
          ],
        ),
      );
    },
  );
}

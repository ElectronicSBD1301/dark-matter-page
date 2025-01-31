import 'package:dark_matter_page/widgets/project_slide.dart';
import 'package:dark_matter_page/widgets/slider_section.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_painter_bg.dart';
import '../widgets/custom_footer.dart';

// Claves GlobalKey para hacer scroll a secciones específicas
final aboutKey = GlobalKey();
final homekey = GlobalKey();
final servicesKey = GlobalKey();
final projectsKey = GlobalKey();
final contactKey = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  // Controlador de video si integras un solo video en el slider
  // o puedes manejar varios si cada slide tiene su propio video

  // Carrusel de proyectos
  late PageController _projectsPageController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Para el carrusel de proyectos
    _projectsPageController =
        PageController(viewportFraction: 0.4, initialPage: 1000);

    // Iniciar auto-scroll en la sección de proyectos
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoScrollProjects());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _projectsPageController.dispose();
    super.dispose();
  }

  // Función para scrollear hasta una sección usando su GlobalKey
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  // Auto-scroll para el carrusel de proyectos (loop infinito)
  void _autoScrollProjects() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_projectsPageController.hasClients) {
        _projectsPageController.nextPage(
          duration: const Duration(seconds: 2),
          curve: Curves.linear,
        );
        _autoScrollProjects();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizado (botones que hacen scroll)
      appBar: CustomAppBar(
        onTapAbout: () => _scrollToSection(aboutKey),
        onTapServices: () => _scrollToSection(servicesKey),
        onTapProjects: () => _scrollToSection(projectsKey),
        onTapContact: () => _scrollToSection(contactKey),
        onTaphome: () => _scrollToSection(homekey),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            /// 1) SECCIÓN de background con CustomPainter
            SizedBox(
              key: homekey,
              height: MediaQuery.of(context).size.height - 70,
              width: double.infinity,
              child: CustomPaint(
                painter: BackgroundPainter(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        Text(
                          'Transformando\nideas en realidad digital',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Transformamos tus ideas en software innovador y ágil,\n'
                          'utilizando las últimas tecnologías para crear soluciones\n'
                          'duraderas que evolucionan con tu negocio.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () => _scrollToSection(contactKey),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                child: Text('Contáctanos'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton(
                              onPressed: () => _scrollToSection(servicesKey),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Servicios'),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: Column(
                            children: [
                              const Text(
                                'Conectamos empresas con soluciones tecnológicas innovadoras '
                                'para impulsar su éxito global.',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 60,
                                runSpacing: 20,
                                alignment: WrapAlignment.center,
                                children: [
                                  Image.asset('assets/images/flutter.png',
                                      width: 80, height: 80),
                                  Image.asset('assets/images/dart.png',
                                      width: 80, height: 80),
                                  Image.asset('assets/images/nodejs.png',
                                      width: 80, height: 80),
                                  Image.asset('assets/images/python.png',
                                      width: 80, height: 80),
                                  Image.asset('assets/images/github.png',
                                      width: 80, height: 80),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// 2) Sección con Slider (Texto + Video en un Slide)
            Container(
              key: aboutKey,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SliderSection(), // Implementación más abajo
            ),

            /// 3) Sección “Construye para el futuro”
            SizedBox(key: servicesKey, child: _buildFutureSection()),

            /// 4) Sección “Proyectos” con auto-scroll
            SizedBox(key: projectsKey, child: ProjectsSection()),

            /// 7) Footer (Contacto, etc.)
            Container(
              key: contactKey,
              color: Colors.black,
              child: const CustomFooter(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  //   SECCIÓN “Construye para el futuro”
  // ============================
  Widget _buildFutureSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Colors.black,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen a la izquierda
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/future_image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Texto a la derecha
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Construye para el futuro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Es hora de llevar tu negocio al siguiente nivel. '
                    'Dark Matter ayuda a empresas de todos los tamaños a transformar '
                    'sus operaciones y conectar el mundo digital con el físico a través '
                    'de tecnología avanzada.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Acción al hacer clic
                    },
                    child: const Text(
                      'Aprende más sobre nosotros',
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _SocialIcon(
                          asset: 'assets/images/linkedin.png', size: 50),
                      const SizedBox(width: 10),
                      _SocialIcon(
                          asset: 'assets/images/instagram.png', size: 44),
                      const SizedBox(width: 10),
                      _SocialIcon(asset: 'assets/images/tiktok.png', size: 44),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  //   SECCIÓN “Proyectos”
  // ============================
  Widget _buildProjectsSection() {
    return Container(
      key: projectsKey,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
            height: 250,
            child: PageView.builder(
              controller: _projectsPageController,
              itemBuilder: (context, index) {
                // Ciclo infinito
                int projectIndex = (index % 6) + 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/project$projectIndex.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
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
                  // Acción "VER TODOS"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    );
  }
}

// ==============================
//   Pequeño widget SocialIcon
// ==============================
class _SocialIcon extends StatelessWidget {
  final String asset;
  final double size;
  const _SocialIcon({required this.asset, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

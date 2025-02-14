import 'package:dark_matter_page/home/componet/hero_content.dart';
import 'package:dark_matter_page/widgets/project_slide.dart';
import 'package:dark_matter_page/widgets/slider_section.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_footer.dart';
import 'package:dark_matter_page/widgets/forumlario.dart'; // Importa el formulario de contacto

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
  // late PageController _projectsPageController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Para el carrusel de proyectos
    /* _projectsPageController =
        PageController(viewportFraction: 0.4, initialPage: 1000);
*/
    // Iniciar auto-scroll en la sección de proyectos
    // WidgetsBinding.instance.addPostFrameCallback((_) => _autoScrollProjects());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _projectsPageController.dispose();
    super.dispose();
  }

  // Función para scrollear hasta una sección usando su GlobalKey
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      // Mapeo de GlobalKey a alignment específico
      final alignmentMap = {
        homekey: 0.0, // Inicio alineado totalmente arriba
        aboutKey: 0.8,
        servicesKey: 0.1,
        projectsKey: 0.7,
        contactKey: 0.1,
      };

      // Obtener el alignment según la clave, con un valor por defecto de 0.5
      double alignment = alignmentMap[key] ?? 0.5;

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: alignment,
      );
    }
  }

/*
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
*/
  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        onTapAbout: () => _scrollToSection(aboutKey),
        onTapServices: () => _scrollToSection(servicesKey),
        onTapProjects: () => _scrollToSection(projectsKey),
        onTapContact: () => _scrollToSection(contactKey),
        onTaphome: () => _scrollToSection(homekey),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                key: homekey,
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: HeroContent(),
              ),

              /// 🔽 Secciones siguientes (Slider, Proyectos, Footer)
              Container(
                margin: const EdgeInsets.only(
                    top: 70.0), // Aquí aplicamos el margen en lugar de padding
                child: SizedBox(
                  key: aboutKey,
                  child: SliderSection(),
                ),
              ),
              SizedBox(
                  key: servicesKey, child: _buildFutureSection(isVertical)),

              SizedBox(key: projectsKey, child: ProjectsSection()),

              /// 🚀 Footer
              Container(
                key: contactKey,
                color: Colors.black,
                child: const CustomFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================
  //   SECCIÓN “Construye para el futuro”
  // ============================
  Widget _buildFutureSection(bool isVertical) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Colors.black,
      child: isVertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen arriba sin Expanded
                SizedBox(child: imagefuture()),
                const SizedBox(height: 20),
                // Texto abajo sin Expanded
                SizedBox(child: textfuture(isVertical)),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen a la izquierda con Expanded
                Expanded(flex: 1, child: imagefuture()),
                const SizedBox(width: 20),
                // Texto a la derecha con Expanded
                Expanded(flex: 2, child: textfuture(isVertical)),
              ],
            ),
    );
  }

  Widget textfuture(bool isVertical) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment:
            isVertical ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment:
            isVertical ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            'Construye para el futuro',
            textAlign: isVertical ? TextAlign.center : TextAlign.justify,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Es hora de llevar tu negocio al siguiente nivel. '
            'Dark Matter ayuda a empresas de todos los tamaños a transformar '
            'sus operaciones y conectar el mundo digital con el físico a través '
            'de tecnología avanzada.',
            textAlign: isVertical ? TextAlign.center : TextAlign.justify,
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
            mainAxisAlignment:
                isVertical ? MainAxisAlignment.center : MainAxisAlignment.start,
            // Centra los iconos siempre
            children: [
              _SocialIcon(asset: 'assets/images/linkedin.png', size: 50),
              const SizedBox(width: 10),
              _SocialIcon(asset: 'assets/images/instagram.png', size: 44),
              const SizedBox(width: 10),
              _SocialIcon(asset: 'assets/images/tiktok.png', size: 44),
            ],
          ),
        ],
      ),
    );
  }

  Widget imagefuture() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        'assets/images/future_image.png',
        fit: BoxFit.cover,
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

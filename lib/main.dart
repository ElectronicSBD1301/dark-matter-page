import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const DarkMatterPage());
}

class DarkMatterPage extends StatefulWidget {
  const DarkMatterPage({super.key});

  @override
  State<DarkMatterPage> createState() => _DarkMatterPageState();
}

class _DarkMatterPageState extends State<DarkMatterPage> {
  late VideoPlayerController _videoController;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador del video
    _videoController = VideoPlayerController.asset('assets/images/slide.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  final List<Map<String, String>> _slides = [
    {
      'subtitle': 'Innovación',
      'description':
          'En Dark Matter, la innovación es nuestro motor principal. Nos esforzamospor incorporar lo último en tecnologías como Flutter y Dart para crear aplicaciones móviles y web que combinan funcionalidad, diseño intuitivo y un enfoque en el futuro. Cada solución que desarrollamos está diseñada para superar las expectativas, adaptándose a las tendencias tecnológicas más avanzadas y permitiendo que las empresas se mantengan a la vanguardia.',
    },
    {
      'subtitle': 'Escalabilidad',
      'description':
          'En un entorno empresarial en constante evolución, nuestras aplicaciones están preparadas para crecer contigo. En Dark Matter, desarrollamos soluciones escalables que pueden adaptarse al aumento de usuarios, la integración de nuevas funciones o la expansión de tus operaciones, sin comprometer la calidad ni el rendimiento. Nuestra tecnología asegura que tus herramientas digitales puedan soportar el presente y los desafíos futuros.',
    },
    {
      'subtitle': 'Soluciones',
      'description':
          'Entendemos que cada negocio tiene necesidades únicas. Por eso, en Dark Matter nos especializamos en diseñar aplicaciones personalizadas que resuelven problemas específicos y potencian el éxito de tu empresa. Nos enfocamos en comprender tus metas y desafíos para ofrecer soluciones que optimicen tus procesos internos y reflejen la identidad y valores de tu negocio, garantizando un producto perfectamente alineado con tus objetivos.',
    },
    {
      'subtitle': 'Rendimiento',
      'description':
          'La velocidad y la eficiencia son esenciales, y en Dark Matter nos aseguramos de que cada aplicación entregue un rendimiento sobresaliente. Gracias a Flutter y Dart, creamos soluciones ágiles que ofrecen una experiencia de usuario fluida, rápida y confiable, incluso bajo alta demanda. Desde el inicio del desarrollo, optimizamos cada detalle para garantizar aplicaciones que cumplan con los más altos estándares de calidad.',
    },
  ];

  @override
  void dispose() {
    _videoController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              _buildHeader(),

              // BACKGROUND
              _buildBackground(context),

              // TEXTO AZUL Y TECNOLOGÍAS
              _buildTechnologiesSection(),

              // SLIDER CON FLECHAS
              _buildSlider(),

              _buildFutureSection(),

              // SECCION DE PROYECTOS
              _buildProjectsSection(),

              // FOOTER
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                'Dark Matter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _HeaderOption(label: 'Nosotros'),
              _HeaderOption(label: 'Contactos'),
              _HeaderOption(label: 'Servicios'),
              _HeaderOption(label: 'Proyectos'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      height: 900,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -500,
            child: Image.asset(
              'assets/images/background1.png',
              width: MediaQuery.of(context).size.width * 0.6,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 300,
            right: -520,
            child: Image.asset(
              'assets/images/background1.png',
              width: MediaQuery.of(context).size.width * 0.6,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Transformando\nideas en realidad digital',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Transformamos tus ideas en software innovador y ágil, '
                  'utilizando las últimas\ntecnologías para crear soluciones '
                  'duraderas que evolucionan con tu negocio.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(179, 255, 255, 255),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromARGB(255, 122, 0, 204),
                              Color.fromARGB(255, 17, 0, 34),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Contáctanos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text('Servicios'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFutureSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
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
                    onPressed: () {},
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
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Alinea los iconos a la izquierda
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

  Widget _buildTechnologiesSection() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 569, vertical: 0),
      child: Column(
        children: [
          const Text(
            'Conectamos empresas con soluciones tecnológicas innovadoras para impulsar su éxito global.',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 60,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Image.asset('assets/images/flutter.png', width: 100, height: 100),
              Image.asset('assets/images/dart.png', width: 100, height: 100),
              Image.asset('assets/images/nodejs.png', width: 100, height: 100),
              Image.asset('assets/images/python.png', width: 100, height: 100),
              Image.asset('assets/images/github.png', width: 100, height: 100),
            ],
          ),
          const SizedBox(height: 50),
          const SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '¿Por qué somos los indicados para ti?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Container(
      width: double.infinity,
      height: 600,
      color: Colors.black,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: _slides.map((slide) {
                    return _buildSlide(
                      subtitle: slide['subtitle']!,
                      description: slide['description']!,
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black,
                  margin: const EdgeInsets.only(left: 10),
                  child: _videoController.value.isInitialized
                      ? IgnorePointer(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController.value.size.width,
                              height: _videoController.value.size.height,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
          if (_currentPage > 0)
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _goToPreviousPage,
              ),
            ),
          if (_currentPage < _slides.length - 1)
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _goToNextPage,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    final PageController pageController =
        PageController(viewportFraction: 0.4, initialPage: 1000);

    // Método para auto-scroll del carrusel con desplazamiento infinito en ambas direcciones
    void autoScroll() {
      Future.delayed(const Duration(seconds: 3), () {
        if (pageController.hasClients) {
          pageController.nextPage(
            duration: const Duration(seconds: 2),
            curve: Curves.linear,
          );
          autoScroll();
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => autoScroll()); // Iniciar el auto-scroll al renderizar

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background2.png"),
          fit: BoxFit.cover,
        ),
      ),
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
              controller: pageController,
              itemBuilder: (context, index) {
                int projectIndex =
                    (index % 6) + 1; // Ciclo infinito en ambas direcciones
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
                onPressed: () {},
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

  Widget _buildFooter() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Gestionado por Dark Matter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Icon(Icons.phone, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    '+1 829-362-4805',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.email, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'wa.darkmattercode@gmail.com',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '©2024 Dark Matter. All rights reserved',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Quieres iniciar un proyecto juntos?\nHablemos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Redes sociales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _SocialIcon(asset: 'assets/images/linkedin.png', size: 44),
                  const SizedBox(width: 20),
                  _SocialIcon(asset: 'assets/images/instagram.png', size: 36),
                  const SizedBox(width: 20),
                  _SocialIcon(asset: 'assets/images/tiktok.png', size: 36),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/logo.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 12),
              const Text(
                'Dark Matter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlide({
    required String subtitle,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < _slides.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

class _HeaderOption extends StatelessWidget {
  final String label;

  const _HeaderOption({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {},
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final String asset;
  final double size;

  const _SocialIcon({
    required this.asset,
    this.size = 24,
  });

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

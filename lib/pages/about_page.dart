import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_footer.dart';
import '../widgets/custom_painter_bg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTapAbout:
            () {}, // Podrías navegar o scrollear a secciones internas, etc.
        onTapServices: () => Navigator.pushNamed(context, '/services'),
        onTapProjects: () => Navigator.pushNamed(context, '/projects'),
        onTapContact: () {}, // O navega/scroll a un formulario de contacto
      ),
      body: Stack(
        children: [
          /// Fondo con `CustomPainter`
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: BackgroundPainter(),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sobre Dark Matter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'En Dark Matter, creemos en la innovación constante y en la búsqueda\n'
                    'de soluciones digitales que transformen la forma de hacer negocios.\n'
                    'Nuestro equipo está formado por desarrolladores, diseñadores y expertos\n'
                    'en tecnología con la misión de impulsar tu empresa al siguiente nivel.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),

                  // Sección de valores / misión / visión (ejemplo)
                  _buildValuesSection(),

                  const SizedBox(height: 50),
                  const CustomFooter(), // Footer reutilizable
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _valueCard(
          icon: Icons.lightbulb_outline,
          title: 'Innovación',
          description: 'Impulsamos nuevas tecnologías y frameworks para crear\n'
              'productos digitales flexibles, ágiles y potentes.',
        ),
        _valueCard(
          icon: Icons.people_outline,
          title: 'Colaboración',
          description:
              'Creemos en la cercanía con nuestros clientes, trabajando\n'
              'hombro a hombro para lograr resultados increíbles.',
        ),
        _valueCard(
          icon: Icons.security_outlined,
          title: 'Calidad y Seguridad',
          description: 'Cada proyecto se construye con altos estándares de\n'
              'calidad y robustez, cuidando cada detalle.',
        ),
      ],
    );
  }

  Widget _valueCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Expanded(
      child: Card(
        color: Colors.black54,
        elevation: 0,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.purpleAccent),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

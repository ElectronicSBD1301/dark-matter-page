import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_footer.dart';
import '../widgets/custom_painter_bg.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTapAbout: () => Navigator.pushNamed(context, '/about'),
        onTapServices: () {},
        onTapProjects: () => Navigator.pushNamed(context, '/projects'),
        onTapContact: () {},
        onTaphome: () {},
      ),
      body: Stack(
        children: [
          // Fondo con painter o gradiente
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
                children: [
                  Text(
                    'Servicios',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Transformamos tus ideas en soluciones digitales,\n'
                    'utilizando las últimas tecnologías para que tu negocio\n'
                    'destaque en un entorno competitivo.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // Lista/Grilla de servicios
                  _buildServicesGrid(),

                  const SizedBox(height: 60),
                  const CustomFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid() {
    // Ejemplo de grilla con 4 servicios
    final services = [
      {
        'title': 'Desarrollo Mobile',
        'icon': Icons.phone_iphone,
        'description':
            'Apps nativas y cross-platform con Flutter para iOS y Android.',
      },
      {
        'title': 'Desarrollo Web',
        'icon': Icons.web,
        'description':
            'Sitios y plataformas web escalables con Node.js, Python, etc.',
      },
      {
        'title': 'Diseño UI/UX',
        'icon': Icons.design_services,
        'description':
            'Interfaz y experiencia de usuario intuitivas y atractivas.',
      },
      {
        'title': 'Consultoría Tech',
        'icon': Icons.settings_suggest,
        'description':
            'Te asesoramos en la implementación de soluciones tecnológicas.',
      },
    ];

    return GridView.builder(
      shrinkWrap: true, // Para que no ocupe toda la pantalla
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (_, index) {
        final item = services[index];
        return _serviceCard(
          icon: item['icon'] as IconData,
          title: item['title'].toString()!,
          description: item['description'].toString()!,
        );
      },
    );
  }

  Widget _serviceCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.purpleAccent),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

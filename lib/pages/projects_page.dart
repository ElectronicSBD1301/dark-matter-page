import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_footer.dart';
import '../widgets/custom_painter_bg.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTapAbout: () => Navigator.pushNamed(context, '/about'),
        onTapServices: () => Navigator.pushNamed(context, '/services'),
        onTapProjects: () {},
        onTapContact: () {},
        onTaphome: () {},
      ),
      body: Stack(
        children: [
          /// Fondo con CustomPainter
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
                    'Proyectos Destacados',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Hemos trabajado con empresas de diversos sectores,\n'
                    'creando soluciones digitales que impulsan su crecimiento.\n'
                    'Estos son algunos de nuestros proyectos destacados.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Carrusel o grilla de proyectos
                  _buildProjectsList(),

                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      // Accion de ver todos
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'VER TODOS',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
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

  Widget _buildProjectsList() {
    // Ejemplo: contenedor tipo "carrusel" horizontal
    // Usa PageView o ListView horizontal con proyectos repetidos
    final projects = [
      'assets/images/project1.png',
      'assets/images/project2.png',
      'assets/images/project3.png',
      'assets/images/project4.png',
      'assets/images/project5.png',
      'assets/images/project6.png',
    ];

    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: projects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, index) {
          final projectImg = projects[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              projectImg,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

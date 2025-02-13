import 'package:dark_matter_page/widgets/custom_footer.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final ValueNotifier<int> _hoveringProjectIndex = ValueNotifier(-1);
  bool _isHoveringBack = false;

  @override
  void dispose() {
    _hoveringProjectIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeaderSection(context, screenWidth, screenHeight),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05, vertical: 20),
                child: Column(
                  children: [
                    _buildProjectsList(context, screenWidth),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          const CustomFooter(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(
      BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/soon.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHoveringBack = true),
              onExit: (_) => setState(() => _isHoveringBack = false),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: _isHoveringBack
                        ? Colors.purpleAccent.withOpacity(0.7)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Proyectos Destacados',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hemos trabajado con empresas de diversos sectores,\n'
              'creando soluciones digitales que impulsan su crecimiento.\n'
              'Estos son algunos de nuestros proyectos destacados.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth * 0.035,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context, double screenWidth) {
    final projects = [
      {
        'image': 'assets/images/project1.png',
        'title': 'Proyecto 1',
        'description': 'Descripción breve del Proyecto 1',
        'date': 'Enero 2025',
        'relatedImages': [
          'assets/images/project2.png',
          'assets/images/project3.png'
        ],
      },
      {
        'image': 'assets/images/project2.png',
        'title': 'Proyecto 2',
        'description': 'Descripción breve del Proyecto 2',
        'date': 'Febrero 2025',
        'relatedImages': [
          'assets/images/project3.png',
          'assets/images/project4.png'
        ],
      },
      {
        'image': 'assets/images/soon.jpg',
        'title': 'Coming Soon',
        'description': '',
        'date': '',
        'relatedImages': [],
      },
    ];

    return Column(
      children: projects.asMap().entries.map((entry) {
        int index = entry.key;
        var project = entry.value;

        return ValueListenableBuilder<int>(
          valueListenable: _hoveringProjectIndex,
          builder: (context, hoveringIndex, child) {
            final bool isHovered = hoveringIndex == index;

            return MouseRegion(
              onEnter: (_) => _hoveringProjectIndex.value = index,
              onExit: (_) => _hoveringProjectIndex.value = -1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
                padding: EdgeInsets.all(screenWidth * 0.03),
                height: screenWidth * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(project['image'].toString()),
                    fit: BoxFit.cover,
                    colorFilter: isHovered
                        ? null
                        : ColorFilter.mode(
                            Colors.black.withOpacity(0.6),
                            BlendMode.darken,
                          ),
                  ),
                  boxShadow: isHovered
                      ? [
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isHovered ? 1.0 : 0.7,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              project['title'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (project['description'].toString().isNotEmpty)
                              const SizedBox(height: 10),
                            if (project['description'].toString().isNotEmpty)
                              Text(
                                project['description'].toString(),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            if (project['date'].toString().isNotEmpty)
                              const SizedBox(height: 10),
                            if (project['date'].toString().isNotEmpty)
                              Text(
                                project['date'].toString(),
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      right: isHovered ? 10 : -50,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isHovered ? 1.0 : 0.0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.purpleAccent,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

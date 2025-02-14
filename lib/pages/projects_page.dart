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

  double titleFontSize = 24;
  double aboutFontSize = 16;
  double buttonFontSize = 14;
  double headerHeight = 0.25;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFontSizes();
    });
  }

  @override
  void dispose() {
    _hoveringProjectIndex.dispose();
    super.dispose();
  }

  void _updateFontSizes() {
    final mediaQuery = MediaQuery.of(context).size;
    final double width = mediaQuery.width;

    if (width >= 1800) {
      titleFontSize = width * 0.025;
      aboutFontSize = width * 0.012;
      buttonFontSize = width * 0.008;
      headerHeight = 0.20;
    } else if (width >= 1500) {
      titleFontSize = width * 0.027;
      aboutFontSize = width * 0.013;
      buttonFontSize = width * 0.009;
      headerHeight = 0.22;
    } else if (width >= 1200) {
      titleFontSize = width * 0.030;
      aboutFontSize = width * 0.015;
      buttonFontSize = width * 0.010;
      headerHeight = 0.24;
    } else if (width >= 1024) {
      titleFontSize = width * 0.033;
      aboutFontSize = width * 0.018;
      buttonFontSize = width * 0.012;
      headerHeight = 0.25;
    } else if (width >= 850) {
      titleFontSize = width * 0.035;
      aboutFontSize = width * 0.020;
      buttonFontSize = width * 0.014;
      headerHeight = 0.27;
    } else if (width >= 600) {
      titleFontSize = width * 0.040;
      aboutFontSize = width * 0.025;
      buttonFontSize = width * 0.018;
      headerHeight = 0.30;
    } else if (width >= 400) {
      titleFontSize = width * 0.040;
      aboutFontSize = width * 0.030;
      buttonFontSize = width * 0.020;
      headerHeight = 0.22;
    } else {
      titleFontSize = width * 0.050;
      aboutFontSize = width * 0.035;
      buttonFontSize = width * 0.025;
      headerHeight = 0.35;
    }

    setState(() {});
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
                    const SizedBox(height: 20),

                    const CustomFooter(), // Hacer el footer más pequeño
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(
      BuildContext context, double screenWidth, double screenHeight) {
    final bool isWideScreen = screenWidth / screenHeight > 1.6;

    return Container(
      width: screenWidth,
      height: screenHeight * headerHeight,
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
            EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
        child: isWideScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Proyectos Destacados',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize *
                                  0.8, // Reducir el tamaño del texto
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: Text(
                            'Hemos trabajado con empresas de diversos sectores,\n'
                            'creando soluciones digitales que impulsan su crecimiento.\n'
                            'Estos son algunos de nuestros proyectos destacados.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: aboutFontSize *
                                  0.8, // Reducir el tamaño del texto
                              height: 1.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Expanded(
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
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hemos trabajado con empresas de diversos sectores,\n'
                      'creando soluciones digitales que impulsan su crecimiento.\n'
                      'Estos son algunos de nuestros proyectos destacados.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: aboutFontSize,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context, double screenWidth) {
    final projects = [
      {
        'image': 'assets/images/prueba.jpeg',
        'title': 'Proyecto 1',
        'description': 'Descripción breve del Proyecto 1',
        'date': 'Enero 2025',
        'shadowColor': Colors.purpleAccent,
        'relatedImages': [
          'assets/images/project2.png',
          'assets/images/project3.png'
        ],
      },
      {
        'image': 'assets/images/prueba.jpeg',
        'title': 'Proyecto 2',
        'description': 'Descripción breve del Proyecto 2',
        'date': 'Febrero 2025',
        'shadowColor': Colors.blueAccent,
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
        'shadowColor': Colors.greenAccent,
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
                padding: EdgeInsets.all(
                    screenWidth * 0.025), // Reducir el ancho de cada slide
                height: screenWidth * 0.28, // Reducir la altura de cada slide
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
                            color: (project['shadowColor'] as Color)
                                    .withOpacity(0.3) ??
                                Colors.transparent,
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
                        alignment: project['title'] == 'Coming Soon'
                            ? Alignment.center
                            : Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: Column(
                          crossAxisAlignment: project['title'] == 'Coming Soon'
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              project['title'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth *
                                    0.03, // Reducir el tamaño del texto
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: project['title'] == 'Coming Soon'
                                  ? TextAlign.center
                                  : TextAlign.left,
                            ),
                            if (project['description'].toString().isNotEmpty)
                              const SizedBox(height: 10),
                            if (project['description'].toString().isNotEmpty)
                              Text(
                                project['description'].toString(),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: screenWidth *
                                      0.025, // Reducir el tamaño del texto
                                ),
                              ),
                            if (project['date'].toString().isNotEmpty)
                              const SizedBox(height: 10),
                            if (project['date'].toString().isNotEmpty)
                              Text(
                                project['date'].toString(),
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: screenWidth *
                                      0.02, // Reducir el tamaño del texto
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

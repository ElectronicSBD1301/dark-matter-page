import 'package:dark_matter_page/lenguaje/localization.dart';
import 'package:dark_matter_page/widgets/custom_footer.dart';
import 'package:dark_matter_page/widgets/project_slide.dart';
import 'package:dark_matter_page/widgets/view_project.dart';
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

    final localizedStrings = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeaderSection(
              context, screenWidth, screenHeight, localizedStrings),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05, vertical: 20),
                child: Column(
                  children: [
                    _buildProjectsList(context, screenWidth, localizedStrings),
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

  //double headerHeight = 0.35; // Puedes ajustarlo o quitarlo si no quieres altura fija

  Widget _buildHeaderSection(BuildContext context, double screenWidth,
      double screenHeight, AppLocalizations localizedStrings) {
    final bool isWideScreen = screenWidth / screenHeight > 1.6;

    return Container(
      width: screenWidth,
      // Quita el alto fijo para dejar que el contenedor crezca
      // height: screenHeight * headerHeight, // <- COMENTA O ELIMINA ESTA LÍNEA
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/soon.webp'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 10,
        ),
        // Cambia entre Row/Column según la relación de aspecto
        child: isWideScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // BOTÓN REGRESAR
                  _buildBackButton(context),
                  const SizedBox(width: 20),
                  // TEXTO SIN Flexible
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizedStrings.translate("featured_projects"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        // Quitar overflow y maxLines
                      ),
                      const SizedBox(height: 10),
                      Text(
                        localizedStrings.translate("description"),
                        /* 'Hemos trabajado con empresas de diversos sectores,\n'
                        'creando soluciones digitales que impulsan su crecimiento.\n'
                        'Estos son algunos de nuestros proyectos destacados.',*/
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: aboutFontSize,
                          height: 1.5,
                        ),
                        // Quitar overflow y maxLines
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BOTÓN REGRESAR
                  _buildBackButton(context),
                  const SizedBox(height: 20),
                  Text(
                    localizedStrings.translate("featured_projects"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    // Quitar overflow y maxLines
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localizedStrings.translate("description"),
                    /* 'Hemos trabajado con empresas de diversos sectores,\n'
                        'creando soluciones digitales que impulsan su crecimiento.\n'
                        'Estos son algunos de nuestros proyectos destacados.',*/
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: aboutFontSize,
                      height: 1.5,
                    ),
                    // Quitar overflow y maxLines
                  ),
                ],
              ),
      ),
    );
  }

  // Extraer la lógica del botón en un método para mayor claridad
  Widget _buildBackButton(BuildContext context) {
    return MouseRegion(
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
    );
  }

  Widget _buildProjectsList(BuildContext context, double screenWidth,
      AppLocalizations localizedStrings) {
    final projects = [
      {
        'image': 'assets/images/pp0.webp',
        'title': 'Pickup Workshop',
        'subtitle': localizedStrings.translate("pickup_sub"),
        'description': localizedStrings.translate("pickup_largo"),
        'description_small': localizedStrings.translate("pickup_corto"),
        'date': localizedStrings.translate("pickup_date"),
        'shadowColor': Colors.blueAccent,
        'relatedImages': [
          'assets/images/p0.webp',
          'assets/images/p1.webp',
          'assets/images/p2.webp',
          'assets/images/p3.webp',
          'assets/images/p4.webp',
          'assets/images/p5.webp',
          'assets/images/p6.webp',
        ],
      },
      {
        'image': 'assets/images/jadep.webp',
        'title': 'GRUPO JADE ROSARIO',
        'subtitle': localizedStrings.translate("jade_sub"),
        'description': localizedStrings.translate("jade_largo"),
        'description_small': localizedStrings.translate("jade_corto"),
        'date': localizedStrings.translate("jade_date"),
        'shadowColor': Colors.teal[900],
        'relatedImages': [
          "assets/images/jade0.webp",
          "assets/images/jade00.webp",
          "assets/images/jade1.webp",
          'assets/images/jade2.webp',
          'assets/images/jade3.webp',
          'assets/images/jade4.webp',
          "assets/images/jade5.webp",
          "assets/images/jade6.webp",
          'assets/images/jade7.webp',
          'assets/images/jade8.webp',
          'assets/images/jade9.webp',
          "assets/images/jade10.webp",
        ],
      },
      {
        'image': 'assets/images/luna.webp',
        'title': 'Rodríguez Luna Import',
        'subtitle': localizedStrings.translate("luna_sub"),
        'description': localizedStrings.translate("luna_largo"),
        'description_small': localizedStrings.translate("luna_corto"),
        'date': localizedStrings.translate("luna_date"),
        'shadowColor': Colors.white,
        'relatedImages': [
          'assets/images/luna.webp',
          'assets/images/l0.webp',
          'assets/images/l1.webp',
          'assets/images/l2.webp',
          'assets/images/l3.webp',
          'assets/images/l4.webp',
        ],
      },
      {
        'image': 'assets/images/soon.webp',
        'title': 'Coming Soon',
        'subtitle': "",
        'description': '',
        'date': '',
        'shadowColor': Colors.grey,
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
              onEnter: (_) {
                if (_hoveringProjectIndex.value != index) {
                  _hoveringProjectIndex.value = index;
                }
              },
              onExit: (_) {
                if (_hoveringProjectIndex.value == index) {
                  _hoveringProjectIndex.value = -1;
                }
              },
              child: GestureDetector(
                onTap: () {
                  showProjectDetails(
                      SlideData(
                        relatedImages: project['relatedImages'] as List<String>,
                        subtitle: project['date'].toString(),
                        title: project['title'].toString(),
                        description: project['description'].toString(),
                        slideWidth: 200,
                        type: 'normal',
                        image: project['image'].toString(),
                      ),
                      context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 0.005),
                  padding: EdgeInsets.all(
                      screenWidth * 0.004), // Reducir el ancho de cada slide
                  height: screenWidth * 0.28, // Reducir la altura de cada slide
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: (project['shadowColor'] as Color)
                                      .withOpacity(0.2) ??
                                  Colors.transparent,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isHovered ? 1.0 : 0.4,
                          child: Image.asset(
                            project['image'].toString(),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Container(
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
                            if (project['subtitle'].toString().isNotEmpty)
                              const SizedBox(height: 10),
                            if (project['subtitle'].toString().isNotEmpty)
                              Text(
                                project['subtitle'].toString(),
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
                                textAlign: TextAlign.center, // Centrar la fecha
                              ),
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        right: isHovered
                            ? screenWidth * 0.02
                            : -50, // Se mueve desde la derecha

                        top: screenWidth * 0.11,
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
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

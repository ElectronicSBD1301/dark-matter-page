import 'package:animations/animations.dart';
import 'package:dark_matter_page/lenguaje/localization.dart';
import 'package:dark_matter_page/widgets/project_slide.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:three_dart/three3d/math/math.dart';

void showProjectDetails(SlideData slide, BuildContext context) {
  if (slide.relatedImages.isEmpty) return;

  showModal(
    context: context,
    configuration: const FadeScaleTransitionConfiguration(),
    builder: (BuildContext context) {
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      final bool isLandscape = screenWidth > screenHeight;
      final localizedStrings = AppLocalizations.of(context);

      double maxHeight = isLandscape ? screenHeight * 0.85 : screenHeight * 0.7;
      double maxWidth = isLandscape ? screenWidth * 0.85 : screenWidth * 0.7;

      // 1. Primero crear la lista de imágenes y calcular las alturas iniciales
      List<String> imageList = List.from(slide.relatedImages);
      List<double> aspectRatios = [];
      double totalHeightLeft = 0;
      double totalHeightRight = 0;

      // 2. Calcular los aspect ratios iniciales y las alturas
      for (int i = 0; i < imageList.length; i++) {
        double aspectRatio =
            isLandscape ? (i % 2 == 0 ? 1.2 : 0.8) : (i % 3 == 0 ? 1.3 : 0.9);
        aspectRatios.add(aspectRatio);

        // Calcular en qué columna irá cada imagen
        if (i % 2 == 0) {
          totalHeightLeft += 1 / aspectRatio;
        } else {
          totalHeightRight += 1 / aspectRatio;
        }
      }

      // 3. Si es impar, agregar la primera imagen y calcular su aspect ratio para balancear
      if (imageList.length % 2 != 0) {
        imageList.add(imageList.first);

        // Calcular el aspect ratio necesario para balancear las columnas
        double heightDifference = totalHeightLeft - totalHeightRight;
        double newAspectRatio;

        if (heightDifference > 0) {
          // La columna izquierda es más alta
          newAspectRatio = 1 / heightDifference;
        } else {
          // La columna derecha es más alta o son iguales
          newAspectRatio = 1 / Math.abs(heightDifference);
        }

        // Asegurarse de que el aspect ratio esté dentro de límites razonables
        newAspectRatio = newAspectRatio.clamp(0.5, 2.0);
        aspectRatios.add(newAspectRatio);
      }

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.black,
        child: SizedBox(
          width: maxWidth,
          height: maxHeight,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  slide.title,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  minFontSize: 18,
                ),
                if (slide.subtitle.isNotEmpty)
                  AutoSizeText(
                    slide.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                  ),
                const SizedBox(height: 8),
                Container(
                  height: 6.0,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.purpleAccent, Colors.white],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MasonryGridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          itemCount: imageList.length,
                          itemBuilder: (context, index) {
                            return AspectRatio(
                              aspectRatio: aspectRatios[index],
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenGallery(
                                        images: imageList,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: imageList[index],
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      imageList[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(localizedStrings.translate('close'),
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenGallery({
    required this.images,
    required this.initialIndex,
  });

  @override
  _FullScreenGalleryState createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.images.length,
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(widget.images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.images[index]),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            left: 20,
            top: MediaQuery.of(context).size.height / 2 - 30,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 30),
              onPressed: () {
                if (_currentIndex > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height / 2 - 30,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 30),
              onPressed: () {
                if (_currentIndex < widget.images.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentIndex == index ? Colors.white : Colors.white54,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

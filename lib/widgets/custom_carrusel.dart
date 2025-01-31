import 'dart:async';
import 'package:flutter/material.dart';

/// Representa cada Slide de tu carrusel custom
/// con “falso infinito”, auto-play, snapping, etc.
class SlideData {
  final double slideWidth;
  final String type;
  final String image;
  final String title;
  final String subtitle;

  SlideData({
    required this.slideWidth,
    required this.type,
    required this.image,
    this.title = '',
    this.subtitle = '',
  });
}

class CustomCarousel extends StatefulWidget {
  final List<SlideData> slides; // Lista de SlideData
  final double height; // altura total
  final double minSeparation; // separación mínima
  final Duration autoPlayInterval;
  final bool autoPlay;
  final Duration snappingDuration;
  final int loopCount;

  const CustomCarousel({
    Key? key,
    required this.slides,
    this.height = 400,
    this.minSeparation = 2,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.loopCount = 3,
    this.snappingDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  late final ScrollController _scrollController;
  late List<SlideData> _infiniteSlides;

  Timer? _autoPlayTimer;
  int _currentItemIndex = 0; // índice virtual actual

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _buildInfiniteList();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Replicamos la lista base loopCount veces
  void _buildInfiniteList() {
    _infiniteSlides = [];
    for (int i = 0; i < widget.loopCount; i++) {
      _infiniteSlides.addAll(widget.slides);
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (_) {
      _goToNext();
    });
  }

  void _goToNext() {
    setState(() => _currentItemIndex++);
    _snapToIndex(_currentItemIndex);
  }

  Future<void> _snapToIndex(int index) async {
    final offset = _calculateOffset(index);
    await _scrollController.animateTo(
      offset,
      duration: widget.snappingDuration,
      curve: Curves.easeInOut,
    );
    _maybeLoopReset(index);
  }

  // Si estamos cerca del final, reseteamos al medio
  void _maybeLoopReset(int index) {
    final baseLen = widget.slides.length;
    final total = baseLen * widget.loopCount;
    if (index > total - baseLen) {
      final midStart = baseLen * (widget.loopCount ~/ 2);
      final newIndex = midStart + (index % baseLen);
      _currentItemIndex = newIndex;
      final newOffset = _calculateOffset(newIndex);
      _scrollController.jumpTo(newOffset);
    }
  }

  double _calculateOffset(int index) {
    double offset = 0;
    for (int i = 0; i < index; i++) {
      offset += _infiniteSlides[i].slideWidth + widget.minSeparation;
    }
    return offset;
  }

  void _onPanEndOrCancel() {
    final pos = _scrollController.offset;
    double bestDist = double.infinity;
    int bestIndex = 0;
    for (int i = 0; i < _infiniteSlides.length; i++) {
      final center = _calculateOffset(i) + (_infiniteSlides[i].slideWidth / 2);
      final dist = (center - pos).abs();
      if (dist < bestDist) {
        bestDist = dist;
        bestIndex = i;
      }
    }
    _currentItemIndex = bestIndex;
    _snapToIndex(bestIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Listener(
        onPointerUp: (_) => _onPanEndOrCancel(),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_infiniteSlides.length, (index) {
              final slide = _infiniteSlides[index];
              return Container(
                width: slide.slideWidth,
                height: widget.height,
                margin: EdgeInsets.only(right: widget.minSeparation),
                color: Colors.transparent,
                child: (slide.type == 'sub')
                    ? _buildSubContent(slide)
                    : _buildNormalContent(slide),
              );
            }),
          ),
        ),
      ),
    );
  }

  // Sub-content
  Widget _buildSubContent(SlideData slide) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Título + subtítulo
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  slide.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          // Imagen
          if (slide.image.isNotEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(slide.image, fit: BoxFit.cover),
                ),
              ),
            )
          else
            const Text('No Image', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Normal
  Widget _buildNormalContent(SlideData slide) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: (slide.image.isNotEmpty)
          ? Image.asset(slide.image, fit: BoxFit.cover)
          : const Center(
              child: Text('No Image', style: TextStyle(color: Colors.white))),
    );
  }

  // Puedes exponer métodos para “flechas” si quieres
  void goToPrevious() {
    setState(() {
      _currentItemIndex = (_currentItemIndex > 0) ? _currentItemIndex - 1 : 0;
    });
    _snapToIndex(_currentItemIndex);
  }

  void goToNext() {
    setState(() => _currentItemIndex++);
    _snapToIndex(_currentItemIndex);
  }
}

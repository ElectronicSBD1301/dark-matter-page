import 'dart:ui';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onTaphome;
  final VoidCallback onTapAbout;
  final VoidCallback onTapServices;
  final VoidCallback onTapProjects;
  final VoidCallback onTapContact;

  const CustomAppBar({
    Key? key,
    required this.onTaphome,
    required this.onTapAbout,
    required this.onTapServices,
    required this.onTapProjects,
    required this.onTapContact,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  double _backgroundOpacity = 0.0;
  double _textOpacity = 1.0;
  double _lastOffset = 0;
  bool _isScrollingDown = false;
  String? _hoveredButton; // Almacena el botón que tiene el mouse encima

  @override
  void initState() {
    super.initState();
  }

  void _onScroll(double offset) {
    setState(() {
      if (offset > _lastOffset && offset > 100) {
        _isScrollingDown = true;
      } else if (offset < _lastOffset) {
        _isScrollingDown = false;
      }

      double normalizedOpacity = (1 - (offset / 300)).clamp(0.2, 1.0);

      _backgroundOpacity = normalizedOpacity * 0.2;
      _textOpacity = normalizedOpacity * 0.8;

      if (offset <= 0) {
        _backgroundOpacity = 0.0;
        _textOpacity = 1.0;
      }

      _lastOffset = offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        _onScroll(notification.metrics.pixels);
        return true;
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _backgroundOpacity = 0.6;
            _textOpacity = 1.0;
          });
        },
        onExit: (_) {
          setState(() {
            _backgroundOpacity = _isScrollingDown ? 0.2 : 0.4;
            _textOpacity = _isScrollingDown ? 0.5 : 0.8;
          });
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _textOpacity,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _backgroundOpacity * 10,
                sigmaY: _backgroundOpacity * 10,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(_backgroundOpacity),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _textOpacity,
                        child: const Text(
                          'Dark Matter',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    _buildAnimatedButton('Home', widget.onTaphome),
                    _buildAnimatedButton('Nosotros', widget.onTapAbout),
                    _buildAnimatedButton('Servicios', widget.onTapServices),
                    _buildAnimatedButton('Proyectos', widget.onTapProjects),
                    _buildAnimatedButton('Contactos', widget.onTapContact),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(String text, VoidCallback onTap) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredButton = text; // Guarda el botón activo
      }),
      onExit: (_) => setState(() {
        _hoveredButton = null; // Lo resetea cuando se va el mouse
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: _hoveredButton == text
                      ? Colors.purpleAccent
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                child: Text(text),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _hoveredButton == text
                    ? 40
                    : 0, // La línea solo aparece cuando pasa el mouse
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

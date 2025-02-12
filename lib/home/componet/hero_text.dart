import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class HeroText extends StatefulWidget {
  const HeroText({Key? key, required Size mediaQuery}) : super(key: key);

  @override
  _HeroTextState createState() => _HeroTextState();
}

class _HeroTextState extends State<HeroText> {
  double titleFontSize = 40.0;
  double aboutFontSize = 18.0;
  double buttonFontSize = 16.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFontSizes();
  }

  void _updateFontSizes() {
    final mediaQuery = MediaQuery.of(context).size;
    final double width = mediaQuery.width;

    if (width >= 1800) {
      // Pantallas ultra grandes (4K o monitores grandes)
      titleFontSize = width * 0.028;
      aboutFontSize = width * 0.014;
      buttonFontSize = width * 0.009;
    } else if (width >= 1500) {
      // Pantallas grandes (Desktop estándar)
      titleFontSize = width * 0.030;
      aboutFontSize = width * 0.015;
      buttonFontSize = width * 0.01;
    } else if (width >= 1200) {
      // Laptops o monitores pequeños
      titleFontSize = width * 0.035;
      aboutFontSize = width * 0.017;
      buttonFontSize = width * 0.012;
    } else if (width >= 1024) {
      // Tablets grandes o laptops pequeñas
      titleFontSize = width * 0.038;
      aboutFontSize = width * 0.028;
      buttonFontSize = width * 0.024;
    } else if (width >= 850) {
      // Tablets medianas
      titleFontSize = width * 0.04;
      aboutFontSize = width * 0.03;
      buttonFontSize = width * 0.026;
    } else if (width >= 600) {
      // Tablets pequeñas o teléfonos grandes
      titleFontSize = width * 0.045;
      aboutFontSize = width * 0.033;
      buttonFontSize = width * 0.029;
    } else if (width >= 400) {
      // Teléfonos medianos
      titleFontSize = width * 0.05;
      aboutFontSize = width * 0.035;
      buttonFontSize = width * 0.032;
    } else {
      // Teléfonos pequeños
      titleFontSize = width * 0.06;
      aboutFontSize = width * 0.040;
      buttonFontSize = width * 0.035;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TitleDark(fontSize: titleFontSize),
          const SizedBox(height: 40.0),
          About(fontSize: aboutFontSize),
          const SizedBox(height: 20.0),
          Button(fontSize: buttonFontSize),
        ],
      ),
    );
  }
}

// ---------------------- BOTONES ----------------------
class Button extends StatefulWidget {
  final VoidCallback? onContactPressed;
  final VoidCallback? onServicesPressed;
  final double fontSize;

  const Button({
    Key? key,
    this.onContactPressed,
    this.onServicesPressed,
    required this.fontSize,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isHoveringContact = false;
  bool _isHoveringServices = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAnimatedButton(
          text: 'Contáctanos',
          isHovering: _isHoveringContact,
          onEnter: () => setState(() => _isHoveringContact = true),
          onExit: () => setState(() => _isHoveringContact = false),
          onPressed: widget.onContactPressed,
          backgroundColor: const Color.fromARGB(255, 35, 81, 102),
          hoverColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: widget.fontSize,
        ),
        const SizedBox(width: 16),
        _buildAnimatedButton(
          text: 'Servicios',
          isHovering: _isHoveringServices,
          onEnter: () => setState(() => _isHoveringServices = true),
          onExit: () => setState(() => _isHoveringServices = false),
          onPressed: widget.onServicesPressed,
          backgroundColor: Colors.transparent,
          hoverColor: Colors.white,
          textColor: Colors.white,
          borderColor: Colors.white,
          fontSize: widget.fontSize,
          isOutlined: true,
        ),
      ],
    );
  }

  Widget _buildAnimatedButton({
    required String text,
    required bool isHovering,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color hoverColor,
    required Color textColor,
    Color borderColor = Colors.transparent,
    required double fontSize,
    bool isOutlined = false,
    required VoidCallback onEnter,
    required VoidCallback onExit,
  }) {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isOutlined
              ? backgroundColor
              : (isHovering ? hoverColor : backgroundColor),
          borderRadius: BorderRadius.circular(30),
          border: isOutlined
              ? Border.all(color: isHovering ? hoverColor : borderColor)
              : null,
          boxShadow: isHovering
              ? [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4))
                ]
              : [],
        ),
        child: isOutlined
            ? OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(text, style: TextStyle(fontSize: fontSize)),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: textColor,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: WidgetAnimator(
                    atRestEffect: WidgetRestingEffects.size(),
                    child: Text(text, style: TextStyle(fontSize: fontSize)),
                  ),
                ),
              ),
      ),
    );
  }
}

// ---------------------- SECCIÓN "ABOUT" ----------------------

class About extends StatelessWidget {
  final double fontSize;

  const About({
    Key? key,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Filtro de desenfoque detrás del texto
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 5, sigmaY: 5), // Ajusta el nivel de desenfoque
            child: Container(
                color: Colors.black.withOpacity(0.15)), // Suaviza el contraste
          ),
        ),
        // Texto animado con sombra
        WidgetAnimator(
          atRestEffect: WidgetRestingEffects.bounce(),
          child: AutoSizeText(
            'Transformamos tus ideas en software innovador y ágil,\n'
            'utilizando las últimas tecnologías para crear soluciones\n'
            'duraderas que evolucionan con tu negocio.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: fontSize,
              height: 1.2,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// ---------------------- SECCIÓN "TITLE" ----------------------
class TitleDark extends StatelessWidget {
  final double fontSize;

  const TitleDark({
    Key? key,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WidgetAnimator(
          atRestEffect: WidgetRestingEffects.bounce(),
          child: TextAnimator(
            'Transformando',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              fontFamily: 'Santana',
            ),
            incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
          ),
        ),
        const SizedBox(height: 10),
        WidgetAnimator(
          atRestEffect: WidgetRestingEffects.bounce(),
          child: TextAnimator(
            'ideas en realidad digital',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 0.9, // Ligera variación en el tamaño
              fontWeight: FontWeight.w900,
              fontFamily: 'Santana',
            ),
            incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
          ),
        ),
      ],
    );
  }
}

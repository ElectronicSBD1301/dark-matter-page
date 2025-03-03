import 'dart:ui';
import 'dart:async';
import 'dart:math' show sin, pi;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dark_matter_page/widgets/forumlario.dart';
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:dark_matter_page/lenguaje/localization.dart';

// Constantes de animación globales
const kAnimationDuration = Duration(milliseconds: 700);
const kCompletionBuffer = Duration(milliseconds: 1200);
const kCycleDelay = Duration(seconds: 10);

class HeroText extends StatefulWidget {
  final VoidCallback onTapServices;
  const HeroText({
    Key? key,
    required Size mediaQuery,
    required this.onTapServices,
  }) : super(key: key);

  @override
  _HeroTextState createState() => _HeroTextState();
}

class _HeroTextState extends State<HeroText> {
  double titleFontSize = 40.0;
  double aboutFontSize = 18.0;
  double buttonFontSize = 16.0;
  double buttonPadding = 24.0;
  double spacingAfterTitle = 0.05;
  double spacingAfterAbout = 0.03;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSizes();
  }

  void _updateSizes() {
    final mediaQuery = MediaQuery.of(context).size;
    final double width = mediaQuery.width;
    final double height = mediaQuery.height;

    setState(() {
      // Ajuste de espaciados según el ancho de pantalla
      if (width >= 1800) {
        spacingAfterTitle = 0.05;
        spacingAfterAbout = 0.02;
        titleFontSize = width * 0.032;
        aboutFontSize = width * 0.016;
        buttonFontSize = width * 0.012;
      } else if (width >= 1500) {
        spacingAfterTitle = 0.045;
        spacingAfterAbout = 0.025;
        titleFontSize = width * 0.034;
        aboutFontSize = width * 0.017;
        buttonFontSize = width * 0.013;
      } else if (width >= 1200) {
        spacingAfterTitle = 0.04;
        spacingAfterAbout = 0.025;
        titleFontSize = width * 0.036;
        aboutFontSize = width * 0.018;
        buttonFontSize = width * 0.014;
      } else if (width >= 1000) {
        spacingAfterTitle = 0.035;
        spacingAfterAbout = 0.022;
        titleFontSize = width * 0.038;
        aboutFontSize = width * 0.019;
        buttonFontSize = width * 0.015;
      } else if (width >= 850) {
        spacingAfterTitle = 0.03;
        spacingAfterAbout = 0.025;
        titleFontSize = width * 0.040;
        aboutFontSize = width * 0.020;
        buttonFontSize = width * 0.016;
      } else if (width >= 650) {
        spacingAfterTitle = 0.025;
        spacingAfterAbout = 0.020;
        titleFontSize = width * 0.042;
        aboutFontSize = width * 0.021;
        buttonFontSize = width * 0.018;
      } else if (width >= 400) {
        spacingAfterTitle = 0.02;
        spacingAfterAbout = 0.015;
        titleFontSize = width * 0.058;
        aboutFontSize = width * 0.040;
        buttonFontSize = width * 0.022;
      } else {
        spacingAfterTitle = 0.015;
        spacingAfterAbout = 0.012;
        titleFontSize = width * 0.068;
        aboutFontSize = width * 0.045;
        buttonFontSize = width * 0.024;
      }
      buttonPadding = width >= 650 ? 16.0 : 14.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TitleDark(fontSize: titleFontSize),
          SizedBox(height: screenHeight * spacingAfterTitle),
          About(fontSize: aboutFontSize),
          SizedBox(height: screenHeight * spacingAfterAbout),
          Button(
            fontSize: buttonFontSize,
            padding: buttonPadding,
            onContactPressed: () => showContactForm(context),
            onServicesPressed: widget.onTapServices,
          ),
        ],
      ),
    );
  }
}

void showContactForm(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: const ContactForm(),
        ),
      );
    },
  );
}

// Mixin para manejar animaciones comunes
mixin AnimationControllerMixin<T extends StatefulWidget> on State<T> {
  bool _isAnimating = false;
  Timer? _animationTimer;

  bool get isAnimating => _isAnimating;

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void startAnimation() {
    if (!mounted) return;
    setState(() => _isAnimating = true);
    Future.delayed(kAnimationDuration + kCompletionBuffer, () {
      if (!mounted) return;
      setState(() => _isAnimating = false);
    });
  }

  void startAnimationCycle() {
    _animationTimer = Timer.periodic(kCycleDelay, (_) => startAnimation());
  }
}

class Button extends StatefulWidget {
  final VoidCallback? onContactPressed;
  final VoidCallback? onServicesPressed;
  final double fontSize;
  final double padding;

  const Button({
    Key? key,
    this.onContactPressed,
    this.onServicesPressed,
    required this.fontSize,
    required this.padding,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isHoveringContact = false;
  bool _isHoveringServices = false;
  String _contactText = '';
  String _servicesText = '';
  late double _buttonWidth;
  late double _buttonSpacing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;
    _updateButtonDimensions(screenWidth);
    final localizedStrings = AppLocalizations.of(context);
    setState(() {
      _contactText = localizedStrings.translate('contact_us');
      _servicesText = localizedStrings.translate('services');
    });
  }

  void _updateButtonDimensions(double screenWidth) {
    final screenHeight = MediaQuery.of(context).size.height;
    final baseWidth = 375.0;
    final baseHeight = 642.0;
    final scale = screenWidth / baseWidth;
    final maxButtonWidth = 160.0;
    final baseButtonWidth = 120.0;

    setState(() {
      double scaledWidth = baseButtonWidth * scale;

      if (screenWidth >= 1800) {
        scaledWidth = scaledWidth * 0.30;
        _buttonSpacing = 14.0;
      } else if (screenWidth >= 1500) {
        scaledWidth = scaledWidth * 0.35;
        _buttonSpacing = 13.0;
      } else if (screenWidth >= 1200) {
        scaledWidth = scaledWidth * 0.40;
        _buttonSpacing = 12.0;
      } else if (screenWidth >= 1024) {
        scaledWidth = scaledWidth * 0.45;
        _buttonSpacing = 11.0;
      } else if (screenWidth >= 850) {
        scaledWidth = scaledWidth * 0.50;
        _buttonSpacing = 10.0;
      } else if (screenWidth >= 650) {
        scaledWidth = scaledWidth * 0.60;
        _buttonSpacing = 10.0;
      } else if (screenWidth >= 400) {
        scaledWidth = scaledWidth * 0.85;
        _buttonSpacing = 10.0;
      } else {
        scaledWidth = scaledWidth * 0.95;
        _buttonSpacing = 8.0;
      }

      _buttonWidth = scaledWidth.clamp(90.0, maxButtonWidth);
    });
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
    final buttonHeight = _buttonWidth * 0.30;

    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: isOutlined
              ? backgroundColor
              : (isHovering ? hoverColor : backgroundColor),
          borderRadius: BorderRadius.circular(buttonHeight / 2),
          border: Border.all(
            color: isOutlined
                ? (isHovering ? hoverColor : borderColor)
                : Colors.transparent,
            width: isOutlined ? 1.5 : 0.0,
          ),
          boxShadow: isHovering
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(buttonHeight / 2),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: buttonHeight * 0.25,
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAnimatedButton(
          text: _contactText,
          isHovering: _isHoveringContact,
          onEnter: () => setState(() => _isHoveringContact = true),
          onExit: () => setState(() => _isHoveringContact = false),
          onPressed: widget.onContactPressed,
          backgroundColor: const Color.fromARGB(255, 35, 81, 102),
          hoverColor: const Color.fromARGB(255, 45, 100, 125),
          textColor: Colors.white,
          fontSize: widget.fontSize,
        ),
        SizedBox(width: _buttonSpacing),
        _buildAnimatedButton(
          text: _servicesText,
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
}

class About extends StatefulWidget {
  final double fontSize;

  const About({
    Key? key,
    required this.fontSize,
  }) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> with SingleTickerProviderStateMixin {
  String _aboutText = '';
  late AnimationController _controller;
  Timer? _pauseTimer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _startAnimation();
  }

  void _startAnimation() {
    const animationDuration = Duration(milliseconds: 1500);
    const pauseDuration = Duration(seconds: 3);
    const fullCycleDuration = Duration(seconds: 5);

    void animate() {
      if (!mounted) return;
      setState(() => _isPaused = false);
      _controller.repeat();

      _pauseTimer = Timer(animationDuration, () {
        if (!mounted) return;
        setState(() => _isPaused = true);
        _controller.stop();
      });
    }

    // Primera animación
    animate();

    // Ciclo de animaciones
    _pauseTimer = Timer.periodic(fullCycleDuration, (_) {
      animate();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pauseTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _aboutText = AppLocalizations.of(context).translate('transform_ideas');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset:
                Offset(0, _isPaused ? 0 : sin(_controller.value * 3 * pi) * 10),
            child: AutoSizeText(
              _aboutText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: widget.fontSize * 0.9,
                height: 1.3,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.8),
                    offset: const Offset(0.5, 0.5),
                  ),
                ],
              ),
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}

class TitleDark extends StatefulWidget {
  final double fontSize;

  const TitleDark({
    Key? key,
    required this.fontSize,
  }) : super(key: key);

  @override
  _TitleDarkState createState() => _TitleDarkState();
}

class _TitleDarkState extends State<TitleDark> with AnimationControllerMixin {
  String _title = '';
  String _subtitle = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      startAnimation();
      startAnimationCycle();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizedStrings = AppLocalizations.of(context);
    setState(() {
      _title = localizedStrings.translate('transforming');
      _subtitle = localizedStrings.translate('ideas_into_digital_reality');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isAnimating) {
      return _buildStaticTitle();
    }
    return _buildAnimatedTitle();
  }

  Widget _buildStaticTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitleText(_title),
        const SizedBox(height: 12),
        _buildSubtitleText(_subtitle),
      ],
    );
  }

  Widget _buildAnimatedTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: WidgetAnimator(
            atRestEffect: WidgetRestingEffects.none(),
            child: TextAnimator(
              key: ValueKey('$_title$isAnimating'),
              _title,
              style: _getTitleStyle(),
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromRight(
                duration: kAnimationDuration,
                curve: Curves.linear,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: WidgetAnimator(
            atRestEffect: WidgetRestingEffects.none(),
            child: TextAnimator(
              key: ValueKey('$_subtitle$isAnimating'),
              _subtitle,
              style: _getSubtitleStyle(),
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(
                duration: kAnimationDuration,
                curve: Curves.linear,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: _getTitleStyle(),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitleText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: _getSubtitleStyle(),
        textAlign: TextAlign.center,
      ),
    );
  }

  TextStyle _getTitleStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: widget.fontSize * 0.9,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
      letterSpacing: 2.0,
      height: 1.1,
      shadows: _getTextShadows(),
    );
  }

  TextStyle _getSubtitleStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: widget.fontSize * 0.7,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
      letterSpacing: MediaQuery.of(context).size.width < 450 ? 1.5 : 2.0,
      height: 1.1,
      shadows: _getTextShadows(),
    );
  }

  List<Shadow> _getTextShadows() {
    return [
      Shadow(
        blurRadius: 10,
        color: Colors.white.withOpacity(0.8),
        offset: const Offset(0, 0),
      ),
      Shadow(
        blurRadius: 12,
        color: Colors.white.withOpacity(0.3),
        offset: const Offset(0, 0),
      ),
      Shadow(
        blurRadius: 1,
        color: Colors.black.withOpacity(0.7),
        offset: const Offset(0.2, 0.2),
      ),
    ];
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../language_provider.dart';
import '../lenguaje/localization.dart';

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
  String? _hoveredButton; // Almacena el botón que tiene el mouse encima

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = AppLocalizations.of(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.webp',
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const Text(
            'Dark Matter',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: screenWidth < 1200
          ? _buildPopupMenu(localizedStrings)
          : _buildDesktopMenu(localizedStrings),
    );
  }

  /// Menú en modo **Popup** para dispositivos con `width < 1200px`
  List<Widget> _buildPopupMenu(AppLocalizations localizedStrings) {
    return [
      PopupMenuButton<String>(
        icon: const Icon(Icons.menu, color: Colors.white),
        onSelected: (value) {
          switch (value) {
            case 'Home':
              widget.onTaphome();
              break;
            case 'Nosotros':
              widget.onTapAbout();
              break;
            case 'Servicios':
              widget.onTapServices();
              break;
            case 'Proyectos':
              widget.onTapProjects();
              break;
            case 'Contactos':
              widget.onTapContact();
              break;
            case 'Idioma':
              _showLanguageDialog();
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            _buildPopupMenuItem(
                localizedStrings.translate('home'), widget.onTaphome),
            _buildPopupMenuItem(
                localizedStrings.translate('about'), widget.onTapAbout),
            _buildPopupMenuItem(
                localizedStrings.translate('services'), widget.onTapServices),
            _buildPopupMenuItem(
                localizedStrings.translate('projects'), widget.onTapProjects),
            _buildPopupMenuItem(
                localizedStrings.translate('contact'), widget.onTapContact),
            _buildPopupMenuItem(
              localizedStrings.translate('language'),
              () {
                _showLanguageDialog();
              },
            ),
          ];
        },
      ),
    ];
  }

  /// Menú en **modo Desktop** para dispositivos con `width >= 1200px`
  List<Widget> _buildDesktopMenu(AppLocalizations localizedStrings) {
    return [
      _buildAnimatedButton(
          localizedStrings.translate('home'), widget.onTaphome),
      _buildAnimatedButton(
          localizedStrings.translate('about'), widget.onTapAbout),
      _buildAnimatedButton(
          localizedStrings.translate('services'), widget.onTapServices),
      _buildAnimatedButton(
          localizedStrings.translate('projects'), widget.onTapProjects),
      _buildAnimatedButton(
          localizedStrings.translate('contact'), widget.onTapContact),
      IconButton(
        icon: const Icon(Icons.language, color: Colors.white),
        onPressed: () {
          _showLanguageDialog();
        },
      ),
    ];
  }

  PopupMenuItem<String> _buildPopupMenuItem(String text, VoidCallback ontap) {
    return PopupMenuItem<String>(
      value: text,
      onTap: ontap,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildAnimatedButton(String text, VoidCallback onTap) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredButton = text),
      onExit: (_) => setState(() => _hoveredButton = null),
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
                width: _hoveredButton == text ? 40 : 0,
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final localizedStrings = AppLocalizations.of(context);
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            localizedStrings.translate('language'),
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'English',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .changeLanguage('en');
                  Navigator.of(context).pop();
                },
                tileColor: Provider.of<LanguageProvider>(context)
                            .currentLocale
                            .languageCode ==
                        'en'
                    ? Colors.purpleAccent.withOpacity(0.2)
                    : null,
              ),
              ListTile(
                title: const Text(
                  'Español',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .changeLanguage('es');
                  Navigator.of(context).pop();
                },
                tileColor: Provider.of<LanguageProvider>(context)
                            .currentLocale
                            .languageCode ==
                        'es'
                    ? Colors.purpleAccent.withOpacity(0.2)
                    : null,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }
}

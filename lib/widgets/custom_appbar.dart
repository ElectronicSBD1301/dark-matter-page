import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTapAbout;
  final VoidCallback onTapServices;
  final VoidCallback onTapProjects;
  final VoidCallback onTapContact;

  const CustomAppBar({
    Key? key,
    required this.onTapAbout,
    required this.onTapServices,
    required this.onTapProjects,
    required this.onTapContact,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const Text('Dark Matter'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onTapAbout,
          child: const Text('Home', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onTapAbout,
          child: const Text('Nosotros', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onTapContact,
          child: const Text('Contactos', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onTapServices,
          child: const Text('Servicios', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onTapProjects,
          child: const Text('Proyectos', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

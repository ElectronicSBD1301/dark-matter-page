import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Info de contacto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/logo.png', width: 40, height: 40),
                  const SizedBox(width: 8),
                  const Text(
                    'Gestionado por Dark Matter',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.phone, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    '+1 829-362-4805',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: const [
                  Icon(Icons.email, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'wa.darkmattercode@gmail.com',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                '© 2024 Dark Matter. All rights reserved.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              )
            ],
          ),

          // Redes sociales
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '¿Quieres iniciar un proyecto juntos?\nHablemos',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 8),
              const Text(
                'Síguenos en redes:',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/images/linkedin.png', width: 30),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/images/instagram.png', width: 30),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/images/tiktok.png', width: 30),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

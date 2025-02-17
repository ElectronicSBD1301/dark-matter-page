import 'package:dark_matter_page/home/componet/hero_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatelessWidget {
  final double? height;

  const CustomFooter({super.key, this.height});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          height, // Usar el valor de height si se proporciona, de lo contrario usar 100
      padding: const EdgeInsets.all(28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildContactInfo(isMobile),
                        _buildSocialSection(isMobile, context),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildContactInfo(isMobile),
                    _buildSocialSection(isMobile, context),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildContactInfo(bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
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
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: const [
            Icon(Icons.phone, color: Colors.white),
            SizedBox(width: 8),
            Text('+1 829-362-4805', style: TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: const [
            Icon(Icons.email, color: Colors.white),
            SizedBox(width: 8),
            Text('wa.darkmattercode@gmail.com',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          '© 2024 Dark Matter. All rights reserved.',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSocialSection(bool isMobile, BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () => showContactForm(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Hablemos',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        const SizedBox(height: 8),
        const Text('Síguenos en redes:',
            style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () =>
                  _launchURL('https://www.linkedin.com/company/darkmattercode'),
              icon: Image.asset('assets/images/linkedin.png', width: 30),
            ),
            IconButton(
              onPressed: () =>
                  _launchURL('https://www.instagram.com/darkmattercode'),
              icon: Image.asset('assets/images/instagram.png', width: 30),
            ),
            IconButton(
              onPressed: () =>
                  _launchURL('https://www.tiktok.com/@darkmattercode'),
              icon: Image.asset('assets/images/tiktok.png', width: 30),
            ),
          ],
        ),
      ],
    );
  }
}

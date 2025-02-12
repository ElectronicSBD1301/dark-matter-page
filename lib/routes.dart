import 'package:dark_matter_page/pages/services_pages.dart';
import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'pages/about_page.dart';
import 'pages/projects_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case '/services':
        return MaterialPageRoute(builder: (_) => const ServicesPage());
      case '/projects':
        return MaterialPageRoute(builder: (_) => const ProjectsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Página no encontrada')),
          ),
        );
    }
  }
}

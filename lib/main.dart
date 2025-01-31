import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const DarkMatterApp());
}

class DarkMatterApp extends StatelessWidget {
  const DarkMatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Matter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        // Ejemplo: podrías sobreescribir colores, tipografías, etc.
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Roboto', // O configura google_fonts en cada widget
            ),
      ),
      // Usa un RouteGenerator personalizado
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
    );
  }
}

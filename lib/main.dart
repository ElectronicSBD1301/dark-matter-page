import 'package:dark_matter_page/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // 🔥 Inicializa Firebase

  runApp(const DarkMatterApp());
}

class DarkMatterApp extends StatelessWidget {
  const DarkMatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
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

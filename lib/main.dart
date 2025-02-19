import 'package:dark_matter_page/firebase_options.dart';
import 'package:dark_matter_page/language_provider.dart';
import 'package:dark_matter_page/lenguaje/localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // 🔥 Inicializa Firebase

  runApp(ChangeNotifierProvider(
      create: (context) => LanguageProvider(), child: DarkMatterApp()));
}

class DarkMatterApp extends StatelessWidget {
  const DarkMatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          color: Colors.black,
          title: 'Dark Matter',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: languageProvider.currentLocale, // Usar el locale del provider
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Roboto',
                ),
          ),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/',
        );
      },
    );
  }
}

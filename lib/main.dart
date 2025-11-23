import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/theme.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/theory_screen.dart';
import 'screens/result_screen.dart';
import 'screens/resources_screen.dart';

// Si necesitas el tipo para castear argumentos:
import 'services/feedback_engine.dart'; // define FeedbackResult

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Modo pantalla completa (oculta status/nav bars; aparecen al deslizar)
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Barras transparentes cuando aparezcan temporalmente
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const LideratApp());
}

class LideratApp extends StatelessWidget {
  const LideratApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LideratApp',
      theme: buildTheme(),
      debugShowCheckedModeBanner: false,

      // Pantalla inicial
      initialRoute: '/',

      // Rutas básicas sin /result (lo resolvemos en onGenerateRoute)
      routes: {
        '/': (_) => const HomeScreen(),
        '/quiz': (_) => const QuizScreen(),
        '/theory': (_) => const TheoryScreen(),
        '/resources': (_) => const ResourcesScreen(),
      },

      // Rutas que requieren argumentos o lógicas personalizadas
      onGenerateRoute: (settings) {
        if (settings.name == '/result') {
          final args = settings.arguments;
          if (args is FeedbackResult) {
            return MaterialPageRoute(
              builder: (_) => ResultScreen(result: args),
              settings: settings,
            );
          }
          // Si no llegaron argumentos válidos, mostramos un aviso amigable:
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Resultados')),
              body: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No se recibieron resultados.\n'
                        'Vuelve al cuestionario y finaliza para ver esta pantalla.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            settings: settings,
          );
        }
        return null; // deja que onUnknownRoute maneje lo demás
      },

      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: settings,
      ),
    );
  }
}

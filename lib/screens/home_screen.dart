import 'package:flutter/material.dart';
import '../ui/gradient_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bloque de textos centrado verticalmente
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // centra vertical
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Text(
                    'Bienvenido a Lideratapp',
                    textAlign: TextAlign.center, // centra horizontal
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Evaluación de estilo de liderazgo, teoría offline y recursos web.',
                    textAlign: TextAlign.center, // centra horizontal
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),

            // Botones en la parte inferior
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/quiz'),
              child: const Text('Cuestionario principal'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/theory'),
              child: const Text('Contenido teórico'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/resources'),
              child: const Text('Recursos adicionales'),
            ),
          ],
        ),
      ),

      // Paleta de esta pantalla
      gradientColors: const [Color(0xFF121C3D), Color(0xFF2D6CCB)],
      watermarkOpacity: 0.06,
      blurSigma: 12,
      watermarkWidthFactor: 0.75,
    );
  }
}

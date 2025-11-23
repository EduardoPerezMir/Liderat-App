import 'package:flutter/material.dart';
import '../services/feedback_engine.dart';
import '../models/leadership_style.dart';
import 'home_screen.dart';
import '../ui/gradient_scaffold.dart';

class ResultScreen extends StatelessWidget {
  final FeedbackResult result;
  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text("Resultados"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Estilo predominante: ${styleName(result.dominant)}",
              style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.summary,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _section("Fortalezas", result.strengths),
            _section("Riesgos", result.risks),
            _section("Sugerencias personalizadas", result.suggestions),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false,
              ),
              icon: const Icon(Icons.home),
              label: const Text("Volver al inicio"),
            ),
          ],
        ),
      ),
      // mismos parámetros visuales que en las otras pantallas
      gradientColors: const [Color(0xFF0E6FFF), Color(0xFF6EC8FF)],
      watermarkAsset: 'assets/images/logo.png',
      watermarkOpacity: 0.06,
      blurSigma: 12,
      watermarkWidthFactor: 0.75,
    );
  }

  Widget _section(String title, List<String> items) => Card(
    color: Colors.white,
    elevation: 1.5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...items.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• "),
                  Expanded(child: Text(e)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

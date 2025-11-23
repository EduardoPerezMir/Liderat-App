import 'package:flutter/material.dart';
import '../models/msq_item.dart';
import '../services/msq_loader.dart';
import '../services/msq_scoring.dart';
import '../services/feedback_bridge.dart';
import '../ui/gradient_scaffold.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  MsqSchema? _schema;
  String? _error;
  final Map<String, int> _answers = {};        // itemId -> 1..5
  List<MsqItem> _ordered = const [];           // orden aleatorio estable

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _schema = null; _error = null; _ordered = const []; });
    const path = 'assets/msq_test/items_es.json';
    try {
      final s = await MsqLoader.loadFromAsset(path);
      if (!mounted) return;
      final shuffled = [...s.items]..shuffle();  // mezcla una vez
      setState(() {
        _schema = s;
        _ordered = shuffled;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Error cargando cuestionario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando cuestionario: $e')),
      );
    }
  }

  void _finish() {
    final schema = _schema!;
    final scores = scoreMsq(schema: schema, answers: _answers);
    final fb = msqToFeedback(scores);
    Navigator.pushNamedAndRemoveUntil(
      context, '/result', (route) => false, arguments: fb,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return GradientScaffold(
        appBar: AppBar(title: const Text('Cuestionario')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(color: Colors.white, child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_error!, style: const TextStyle(fontFamily: 'monospace')),
          )),
        ),
        gradientColors: const [Color(0xFF0E6FFF), Color(0xFF6EC8FF)],
      );
    }

    final schema = _schema;
    if (schema == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final total = _ordered.length;
    final answered = _answers.length.clamp(0, total);
    final progress = total == 0 ? 0.0 : answered / total;

    const legendTextColor = Colors.black87;

    return GradientScaffold(
      appBar: AppBar(title: const Text("Test de Liderazgo")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: total + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 12),
                Text("Progreso: $answered / $total",
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8, runSpacing: -6,
                  children: schema.labels.map((e) => Chip(
                    label: Text(e, style: const TextStyle(
                      color: legendTextColor, fontWeight: FontWeight.w600)),
                    backgroundColor: Colors.white,
                  )).toList(),
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          final item = _ordered[index - 1];
          final sel = _answers[item.id];
          final shownNumber = index; // 1..N (porque index==0 es el header)

          return Card(
            color: Colors.white, elevation: 1.5, margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Enumeración visible según orden mezclado
                Text("$shownNumber. ${item.text}",
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: List.generate(schema.scaleMax - schema.scaleMin + 1, (i) {
                    final v = schema.scaleMin + i; // 1..5
                    final selected = sel == v;
                    return ChoiceChip(
                      label: Text("$v", style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      )),
                      selected: selected,
                      onSelected: (_) => setState(() => _answers[item.id] = v),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black12),
                      ),
                    );
                  }),
                ),
              ]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _answers.length == total ? _finish : null,
        icon: const Icon(Icons.check),
        label: const Text("Ver resultados"),
      ),
      gradientColors: const [Color(0xFF0E6FFF), Color(0xFF6EC8FF)],
      watermarkAsset: 'assets/images/logo.png',
      watermarkOpacity: 0.06,
      blurSigma: 12,
      watermarkWidthFactor: 0.75,
    );
  }
}

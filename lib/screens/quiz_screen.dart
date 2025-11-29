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

  // estado del cuestionario
  final Map<String, int> _answers = {}; // itemId -> 1..5
  List<MsqItem> _ordered = const [];    // orden aleatorio estable

  // paginación
  final int pageSize = 5;               // <-- cambia el tamaño de página aquí
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _schema = null; _error = null; _ordered = const []; _page = 0; });
    const path = 'assets/msq_test/items_es.json';
    try {
      final s = await MsqLoader.loadFromAsset(path);
      if (!mounted) return;
      final shuffled = [...s.items]..shuffle(); // mezcla una vez
      setState(() {
        _schema = s;
        _ordered = shuffled;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Error cargando cuestionario: $e');
    }
  }

  void _finish() {
    final schema = _schema!;
    final scores = scoreMsq(schema: schema, answers: _answers);
    final fb = msqToFeedback(scores);
    Navigator.pushNamedAndRemoveUntil(context, '/result', (route) => false, arguments: fb);
  }

  // helpers de paginación
  int get _total => _ordered.length;
  int get _pageCount => _total == 0 ? 1 : ((_total + pageSize - 1) ~/ pageSize);
  int get _startIndex => _page * pageSize;
  int get _endIndex => (_startIndex + pageSize).clamp(0, _total);
  List<MsqItem> get _pageItems => _ordered.sublist(_startIndex, _endIndex);
  bool get _isLastPage => _page == _pageCount - 1;
  bool get _isFirstPage => _page == 0;

  bool get _currentPageComplete {
    for (final it in _pageItems) {
      if (!_answers.containsKey(it.id)) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return GradientScaffold(
        appBar: AppBar(title: const Text('Cuestionario')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, style: const TextStyle(fontFamily: 'monospace')),
            ),
          ),
        ),
        gradientColors: const [Color(0xFF0E6FFF), Color(0xFF6EC8FF)],
      );
    }

    final schema = _schema;
    if (schema == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final answered = _answers.length.clamp(0, _total);
    final progress = _total == 0 ? 0.0 : answered / _total;

    // helper para mapear valor -> etiqueta (ej: "1 Nunca")
    String labelFor(int val) {
      final idx = val - schema.scaleMin;
      if (idx >= 0 && idx < schema.labels.length) return schema.labels[idx];
      return "$val";
    }

    return GradientScaffold(
      appBar: AppBar(
        title: const Text("Test de Liderazgo"),
        actions: [
          IconButton(
            tooltip: 'Re-mezclar',
            icon: const Icon(Icons.shuffle),
            onPressed: () => setState(() {
              _ordered = [..._ordered]..shuffle();
              _page = 0;
            }),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header con progreso (sin leyenda global)
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 12),
          Text(
            "Progreso: $answered / $_total • Página ${_page + 1} / $_pageCount",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Ítems de la página
          ...List.generate(_pageItems.length, (i) {
            final item = _pageItems[i];
            final sel = _answers[item.id];
            final shownNumber = _startIndex + i + 1; // 1..N

            return Card(
              color: Colors.white,
              elevation: 1.5,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$shownNumber. ${item.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),

                    // Opciones 1..5 con RadioListTile y texto pequeño
                    ListTileTheme(
                      dense: true,
                      horizontalTitleGap: 8,
                      minLeadingWidth: 0,
                      child: Column(
                        children: List.generate(
                          schema.scaleMax - schema.scaleMin + 1,
                              (k) {
                            final v = schema.scaleMin + k; // 1..5
                            return RadioListTile<int>(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets.zero,
                              value: v,
                              groupValue: sel,
                              onChanged: (nv) => setState(() => _answers[item.id] = nv!),
                              title: Text(
                                labelFor(v), // "1 Nunca", "2 Rara vez", ...
                                style: const TextStyle(fontSize: 13),
                              ),

                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 8),
          // Navegación de páginas
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isFirstPage ? null : () => setState(() => _page--),
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Anterior'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: !_currentPageComplete
                      ? null
                      : _isLastPage
                      ? _finish
                      : () => setState(() => _page++),
                  icon: Icon(_isLastPage ? Icons.check : Icons.chevron_right),
                  label: Text(_isLastPage ? 'Finalizar' : 'Siguiente'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
      gradientColors: const [Color(0xFF0E6FFF), Color(0xFF6EC8FF)],
      watermarkAsset: 'assets/images/logo.png',
      watermarkOpacity: 0.06,
      blurSigma: 12,
      watermarkWidthFactor: 0.75,
    );
  }
}

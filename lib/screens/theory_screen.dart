import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../data/theory_pages.dart';

class TheoryScreen extends StatefulWidget {
  const TheoryScreen({super.key});
  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  int idx = 0;
  String content = "";
  int _loadId = 0; // para evitar carreras

  // --- NUEVO: escala de fuente ---
  double _scale = 1.0; // 1.0 = base
  static const double _minScale = 0.8;
  static const double _maxScale = 1.8;
  void _fontSmaller() => setState(() => _scale = (_scale - 0.1).clamp(_minScale, _maxScale));
  void _fontBigger() => setState(() => _scale = (_scale + 0.1).clamp(_minScale, _maxScale));
  void _fontReset() => setState(() => _scale = 1.0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final myId = ++_loadId;
    setState(() => content = "");
    final path = theoryPages[idx].assetPath;

    try {
      final data = await rootBundle.loadString(path);
      if (!mounted || myId != _loadId) return;
      setState(() => content = data);
    } catch (e) {
      if (!mounted || myId != _loadId) return;
      setState(() => content = "# Error\nNo se pudo cargar: `$path`\n\n$e");
    }
  }

  void _prev() {
    if (idx > 0) {
      setState(() => idx--);
      _load();
    }
  }

  void _next() {
    if (idx < theoryPages.length - 1) {
      setState(() => idx++);
      _load();
    }
  }

  Future<void> _openIndex() async {
    // Muestra un modal con la lista de páginas. Al seleccionar, actualiza idx y carga.
    final chosen = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.3,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.menu_book, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Índice de contenidos', style: TextStyle(fontWeight: FontWeight.bold))),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: theoryPages.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final p = theoryPages[i];
                        final selected = i == idx;
                        return ListTile(
                          selected: selected,
                          selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                          leading: CircleAvatar(child: Text('${i + 1}')),
                          title: Text(
                            p.title,
                            style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w600),
                          ),
                          // Si quieres contexto rápido mostramos la ruta del asset como subtítulo ligera.
                          subtitle: p.assetPath.isNotEmpty
                              ? Text(p.assetPath, style: const TextStyle(fontSize: 12, color: Colors.black54))
                              : null,
                          trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
                          onTap: () => Navigator.of(context).pop(i),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (chosen != null && chosen != idx) {
      setState(() => idx = chosen);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = theoryPages[idx];

    // estilos (mantén los que ya tenías si los cambiaste)
    final tt = Theme.of(context).textTheme;
    final sheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: tt.bodyMedium?.copyWith(fontSize: 16 * _scale, height: 1.45),
      h1: tt.headlineSmall?.copyWith(fontSize: 26 * _scale, fontWeight: FontWeight.bold),
      h2: tt.titleLarge?.copyWith(fontSize: 22 * _scale, fontWeight: FontWeight.bold),
      h3: tt.titleMedium?.copyWith(fontSize: 20 * _scale, fontWeight: FontWeight.w600),
      h4: tt.titleSmall?.copyWith(fontSize: 18 * _scale, fontWeight: FontWeight.w600),
      listBullet: tt.bodyMedium?.copyWith(fontSize: 16 * _scale),
      code: tt.bodyMedium?.copyWith(
        fontFamily: 'monospace',
        fontSize: 14 * _scale,
        backgroundColor: Colors.black,
      ),
      blockquote: tt.bodyMedium?.copyWith(
        fontStyle: FontStyle.italic,
        fontSize: 16 * _scale,
        color: Colors.black87,
      ),
      blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      blockquoteDecoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Colors.black26, width: 3)),
      ),
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black26)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white, // fondo blanco
      appBar: AppBar(
        title: Text(page.title),
        actions: [
          IconButton(onPressed: _openIndex, icon: const Icon(Icons.list)), // <-- índice
          IconButton(onPressed: _fontSmaller, icon: const Icon(Icons.text_decrease)),
          Center(child: Text("${_scale.toStringAsFixed(1)}x")),
          IconButton(onPressed: _fontBigger, icon: const Icon(Icons.text_increase)),
          IconButton(onPressed: _fontReset, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Stack(
        children: [
          // Watermark centrado, difuminado y con baja opacidad
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Opacity(
                  opacity: 0.06,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: LayoutBuilder(
                      builder: (context, c) => Image.asset(
                        'assets/images/logo.png',
                        width: c.maxWidth * 0.65, // tamaño relativo
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Contenido
          if (content.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            Markdown(
              key: ValueKey(page.assetPath),
              data: content,
              padding: const EdgeInsets.all(16),
              styleSheet: sheet,
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: idx > 0 ? _prev : null, child: const Text("Anterior")),
              TextButton(onPressed: _openIndex, child: Text("${idx + 1}/${theoryPages.length}  •  Ver índice")),
              TextButton(onPressed: idx < theoryPages.length - 1 ? _next : null, child: const Text("Siguiente")),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LegendScale extends StatelessWidget {
  final List<String> labels;
  final EdgeInsets padding;
  final String title;

  const LegendScale({
    super.key,
    required this.labels,
    this.padding = const EdgeInsets.all(12),
    this.title = 'Opciones de escala',
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    return Card(
      color: Colors.white,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            // usamos Wrap para que haga salto de línea en pantallas pequeñas
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: List.generate(labels.length, (i) {
                // Radio "deshabilitado" solo para look de referencia
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // groupValue null => ninguno seleccionado; onChanged null => disabled
                    Radio<int>(value: i, groupValue: null, onChanged: null),
                    Text(labels[i], style: textStyle),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

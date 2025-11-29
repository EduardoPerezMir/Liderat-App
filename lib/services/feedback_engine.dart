import '../models/leadership_style.dart';

class FeedbackResult {
  final LeadershipStyle dominant;
  final Map<LeadershipStyle, int> scores;
  final String summary;
  final List<String> strengths;
  final List<String> risks;
  final List<String> suggestions;
  final List<String> explanations; // breve explicación por factor

  FeedbackResult({
    required this.dominant,
    required this.scores,
    required this.summary,
    required this.strengths,
    required this.risks,
    required this.suggestions,
    required this.explanations,
  });
}

// prioridad estable para desempates (si dos estilos empatan, gana el primero en esta lista)
const List<LeadershipStyle> _tiePriority = [
  LeadershipStyle.transformational,
  LeadershipStyle.democratic,
  LeadershipStyle.coaching,
  LeadershipStyle.autocratic,
  LeadershipStyle.laissezFaire,
];

LeadershipStyle _resolveTie(List<LeadershipStyle> tied) {
  for (final p in _tiePriority) {
    if (tied.contains(p)) return p;
  }
  return tied.first;
}

LeadershipStyle _maxStyle(Map<LeadershipStyle, int> scores) {
  if (scores.isEmpty) {
    return LeadershipStyle.democratic; // fallback razonable
  }
  final maxValue = scores.values.reduce((a, b) => a > b ? a : b);
  final tied = scores.entries.where((e) => e.value == maxValue).map((e) => e.key).toList();
  if (tied.length == 1) return tied.first;
  return _resolveTie(tied);
}

/// Normaliza puntajes a 0..1 con base en el máximo observado (evita dividir por zero)
Map<LeadershipStyle, double> _normalize(Map<LeadershipStyle, int> scores) {
  final max = scores.values.isEmpty ? 1 : scores.values.reduce((a, b) => a > b ? a : b);
  if (max == 0) {
    return {for (final k in scores.keys) k: 0.0};
  }
  return {for (final e in scores.entries) e.key: e.value / max};
}

String _styleLabel(LeadershipStyle s) {
  // Reusa la función existente si la tienes; si no, adapta aquí.
  return styleName(s);
}

FeedbackResult generateFeedback(Map<LeadershipStyle, int> scores) {
  // Defensive copy
  final Map<LeadershipStyle, int> sc = Map.from(scores);

  // determinamos dominante y normalizamos
  final dominant = _maxStyle(sc);
  final normalized = _normalize(sc);

  // fuerza de la dominancia (relación entre dominante y segundo)
  final sorted = sc.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  final top = sorted.isNotEmpty ? sorted[0].value.toDouble() : 0.0;
  final second = sorted.length > 1 ? sorted[1].value.toDouble() : 0.0;
  final dominanceRatio = (second == 0) ? (top == 0 ? 0.0 : 1.0) : (top / second);

  // categorización simple
  final String dominanceLevel;
  if (top == 0) {
    dominanceLevel = 'sin evidencia clara de preferencia';
  } else if (dominanceRatio >= 1.6) {
    dominanceLevel = 'predominante fuerte';
  } else if (dominanceRatio >= 1.15) {
    dominanceLevel = 'moderadamente predominante';
  } else {
    dominanceLevel = 'perfil equilibrado';
  }

  // Resumen natural
  final summary = () {
    if (top == 0) {
      return 'No hubo respuestas suficientes que indiquen un estilo predominante. Revisa las respuestas o repite el cuestionario.';
    }
    final s1 = 'Tu estilo más presente es ${_styleLabel(dominant)} ($dominanceLevel).';
    final s2 = (dominanceLevel == 'perfil equilibrado')
        ? ' Muestras una mezcla de estilos: considera aplicar prácticas situacionales según el contexto.'
        : ' Puedes potenciar tu impacto manteniendo las fortalezas y atenuando los riesgos identificados.';
    return '$s1$s2';
  }();

  // Explicaciones breves por estilo (para mostrar si el usuario lo solicita)
  final explanations = <String>[];
  for (final style in LeadershipStyle.values) {
    final pct = (normalized[style] ?? 0.0);
    final desc = switch (style) {
      LeadershipStyle.transformational => 'Enfoque inspirador, orientado a visión y cambio.',
      LeadershipStyle.democratic => 'Enfoque participativo, busca consenso y colaboración.',
      LeadershipStyle.coaching => 'Enfoque en desarrollo individual y aprendizaje continuo.',
      LeadershipStyle.autocratic => 'Enfoque directivo: decisiones rápidas y control operativo.',
      LeadershipStyle.laissezFaire => 'Enfoque de alta autonomía, mínima intervención del líder.',
    };
    explanations.add('${_styleLabel(style)}: $desc (presencia relativa: ${(pct * 100).round()}%)');
  }

  // Fortalezas / riesgos / sugerencias por estilo dominante (más concretas y accionables)
  final strengths = <String>[];
  final risks = <String>[];
  final suggestions = <String>[];

  switch (dominant) {
    case LeadershipStyle.transformational:
      strengths.addAll([
        'Capacidad para movilizar al equipo hacia metas inspiradoras.',
        'Habilidad para fomentar innovación y cambio.',
      ]);
      risks.addAll([
        'Riesgo de falta de concreción operativa si no hay procesos claros.',
        'Posible sobrecarga al equipo por objetivos muy ambiciosos.',
      ]);
      suggestions.addAll([
        'Traducir la visión en objetivos trimestrales medibles (OKRs).',
        'Establecer ritos cortos: daily + revisión de hitos para mantener foco.',
        'Asignar responsables claros para cada iniciativa transformadora.',
      ]);
      break;

    case LeadershipStyle.democratic:
      strengths.addAll([
        'Genera compromiso y aprovecha la inteligencia colectiva.',
        'Mejora la aceptación de decisiones al ser cocreadas.',
      ]);
      risks.addAll([
        'Decisiones más lentas cuando falta urgencia.',
        'Difusión de responsabilidades si no hay roles claros.',
      ]);
      suggestions.addAll([
        'Definir ventanas de decisión: reunir opiniones en X horas y decidir.',
        'Usar técnicas de decisión rápida (p. ej., dot-voting) en reuniones largas.',
        'Asignar un responsable final cuando la decisión sea crítica.',
      ]);
      break;

    case LeadershipStyle.coaching:
      strengths.addAll([
        'Potencia crecimiento y autonomía de miembros del equipo.',
        'Mejora retención y desarrollo de talento a largo plazo.',
      ]);
      risks.addAll([
        'Puede ralentizar respuestas en situaciones de crisis.',
        'Riesgo de crear dependencia si no se fijan límites temporales.',
      ]);
      suggestions.addAll([
        'Programa 1:1 semanales con objetivos SMART y seguimiento.',
        'Combinar coaching con intervenciones directivas en plazos críticos.',
        'Usar micro-feedback (2–3 sugerencias concretas por sesión).',
      ]);
      break;

    case LeadershipStyle.autocratic:
      strengths.addAll([
        'Toma decisiones rápidas y reduce ambigüedad en crisis.',
        'Mantiene control sobre calidad y cumplimiento.',
      ]);
      risks.addAll([
        'Baja participación y posible desmotivación del equipo.',
        'Menor creatividad al reducir la aportación diversa.',
      ]);
      suggestions.addAll([
        'Explicar el propósito detrás de decisiones importantes (comunicación breve).',
        'Reservar momentos para recoger feedback post-decisiones.',
        'Delegar pequeñas decisiones rutinarias para aumentar autonomía.',
      ]);
      break;

    case LeadershipStyle.laissezFaire:
      strengths.addAll([
        'Fomenta autonomía y posibilidades de experimentación.',
        'Puede aumentar creatividad en equipos maduros.',
      ]);
      risks.addAll([
        'Descoordinación si no hay seguimiento.',
        'Algunos miembros pueden sentirse desorientados sin guía.',
      ]);
      suggestions.addAll([
        'Implementar checkpoints ligeros (cada X días) para revisar avances.',
        'Definir entregables mínimos y canales claros de escalamiento.',
        'Designar puntos de contacto para dudas urgentes.',
      ]);
      break;
  }

  // Añadir sugerencia de balance si hay estilos con presencia opuesta
  if (sc.isNotEmpty) {
    final weakestEntry = sc.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
    suggestions.add('Considera combinar ${_styleLabel(dominant)} con prácticas de ${_styleLabel(weakestEntry)} según la situación.');
  }

  return FeedbackResult(
    dominant: dominant,
    scores: sc,
    summary: summary,
    strengths: strengths,
    risks: risks,
    suggestions: suggestions,
    explanations: explanations,
  );
}

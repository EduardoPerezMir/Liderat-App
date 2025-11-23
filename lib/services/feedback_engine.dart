import '../models/leadership_style.dart';

class FeedbackResult {
  final LeadershipStyle dominant;
  final Map<LeadershipStyle, int> scores;
  final String summary;
  final List<String> strengths;
  final List<String> risks;
  final List<String> suggestions;
  FeedbackResult({
    required this.dominant,
    required this.scores,
    required this.summary,
    required this.strengths,
    required this.risks,
    required this.suggestions,
  });
}

LeadershipStyle _maxStyle(Map<LeadershipStyle, int> scores) =>
  scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

FeedbackResult generateFeedback(Map<LeadershipStyle, int> scores) {
  final dominant = _maxStyle(scores);
  final strengths = <String>[];
  final risks = <String>[];
  final suggestions = <String>[];

  void addCommonBalance() {
    final weaker = scores.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
    suggestions.add("Equilibra ${styleName(dominant)} con prácticas de ${styleName(weaker)} cuando el contexto lo requiera.");
  }

  switch (dominant) {
    case LeadershipStyle.autocratic:
      strengths.addAll(["Decisión rápida", "Claridad bajo presión"]);
      risks.addAll(["Baja participación", "Menos creatividad"]);
      suggestions.addAll(["Usa dirección fuerte sólo en crisis", "Explica el ‘por qué’"]);
      break;
    case LeadershipStyle.democratic:
      strengths.addAll(["Compromiso del equipo", "Mejor información"]);
      risks.addAll(["Lentitud por consulta", "Dilución de responsabilidades"]);
      suggestions.addAll(["Ventanas de decisión", "En urgencias reduce consulta"]);
      break;
    case LeadershipStyle.transformational:
      strengths.addAll(["Visión y propósito", "Cambio continuo"]);
      risks.addAll(["Fatiga por ambición", "Falta de procesos"]);
      suggestions.addAll(["Visión → planes medibles", "Celebra hitos"]);
      break;
    case LeadershipStyle.laissezFaire:
      strengths.addAll(["Autonomía", "Creatividad"]);
      risks.addAll(["Descoordinación", "Detección tardía"]);
      suggestions.addAll(["Checkpoints ligeros", "Escalamiento claro"]);
      break;
    case LeadershipStyle.coaching:
      strengths.addAll(["Desarrollo de talento", "Mejora sostenible"]);
      risks.addAll(["Lentitud en crisis", "Dependencia"]);
      suggestions.addAll(["Alterna coaching con dirección", "Limita tiempos"]);
      break;
  }
  addCommonBalance();

  final summary = "${scores.entries.map((e) => "${styleName(e.key)}=${e.value}").join(", ")}.";

  return FeedbackResult(
    dominant: dominant,
    scores: scores,
    summary: summary,
    strengths: strengths,
    risks: risks,
    suggestions: suggestions,
  );
}


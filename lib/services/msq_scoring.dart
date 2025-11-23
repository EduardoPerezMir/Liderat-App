import '../models/msq_item.dart';

class MsqScores {
  final Map<String, double> factorMeans; // key -> promedio 1..5
  MsqScores(this.factorMeans);
}

MsqScores scoreMsq({
  required MsqSchema schema,
  required Map<String, int> answers, // itemId -> 1..5
}) {
  final sums = <String, int>{};
  final counts = <String, int>{};

  for (final it in schema.items) {
    final v = answers[it.id];
    if (v == null) continue;
    final val = it.reverse ? (schema.scaleMax + schema.scaleMin - v) : v;
    sums[it.factor] = (sums[it.factor] ?? 0) + val;
    counts[it.factor] = (counts[it.factor] ?? 0) + 1;
  }

  final means = <String, double>{};
  for (final f in schema.factors) {
    final c = counts[f.key] ?? 0;
    means[f.key] = c == 0 ? 0.0 : (sums[f.key]! / c);
  }
  return MsqScores(means);
}

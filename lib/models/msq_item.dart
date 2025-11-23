class MsqItem {
  final String id;
  final String text;
  final String factor;
  final bool reverse;

  MsqItem({
    required this.id,
    required this.text,
    required this.factor,
    required this.reverse,
  });

  factory MsqItem.fromMap(Map<String, dynamic> m) => MsqItem(
    id: m['id'] as String,
    text: m['text'] as String,
    factor: m['factor'] as String,
    reverse: (m['reverse'] ?? false) as bool,
  );
}

class MsqFactor {
  final String key;
  final String label;
  MsqFactor({required this.key, required this.label});

  factory MsqFactor.fromMap(Map<String, dynamic> m) =>
      MsqFactor(key: m['key'] as String, label: m['label'] as String);
}

class MsqSchema {
  final String title;
  final int scaleMin;
  final int scaleMax;
  final List<String> labels;
  final List<MsqItem> items;
  final List<MsqFactor> factors;

  MsqSchema({
    required this.title,
    required this.scaleMin,
    required this.scaleMax,
    required this.labels,
    required this.items,
    required this.factors,
  });

  factory MsqSchema.fromMap(Map<String, dynamic> m) => MsqSchema(
    title: m['title'] as String,
    scaleMin: m['scale_min'] as int,
    scaleMax: m['scale_max'] as int,
    labels: (m['labels'] as List).map((e) => e.toString()).toList(),
    items: (m['items'] as List)
        .map((e) => MsqItem.fromMap(e as Map<String, dynamic>))
        .toList(),
    factors: (m['factors'] as List)
        .map((e) => MsqFactor.fromMap(e as Map<String, dynamic>))
        .toList(),
  );
}

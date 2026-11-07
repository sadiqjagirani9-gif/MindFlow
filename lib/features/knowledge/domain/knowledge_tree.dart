class KnowledgeNodeDraft {
  const KnowledgeNodeDraft({
    required this.title,
    this.summary = '',
    this.coreConcept = '',
    this.principle = '',
    this.mechanism = '',
    this.methods = '',
    this.application = '',
    this.learningValue = '',
    this.content = '',
    this.children = const [],
  });

  final String title;
  final String summary;
  final String coreConcept;
  final String principle;
  final String mechanism;
  final String methods;
  final String application;
  final String learningValue;
  final String content;
  final List<KnowledgeNodeDraft> children;

  factory KnowledgeNodeDraft.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'];
    return KnowledgeNodeDraft(
      title: _string(json, 'title'),
      summary: _string(json, 'summary'),
      coreConcept: _string(json, 'coreConcept'),
      principle: _string(json, 'principle'),
      mechanism: _string(json, 'mechanism'),
      methods: _string(json, 'methods'),
      application: _string(json, 'application'),
      learningValue: _string(json, 'learningValue'),
      content: _string(json, 'content'),
      children: rawChildren is List
          ? rawChildren
                .whereType<Map>()
                .map(
                  (item) => KnowledgeNodeDraft.fromJson(
                    item.map((key, value) => MapEntry(key.toString(), value)),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }

  Map<String, Object?> toJson() => {
    'title': title,
    'summary': summary,
    'coreConcept': coreConcept,
    'principle': principle,
    'mechanism': mechanism,
    'methods': methods,
    'application': application,
    'learningValue': learningValue,
    'content': content,
    'children': children.map((item) => item.toJson()).toList(),
  };
}

String _string(Map<String, dynamic> json, String key) =>
    json[key] is String ? (json[key] as String).trim() : '';

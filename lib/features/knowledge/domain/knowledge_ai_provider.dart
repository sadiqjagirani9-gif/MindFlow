abstract interface class KnowledgeAiProvider {
  Future<String> generate(String prompt);
}

class KnowledgeAiProviderFailure implements Exception {
  const KnowledgeAiProviderFailure(
    this.message, {
    this.statusCode,
    this.truncated = false,
  });
  final String message;
  final int? statusCode;
  final bool truncated;

  @override
  String toString() => message;
}

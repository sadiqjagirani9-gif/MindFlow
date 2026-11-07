import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AiProviderConfiguration {
  const AiProviderConfiguration({
    required this.providerId,
    required this.baseUrl,
    required this.model,
    this.temperature = 0.3,
    this.maxOutputTokens = 8192,
  });

  final String providerId;
  final Uri baseUrl;
  final String model;
  final double temperature;
  final int maxOutputTokens;
}

class AiProviderSecretStore {
  AiProviderSecretStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> saveApiKey(String providerId, String apiKey) =>
      _storage.write(key: 'knowledge_ai.$providerId.api_key', value: apiKey);

  Future<String?> readApiKey(String providerId) =>
      _storage.read(key: 'knowledge_ai.$providerId.api_key');

  Future<void> deleteApiKey(String providerId) =>
      _storage.delete(key: 'knowledge_ai.$providerId.api_key');
}

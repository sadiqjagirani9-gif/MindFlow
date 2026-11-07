import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/features/knowledge/data/ai_provider_configuration.dart';
import 'package:mindflow/features/knowledge/data/openai_compatible_knowledge_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final knowledgeAiSettingsProvider = Provider<KnowledgeAiSettings>(
  (ref) => KnowledgeAiSettings(),
);

class KnowledgeAiSettings {
  static const _id = 'openai_compatible';
  final _secrets = AiProviderSecretStore();

  Future<
    ({
      String baseUrl,
      String model,
      double temperature,
      int maxTokens,
      String? apiKey,
    })
  >
  read() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      baseUrl:
          prefs.getString('knowledge_ai.base_url') ??
          'https://api.openai.com/v1/',
      model: prefs.getString('knowledge_ai.model') ?? '',
      temperature: prefs.getDouble('knowledge_ai.temperature') ?? 0.3,
      maxTokens: prefs.getInt('knowledge_ai.max_tokens') ?? 8192,
      apiKey: await _secrets.readApiKey(_id),
    );
  }

  Future<void> save({
    required String baseUrl,
    required String model,
    required String apiKey,
    required double temperature,
    required int maxTokens,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('knowledge_ai.base_url', baseUrl);
    await prefs.setString('knowledge_ai.model', model);
    await prefs.setDouble('knowledge_ai.temperature', temperature);
    await prefs.setInt('knowledge_ai.max_tokens', maxTokens);
    if (apiKey.isNotEmpty) await _secrets.saveApiKey(_id, apiKey);
  }

  Future<OpenAiCompatibleKnowledgeProvider> createProvider() async {
    final settings = await read();
    final key = settings.apiKey;
    if (key == null || key.isEmpty || settings.model.isEmpty) {
      throw StateError('请先配置 API Key 和模型名称');
    }
    final uri = Uri.tryParse(settings.baseUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw StateError('API Base URL 无效');
    }
    return OpenAiCompatibleKnowledgeProvider(
      configuration: AiProviderConfiguration(
        providerId: _id,
        baseUrl: uri.path.endsWith('/')
            ? uri
            : uri.replace(path: '${uri.path}/'),
        model: settings.model,
        temperature: settings.temperature,
        maxOutputTokens: settings.maxTokens,
      ),
      apiKey: key,
    );
  }
}

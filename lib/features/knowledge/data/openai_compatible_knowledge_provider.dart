import 'package:dio/dio.dart';
import 'package:mindflow/features/knowledge/data/ai_provider_configuration.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_ai_provider.dart';

class OpenAiCompatibleKnowledgeProvider implements KnowledgeAiProvider {
  OpenAiCompatibleKnowledgeProvider({
    required this.configuration,
    required this.apiKey,
    Dio? dio,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: configuration.baseUrl.toString(),
               connectTimeout: const Duration(seconds: 15),
               sendTimeout: const Duration(seconds: 30),
               receiveTimeout: const Duration(seconds: 90),
             ),
           );

  final AiProviderConfiguration configuration;
  final String apiKey;
  final Dio _dio;

  @override
  Future<String> generate(String prompt) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'chat/completions',
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
        data: {
          'model': configuration.model,
          'temperature': configuration.temperature,
          'max_tokens': configuration.maxOutputTokens,
          'messages': [
            {
              'role': 'system',
              'content': 'Return valid JSON only. Follow the requested schema exactly.',
            },
            {'role': 'user', 'content': prompt},
          ],
        },
      );
      final content = response.data?['choices']?[0]?['message']?['content'];
      final finishReason = response.data?['choices']?[0]?['finish_reason'];
      if (finishReason == 'length') {
        throw const KnowledgeAiProviderFailure(
          'AI output was truncated. Reduce branch size or increase the output token limit.',
          truncated: true,
        );
      }
      if (content is! String || content.trim().isEmpty) {
        throw const KnowledgeAiProviderFailure(
          'AI provider returned an empty outline.',
        );
      }
      return content;
    } on DioException catch (error) {
      throw KnowledgeAiProviderFailure(
        error.message ?? 'Knowledge provider request failed.',
        statusCode: error.response?.statusCode,
      );
    }
  }
}

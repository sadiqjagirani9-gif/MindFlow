// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/features/knowledge/data/knowledge_ai_settings.dart';

Future<void> showKnowledgeAiSettingsDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final service = ref.read(knowledgeAiSettingsProvider);
  final settings = await service.read();
  if (!context.mounted) return;
  final baseUrl = TextEditingController(text: settings.baseUrl);
  final model = TextEditingController(text: settings.model);
  final apiKey = TextEditingController();
  final maxTokens = TextEditingController(text: '${settings.maxTokens}');
  var temperature = settings.temperature;
  var testing = false;
  await showDialog<void>(
    context: context,
    barrierDismissible: !testing,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('知识体系 AI 设置'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: baseUrl,
                  enabled: !testing,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'API Base URL',
                    hintText: 'https://api.openai.com/v1/',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: model,
                  enabled: !testing,
                  decoration: const InputDecoration(labelText: '模型名称'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: apiKey,
                  enabled: !testing,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: settings.apiKey == null
                        ? 'API Key'
                        : 'API Key（已保存，留空保持不变）',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Temperature'),
                    Expanded(
                      child: Slider(
                        value: temperature,
                        min: 0,
                        max: 1,
                        divisions: 20,
                        label: temperature.toStringAsFixed(2),
                        onChanged: testing
                            ? null
                            : (value) => setState(() => temperature = value),
                      ),
                    ),
                    Text(temperature.toStringAsFixed(2)),
                  ],
                ),
                TextField(
                  controller: maxTokens,
                  enabled: !testing,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '最大输出 Token 数'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'AI 只用于知识体系。API Key 保存在系统安全存储，但客户端密钥仍可能在受控设备上被提取。请使用有限额、有限权限的密钥。',
                  style: TextStyle(fontSize: 12),
                ),
                if (testing) ...[
                  const SizedBox(height: 14),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: testing ? null : () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: testing
                ? null
                : () async {
                    final tokens = int.tryParse(maxTokens.text.trim());
                    final uri = Uri.tryParse(baseUrl.text.trim());
                    if (tokens == null ||
                        tokens < 256 ||
                        tokens > 200000 ||
                        uri == null ||
                        !uri.hasScheme ||
                        uri.host.isEmpty ||
                        model.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('请检查 URL、模型名称和 Token 数值')),
                      );
                      return;
                    }
                    setState(() => testing = true);
                    try {
                      await service.save(
                        baseUrl: baseUrl.text.trim(),
                        model: model.text.trim(),
                        apiKey: apiKey.text.trim(),
                        temperature: temperature,
                        maxTokens: tokens,
                      );
                      final provider = await service.createProvider();
                      await provider.generate(
                        'Return only this JSON object: {"connection":"ok"}',
                      );
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('AI 配置已保存，连接测试成功')),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('连接测试失败：$error')),
                        );
                      }
                      setState(() => testing = false);
                    }
                  },
            child: const Text('保存并测试'),
          ),
        ],
      ),
    ),
  );
  baseUrl.dispose();
  model.dispose();
  apiKey.dispose();
  maxTokens.dispose();
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/features/diary/data/diary_repository.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(diaryEntriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('日记')),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('日记加载失败：$error')),
        data: (items) => items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_stories_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '今天还没有日记',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '写下几句话，不需要总结，也不需要分析。',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => _edit(context, ref),
                        icon: const Icon(Icons.edit_note_rounded),
                        label: const Text('写一篇日记'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = items[index];
                  return Card(
                    child: Dismissible(
                      key: ValueKey(entry.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: const Icon(Icons.delete_outline),
                      ),
                      onDismissed: (_) => ref
                          .read(diaryRepositoryProvider)
                          .deleteEntry(entry.id),
                      child: ListTile(
                        title: Text(
                          entry.title.isEmpty
                              ? DateFormat('M月d日').format(entry.diaryDate)
                              : entry.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '${DateFormat('yyyy年M月d日').format(entry.diaryDate)}  ·  ${entry.content.replaceAll('\n', ' ')}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _edit(context, ref, entry),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('新日记'),
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    DiaryEntry? entry,
  ]) async {
    final result = await showModalBottomSheet<_DiaryDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _DiaryEditor(entry: entry),
    );
    if (result == null) return;
    final repository = ref.read(diaryRepositoryProvider);
    if (entry == null) {
      await repository.createEntry(result.title, result.content, result.date);
    } else {
      await repository.updateEntry(
        entry,
        result.title,
        result.content,
        result.date,
      );
    }
  }
}

class _DiaryDraft {
  const _DiaryDraft(this.title, this.content, this.date);
  final String title;
  final String content;
  final DateTime date;
}

class _DiaryEditor extends StatefulWidget {
  const _DiaryEditor({this.entry});
  final DiaryEntry? entry;

  @override
  State<_DiaryEditor> createState() => _DiaryEditorState();
}

class _DiaryEditorState extends State<_DiaryEditor> {
  late final TextEditingController title = TextEditingController(
    text: widget.entry?.title,
  );
  late final TextEditingController content = TextEditingController(
    text: widget.entry?.content,
  );
  late DateTime date = widget.entry?.diaryDate ?? DateTime.now();
  bool preview = false;

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      12,
      20,
      MediaQuery.viewInsetsOf(context).bottom + 20,
    ),
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * .82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.entry == null ? '写日记' : '编辑日记',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.event_outlined),
            label: Text(DateFormat('yyyy年M月d日').format(date)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: title,
            maxLength: 100,
            decoration: const InputDecoration(labelText: '标题', hintText: '可留空'),
          ),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                icon: Icon(Icons.edit_outlined),
                label: Text('编辑'),
              ),
              ButtonSegment(
                value: true,
                icon: Icon(Icons.visibility_outlined),
                label: Text('预览'),
              ),
            ],
            selected: {preview},
            showSelectedIcon: false,
            onSelectionChanged: (values) =>
                setState(() => preview = values.first),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: preview
                ? Markdown(data: content.text.isEmpty ? ' ' : content.text)
                : TextField(
                    controller: content,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: '记录今天发生的事和你的想法…',
                      alignLabelWithHint: true,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('保存'),
          ),
        ],
      ),
    ),
  );

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: date,
    );
    if (value != null) setState(() => date = value);
  }

  void _save() => Navigator.pop(
    context,
    _DiaryDraft(title.text.trim(), content.text.trim(), date),
  );
}

// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/features/diary/data/diary_repository.dart';

class DiaryHubScreen extends ConsumerStatefulWidget {
  const DiaryHubScreen({super.key});

  @override
  ConsumerState<DiaryHubScreen> createState() => _DiaryHubScreenState();
}

class _DiaryHubScreenState extends ConsumerState<DiaryHubScreen> {
  final _search = TextEditingController();
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;
  int? _tagId;
  Set<int>? _tagEntryIds;
  bool _recentlyEdited = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(diaryEntriesProvider);
    final tags = ref.watch(diaryTagsProvider).valueOrNull ?? const <DiaryTag>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('日记'),
        actions: [
          IconButton(
            tooltip: '日历视图',
            onPressed: _pickCalendarDay,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          IconButton(
            tooltip: _recentlyEdited ? '按日记日期排列' : '最近编辑记录',
            onPressed: () => setState(() => _recentlyEdited = !_recentlyEdited),
            icon: Icon(
              _recentlyEdited ? Icons.history_toggle_off : Icons.history,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '搜索标题和正文',
                isDense: true,
              ),
            ),
          ),
          if (!_recentlyEdited)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: '上个月',
                    onPressed: () => _changeMonth(-1),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      _selectedDay == null
                          ? DateFormat('yyyy年M月').format(_month)
                          : DateFormat('yyyy年M月d日').format(_selectedDay!),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (_selectedDay != null)
                    IconButton(
                      tooltip: '清除日期筛选',
                      onPressed: () => setState(() => _selectedDay = null),
                      icon: const Icon(Icons.close, size: 18),
                    )
                  else
                    IconButton(
                      tooltip: '下个月',
                      onPressed: () => _changeMonth(1),
                      icon: const Icon(Icons.chevron_right),
                    ),
                ],
              ),
            ),
          if (tags.isNotEmpty)
            SizedBox(
              height: 46,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('全部标签'),
                      selected: _tagId == null,
                      onSelected: (_) => _selectTag(null),
                    ),
                  ),
                  ...tags.map(
                    (tag) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(tag.name),
                        selected: _tagId == tag.id,
                        onSelected: (_) => _selectTag(tag.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: entries.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('日记加载失败：$error')),
              data: (items) {
                final visible = _filter(items);
                if (items.isEmpty) return _empty(context);
                if (visible.isEmpty) {
                  return const Center(child: Text('当前条件下没有日记'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _DiaryTile(
                    entry: visible[index],
                    onOpen: () => _openEditor(visible[index]),
                    onDelete: () => _delete(visible[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('新日记'),
      ),
    );
  }

  List<DiaryEntry> _filter(List<DiaryEntry> source) {
    final query = _search.text.trim().toLowerCase();
    final result = source.where((entry) {
      final dateMatches =
          _recentlyEdited ||
          (_selectedDay != null
              ? _sameDay(entry.diaryDate, _selectedDay!)
              : entry.diaryDate.year == _month.year &&
                    entry.diaryDate.month == _month.month);
      final queryMatches =
          query.isEmpty ||
          entry.title.toLowerCase().contains(query) ||
          entry.content.toLowerCase().contains(query);
      final tagMatches =
          _tagId == null || (_tagEntryIds?.contains(entry.id) ?? false);
      return dateMatches && queryMatches && tagMatches;
    }).toList();
    if (_recentlyEdited) {
      result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } else {
      result.sort((a, b) => b.diaryDate.compareTo(a.diaryDate));
    }
    return result;
  }

  Widget _empty(BuildContext context) => Center(
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
          Text('今天还没有日记', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('写下几句话，不需要总结，也不需要分析。'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.edit_note),
            label: const Text('写一篇日记'),
          ),
        ],
      ),
    ),
  );

  void _changeMonth(int delta) => setState(() {
    _month = DateTime(_month.year, _month.month + delta);
    _selectedDay = null;
  });

  Future<void> _pickCalendarDay() async {
    final day = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: _selectedDay ?? _month,
    );
    if (day != null) {
      setState(() {
        _selectedDay = day;
        _month = DateTime(day.year, day.month);
        _recentlyEdited = false;
      });
    }
  }

  Future<void> _selectTag(int? tagId) async {
    if (tagId == null) {
      setState(() {
        _tagId = null;
        _tagEntryIds = null;
      });
      return;
    }
    final ids = await ref.read(diaryRepositoryProvider).entryIdsForTag(tagId);
    if (mounted)
      setState(() {
        _tagId = tagId;
        _tagEntryIds = ids;
      });
  }

  Future<void> _openEditor([DiaryEntry? entry]) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: false,
      builder: (_) => DiaryEditor(entry: entry),
    );
    if (_tagId != null) await _selectTag(_tagId);
  }

  Future<void> _delete(DiaryEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除日记？'),
        content: const Text('关联的本地图片也会删除，此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed == true)
      await ref.read(diaryRepositoryProvider).deleteEntry(entry.id);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DiaryTile extends StatelessWidget {
  const _DiaryTile({
    required this.entry,
    required this.onOpen,
    required this.onDelete,
  });
  final DiaryEntry entry;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Container(
        width: 42,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${entry.diaryDate.day}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${entry.diaryDate.month}月',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      title: Text(
        entry.title.isEmpty ? '无标题日记' : entry.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          '${entry.content.replaceAll('\n', ' ')}\n${diaryWordCount(entry.content)} 字 · 编辑于 ${DateFormat('M-d HH:mm').format(entry.updatedAt.toLocal())}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      isThreeLine: true,
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'delete') onDelete();
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'delete', child: Text('删除日记')),
        ],
      ),
      onTap: onOpen,
    ),
  );
}

class DiaryEditor extends ConsumerStatefulWidget {
  const DiaryEditor({super.key, this.entry});
  final DiaryEntry? entry;

  @override
  ConsumerState<DiaryEditor> createState() => _DiaryEditorState();
}

class _DiaryEditorState extends ConsumerState<DiaryEditor> {
  late final _title = TextEditingController(text: widget.entry?.title ?? '');
  late final _content = TextEditingController(
    text: widget.entry?.content ?? '',
  );
  final _tagInput = TextEditingController();
  late DateTime _date = widget.entry?.diaryDate ?? DateTime.now();
  int? _entryId;
  Timer? _debounce;
  Future<void>? _saving;
  bool _preview = false;
  bool _closing = false;
  bool _loading = true;
  bool _dirty = false;
  int _changeVersion = 0;
  Set<String> _tags = {};
  List<DiaryImage> _images = [];

  @override
  void initState() {
    super.initState();
    _entryId = widget.entry?.id;
    _title.addListener(_changed);
    _content.addListener(_changed);
    _loadRelations();
  }

  Future<void> _loadRelations() async {
    if (_entryId != null) {
      final repository = ref.read(diaryRepositoryProvider);
      final values = await Future.wait([
        repository.tagsForEntry(_entryId!),
        repository.imagesForEntry(_entryId!),
      ]);
      if (!mounted) return;
      _tags = (values[0] as List<DiaryTag>).map((tag) => tag.name).toSet();
      _images = values[1] as List<DiaryImage>;
    }
    if (mounted) setState(() => _loading = false);
  }

  void _changed() {
    _dirty = true;
    _changeVersion++;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), _saveNow);
    if (mounted) setState(() {});
  }

  Future<void> _saveNow({bool allowEmpty = false}) async {
    _debounce?.cancel();
    if (!_dirty && _entryId != null) return;
    if (!allowEmpty &&
        _entryId == null &&
        _title.text.trim().isEmpty &&
        _content.text.trim().isEmpty)
      return;
    final version = _changeVersion;
    final title = _title.text.trim();
    final content = _content.text;
    final date = _date;
    final tags = Set<String>.from(_tags);
    final previous = _saving;
    final operation = () async {
      await previous;
      final repository = ref.read(diaryRepositoryProvider);
      final id = await repository.saveDraft(
        id: _entryId,
        title: title,
        content: content,
        date: date,
      );
      _entryId = id;
      await repository.setTags(id, tags);
      if (_changeVersion == version) _dirty = false;
      if (mounted) setState(() {});
    }();
    _saving = operation;
    await operation;
  }

  Future<void> _close() async {
    if (_closing) return;
    _closing = true;
    try {
      await _saveNow();
      await _saving;
      if (mounted) Navigator.pop(context);
    } finally {
      _closing = false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _title.removeListener(_changed);
    _content.removeListener(_changed);
    _title.dispose();
    _content.dispose();
    _tagInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _close();
    },
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * .94,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.entry == null ? '写日记' : '编辑日记',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              _dirty
                  ? '正在自动保存…'
                  : _entryId == null
                  ? '本地草稿'
                  : '已保存 · ${diaryWordCount(_content.text)} 字',
            ),
            trailing: IconButton(
              tooltip: '保存并关闭',
              onPressed: _close,
              icon: const Icon(Icons.close),
            ),
          ),
          const Divider(height: 1),
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                18,
                14,
                18,
                MediaQuery.viewInsetsOf(context).bottom + 24,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.event_outlined),
                        label: Text(DateFormat('yyyy年M月d日').format(_date)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: '插入图片',
                      onPressed: _pickImage,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _title,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: '标题',
                    hintText: '可留空',
                  ),
                ),
                const SizedBox(height: 4),
                if (_images.isNotEmpty) ...[
                  SizedBox(
                    height: 108,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) => _ImageThumbnail(
                        image: _images[index],
                        onOpen: () => _openImage(_images[index]),
                        onRemove: () => _removeImage(_images[index]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    ..._tags.map(
                      (tag) => InputChip(
                        label: Text(tag),
                        onDeleted: () {
                          setState(() => _tags.remove(tag));
                          _changed();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: TextField(
                        controller: _tagInput,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addTag(),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: '添加标签',
                          suffixIcon: IconButton(
                            tooltip: '添加标签',
                            onPressed: _addTag,
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                  selected: {_preview},
                  showSelectedIcon: false,
                  onSelectionChanged: (values) =>
                      setState(() => _preview = values.first),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 430,
                  child: _preview
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Markdown(
                              data: _content.text.isEmpty ? ' ' : _content.text,
                            ),
                          ),
                        )
                      : TextField(
                          controller: _content,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            hintText: '记录生活和思考…',
                            alignLabelWithHint: true,
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${diaryWordCount(_content.text)} 字',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  void _addTag() {
    final value = _tagInput.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _tags.add(value);
      _tagInput.clear();
    });
    _changed();
  }

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: _date,
    );
    if (value != null) {
      setState(() => _date = value);
      _changed();
    }
  }

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked == null) return;
      _dirty = true;
      await _saveNow(allowEmpty: true);
      final image = await ref
          .read(diaryRepositoryProvider)
          .addImage(_entryId!, picked.path);
      if (mounted) setState(() => _images.add(image));
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('图片保存失败：$error')));
    }
  }

  Future<void> _removeImage(DiaryImage image) async {
    await ref.read(diaryRepositoryProvider).removeImage(image);
    if (mounted)
      setState(() => _images.removeWhere((item) => item.id == image.id));
  }

  void _openImage(DiaryImage image) => showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      child: InteractiveViewer(
        child: Image.file(
          File(image.localPath),
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Padding(
            padding: EdgeInsets.all(40),
            child: Text('图片文件不可用'),
          ),
        ),
      ),
    ),
  );
}

class _ImageThumbnail extends StatelessWidget {
  const _ImageThumbnail({
    required this.image,
    required this.onOpen,
    required this.onRemove,
  });
  final DiaryImage image;
  final VoidCallback onOpen;
  final VoidCallback onRemove;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 108,
    child: Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: onOpen,
              child: Image.file(
                File(image.localPath),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: Colors.black12,
                  child: Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 2,
          top: 2,
          child: IconButton.filledTonal(
            tooltip: '移除图片',
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 16),
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    ),
  );
}

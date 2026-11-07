# MindFlow Database Design

MindFlow uses Drift over SQLite. The database is created in the platform application documents directory as `mindflow.sqlite`; foreign keys are enabled in `beforeOpen`.

## Tables

- `TaskCategories`, `TaskRecords`, `TaskReminders`: task metadata, optional date/time, priority/category, recurrence, and notification IDs. Task reminders cascade when a task is deleted. Recurring completion is transactional and links the next occurrence with `previousOccurrenceId`.
- `DiaryEntries`: title, Markdown content, date-only value, and created/updated timestamps.
- `DiaryTags`, `DiaryTagRelations`: unique tags and the many-to-many diary relationship. Empty tags are cleaned after tag replacement.
- `DiaryImages`: diary-owned local file paths. The repository copies selected images into `diary_images/`, and delete/remove operations clean the physical file after the row is removed.
- `KnowledgeProjects`: independent knowledge systems, descriptions, and JSON generation checkpoint in `generationStatus`.
- `KnowledgeNodes`: recursive `parentId`, structured content fields, Markdown detail, and sibling `sortOrder`.
- `KnowledgeRelations`: directed `prerequisite` or `related` links between nodes; node deletion cascades these links.
- `KnowledgeEditHistories`: project-scoped before/after snapshots for supported undo operations.

## Date and migration rules

Calendar-only task and diary dates use `DateOnlyConverter` and are stored as `YYYYMMDD` integers. This avoids timezone shifts when a device changes timezone. The schema is currently version 4; migrations cover task recurrence fields and conversion of earlier Unix-encoded date values.

## Transaction boundaries

Task creation/update and recurring completion, knowledge branch replacement, node editing/moving/deleting, diary tag replacement, and full data clearing use Drift transactions. Physical image deletion happens after the database transaction, so a database failure does not remove a still-referenced file.

## Backup mapping

Full backups use `mindflow-full-backup-v1`. Imports validate limits, scalar types, IDs, references, parent cycles, dates, and base64 image sizes before writing. Every imported task, diary, and knowledge project receives new local IDs; relations and tag links are remapped. Existing rows are never overwritten. API keys, theme preferences, and platform notification IDs are intentionally excluded. Imported reminders receive local notification IDs and are rescheduled by `TaskService` after import.

Knowledge-only exports use `mindflow-knowledge-v1`, with a separate Markdown representation and a PNG graph capture. A knowledge generation checkpoint stores completed branch titles, input scope/depth, and completeness findings so interrupted AI generation can resume without discarding prior branches.

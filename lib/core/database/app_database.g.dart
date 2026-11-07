// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TaskCategoriesTable extends TaskCategories
    with TableInfo<$TaskCategoriesTable, TaskCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF6D8F7D),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, colorValue, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskCategoriesTable createAlias(String alias) {
    return $TaskCategoriesTable(attachedDatabase, alias);
  }
}

class TaskCategory extends DataClass implements Insertable<TaskCategory> {
  final int id;
  final String name;
  final int colorValue;
  final DateTime createdAt;
  const TaskCategory({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskCategoriesCompanion toCompanion(bool nullToAbsent) {
    return TaskCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: Value(colorValue),
      createdAt: Value(createdAt),
    );
  }

  factory TaskCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskCategory copyWith({
    int? id,
    String? name,
    int? colorValue,
    DateTime? createdAt,
  }) => TaskCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    colorValue: colorValue ?? this.colorValue,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskCategory copyWithCompanion(TaskCategoriesCompanion data) {
    return TaskCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorValue, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.createdAt == this.createdAt);
}

class TaskCategoriesCompanion extends UpdateCompanion<TaskCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<DateTime> createdAt;
  const TaskCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TaskCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorValue = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TaskCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TaskCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? colorValue,
    Value<DateTime>? createdAt,
  }) {
    return TaskCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TaskRecordsTable extends TaskRecords
    with TableInfo<$TaskRecordsTable, TaskRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> dueDate =
      GeneratedColumn<int>(
        'due_date',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($TaskRecordsTable.$converterdueDaten);
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>(
    'due_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _repeatRuleMeta = const VerificationMeta(
    'repeatRule',
  );
  @override
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
    'repeat_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _previousOccurrenceIdMeta =
      const VerificationMeta('previousOccurrenceId');
  @override
  late final GeneratedColumn<int> previousOccurrenceId = GeneratedColumn<int>(
    'previous_occurrence_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_records (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    dueDate,
    dueTime,
    priority,
    repeatRule,
    previousOccurrenceId,
    categoryId,
    isCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('repeat_rule')) {
      context.handle(
        _repeatRuleMeta,
        repeatRule.isAcceptableOrUnknown(data['repeat_rule']!, _repeatRuleMeta),
      );
    }
    if (data.containsKey('previous_occurrence_id')) {
      context.handle(
        _previousOccurrenceIdMeta,
        previousOccurrenceId.isAcceptableOrUnknown(
          data['previous_occurrence_id']!,
          _previousOccurrenceIdMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      dueDate: $TaskRecordsTable.$converterdueDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}due_date'],
        ),
      ),
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_time'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      repeatRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_rule'],
      )!,
      previousOccurrenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_occurrence_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskRecordsTable createAlias(String alias) {
    return $TaskRecordsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterdueDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime?, int?> $converterdueDaten =
      NullAwareTypeConverter.wrap($converterdueDate);
}

class TaskRecord extends DataClass implements Insertable<TaskRecord> {
  final int id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final String? dueTime;
  final int priority;
  final String repeatRule;
  final int? previousOccurrenceId;
  final int? categoryId;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskRecord({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.dueTime,
    required this.priority,
    required this.repeatRule,
    this.previousOccurrenceId,
    this.categoryId,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<int>(
        $TaskRecordsTable.$converterdueDaten.toSql(dueDate),
      );
    }
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<String>(dueTime);
    }
    map['priority'] = Variable<int>(priority);
    map['repeat_rule'] = Variable<String>(repeatRule);
    if (!nullToAbsent || previousOccurrenceId != null) {
      map['previous_occurrence_id'] = Variable<int>(previousOccurrenceId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskRecordsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      priority: Value(priority),
      repeatRule: Value(repeatRule),
      previousOccurrenceId: previousOccurrenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(previousOccurrenceId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRecord(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      priority: serializer.fromJson<int>(json['priority']),
      repeatRule: serializer.fromJson<String>(json['repeatRule']),
      previousOccurrenceId: serializer.fromJson<int?>(
        json['previousOccurrenceId'],
      ),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'priority': serializer.toJson<int>(priority),
      'repeatRule': serializer.toJson<String>(repeatRule),
      'previousOccurrenceId': serializer.toJson<int?>(previousOccurrenceId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRecord copyWith({
    int? id,
    String? title,
    String? description,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<String?> dueTime = const Value.absent(),
    int? priority,
    String? repeatRule,
    Value<int?> previousOccurrenceId = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueTime: dueTime.present ? dueTime.value : this.dueTime,
    priority: priority ?? this.priority,
    repeatRule: repeatRule ?? this.repeatRule,
    previousOccurrenceId: previousOccurrenceId.present
        ? previousOccurrenceId.value
        : this.previousOccurrenceId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRecord copyWithCompanion(TaskRecordsCompanion data) {
    return TaskRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      priority: data.priority.present ? data.priority.value : this.priority,
      repeatRule: data.repeatRule.present
          ? data.repeatRule.value
          : this.repeatRule,
      previousOccurrenceId: data.previousOccurrenceId.present
          ? data.previousOccurrenceId.value
          : this.previousOccurrenceId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('priority: $priority, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('previousOccurrenceId: $previousOccurrenceId, ')
          ..write('categoryId: $categoryId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    dueDate,
    dueTime,
    priority,
    repeatRule,
    previousOccurrenceId,
    categoryId,
    isCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.priority == this.priority &&
          other.repeatRule == this.repeatRule &&
          other.previousOccurrenceId == this.previousOccurrenceId &&
          other.categoryId == this.categoryId &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskRecordsCompanion extends UpdateCompanion<TaskRecord> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime?> dueDate;
  final Value<String?> dueTime;
  final Value<int> priority;
  final Value<String> repeatRule;
  final Value<int?> previousOccurrenceId;
  final Value<int?> categoryId;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TaskRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.previousOccurrenceId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaskRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.previousOccurrenceId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<TaskRecord> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? dueDate,
    Expression<String>? dueTime,
    Expression<int>? priority,
    Expression<String>? repeatRule,
    Expression<int>? previousOccurrenceId,
    Expression<int>? categoryId,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (priority != null) 'priority': priority,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (previousOccurrenceId != null)
        'previous_occurrence_id': previousOccurrenceId,
      if (categoryId != null) 'category_id': categoryId,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaskRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<DateTime?>? dueDate,
    Value<String?>? dueTime,
    Value<int>? priority,
    Value<String>? repeatRule,
    Value<int?>? previousOccurrenceId,
    Value<int?>? categoryId,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TaskRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      repeatRule: repeatRule ?? this.repeatRule,
      previousOccurrenceId: previousOccurrenceId ?? this.previousOccurrenceId,
      categoryId: categoryId ?? this.categoryId,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(
        $TaskRecordsTable.$converterdueDaten.toSql(dueDate.value),
      );
    }
    if (dueTime.present) {
      map['due_time'] = Variable<String>(dueTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (previousOccurrenceId.present) {
      map['previous_occurrence_id'] = Variable<int>(previousOccurrenceId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('priority: $priority, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('previousOccurrenceId: $previousOccurrenceId, ')
          ..write('categoryId: $categoryId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskRemindersTable extends TaskReminders
    with TableInfo<$TaskRemindersTable, TaskReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
    'reminder_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatRuleMeta = const VerificationMeta(
    'repeatRule',
  );
  @override
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
    'repeat_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    reminderTime,
    repeatRule,
    notificationId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskReminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderTimeMeta);
    }
    if (data.containsKey('repeat_rule')) {
      context.handle(
        _repeatRuleMeta,
        repeatRule.isAcceptableOrUnknown(data['repeat_rule']!, _repeatRuleMeta),
      );
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskReminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_time'],
      )!,
      repeatRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_rule'],
      )!,
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
    );
  }

  @override
  $TaskRemindersTable createAlias(String alias) {
    return $TaskRemindersTable(attachedDatabase, alias);
  }
}

class TaskReminder extends DataClass implements Insertable<TaskReminder> {
  final int id;
  final int taskId;
  final DateTime reminderTime;
  final String repeatRule;
  final int notificationId;
  const TaskReminder({
    required this.id,
    required this.taskId,
    required this.reminderTime,
    required this.repeatRule,
    required this.notificationId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<int>(taskId);
    map['reminder_time'] = Variable<DateTime>(reminderTime);
    map['repeat_rule'] = Variable<String>(repeatRule);
    map['notification_id'] = Variable<int>(notificationId);
    return map;
  }

  TaskRemindersCompanion toCompanion(bool nullToAbsent) {
    return TaskRemindersCompanion(
      id: Value(id),
      taskId: Value(taskId),
      reminderTime: Value(reminderTime),
      repeatRule: Value(repeatRule),
      notificationId: Value(notificationId),
    );
  }

  factory TaskReminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskReminder(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<int>(json['taskId']),
      reminderTime: serializer.fromJson<DateTime>(json['reminderTime']),
      repeatRule: serializer.fromJson<String>(json['repeatRule']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<int>(taskId),
      'reminderTime': serializer.toJson<DateTime>(reminderTime),
      'repeatRule': serializer.toJson<String>(repeatRule),
      'notificationId': serializer.toJson<int>(notificationId),
    };
  }

  TaskReminder copyWith({
    int? id,
    int? taskId,
    DateTime? reminderTime,
    String? repeatRule,
    int? notificationId,
  }) => TaskReminder(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    reminderTime: reminderTime ?? this.reminderTime,
    repeatRule: repeatRule ?? this.repeatRule,
    notificationId: notificationId ?? this.notificationId,
  );
  TaskReminder copyWithCompanion(TaskRemindersCompanion data) {
    return TaskReminder(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      repeatRule: data.repeatRule.present
          ? data.repeatRule.value
          : this.repeatRule,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskReminder(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('notificationId: $notificationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, reminderTime, repeatRule, notificationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskReminder &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.reminderTime == this.reminderTime &&
          other.repeatRule == this.repeatRule &&
          other.notificationId == this.notificationId);
}

class TaskRemindersCompanion extends UpdateCompanion<TaskReminder> {
  final Value<int> id;
  final Value<int> taskId;
  final Value<DateTime> reminderTime;
  final Value<String> repeatRule;
  final Value<int> notificationId;
  const TaskRemindersCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.notificationId = const Value.absent(),
  });
  TaskRemindersCompanion.insert({
    this.id = const Value.absent(),
    required int taskId,
    required DateTime reminderTime,
    this.repeatRule = const Value.absent(),
    required int notificationId,
  }) : taskId = Value(taskId),
       reminderTime = Value(reminderTime),
       notificationId = Value(notificationId);
  static Insertable<TaskReminder> custom({
    Expression<int>? id,
    Expression<int>? taskId,
    Expression<DateTime>? reminderTime,
    Expression<String>? repeatRule,
    Expression<int>? notificationId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (notificationId != null) 'notification_id': notificationId,
    });
  }

  TaskRemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? taskId,
    Value<DateTime>? reminderTime,
    Value<String>? repeatRule,
    Value<int>? notificationId,
  }) {
    return TaskRemindersCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      reminderTime: reminderTime ?? this.reminderTime,
      repeatRule: repeatRule ?? this.repeatRule,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRemindersCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('notificationId: $notificationId')
          ..write(')'))
        .toString();
  }
}

class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> diaryDate =
      GeneratedColumn<int>(
        'diary_date',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($DiaryEntriesTable.$converterdiaryDate);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    diaryDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      diaryDate: $DiaryEntriesTable.$converterdiaryDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}diary_date'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterdiaryDate =
      const DateOnlyConverter();
}

class DiaryEntry extends DataClass implements Insertable<DiaryEntry> {
  final int id;
  final String title;
  final String content;
  final DateTime diaryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.diaryDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    {
      map['diary_date'] = Variable<int>(
        $DiaryEntriesTable.$converterdiaryDate.toSql(diaryDate),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      diaryDate: Value(diaryDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DiaryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      diaryDate: serializer.fromJson<DateTime>(json['diaryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'diaryDate': serializer.toJson<DateTime>(diaryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DiaryEntry copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? diaryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DiaryEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    diaryDate: diaryDate ?? this.diaryDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DiaryEntry copyWithCompanion(DiaryEntriesCompanion data) {
    return DiaryEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      diaryDate: data.diaryDate.present ? data.diaryDate.value : this.diaryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('diaryDate: $diaryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, diaryDate, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.diaryDate == this.diaryDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> diaryDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.diaryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    required DateTime diaryDate,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : diaryDate = Value(diaryDate);
  static Insertable<DiaryEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? diaryDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (diaryDate != null) 'diary_date': diaryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DiaryEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? content,
    Value<DateTime>? diaryDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DiaryEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      diaryDate: diaryDate ?? this.diaryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (diaryDate.present) {
      map['diary_date'] = Variable<int>(
        $DiaryEntriesTable.$converterdiaryDate.toSql(diaryDate.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('diaryDate: $diaryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DiaryTagsTable extends DiaryTags
    with TableInfo<$DiaryTagsTable, DiaryTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $DiaryTagsTable createAlias(String alias) {
    return $DiaryTagsTable(attachedDatabase, alias);
  }
}

class DiaryTag extends DataClass implements Insertable<DiaryTag> {
  final int id;
  final String name;
  const DiaryTag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  DiaryTagsCompanion toCompanion(bool nullToAbsent) {
    return DiaryTagsCompanion(id: Value(id), name: Value(name));
  }

  factory DiaryTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryTag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  DiaryTag copyWith({int? id, String? name}) =>
      DiaryTag(id: id ?? this.id, name: name ?? this.name);
  DiaryTag copyWithCompanion(DiaryTagsCompanion data) {
    return DiaryTag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryTag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryTag && other.id == this.id && other.name == this.name);
}

class DiaryTagsCompanion extends UpdateCompanion<DiaryTag> {
  final Value<int> id;
  final Value<String> name;
  const DiaryTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  DiaryTagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<DiaryTag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  DiaryTagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return DiaryTagsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $DiaryTagRelationsTable extends DiaryTagRelations
    with TableInfo<$DiaryTagRelationsTable, DiaryTagRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryTagRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _diaryIdMeta = const VerificationMeta(
    'diaryId',
  );
  @override
  late final GeneratedColumn<int> diaryId = GeneratedColumn<int>(
    'diary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diary_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diary_tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [diaryId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_tag_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryTagRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('diary_id')) {
      context.handle(
        _diaryIdMeta,
        diaryId.isAcceptableOrUnknown(data['diary_id']!, _diaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diaryIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {diaryId, tagId};
  @override
  DiaryTagRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryTagRelation(
      diaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diary_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $DiaryTagRelationsTable createAlias(String alias) {
    return $DiaryTagRelationsTable(attachedDatabase, alias);
  }
}

class DiaryTagRelation extends DataClass
    implements Insertable<DiaryTagRelation> {
  final int diaryId;
  final int tagId;
  const DiaryTagRelation({required this.diaryId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['diary_id'] = Variable<int>(diaryId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  DiaryTagRelationsCompanion toCompanion(bool nullToAbsent) {
    return DiaryTagRelationsCompanion(
      diaryId: Value(diaryId),
      tagId: Value(tagId),
    );
  }

  factory DiaryTagRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryTagRelation(
      diaryId: serializer.fromJson<int>(json['diaryId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'diaryId': serializer.toJson<int>(diaryId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  DiaryTagRelation copyWith({int? diaryId, int? tagId}) => DiaryTagRelation(
    diaryId: diaryId ?? this.diaryId,
    tagId: tagId ?? this.tagId,
  );
  DiaryTagRelation copyWithCompanion(DiaryTagRelationsCompanion data) {
    return DiaryTagRelation(
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryTagRelation(')
          ..write('diaryId: $diaryId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(diaryId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryTagRelation &&
          other.diaryId == this.diaryId &&
          other.tagId == this.tagId);
}

class DiaryTagRelationsCompanion extends UpdateCompanion<DiaryTagRelation> {
  final Value<int> diaryId;
  final Value<int> tagId;
  final Value<int> rowid;
  const DiaryTagRelationsCompanion({
    this.diaryId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiaryTagRelationsCompanion.insert({
    required int diaryId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : diaryId = Value(diaryId),
       tagId = Value(tagId);
  static Insertable<DiaryTagRelation> custom({
    Expression<int>? diaryId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (diaryId != null) 'diary_id': diaryId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiaryTagRelationsCompanion copyWith({
    Value<int>? diaryId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return DiaryTagRelationsCompanion(
      diaryId: diaryId ?? this.diaryId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (diaryId.present) {
      map['diary_id'] = Variable<int>(diaryId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryTagRelationsCompanion(')
          ..write('diaryId: $diaryId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiaryImagesTable extends DiaryImages
    with TableInfo<$DiaryImagesTable, DiaryImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _diaryIdMeta = const VerificationMeta(
    'diaryId',
  );
  @override
  late final GeneratedColumn<int> diaryId = GeneratedColumn<int>(
    'diary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diary_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, diaryId, localPath, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('diary_id')) {
      context.handle(
        _diaryIdMeta,
        diaryId.isAcceptableOrUnknown(data['diary_id']!, _diaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diaryIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diary_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DiaryImagesTable createAlias(String alias) {
    return $DiaryImagesTable(attachedDatabase, alias);
  }
}

class DiaryImage extends DataClass implements Insertable<DiaryImage> {
  final int id;
  final int diaryId;
  final String localPath;
  final DateTime createdAt;
  const DiaryImage({
    required this.id,
    required this.diaryId,
    required this.localPath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['diary_id'] = Variable<int>(diaryId);
    map['local_path'] = Variable<String>(localPath);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DiaryImagesCompanion toCompanion(bool nullToAbsent) {
    return DiaryImagesCompanion(
      id: Value(id),
      diaryId: Value(diaryId),
      localPath: Value(localPath),
      createdAt: Value(createdAt),
    );
  }

  factory DiaryImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryImage(
      id: serializer.fromJson<int>(json['id']),
      diaryId: serializer.fromJson<int>(json['diaryId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diaryId': serializer.toJson<int>(diaryId),
      'localPath': serializer.toJson<String>(localPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DiaryImage copyWith({
    int? id,
    int? diaryId,
    String? localPath,
    DateTime? createdAt,
  }) => DiaryImage(
    id: id ?? this.id,
    diaryId: diaryId ?? this.diaryId,
    localPath: localPath ?? this.localPath,
    createdAt: createdAt ?? this.createdAt,
  );
  DiaryImage copyWithCompanion(DiaryImagesCompanion data) {
    return DiaryImage(
      id: data.id.present ? data.id.value : this.id,
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryImage(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('localPath: $localPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, diaryId, localPath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryImage &&
          other.id == this.id &&
          other.diaryId == this.diaryId &&
          other.localPath == this.localPath &&
          other.createdAt == this.createdAt);
}

class DiaryImagesCompanion extends UpdateCompanion<DiaryImage> {
  final Value<int> id;
  final Value<int> diaryId;
  final Value<String> localPath;
  final Value<DateTime> createdAt;
  const DiaryImagesCompanion({
    this.id = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DiaryImagesCompanion.insert({
    this.id = const Value.absent(),
    required int diaryId,
    required String localPath,
    this.createdAt = const Value.absent(),
  }) : diaryId = Value(diaryId),
       localPath = Value(localPath);
  static Insertable<DiaryImage> custom({
    Expression<int>? id,
    Expression<int>? diaryId,
    Expression<String>? localPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diaryId != null) 'diary_id': diaryId,
      if (localPath != null) 'local_path': localPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DiaryImagesCompanion copyWith({
    Value<int>? id,
    Value<int>? diaryId,
    Value<String>? localPath,
    Value<DateTime>? createdAt,
  }) {
    return DiaryImagesCompanion(
      id: id ?? this.id,
      diaryId: diaryId ?? this.diaryId,
      localPath: localPath ?? this.localPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diaryId.present) {
      map['diary_id'] = Variable<int>(diaryId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryImagesCompanion(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('localPath: $localPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeProjectsTable extends KnowledgeProjects
    with TableInfo<$KnowledgeProjectsTable, KnowledgeProject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _generationStatusMeta = const VerificationMeta(
    'generationStatus',
  );
  @override
  late final GeneratedColumn<String> generationStatus = GeneratedColumn<String>(
    'generation_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('idle'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    generationStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeProject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('generation_status')) {
      context.handle(
        _generationStatusMeta,
        generationStatus.isAcceptableOrUnknown(
          data['generation_status']!,
          _generationStatusMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeProject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeProject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      generationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generation_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KnowledgeProjectsTable createAlias(String alias) {
    return $KnowledgeProjectsTable(attachedDatabase, alias);
  }
}

class KnowledgeProject extends DataClass
    implements Insertable<KnowledgeProject> {
  final int id;
  final String title;
  final String description;
  final String generationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KnowledgeProject({
    required this.id,
    required this.title,
    required this.description,
    required this.generationStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['generation_status'] = Variable<String>(generationStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KnowledgeProjectsCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeProjectsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      generationStatus: Value(generationStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KnowledgeProject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeProject(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      generationStatus: serializer.fromJson<String>(json['generationStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'generationStatus': serializer.toJson<String>(generationStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KnowledgeProject copyWith({
    int? id,
    String? title,
    String? description,
    String? generationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KnowledgeProject(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    generationStatus: generationStatus ?? this.generationStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KnowledgeProject copyWithCompanion(KnowledgeProjectsCompanion data) {
    return KnowledgeProject(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      generationStatus: data.generationStatus.present
          ? data.generationStatus.value
          : this.generationStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeProject(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('generationStatus: $generationStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    generationStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeProject &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.generationStatus == this.generationStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KnowledgeProjectsCompanion extends UpdateCompanion<KnowledgeProject> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> generationStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KnowledgeProjectsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.generationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KnowledgeProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.generationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<KnowledgeProject> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? generationStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (generationStatus != null) 'generation_status': generationStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KnowledgeProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? generationStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KnowledgeProjectsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      generationStatus: generationStatus ?? this.generationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (generationStatus.present) {
      map['generation_status'] = Variable<String>(generationStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeProjectsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('generationStatus: $generationStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeNodesTable extends KnowledgeNodes
    with TableInfo<$KnowledgeNodesTable, KnowledgeNode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES knowledge_projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES knowledge_nodes (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _coreConceptMeta = const VerificationMeta(
    'coreConcept',
  );
  @override
  late final GeneratedColumn<String> coreConcept = GeneratedColumn<String>(
    'core_concept',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _principleMeta = const VerificationMeta(
    'principle',
  );
  @override
  late final GeneratedColumn<String> principle = GeneratedColumn<String>(
    'principle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _mechanismMeta = const VerificationMeta(
    'mechanism',
  );
  @override
  late final GeneratedColumn<String> mechanism = GeneratedColumn<String>(
    'mechanism',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _methodsMeta = const VerificationMeta(
    'methods',
  );
  @override
  late final GeneratedColumn<String> methods = GeneratedColumn<String>(
    'methods',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _applicationMeta = const VerificationMeta(
    'application',
  );
  @override
  late final GeneratedColumn<String> application = GeneratedColumn<String>(
    'application',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _learningValueMeta = const VerificationMeta(
    'learningValue',
  );
  @override
  late final GeneratedColumn<String> learningValue = GeneratedColumn<String>(
    'learning_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    parentId,
    title,
    summary,
    content,
    coreConcept,
    principle,
    mechanism,
    methods,
    application,
    learningValue,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeNode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('core_concept')) {
      context.handle(
        _coreConceptMeta,
        coreConcept.isAcceptableOrUnknown(
          data['core_concept']!,
          _coreConceptMeta,
        ),
      );
    }
    if (data.containsKey('principle')) {
      context.handle(
        _principleMeta,
        principle.isAcceptableOrUnknown(data['principle']!, _principleMeta),
      );
    }
    if (data.containsKey('mechanism')) {
      context.handle(
        _mechanismMeta,
        mechanism.isAcceptableOrUnknown(data['mechanism']!, _mechanismMeta),
      );
    }
    if (data.containsKey('methods')) {
      context.handle(
        _methodsMeta,
        methods.isAcceptableOrUnknown(data['methods']!, _methodsMeta),
      );
    }
    if (data.containsKey('application')) {
      context.handle(
        _applicationMeta,
        application.isAcceptableOrUnknown(
          data['application']!,
          _applicationMeta,
        ),
      );
    }
    if (data.containsKey('learning_value')) {
      context.handle(
        _learningValueMeta,
        learningValue.isAcceptableOrUnknown(
          data['learning_value']!,
          _learningValueMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeNode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeNode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      coreConcept: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}core_concept'],
      )!,
      principle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}principle'],
      )!,
      mechanism: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mechanism'],
      )!,
      methods: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}methods'],
      )!,
      application: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}application'],
      )!,
      learningValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_value'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KnowledgeNodesTable createAlias(String alias) {
    return $KnowledgeNodesTable(attachedDatabase, alias);
  }
}

class KnowledgeNode extends DataClass implements Insertable<KnowledgeNode> {
  final int id;
  final int projectId;
  final int? parentId;
  final String title;
  final String summary;
  final String content;
  final String coreConcept;
  final String principle;
  final String mechanism;
  final String methods;
  final String application;
  final String learningValue;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KnowledgeNode({
    required this.id,
    required this.projectId,
    this.parentId,
    required this.title,
    required this.summary,
    required this.content,
    required this.coreConcept,
    required this.principle,
    required this.mechanism,
    required this.methods,
    required this.application,
    required this.learningValue,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    map['content'] = Variable<String>(content);
    map['core_concept'] = Variable<String>(coreConcept);
    map['principle'] = Variable<String>(principle);
    map['mechanism'] = Variable<String>(mechanism);
    map['methods'] = Variable<String>(methods);
    map['application'] = Variable<String>(application);
    map['learning_value'] = Variable<String>(learningValue);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KnowledgeNodesCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeNodesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      title: Value(title),
      summary: Value(summary),
      content: Value(content),
      coreConcept: Value(coreConcept),
      principle: Value(principle),
      mechanism: Value(mechanism),
      methods: Value(methods),
      application: Value(application),
      learningValue: Value(learningValue),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KnowledgeNode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeNode(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      content: serializer.fromJson<String>(json['content']),
      coreConcept: serializer.fromJson<String>(json['coreConcept']),
      principle: serializer.fromJson<String>(json['principle']),
      mechanism: serializer.fromJson<String>(json['mechanism']),
      methods: serializer.fromJson<String>(json['methods']),
      application: serializer.fromJson<String>(json['application']),
      learningValue: serializer.fromJson<String>(json['learningValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'parentId': serializer.toJson<int?>(parentId),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
      'content': serializer.toJson<String>(content),
      'coreConcept': serializer.toJson<String>(coreConcept),
      'principle': serializer.toJson<String>(principle),
      'mechanism': serializer.toJson<String>(mechanism),
      'methods': serializer.toJson<String>(methods),
      'application': serializer.toJson<String>(application),
      'learningValue': serializer.toJson<String>(learningValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KnowledgeNode copyWith({
    int? id,
    int? projectId,
    Value<int?> parentId = const Value.absent(),
    String? title,
    String? summary,
    String? content,
    String? coreConcept,
    String? principle,
    String? mechanism,
    String? methods,
    String? application,
    String? learningValue,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KnowledgeNode(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    parentId: parentId.present ? parentId.value : this.parentId,
    title: title ?? this.title,
    summary: summary ?? this.summary,
    content: content ?? this.content,
    coreConcept: coreConcept ?? this.coreConcept,
    principle: principle ?? this.principle,
    mechanism: mechanism ?? this.mechanism,
    methods: methods ?? this.methods,
    application: application ?? this.application,
    learningValue: learningValue ?? this.learningValue,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KnowledgeNode copyWithCompanion(KnowledgeNodesCompanion data) {
    return KnowledgeNode(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      content: data.content.present ? data.content.value : this.content,
      coreConcept: data.coreConcept.present
          ? data.coreConcept.value
          : this.coreConcept,
      principle: data.principle.present ? data.principle.value : this.principle,
      mechanism: data.mechanism.present ? data.mechanism.value : this.mechanism,
      methods: data.methods.present ? data.methods.value : this.methods,
      application: data.application.present
          ? data.application.value
          : this.application,
      learningValue: data.learningValue.present
          ? data.learningValue.value
          : this.learningValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeNode(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('parentId: $parentId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('coreConcept: $coreConcept, ')
          ..write('principle: $principle, ')
          ..write('mechanism: $mechanism, ')
          ..write('methods: $methods, ')
          ..write('application: $application, ')
          ..write('learningValue: $learningValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    parentId,
    title,
    summary,
    content,
    coreConcept,
    principle,
    mechanism,
    methods,
    application,
    learningValue,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeNode &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.parentId == this.parentId &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.content == this.content &&
          other.coreConcept == this.coreConcept &&
          other.principle == this.principle &&
          other.mechanism == this.mechanism &&
          other.methods == this.methods &&
          other.application == this.application &&
          other.learningValue == this.learningValue &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KnowledgeNodesCompanion extends UpdateCompanion<KnowledgeNode> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<int?> parentId;
  final Value<String> title;
  final Value<String> summary;
  final Value<String> content;
  final Value<String> coreConcept;
  final Value<String> principle;
  final Value<String> mechanism;
  final Value<String> methods;
  final Value<String> application;
  final Value<String> learningValue;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KnowledgeNodesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.coreConcept = const Value.absent(),
    this.principle = const Value.absent(),
    this.mechanism = const Value.absent(),
    this.methods = const Value.absent(),
    this.application = const Value.absent(),
    this.learningValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KnowledgeNodesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    this.parentId = const Value.absent(),
    required String title,
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.coreConcept = const Value.absent(),
    this.principle = const Value.absent(),
    this.mechanism = const Value.absent(),
    this.methods = const Value.absent(),
    this.application = const Value.absent(),
    this.learningValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : projectId = Value(projectId),
       title = Value(title);
  static Insertable<KnowledgeNode> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<int>? parentId,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<String>? content,
    Expression<String>? coreConcept,
    Expression<String>? principle,
    Expression<String>? mechanism,
    Expression<String>? methods,
    Expression<String>? application,
    Expression<String>? learningValue,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (parentId != null) 'parent_id': parentId,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (content != null) 'content': content,
      if (coreConcept != null) 'core_concept': coreConcept,
      if (principle != null) 'principle': principle,
      if (mechanism != null) 'mechanism': mechanism,
      if (methods != null) 'methods': methods,
      if (application != null) 'application': application,
      if (learningValue != null) 'learning_value': learningValue,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KnowledgeNodesCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<int?>? parentId,
    Value<String>? title,
    Value<String>? summary,
    Value<String>? content,
    Value<String>? coreConcept,
    Value<String>? principle,
    Value<String>? mechanism,
    Value<String>? methods,
    Value<String>? application,
    Value<String>? learningValue,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KnowledgeNodesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      coreConcept: coreConcept ?? this.coreConcept,
      principle: principle ?? this.principle,
      mechanism: mechanism ?? this.mechanism,
      methods: methods ?? this.methods,
      application: application ?? this.application,
      learningValue: learningValue ?? this.learningValue,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (coreConcept.present) {
      map['core_concept'] = Variable<String>(coreConcept.value);
    }
    if (principle.present) {
      map['principle'] = Variable<String>(principle.value);
    }
    if (mechanism.present) {
      map['mechanism'] = Variable<String>(mechanism.value);
    }
    if (methods.present) {
      map['methods'] = Variable<String>(methods.value);
    }
    if (application.present) {
      map['application'] = Variable<String>(application.value);
    }
    if (learningValue.present) {
      map['learning_value'] = Variable<String>(learningValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeNodesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('parentId: $parentId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('coreConcept: $coreConcept, ')
          ..write('principle: $principle, ')
          ..write('mechanism: $mechanism, ')
          ..write('methods: $methods, ')
          ..write('application: $application, ')
          ..write('learningValue: $learningValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeRelationsTable extends KnowledgeRelations
    with TableInfo<$KnowledgeRelationsTable, KnowledgeRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceNodeIdMeta = const VerificationMeta(
    'sourceNodeId',
  );
  @override
  late final GeneratedColumn<int> sourceNodeId = GeneratedColumn<int>(
    'source_node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES knowledge_nodes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetNodeIdMeta = const VerificationMeta(
    'targetNodeId',
  );
  @override
  late final GeneratedColumn<int> targetNodeId = GeneratedColumn<int>(
    'target_node_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES knowledge_nodes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relationTypeMeta = const VerificationMeta(
    'relationType',
  );
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
    'relation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceNodeId,
    targetNodeId,
    relationType,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_node_id')) {
      context.handle(
        _sourceNodeIdMeta,
        sourceNodeId.isAcceptableOrUnknown(
          data['source_node_id']!,
          _sourceNodeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceNodeIdMeta);
    }
    if (data.containsKey('target_node_id')) {
      context.handle(
        _targetNodeIdMeta,
        targetNodeId.isAcceptableOrUnknown(
          data['target_node_id']!,
          _targetNodeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetNodeIdMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
        _relationTypeMeta,
        relationType.isAcceptableOrUnknown(
          data['relation_type']!,
          _relationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relationTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeRelation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_node_id'],
      )!,
      targetNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_node_id'],
      )!,
      relationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $KnowledgeRelationsTable createAlias(String alias) {
    return $KnowledgeRelationsTable(attachedDatabase, alias);
  }
}

class KnowledgeRelation extends DataClass
    implements Insertable<KnowledgeRelation> {
  final int id;
  final int sourceNodeId;
  final int targetNodeId;
  final String relationType;
  final String description;
  const KnowledgeRelation({
    required this.id,
    required this.sourceNodeId,
    required this.targetNodeId,
    required this.relationType,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_node_id'] = Variable<int>(sourceNodeId);
    map['target_node_id'] = Variable<int>(targetNodeId);
    map['relation_type'] = Variable<String>(relationType);
    map['description'] = Variable<String>(description);
    return map;
  }

  KnowledgeRelationsCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeRelationsCompanion(
      id: Value(id),
      sourceNodeId: Value(sourceNodeId),
      targetNodeId: Value(targetNodeId),
      relationType: Value(relationType),
      description: Value(description),
    );
  }

  factory KnowledgeRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeRelation(
      id: serializer.fromJson<int>(json['id']),
      sourceNodeId: serializer.fromJson<int>(json['sourceNodeId']),
      targetNodeId: serializer.fromJson<int>(json['targetNodeId']),
      relationType: serializer.fromJson<String>(json['relationType']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceNodeId': serializer.toJson<int>(sourceNodeId),
      'targetNodeId': serializer.toJson<int>(targetNodeId),
      'relationType': serializer.toJson<String>(relationType),
      'description': serializer.toJson<String>(description),
    };
  }

  KnowledgeRelation copyWith({
    int? id,
    int? sourceNodeId,
    int? targetNodeId,
    String? relationType,
    String? description,
  }) => KnowledgeRelation(
    id: id ?? this.id,
    sourceNodeId: sourceNodeId ?? this.sourceNodeId,
    targetNodeId: targetNodeId ?? this.targetNodeId,
    relationType: relationType ?? this.relationType,
    description: description ?? this.description,
  );
  KnowledgeRelation copyWithCompanion(KnowledgeRelationsCompanion data) {
    return KnowledgeRelation(
      id: data.id.present ? data.id.value : this.id,
      sourceNodeId: data.sourceNodeId.present
          ? data.sourceNodeId.value
          : this.sourceNodeId,
      targetNodeId: data.targetNodeId.present
          ? data.targetNodeId.value
          : this.targetNodeId,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeRelation(')
          ..write('id: $id, ')
          ..write('sourceNodeId: $sourceNodeId, ')
          ..write('targetNodeId: $targetNodeId, ')
          ..write('relationType: $relationType, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourceNodeId, targetNodeId, relationType, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeRelation &&
          other.id == this.id &&
          other.sourceNodeId == this.sourceNodeId &&
          other.targetNodeId == this.targetNodeId &&
          other.relationType == this.relationType &&
          other.description == this.description);
}

class KnowledgeRelationsCompanion extends UpdateCompanion<KnowledgeRelation> {
  final Value<int> id;
  final Value<int> sourceNodeId;
  final Value<int> targetNodeId;
  final Value<String> relationType;
  final Value<String> description;
  const KnowledgeRelationsCompanion({
    this.id = const Value.absent(),
    this.sourceNodeId = const Value.absent(),
    this.targetNodeId = const Value.absent(),
    this.relationType = const Value.absent(),
    this.description = const Value.absent(),
  });
  KnowledgeRelationsCompanion.insert({
    this.id = const Value.absent(),
    required int sourceNodeId,
    required int targetNodeId,
    required String relationType,
    this.description = const Value.absent(),
  }) : sourceNodeId = Value(sourceNodeId),
       targetNodeId = Value(targetNodeId),
       relationType = Value(relationType);
  static Insertable<KnowledgeRelation> custom({
    Expression<int>? id,
    Expression<int>? sourceNodeId,
    Expression<int>? targetNodeId,
    Expression<String>? relationType,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceNodeId != null) 'source_node_id': sourceNodeId,
      if (targetNodeId != null) 'target_node_id': targetNodeId,
      if (relationType != null) 'relation_type': relationType,
      if (description != null) 'description': description,
    });
  }

  KnowledgeRelationsCompanion copyWith({
    Value<int>? id,
    Value<int>? sourceNodeId,
    Value<int>? targetNodeId,
    Value<String>? relationType,
    Value<String>? description,
  }) {
    return KnowledgeRelationsCompanion(
      id: id ?? this.id,
      sourceNodeId: sourceNodeId ?? this.sourceNodeId,
      targetNodeId: targetNodeId ?? this.targetNodeId,
      relationType: relationType ?? this.relationType,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceNodeId.present) {
      map['source_node_id'] = Variable<int>(sourceNodeId.value);
    }
    if (targetNodeId.present) {
      map['target_node_id'] = Variable<int>(targetNodeId.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeRelationsCompanion(')
          ..write('id: $id, ')
          ..write('sourceNodeId: $sourceNodeId, ')
          ..write('targetNodeId: $targetNodeId, ')
          ..write('relationType: $relationType, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeEditHistoriesTable extends KnowledgeEditHistories
    with TableInfo<$KnowledgeEditHistoriesTable, KnowledgeEditHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeEditHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES knowledge_projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beforeDataMeta = const VerificationMeta(
    'beforeData',
  );
  @override
  late final GeneratedColumn<String> beforeData = GeneratedColumn<String>(
    'before_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _afterDataMeta = const VerificationMeta(
    'afterData',
  );
  @override
  late final GeneratedColumn<String> afterData = GeneratedColumn<String>(
    'after_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    operationType,
    beforeData,
    afterData,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_edit_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeEditHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('before_data')) {
      context.handle(
        _beforeDataMeta,
        beforeData.isAcceptableOrUnknown(data['before_data']!, _beforeDataMeta),
      );
    }
    if (data.containsKey('after_data')) {
      context.handle(
        _afterDataMeta,
        afterData.isAcceptableOrUnknown(data['after_data']!, _afterDataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeEditHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeEditHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      beforeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}before_data'],
      ),
      afterData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}after_data'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $KnowledgeEditHistoriesTable createAlias(String alias) {
    return $KnowledgeEditHistoriesTable(attachedDatabase, alias);
  }
}

class KnowledgeEditHistory extends DataClass
    implements Insertable<KnowledgeEditHistory> {
  final int id;
  final int projectId;
  final String operationType;
  final String? beforeData;
  final String? afterData;
  final DateTime createdAt;
  const KnowledgeEditHistory({
    required this.id,
    required this.projectId,
    required this.operationType,
    this.beforeData,
    this.afterData,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['operation_type'] = Variable<String>(operationType);
    if (!nullToAbsent || beforeData != null) {
      map['before_data'] = Variable<String>(beforeData);
    }
    if (!nullToAbsent || afterData != null) {
      map['after_data'] = Variable<String>(afterData);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KnowledgeEditHistoriesCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeEditHistoriesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      operationType: Value(operationType),
      beforeData: beforeData == null && nullToAbsent
          ? const Value.absent()
          : Value(beforeData),
      afterData: afterData == null && nullToAbsent
          ? const Value.absent()
          : Value(afterData),
      createdAt: Value(createdAt),
    );
  }

  factory KnowledgeEditHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeEditHistory(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      beforeData: serializer.fromJson<String?>(json['beforeData']),
      afterData: serializer.fromJson<String?>(json['afterData']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'operationType': serializer.toJson<String>(operationType),
      'beforeData': serializer.toJson<String?>(beforeData),
      'afterData': serializer.toJson<String?>(afterData),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  KnowledgeEditHistory copyWith({
    int? id,
    int? projectId,
    String? operationType,
    Value<String?> beforeData = const Value.absent(),
    Value<String?> afterData = const Value.absent(),
    DateTime? createdAt,
  }) => KnowledgeEditHistory(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    operationType: operationType ?? this.operationType,
    beforeData: beforeData.present ? beforeData.value : this.beforeData,
    afterData: afterData.present ? afterData.value : this.afterData,
    createdAt: createdAt ?? this.createdAt,
  );
  KnowledgeEditHistory copyWithCompanion(KnowledgeEditHistoriesCompanion data) {
    return KnowledgeEditHistory(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      beforeData: data.beforeData.present
          ? data.beforeData.value
          : this.beforeData,
      afterData: data.afterData.present ? data.afterData.value : this.afterData,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeEditHistory(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('operationType: $operationType, ')
          ..write('beforeData: $beforeData, ')
          ..write('afterData: $afterData, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    operationType,
    beforeData,
    afterData,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeEditHistory &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.operationType == this.operationType &&
          other.beforeData == this.beforeData &&
          other.afterData == this.afterData &&
          other.createdAt == this.createdAt);
}

class KnowledgeEditHistoriesCompanion
    extends UpdateCompanion<KnowledgeEditHistory> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> operationType;
  final Value<String?> beforeData;
  final Value<String?> afterData;
  final Value<DateTime> createdAt;
  const KnowledgeEditHistoriesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.beforeData = const Value.absent(),
    this.afterData = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  KnowledgeEditHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String operationType,
    this.beforeData = const Value.absent(),
    this.afterData = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : projectId = Value(projectId),
       operationType = Value(operationType);
  static Insertable<KnowledgeEditHistory> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? operationType,
    Expression<String>? beforeData,
    Expression<String>? afterData,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (operationType != null) 'operation_type': operationType,
      if (beforeData != null) 'before_data': beforeData,
      if (afterData != null) 'after_data': afterData,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  KnowledgeEditHistoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<String>? operationType,
    Value<String?>? beforeData,
    Value<String?>? afterData,
    Value<DateTime>? createdAt,
  }) {
    return KnowledgeEditHistoriesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      operationType: operationType ?? this.operationType,
      beforeData: beforeData ?? this.beforeData,
      afterData: afterData ?? this.afterData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (beforeData.present) {
      map['before_data'] = Variable<String>(beforeData.value);
    }
    if (afterData.present) {
      map['after_data'] = Variable<String>(afterData.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeEditHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('operationType: $operationType, ')
          ..write('beforeData: $beforeData, ')
          ..write('afterData: $afterData, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskCategoriesTable taskCategories = $TaskCategoriesTable(this);
  late final $TaskRecordsTable taskRecords = $TaskRecordsTable(this);
  late final $TaskRemindersTable taskReminders = $TaskRemindersTable(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  late final $DiaryTagsTable diaryTags = $DiaryTagsTable(this);
  late final $DiaryTagRelationsTable diaryTagRelations =
      $DiaryTagRelationsTable(this);
  late final $DiaryImagesTable diaryImages = $DiaryImagesTable(this);
  late final $KnowledgeProjectsTable knowledgeProjects =
      $KnowledgeProjectsTable(this);
  late final $KnowledgeNodesTable knowledgeNodes = $KnowledgeNodesTable(this);
  late final $KnowledgeRelationsTable knowledgeRelations =
      $KnowledgeRelationsTable(this);
  late final $KnowledgeEditHistoriesTable knowledgeEditHistories =
      $KnowledgeEditHistoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskCategories,
    taskRecords,
    taskReminders,
    diaryEntries,
    diaryTags,
    diaryTagRelations,
    diaryImages,
    knowledgeProjects,
    knowledgeNodes,
    knowledgeRelations,
    knowledgeEditHistories,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_records', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_records', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'diary_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('diary_tag_relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'diary_tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('diary_tag_relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'diary_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('diary_images', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'knowledge_projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('knowledge_nodes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'knowledge_nodes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('knowledge_nodes', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'knowledge_nodes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('knowledge_relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'knowledge_nodes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('knowledge_relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'knowledge_projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('knowledge_edit_histories', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$TaskCategoriesTableCreateCompanionBuilder =
    TaskCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<int> colorValue,
      Value<DateTime> createdAt,
    });
typedef $$TaskCategoriesTableUpdateCompanionBuilder =
    TaskCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> colorValue,
      Value<DateTime> createdAt,
    });

final class $$TaskCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $TaskCategoriesTable, TaskCategory> {
  $$TaskCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TaskRecordsTable, List<TaskRecord>>
  _taskRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskRecords,
    aliasName: $_aliasNameGenerator(
      db.taskCategories.id,
      db.taskRecords.categoryId,
    ),
  );

  $$TaskRecordsTableProcessedTableManager get taskRecordsRefs {
    final manager = $$TaskRecordsTableTableManager(
      $_db,
      $_db.taskRecords,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTable> {
  $$TaskCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskRecordsRefs(
    Expression<bool> Function($$TaskRecordsTableFilterComposer f) f,
  ) {
    final $$TaskRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableFilterComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTable> {
  $$TaskCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTable> {
  $$TaskCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> taskRecordsRefs<T extends Object>(
    Expression<T> Function($$TaskRecordsTableAnnotationComposer a) f,
  ) {
    final $$TaskRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCategoriesTable,
          TaskCategory,
          $$TaskCategoriesTableFilterComposer,
          $$TaskCategoriesTableOrderingComposer,
          $$TaskCategoriesTableAnnotationComposer,
          $$TaskCategoriesTableCreateCompanionBuilder,
          $$TaskCategoriesTableUpdateCompanionBuilder,
          (TaskCategory, $$TaskCategoriesTableReferences),
          TaskCategory,
          PrefetchHooks Function({bool taskRecordsRefs})
        > {
  $$TaskCategoriesTableTableManager(
    _$AppDatabase db,
    $TaskCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TaskCategoriesCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> colorValue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TaskCategoriesCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskRecordsRefs) db.taskRecords],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskRecordsRefs)
                    await $_getPrefetchedData<
                      TaskCategory,
                      $TaskCategoriesTable,
                      TaskRecord
                    >(
                      currentTable: table,
                      referencedTable: $$TaskCategoriesTableReferences
                          ._taskRecordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TaskCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).taskRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCategoriesTable,
      TaskCategory,
      $$TaskCategoriesTableFilterComposer,
      $$TaskCategoriesTableOrderingComposer,
      $$TaskCategoriesTableAnnotationComposer,
      $$TaskCategoriesTableCreateCompanionBuilder,
      $$TaskCategoriesTableUpdateCompanionBuilder,
      (TaskCategory, $$TaskCategoriesTableReferences),
      TaskCategory,
      PrefetchHooks Function({bool taskRecordsRefs})
    >;
typedef $$TaskRecordsTableCreateCompanionBuilder =
    TaskRecordsCompanion Function({
      Value<int> id,
      required String title,
      Value<String> description,
      Value<DateTime?> dueDate,
      Value<String?> dueTime,
      Value<int> priority,
      Value<String> repeatRule,
      Value<int?> previousOccurrenceId,
      Value<int?> categoryId,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TaskRecordsTableUpdateCompanionBuilder =
    TaskRecordsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<DateTime?> dueDate,
      Value<String?> dueTime,
      Value<int> priority,
      Value<String> repeatRule,
      Value<int?> previousOccurrenceId,
      Value<int?> categoryId,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TaskRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $TaskRecordsTable, TaskRecord> {
  $$TaskRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TaskRecordsTable _previousOccurrenceIdTable(_$AppDatabase db) =>
      db.taskRecords.createAlias(
        $_aliasNameGenerator(
          db.taskRecords.previousOccurrenceId,
          db.taskRecords.id,
        ),
      );

  $$TaskRecordsTableProcessedTableManager? get previousOccurrenceId {
    final $_column = $_itemColumn<int>('previous_occurrence_id');
    if ($_column == null) return null;
    final manager = $$TaskRecordsTableTableManager(
      $_db,
      $_db.taskRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _previousOccurrenceIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaskCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.taskCategories.createAlias(
        $_aliasNameGenerator(db.taskRecords.categoryId, db.taskCategories.id),
      );

  $$TaskCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$TaskCategoriesTableTableManager(
      $_db,
      $_db.taskCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskRemindersTable, List<TaskReminder>>
  _taskRemindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskReminders,
    aliasName: $_aliasNameGenerator(db.taskRecords.id, db.taskReminders.taskId),
  );

  $$TaskRemindersTableProcessedTableManager get taskRemindersRefs {
    final manager = $$TaskRemindersTableTableManager(
      $_db,
      $_db.taskReminders,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskRemindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get dueDate =>
      $composableBuilder(
        column: $table.dueDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskRecordsTableFilterComposer get previousOccurrenceId {
    final $$TaskRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousOccurrenceId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableFilterComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskCategoriesTableFilterComposer get categoryId {
    final $$TaskCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.taskCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.taskCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskRemindersRefs(
    Expression<bool> Function($$TaskRemindersTableFilterComposer f) f,
  ) {
    final $$TaskRemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskReminders,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRemindersTableFilterComposer(
            $db: $db,
            $table: $db.taskReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskRecordsTableOrderingComposer get previousOccurrenceId {
    final $$TaskRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousOccurrenceId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskCategoriesTableOrderingComposer get categoryId {
    final $$TaskCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.taskCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.taskCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime?, int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TaskRecordsTableAnnotationComposer get previousOccurrenceId {
    final $$TaskRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousOccurrenceId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskCategoriesTableAnnotationComposer get categoryId {
    final $$TaskCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.taskCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskRemindersRefs<T extends Object>(
    Expression<T> Function($$TaskRemindersTableAnnotationComposer a) f,
  ) {
    final $$TaskRemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskReminders,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.taskReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskRecordsTable,
          TaskRecord,
          $$TaskRecordsTableFilterComposer,
          $$TaskRecordsTableOrderingComposer,
          $$TaskRecordsTableAnnotationComposer,
          $$TaskRecordsTableCreateCompanionBuilder,
          $$TaskRecordsTableUpdateCompanionBuilder,
          (TaskRecord, $$TaskRecordsTableReferences),
          TaskRecord,
          PrefetchHooks Function({
            bool previousOccurrenceId,
            bool categoryId,
            bool taskRemindersRefs,
          })
        > {
  $$TaskRecordsTableTableManager(_$AppDatabase db, $TaskRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String> repeatRule = const Value.absent(),
                Value<int?> previousOccurrenceId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaskRecordsCompanion(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                dueTime: dueTime,
                priority: priority,
                repeatRule: repeatRule,
                previousOccurrenceId: previousOccurrenceId,
                categoryId: categoryId,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String> repeatRule = const Value.absent(),
                Value<int?> previousOccurrenceId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaskRecordsCompanion.insert(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                dueTime: dueTime,
                priority: priority,
                repeatRule: repeatRule,
                previousOccurrenceId: previousOccurrenceId,
                categoryId: categoryId,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                previousOccurrenceId = false,
                categoryId = false,
                taskRemindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskRemindersRefs) db.taskReminders,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (previousOccurrenceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.previousOccurrenceId,
                            referencedTable: $$TaskRecordsTableReferences
                                ._previousOccurrenceIdTable(db),
                            referencedColumn: $$TaskRecordsTableReferences
                                ._previousOccurrenceIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TaskRecordsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TaskRecordsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskRemindersRefs)
                        await $_getPrefetchedData<
                          TaskRecord,
                          $TaskRecordsTable,
                          TaskReminder
                        >(
                          currentTable: table,
                          referencedTable: $$TaskRecordsTableReferences
                              ._taskRemindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskRemindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TaskRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskRecordsTable,
      TaskRecord,
      $$TaskRecordsTableFilterComposer,
      $$TaskRecordsTableOrderingComposer,
      $$TaskRecordsTableAnnotationComposer,
      $$TaskRecordsTableCreateCompanionBuilder,
      $$TaskRecordsTableUpdateCompanionBuilder,
      (TaskRecord, $$TaskRecordsTableReferences),
      TaskRecord,
      PrefetchHooks Function({
        bool previousOccurrenceId,
        bool categoryId,
        bool taskRemindersRefs,
      })
    >;
typedef $$TaskRemindersTableCreateCompanionBuilder =
    TaskRemindersCompanion Function({
      Value<int> id,
      required int taskId,
      required DateTime reminderTime,
      Value<String> repeatRule,
      required int notificationId,
    });
typedef $$TaskRemindersTableUpdateCompanionBuilder =
    TaskRemindersCompanion Function({
      Value<int> id,
      Value<int> taskId,
      Value<DateTime> reminderTime,
      Value<String> repeatRule,
      Value<int> notificationId,
    });

final class $$TaskRemindersTableReferences
    extends BaseReferences<_$AppDatabase, $TaskRemindersTable, TaskReminder> {
  $$TaskRemindersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskRecordsTable _taskIdTable(_$AppDatabase db) =>
      db.taskRecords.createAlias(
        $_aliasNameGenerator(db.taskReminders.taskId, db.taskRecords.id),
      );

  $$TaskRecordsTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$TaskRecordsTableTableManager(
      $_db,
      $_db.taskRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskRecordsTableFilterComposer get taskId {
    final $$TaskRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableFilterComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskRecordsTableOrderingComposer get taskId {
    final $$TaskRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  $$TaskRecordsTableAnnotationComposer get taskId {
    final $$TaskRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskRemindersTable,
          TaskReminder,
          $$TaskRemindersTableFilterComposer,
          $$TaskRemindersTableOrderingComposer,
          $$TaskRemindersTableAnnotationComposer,
          $$TaskRemindersTableCreateCompanionBuilder,
          $$TaskRemindersTableUpdateCompanionBuilder,
          (TaskReminder, $$TaskRemindersTableReferences),
          TaskReminder,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskRemindersTableTableManager(_$AppDatabase db, $TaskRemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<DateTime> reminderTime = const Value.absent(),
                Value<String> repeatRule = const Value.absent(),
                Value<int> notificationId = const Value.absent(),
              }) => TaskRemindersCompanion(
                id: id,
                taskId: taskId,
                reminderTime: reminderTime,
                repeatRule: repeatRule,
                notificationId: notificationId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int taskId,
                required DateTime reminderTime,
                Value<String> repeatRule = const Value.absent(),
                required int notificationId,
              }) => TaskRemindersCompanion.insert(
                id: id,
                taskId: taskId,
                reminderTime: reminderTime,
                repeatRule: repeatRule,
                notificationId: notificationId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskRemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$TaskRemindersTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$TaskRemindersTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskRemindersTable,
      TaskReminder,
      $$TaskRemindersTableFilterComposer,
      $$TaskRemindersTableOrderingComposer,
      $$TaskRemindersTableAnnotationComposer,
      $$TaskRemindersTableCreateCompanionBuilder,
      $$TaskRemindersTableUpdateCompanionBuilder,
      (TaskReminder, $$TaskRemindersTableReferences),
      TaskReminder,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$DiaryEntriesTableCreateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> content,
      required DateTime diaryDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DiaryEntriesTableUpdateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> content,
      Value<DateTime> diaryDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$DiaryEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry> {
  $$DiaryEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DiaryTagRelationsTable, List<DiaryTagRelation>>
  _diaryTagRelationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.diaryTagRelations,
        aliasName: $_aliasNameGenerator(
          db.diaryEntries.id,
          db.diaryTagRelations.diaryId,
        ),
      );

  $$DiaryTagRelationsTableProcessedTableManager get diaryTagRelationsRefs {
    final manager = $$DiaryTagRelationsTableTableManager(
      $_db,
      $_db.diaryTagRelations,
    ).filter((f) => f.diaryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _diaryTagRelationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DiaryImagesTable, List<DiaryImage>>
  _diaryImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.diaryImages,
    aliasName: $_aliasNameGenerator(db.diaryEntries.id, db.diaryImages.diaryId),
  );

  $$DiaryImagesTableProcessedTableManager get diaryImagesRefs {
    final manager = $$DiaryImagesTableTableManager(
      $_db,
      $_db.diaryImages,
    ).filter((f) => f.diaryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_diaryImagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get diaryDate =>
      $composableBuilder(
        column: $table.diaryDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> diaryTagRelationsRefs(
    Expression<bool> Function($$DiaryTagRelationsTableFilterComposer f) f,
  ) {
    final $$DiaryTagRelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryTagRelations,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagRelationsTableFilterComposer(
            $db: $db,
            $table: $db.diaryTagRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> diaryImagesRefs(
    Expression<bool> Function($$DiaryImagesTableFilterComposer f) f,
  ) {
    final $$DiaryImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryImages,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryImagesTableFilterComposer(
            $db: $db,
            $table: $db.diaryImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaryDate => $composableBuilder(
    column: $table.diaryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get diaryDate =>
      $composableBuilder(column: $table.diaryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> diaryTagRelationsRefs<T extends Object>(
    Expression<T> Function($$DiaryTagRelationsTableAnnotationComposer a) f,
  ) {
    final $$DiaryTagRelationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.diaryTagRelations,
          getReferencedColumn: (t) => t.diaryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DiaryTagRelationsTableAnnotationComposer(
                $db: $db,
                $table: $db.diaryTagRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> diaryImagesRefs<T extends Object>(
    Expression<T> Function($$DiaryImagesTableAnnotationComposer a) f,
  ) {
    final $$DiaryImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryImages,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiaryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryEntriesTable,
          DiaryEntry,
          $$DiaryEntriesTableFilterComposer,
          $$DiaryEntriesTableOrderingComposer,
          $$DiaryEntriesTableAnnotationComposer,
          $$DiaryEntriesTableCreateCompanionBuilder,
          $$DiaryEntriesTableUpdateCompanionBuilder,
          (DiaryEntry, $$DiaryEntriesTableReferences),
          DiaryEntry,
          PrefetchHooks Function({
            bool diaryTagRelationsRefs,
            bool diaryImagesRefs,
          })
        > {
  $$DiaryEntriesTableTableManager(_$AppDatabase db, $DiaryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> diaryDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DiaryEntriesCompanion(
                id: id,
                title: title,
                content: content,
                diaryDate: diaryDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                required DateTime diaryDate,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DiaryEntriesCompanion.insert(
                id: id,
                title: title,
                content: content,
                diaryDate: diaryDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({diaryTagRelationsRefs = false, diaryImagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (diaryTagRelationsRefs) db.diaryTagRelations,
                    if (diaryImagesRefs) db.diaryImages,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (diaryTagRelationsRefs)
                        await $_getPrefetchedData<
                          DiaryEntry,
                          $DiaryEntriesTable,
                          DiaryTagRelation
                        >(
                          currentTable: table,
                          referencedTable: $$DiaryEntriesTableReferences
                              ._diaryTagRelationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiaryEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).diaryTagRelationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diaryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (diaryImagesRefs)
                        await $_getPrefetchedData<
                          DiaryEntry,
                          $DiaryEntriesTable,
                          DiaryImage
                        >(
                          currentTable: table,
                          referencedTable: $$DiaryEntriesTableReferences
                              ._diaryImagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiaryEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).diaryImagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diaryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DiaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryEntriesTable,
      DiaryEntry,
      $$DiaryEntriesTableFilterComposer,
      $$DiaryEntriesTableOrderingComposer,
      $$DiaryEntriesTableAnnotationComposer,
      $$DiaryEntriesTableCreateCompanionBuilder,
      $$DiaryEntriesTableUpdateCompanionBuilder,
      (DiaryEntry, $$DiaryEntriesTableReferences),
      DiaryEntry,
      PrefetchHooks Function({bool diaryTagRelationsRefs, bool diaryImagesRefs})
    >;
typedef $$DiaryTagsTableCreateCompanionBuilder = DiaryTagsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$DiaryTagsTableUpdateCompanionBuilder = DiaryTagsCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$DiaryTagsTableReferences
    extends BaseReferences<_$AppDatabase, $DiaryTagsTable, DiaryTag> {
  $$DiaryTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DiaryTagRelationsTable, List<DiaryTagRelation>>
  _diaryTagRelationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.diaryTagRelations,
        aliasName: $_aliasNameGenerator(
          db.diaryTags.id,
          db.diaryTagRelations.tagId,
        ),
      );

  $$DiaryTagRelationsTableProcessedTableManager get diaryTagRelationsRefs {
    final manager = $$DiaryTagRelationsTableTableManager(
      $_db,
      $_db.diaryTagRelations,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _diaryTagRelationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiaryTagsTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryTagsTable> {
  $$DiaryTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> diaryTagRelationsRefs(
    Expression<bool> Function($$DiaryTagRelationsTableFilterComposer f) f,
  ) {
    final $$DiaryTagRelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryTagRelations,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagRelationsTableFilterComposer(
            $db: $db,
            $table: $db.diaryTagRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiaryTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryTagsTable> {
  $$DiaryTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiaryTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryTagsTable> {
  $$DiaryTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> diaryTagRelationsRefs<T extends Object>(
    Expression<T> Function($$DiaryTagRelationsTableAnnotationComposer a) f,
  ) {
    final $$DiaryTagRelationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.diaryTagRelations,
          getReferencedColumn: (t) => t.tagId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DiaryTagRelationsTableAnnotationComposer(
                $db: $db,
                $table: $db.diaryTagRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DiaryTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryTagsTable,
          DiaryTag,
          $$DiaryTagsTableFilterComposer,
          $$DiaryTagsTableOrderingComposer,
          $$DiaryTagsTableAnnotationComposer,
          $$DiaryTagsTableCreateCompanionBuilder,
          $$DiaryTagsTableUpdateCompanionBuilder,
          (DiaryTag, $$DiaryTagsTableReferences),
          DiaryTag,
          PrefetchHooks Function({bool diaryTagRelationsRefs})
        > {
  $$DiaryTagsTableTableManager(_$AppDatabase db, $DiaryTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => DiaryTagsCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => DiaryTagsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diaryTagRelationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (diaryTagRelationsRefs) db.diaryTagRelations,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (diaryTagRelationsRefs)
                    await $_getPrefetchedData<
                      DiaryTag,
                      $DiaryTagsTable,
                      DiaryTagRelation
                    >(
                      currentTable: table,
                      referencedTable: $$DiaryTagsTableReferences
                          ._diaryTagRelationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DiaryTagsTableReferences(
                            db,
                            table,
                            p0,
                          ).diaryTagRelationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DiaryTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryTagsTable,
      DiaryTag,
      $$DiaryTagsTableFilterComposer,
      $$DiaryTagsTableOrderingComposer,
      $$DiaryTagsTableAnnotationComposer,
      $$DiaryTagsTableCreateCompanionBuilder,
      $$DiaryTagsTableUpdateCompanionBuilder,
      (DiaryTag, $$DiaryTagsTableReferences),
      DiaryTag,
      PrefetchHooks Function({bool diaryTagRelationsRefs})
    >;
typedef $$DiaryTagRelationsTableCreateCompanionBuilder =
    DiaryTagRelationsCompanion Function({
      required int diaryId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$DiaryTagRelationsTableUpdateCompanionBuilder =
    DiaryTagRelationsCompanion Function({
      Value<int> diaryId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $$DiaryTagRelationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DiaryTagRelationsTable,
          DiaryTagRelation
        > {
  $$DiaryTagRelationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DiaryEntriesTable _diaryIdTable(_$AppDatabase db) =>
      db.diaryEntries.createAlias(
        $_aliasNameGenerator(db.diaryTagRelations.diaryId, db.diaryEntries.id),
      );

  $$DiaryEntriesTableProcessedTableManager get diaryId {
    final $_column = $_itemColumn<int>('diary_id')!;

    final manager = $$DiaryEntriesTableTableManager(
      $_db,
      $_db.diaryEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DiaryTagsTable _tagIdTable(_$AppDatabase db) =>
      db.diaryTags.createAlias(
        $_aliasNameGenerator(db.diaryTagRelations.tagId, db.diaryTags.id),
      );

  $$DiaryTagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$DiaryTagsTableTableManager(
      $_db,
      $_db.diaryTags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiaryTagRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryTagRelationsTable> {
  $$DiaryTagRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DiaryEntriesTableFilterComposer get diaryId {
    final $$DiaryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiaryTagsTableFilterComposer get tagId {
    final $$DiaryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.diaryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagsTableFilterComposer(
            $db: $db,
            $table: $db.diaryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryTagRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryTagRelationsTable> {
  $$DiaryTagRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DiaryEntriesTableOrderingComposer get diaryId {
    final $$DiaryEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiaryTagsTableOrderingComposer get tagId {
    final $$DiaryTagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.diaryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagsTableOrderingComposer(
            $db: $db,
            $table: $db.diaryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryTagRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryTagRelationsTable> {
  $$DiaryTagRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DiaryEntriesTableAnnotationComposer get diaryId {
    final $$DiaryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiaryTagsTableAnnotationComposer get tagId {
    final $$DiaryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.diaryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryTagRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryTagRelationsTable,
          DiaryTagRelation,
          $$DiaryTagRelationsTableFilterComposer,
          $$DiaryTagRelationsTableOrderingComposer,
          $$DiaryTagRelationsTableAnnotationComposer,
          $$DiaryTagRelationsTableCreateCompanionBuilder,
          $$DiaryTagRelationsTableUpdateCompanionBuilder,
          (DiaryTagRelation, $$DiaryTagRelationsTableReferences),
          DiaryTagRelation,
          PrefetchHooks Function({bool diaryId, bool tagId})
        > {
  $$DiaryTagRelationsTableTableManager(
    _$AppDatabase db,
    $DiaryTagRelationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryTagRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryTagRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryTagRelationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> diaryId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryTagRelationsCompanion(
                diaryId: diaryId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int diaryId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => DiaryTagRelationsCompanion.insert(
                diaryId: diaryId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryTagRelationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diaryId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diaryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.diaryId,
                        referencedTable: $$DiaryTagRelationsTableReferences
                            ._diaryIdTable(db),
                        referencedColumn: $$DiaryTagRelationsTableReferences
                            ._diaryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$DiaryTagRelationsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$DiaryTagRelationsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiaryTagRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryTagRelationsTable,
      DiaryTagRelation,
      $$DiaryTagRelationsTableFilterComposer,
      $$DiaryTagRelationsTableOrderingComposer,
      $$DiaryTagRelationsTableAnnotationComposer,
      $$DiaryTagRelationsTableCreateCompanionBuilder,
      $$DiaryTagRelationsTableUpdateCompanionBuilder,
      (DiaryTagRelation, $$DiaryTagRelationsTableReferences),
      DiaryTagRelation,
      PrefetchHooks Function({bool diaryId, bool tagId})
    >;
typedef $$DiaryImagesTableCreateCompanionBuilder =
    DiaryImagesCompanion Function({
      Value<int> id,
      required int diaryId,
      required String localPath,
      Value<DateTime> createdAt,
    });
typedef $$DiaryImagesTableUpdateCompanionBuilder =
    DiaryImagesCompanion Function({
      Value<int> id,
      Value<int> diaryId,
      Value<String> localPath,
      Value<DateTime> createdAt,
    });

final class $$DiaryImagesTableReferences
    extends BaseReferences<_$AppDatabase, $DiaryImagesTable, DiaryImage> {
  $$DiaryImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiaryEntriesTable _diaryIdTable(_$AppDatabase db) =>
      db.diaryEntries.createAlias(
        $_aliasNameGenerator(db.diaryImages.diaryId, db.diaryEntries.id),
      );

  $$DiaryEntriesTableProcessedTableManager get diaryId {
    final $_column = $_itemColumn<int>('diary_id')!;

    final manager = $$DiaryEntriesTableTableManager(
      $_db,
      $_db.diaryEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiaryImagesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryImagesTable> {
  $$DiaryImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DiaryEntriesTableFilterComposer get diaryId {
    final $$DiaryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryImagesTable> {
  $$DiaryImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiaryEntriesTableOrderingComposer get diaryId {
    final $$DiaryEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryImagesTable> {
  $$DiaryImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DiaryEntriesTableAnnotationComposer get diaryId {
    final $$DiaryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryImagesTable,
          DiaryImage,
          $$DiaryImagesTableFilterComposer,
          $$DiaryImagesTableOrderingComposer,
          $$DiaryImagesTableAnnotationComposer,
          $$DiaryImagesTableCreateCompanionBuilder,
          $$DiaryImagesTableUpdateCompanionBuilder,
          (DiaryImage, $$DiaryImagesTableReferences),
          DiaryImage,
          PrefetchHooks Function({bool diaryId})
        > {
  $$DiaryImagesTableTableManager(_$AppDatabase db, $DiaryImagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> diaryId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DiaryImagesCompanion(
                id: id,
                diaryId: diaryId,
                localPath: localPath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int diaryId,
                required String localPath,
                Value<DateTime> createdAt = const Value.absent(),
              }) => DiaryImagesCompanion.insert(
                id: id,
                diaryId: diaryId,
                localPath: localPath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryImagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diaryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diaryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.diaryId,
                        referencedTable: $$DiaryImagesTableReferences
                            ._diaryIdTable(db),
                        referencedColumn: $$DiaryImagesTableReferences
                            ._diaryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiaryImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryImagesTable,
      DiaryImage,
      $$DiaryImagesTableFilterComposer,
      $$DiaryImagesTableOrderingComposer,
      $$DiaryImagesTableAnnotationComposer,
      $$DiaryImagesTableCreateCompanionBuilder,
      $$DiaryImagesTableUpdateCompanionBuilder,
      (DiaryImage, $$DiaryImagesTableReferences),
      DiaryImage,
      PrefetchHooks Function({bool diaryId})
    >;
typedef $$KnowledgeProjectsTableCreateCompanionBuilder =
    KnowledgeProjectsCompanion Function({
      Value<int> id,
      required String title,
      Value<String> description,
      Value<String> generationStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$KnowledgeProjectsTableUpdateCompanionBuilder =
    KnowledgeProjectsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<String> generationStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$KnowledgeProjectsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $KnowledgeProjectsTable,
          KnowledgeProject
        > {
  $$KnowledgeProjectsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$KnowledgeNodesTable, List<KnowledgeNode>>
  _knowledgeNodesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.knowledgeNodes,
    aliasName: $_aliasNameGenerator(
      db.knowledgeProjects.id,
      db.knowledgeNodes.projectId,
    ),
  );

  $$KnowledgeNodesTableProcessedTableManager get knowledgeNodesRefs {
    final manager = $$KnowledgeNodesTableTableManager(
      $_db,
      $_db.knowledgeNodes,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_knowledgeNodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $KnowledgeEditHistoriesTable,
    List<KnowledgeEditHistory>
  >
  _knowledgeEditHistoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.knowledgeEditHistories,
        aliasName: $_aliasNameGenerator(
          db.knowledgeProjects.id,
          db.knowledgeEditHistories.projectId,
        ),
      );

  $$KnowledgeEditHistoriesTableProcessedTableManager
  get knowledgeEditHistoriesRefs {
    final manager = $$KnowledgeEditHistoriesTableTableManager(
      $_db,
      $_db.knowledgeEditHistories,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _knowledgeEditHistoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KnowledgeProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeProjectsTable> {
  $$KnowledgeProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generationStatus => $composableBuilder(
    column: $table.generationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> knowledgeNodesRefs(
    Expression<bool> Function($$KnowledgeNodesTableFilterComposer f) f,
  ) {
    final $$KnowledgeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> knowledgeEditHistoriesRefs(
    Expression<bool> Function($$KnowledgeEditHistoriesTableFilterComposer f) f,
  ) {
    final $$KnowledgeEditHistoriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.knowledgeEditHistories,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeEditHistoriesTableFilterComposer(
                $db: $db,
                $table: $db.knowledgeEditHistories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KnowledgeProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeProjectsTable> {
  $$KnowledgeProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generationStatus => $composableBuilder(
    column: $table.generationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnowledgeProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeProjectsTable> {
  $$KnowledgeProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generationStatus => $composableBuilder(
    column: $table.generationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> knowledgeNodesRefs<T extends Object>(
    Expression<T> Function($$KnowledgeNodesTableAnnotationComposer a) f,
  ) {
    final $$KnowledgeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> knowledgeEditHistoriesRefs<T extends Object>(
    Expression<T> Function($$KnowledgeEditHistoriesTableAnnotationComposer a) f,
  ) {
    final $$KnowledgeEditHistoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.knowledgeEditHistories,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeEditHistoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.knowledgeEditHistories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KnowledgeProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnowledgeProjectsTable,
          KnowledgeProject,
          $$KnowledgeProjectsTableFilterComposer,
          $$KnowledgeProjectsTableOrderingComposer,
          $$KnowledgeProjectsTableAnnotationComposer,
          $$KnowledgeProjectsTableCreateCompanionBuilder,
          $$KnowledgeProjectsTableUpdateCompanionBuilder,
          (KnowledgeProject, $$KnowledgeProjectsTableReferences),
          KnowledgeProject,
          PrefetchHooks Function({
            bool knowledgeNodesRefs,
            bool knowledgeEditHistoriesRefs,
          })
        > {
  $$KnowledgeProjectsTableTableManager(
    _$AppDatabase db,
    $KnowledgeProjectsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeProjectsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> generationStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KnowledgeProjectsCompanion(
                id: id,
                title: title,
                description: description,
                generationStatus: generationStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> description = const Value.absent(),
                Value<String> generationStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KnowledgeProjectsCompanion.insert(
                id: id,
                title: title,
                description: description,
                generationStatus: generationStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KnowledgeProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                knowledgeNodesRefs = false,
                knowledgeEditHistoriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (knowledgeNodesRefs) db.knowledgeNodes,
                    if (knowledgeEditHistoriesRefs) db.knowledgeEditHistories,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (knowledgeNodesRefs)
                        await $_getPrefetchedData<
                          KnowledgeProject,
                          $KnowledgeProjectsTable,
                          KnowledgeNode
                        >(
                          currentTable: table,
                          referencedTable: $$KnowledgeProjectsTableReferences
                              ._knowledgeNodesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KnowledgeProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).knowledgeNodesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (knowledgeEditHistoriesRefs)
                        await $_getPrefetchedData<
                          KnowledgeProject,
                          $KnowledgeProjectsTable,
                          KnowledgeEditHistory
                        >(
                          currentTable: table,
                          referencedTable: $$KnowledgeProjectsTableReferences
                              ._knowledgeEditHistoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KnowledgeProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).knowledgeEditHistoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$KnowledgeProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnowledgeProjectsTable,
      KnowledgeProject,
      $$KnowledgeProjectsTableFilterComposer,
      $$KnowledgeProjectsTableOrderingComposer,
      $$KnowledgeProjectsTableAnnotationComposer,
      $$KnowledgeProjectsTableCreateCompanionBuilder,
      $$KnowledgeProjectsTableUpdateCompanionBuilder,
      (KnowledgeProject, $$KnowledgeProjectsTableReferences),
      KnowledgeProject,
      PrefetchHooks Function({
        bool knowledgeNodesRefs,
        bool knowledgeEditHistoriesRefs,
      })
    >;
typedef $$KnowledgeNodesTableCreateCompanionBuilder =
    KnowledgeNodesCompanion Function({
      Value<int> id,
      required int projectId,
      Value<int?> parentId,
      required String title,
      Value<String> summary,
      Value<String> content,
      Value<String> coreConcept,
      Value<String> principle,
      Value<String> mechanism,
      Value<String> methods,
      Value<String> application,
      Value<String> learningValue,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$KnowledgeNodesTableUpdateCompanionBuilder =
    KnowledgeNodesCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<int?> parentId,
      Value<String> title,
      Value<String> summary,
      Value<String> content,
      Value<String> coreConcept,
      Value<String> principle,
      Value<String> mechanism,
      Value<String> methods,
      Value<String> application,
      Value<String> learningValue,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$KnowledgeNodesTableReferences
    extends BaseReferences<_$AppDatabase, $KnowledgeNodesTable, KnowledgeNode> {
  $$KnowledgeNodesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KnowledgeProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.knowledgeProjects.createAlias(
        $_aliasNameGenerator(
          db.knowledgeNodes.projectId,
          db.knowledgeProjects.id,
        ),
      );

  $$KnowledgeProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$KnowledgeProjectsTableTableManager(
      $_db,
      $_db.knowledgeProjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KnowledgeNodesTable _parentIdTable(_$AppDatabase db) =>
      db.knowledgeNodes.createAlias(
        $_aliasNameGenerator(db.knowledgeNodes.parentId, db.knowledgeNodes.id),
      );

  $$KnowledgeNodesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$KnowledgeNodesTableTableManager(
      $_db,
      $_db.knowledgeNodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$KnowledgeRelationsTable, List<KnowledgeRelation>>
  _sourceRelationsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.knowledgeRelations,
    aliasName: $_aliasNameGenerator(
      db.knowledgeNodes.id,
      db.knowledgeRelations.sourceNodeId,
    ),
  );

  $$KnowledgeRelationsTableProcessedTableManager get sourceRelations {
    final manager = $$KnowledgeRelationsTableTableManager(
      $_db,
      $_db.knowledgeRelations,
    ).filter((f) => f.sourceNodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceRelationsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$KnowledgeRelationsTable, List<KnowledgeRelation>>
  _targetRelationsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.knowledgeRelations,
    aliasName: $_aliasNameGenerator(
      db.knowledgeNodes.id,
      db.knowledgeRelations.targetNodeId,
    ),
  );

  $$KnowledgeRelationsTableProcessedTableManager get targetRelations {
    final manager = $$KnowledgeRelationsTableTableManager(
      $_db,
      $_db.knowledgeRelations,
    ).filter((f) => f.targetNodeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetRelationsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KnowledgeNodesTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeNodesTable> {
  $$KnowledgeNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coreConcept => $composableBuilder(
    column: $table.coreConcept,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get principle => $composableBuilder(
    column: $table.principle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mechanism => $composableBuilder(
    column: $table.mechanism,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get methods => $composableBuilder(
    column: $table.methods,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get application => $composableBuilder(
    column: $table.application,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningValue => $composableBuilder(
    column: $table.learningValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$KnowledgeProjectsTableFilterComposer get projectId {
    final $$KnowledgeProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.knowledgeProjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeProjectsTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeProjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KnowledgeNodesTableFilterComposer get parentId {
    final $$KnowledgeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sourceRelations(
    Expression<bool> Function($$KnowledgeRelationsTableFilterComposer f) f,
  ) {
    final $$KnowledgeRelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.knowledgeRelations,
      getReferencedColumn: (t) => t.sourceNodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeRelationsTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> targetRelations(
    Expression<bool> Function($$KnowledgeRelationsTableFilterComposer f) f,
  ) {
    final $$KnowledgeRelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.knowledgeRelations,
      getReferencedColumn: (t) => t.targetNodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeRelationsTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KnowledgeNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeNodesTable> {
  $$KnowledgeNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coreConcept => $composableBuilder(
    column: $table.coreConcept,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get principle => $composableBuilder(
    column: $table.principle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mechanism => $composableBuilder(
    column: $table.mechanism,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get methods => $composableBuilder(
    column: $table.methods,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get application => $composableBuilder(
    column: $table.application,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningValue => $composableBuilder(
    column: $table.learningValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$KnowledgeProjectsTableOrderingComposer get projectId {
    final $$KnowledgeProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.knowledgeProjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.knowledgeProjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KnowledgeNodesTableOrderingComposer get parentId {
    final $$KnowledgeNodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableOrderingComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeNodesTable> {
  $$KnowledgeNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get coreConcept => $composableBuilder(
    column: $table.coreConcept,
    builder: (column) => column,
  );

  GeneratedColumn<String> get principle =>
      $composableBuilder(column: $table.principle, builder: (column) => column);

  GeneratedColumn<String> get mechanism =>
      $composableBuilder(column: $table.mechanism, builder: (column) => column);

  GeneratedColumn<String> get methods =>
      $composableBuilder(column: $table.methods, builder: (column) => column);

  GeneratedColumn<String> get application => $composableBuilder(
    column: $table.application,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learningValue => $composableBuilder(
    column: $table.learningValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$KnowledgeProjectsTableAnnotationComposer get projectId {
    final $$KnowledgeProjectsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.projectId,
          referencedTable: $db.knowledgeProjects,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeProjectsTableAnnotationComposer(
                $db: $db,
                $table: $db.knowledgeProjects,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$KnowledgeNodesTableAnnotationComposer get parentId {
    final $$KnowledgeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sourceRelations<T extends Object>(
    Expression<T> Function($$KnowledgeRelationsTableAnnotationComposer a) f,
  ) {
    final $$KnowledgeRelationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.knowledgeRelations,
          getReferencedColumn: (t) => t.sourceNodeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeRelationsTableAnnotationComposer(
                $db: $db,
                $table: $db.knowledgeRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> targetRelations<T extends Object>(
    Expression<T> Function($$KnowledgeRelationsTableAnnotationComposer a) f,
  ) {
    final $$KnowledgeRelationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.knowledgeRelations,
          getReferencedColumn: (t) => t.targetNodeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeRelationsTableAnnotationComposer(
                $db: $db,
                $table: $db.knowledgeRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KnowledgeNodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnowledgeNodesTable,
          KnowledgeNode,
          $$KnowledgeNodesTableFilterComposer,
          $$KnowledgeNodesTableOrderingComposer,
          $$KnowledgeNodesTableAnnotationComposer,
          $$KnowledgeNodesTableCreateCompanionBuilder,
          $$KnowledgeNodesTableUpdateCompanionBuilder,
          (KnowledgeNode, $$KnowledgeNodesTableReferences),
          KnowledgeNode,
          PrefetchHooks Function({
            bool projectId,
            bool parentId,
            bool sourceRelations,
            bool targetRelations,
          })
        > {
  $$KnowledgeNodesTableTableManager(
    _$AppDatabase db,
    $KnowledgeNodesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> coreConcept = const Value.absent(),
                Value<String> principle = const Value.absent(),
                Value<String> mechanism = const Value.absent(),
                Value<String> methods = const Value.absent(),
                Value<String> application = const Value.absent(),
                Value<String> learningValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KnowledgeNodesCompanion(
                id: id,
                projectId: projectId,
                parentId: parentId,
                title: title,
                summary: summary,
                content: content,
                coreConcept: coreConcept,
                principle: principle,
                mechanism: mechanism,
                methods: methods,
                application: application,
                learningValue: learningValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                Value<int?> parentId = const Value.absent(),
                required String title,
                Value<String> summary = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> coreConcept = const Value.absent(),
                Value<String> principle = const Value.absent(),
                Value<String> mechanism = const Value.absent(),
                Value<String> methods = const Value.absent(),
                Value<String> application = const Value.absent(),
                Value<String> learningValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KnowledgeNodesCompanion.insert(
                id: id,
                projectId: projectId,
                parentId: parentId,
                title: title,
                summary: summary,
                content: content,
                coreConcept: coreConcept,
                principle: principle,
                mechanism: mechanism,
                methods: methods,
                application: application,
                learningValue: learningValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KnowledgeNodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectId = false,
                parentId = false,
                sourceRelations = false,
                targetRelations = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceRelations) db.knowledgeRelations,
                    if (targetRelations) db.knowledgeRelations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$KnowledgeNodesTableReferences
                                ._projectIdTable(db),
                            referencedColumn: $$KnowledgeNodesTableReferences
                                ._projectIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (parentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$KnowledgeNodesTableReferences
                                ._parentIdTable(db),
                            referencedColumn: $$KnowledgeNodesTableReferences
                                ._parentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceRelations)
                        await $_getPrefetchedData<
                          KnowledgeNode,
                          $KnowledgeNodesTable,
                          KnowledgeRelation
                        >(
                          currentTable: table,
                          referencedTable: $$KnowledgeNodesTableReferences
                              ._sourceRelationsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KnowledgeNodesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceRelations,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceNodeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (targetRelations)
                        await $_getPrefetchedData<
                          KnowledgeNode,
                          $KnowledgeNodesTable,
                          KnowledgeRelation
                        >(
                          currentTable: table,
                          referencedTable: $$KnowledgeNodesTableReferences
                              ._targetRelationsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KnowledgeNodesTableReferences(
                                db,
                                table,
                                p0,
                              ).targetRelations,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.targetNodeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$KnowledgeNodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnowledgeNodesTable,
      KnowledgeNode,
      $$KnowledgeNodesTableFilterComposer,
      $$KnowledgeNodesTableOrderingComposer,
      $$KnowledgeNodesTableAnnotationComposer,
      $$KnowledgeNodesTableCreateCompanionBuilder,
      $$KnowledgeNodesTableUpdateCompanionBuilder,
      (KnowledgeNode, $$KnowledgeNodesTableReferences),
      KnowledgeNode,
      PrefetchHooks Function({
        bool projectId,
        bool parentId,
        bool sourceRelations,
        bool targetRelations,
      })
    >;
typedef $$KnowledgeRelationsTableCreateCompanionBuilder =
    KnowledgeRelationsCompanion Function({
      Value<int> id,
      required int sourceNodeId,
      required int targetNodeId,
      required String relationType,
      Value<String> description,
    });
typedef $$KnowledgeRelationsTableUpdateCompanionBuilder =
    KnowledgeRelationsCompanion Function({
      Value<int> id,
      Value<int> sourceNodeId,
      Value<int> targetNodeId,
      Value<String> relationType,
      Value<String> description,
    });

final class $$KnowledgeRelationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $KnowledgeRelationsTable,
          KnowledgeRelation
        > {
  $$KnowledgeRelationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KnowledgeNodesTable _sourceNodeIdTable(_$AppDatabase db) =>
      db.knowledgeNodes.createAlias(
        $_aliasNameGenerator(
          db.knowledgeRelations.sourceNodeId,
          db.knowledgeNodes.id,
        ),
      );

  $$KnowledgeNodesTableProcessedTableManager get sourceNodeId {
    final $_column = $_itemColumn<int>('source_node_id')!;

    final manager = $$KnowledgeNodesTableTableManager(
      $_db,
      $_db.knowledgeNodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceNodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KnowledgeNodesTable _targetNodeIdTable(_$AppDatabase db) =>
      db.knowledgeNodes.createAlias(
        $_aliasNameGenerator(
          db.knowledgeRelations.targetNodeId,
          db.knowledgeNodes.id,
        ),
      );

  $$KnowledgeNodesTableProcessedTableManager get targetNodeId {
    final $_column = $_itemColumn<int>('target_node_id')!;

    final manager = $$KnowledgeNodesTableTableManager(
      $_db,
      $_db.knowledgeNodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetNodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KnowledgeRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeRelationsTable> {
  $$KnowledgeRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$KnowledgeNodesTableFilterComposer get sourceNodeId {
    final $$KnowledgeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNodeId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KnowledgeNodesTableFilterComposer get targetNodeId {
    final $$KnowledgeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNodeId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeRelationsTable> {
  $$KnowledgeRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$KnowledgeNodesTableOrderingComposer get sourceNodeId {
    final $$KnowledgeNodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNodeId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableOrderingComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KnowledgeNodesTableOrderingComposer get targetNodeId {
    final $$KnowledgeNodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNodeId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableOrderingComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeRelationsTable> {
  $$KnowledgeRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$KnowledgeNodesTableAnnotationComposer get sourceNodeId {
    final $$KnowledgeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNodeId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KnowledgeNodesTableAnnotationComposer get targetNodeId {
    final $$KnowledgeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNodeId,
      referencedTable: $db.knowledgeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.knowledgeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnowledgeRelationsTable,
          KnowledgeRelation,
          $$KnowledgeRelationsTableFilterComposer,
          $$KnowledgeRelationsTableOrderingComposer,
          $$KnowledgeRelationsTableAnnotationComposer,
          $$KnowledgeRelationsTableCreateCompanionBuilder,
          $$KnowledgeRelationsTableUpdateCompanionBuilder,
          (KnowledgeRelation, $$KnowledgeRelationsTableReferences),
          KnowledgeRelation,
          PrefetchHooks Function({bool sourceNodeId, bool targetNodeId})
        > {
  $$KnowledgeRelationsTableTableManager(
    _$AppDatabase db,
    $KnowledgeRelationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeRelationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sourceNodeId = const Value.absent(),
                Value<int> targetNodeId = const Value.absent(),
                Value<String> relationType = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => KnowledgeRelationsCompanion(
                id: id,
                sourceNodeId: sourceNodeId,
                targetNodeId: targetNodeId,
                relationType: relationType,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sourceNodeId,
                required int targetNodeId,
                required String relationType,
                Value<String> description = const Value.absent(),
              }) => KnowledgeRelationsCompanion.insert(
                id: id,
                sourceNodeId: sourceNodeId,
                targetNodeId: targetNodeId,
                relationType: relationType,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KnowledgeRelationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceNodeId = false, targetNodeId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceNodeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceNodeId,
                            referencedTable: $$KnowledgeRelationsTableReferences
                                ._sourceNodeIdTable(db),
                            referencedColumn:
                                $$KnowledgeRelationsTableReferences
                                    ._sourceNodeIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (targetNodeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.targetNodeId,
                            referencedTable: $$KnowledgeRelationsTableReferences
                                ._targetNodeIdTable(db),
                            referencedColumn:
                                $$KnowledgeRelationsTableReferences
                                    ._targetNodeIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$KnowledgeRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnowledgeRelationsTable,
      KnowledgeRelation,
      $$KnowledgeRelationsTableFilterComposer,
      $$KnowledgeRelationsTableOrderingComposer,
      $$KnowledgeRelationsTableAnnotationComposer,
      $$KnowledgeRelationsTableCreateCompanionBuilder,
      $$KnowledgeRelationsTableUpdateCompanionBuilder,
      (KnowledgeRelation, $$KnowledgeRelationsTableReferences),
      KnowledgeRelation,
      PrefetchHooks Function({bool sourceNodeId, bool targetNodeId})
    >;
typedef $$KnowledgeEditHistoriesTableCreateCompanionBuilder =
    KnowledgeEditHistoriesCompanion Function({
      Value<int> id,
      required int projectId,
      required String operationType,
      Value<String?> beforeData,
      Value<String?> afterData,
      Value<DateTime> createdAt,
    });
typedef $$KnowledgeEditHistoriesTableUpdateCompanionBuilder =
    KnowledgeEditHistoriesCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<String> operationType,
      Value<String?> beforeData,
      Value<String?> afterData,
      Value<DateTime> createdAt,
    });

final class $$KnowledgeEditHistoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $KnowledgeEditHistoriesTable,
          KnowledgeEditHistory
        > {
  $$KnowledgeEditHistoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KnowledgeProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.knowledgeProjects.createAlias(
        $_aliasNameGenerator(
          db.knowledgeEditHistories.projectId,
          db.knowledgeProjects.id,
        ),
      );

  $$KnowledgeProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$KnowledgeProjectsTableTableManager(
      $_db,
      $_db.knowledgeProjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KnowledgeEditHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeEditHistoriesTable> {
  $$KnowledgeEditHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beforeData => $composableBuilder(
    column: $table.beforeData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get afterData => $composableBuilder(
    column: $table.afterData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$KnowledgeProjectsTableFilterComposer get projectId {
    final $$KnowledgeProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.knowledgeProjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeProjectsTableFilterComposer(
            $db: $db,
            $table: $db.knowledgeProjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeEditHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeEditHistoriesTable> {
  $$KnowledgeEditHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beforeData => $composableBuilder(
    column: $table.beforeData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get afterData => $composableBuilder(
    column: $table.afterData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$KnowledgeProjectsTableOrderingComposer get projectId {
    final $$KnowledgeProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.knowledgeProjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KnowledgeProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.knowledgeProjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KnowledgeEditHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeEditHistoriesTable> {
  $$KnowledgeEditHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get beforeData => $composableBuilder(
    column: $table.beforeData,
    builder: (column) => column,
  );

  GeneratedColumn<String> get afterData =>
      $composableBuilder(column: $table.afterData, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$KnowledgeProjectsTableAnnotationComposer get projectId {
    final $$KnowledgeProjectsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.projectId,
          referencedTable: $db.knowledgeProjects,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KnowledgeProjectsTableAnnotationComposer(
                $db: $db,
                $table: $db.knowledgeProjects,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$KnowledgeEditHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnowledgeEditHistoriesTable,
          KnowledgeEditHistory,
          $$KnowledgeEditHistoriesTableFilterComposer,
          $$KnowledgeEditHistoriesTableOrderingComposer,
          $$KnowledgeEditHistoriesTableAnnotationComposer,
          $$KnowledgeEditHistoriesTableCreateCompanionBuilder,
          $$KnowledgeEditHistoriesTableUpdateCompanionBuilder,
          (KnowledgeEditHistory, $$KnowledgeEditHistoriesTableReferences),
          KnowledgeEditHistory,
          PrefetchHooks Function({bool projectId})
        > {
  $$KnowledgeEditHistoriesTableTableManager(
    _$AppDatabase db,
    $KnowledgeEditHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeEditHistoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$KnowledgeEditHistoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$KnowledgeEditHistoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String?> beforeData = const Value.absent(),
                Value<String?> afterData = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KnowledgeEditHistoriesCompanion(
                id: id,
                projectId: projectId,
                operationType: operationType,
                beforeData: beforeData,
                afterData: afterData,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required String operationType,
                Value<String?> beforeData = const Value.absent(),
                Value<String?> afterData = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KnowledgeEditHistoriesCompanion.insert(
                id: id,
                projectId: projectId,
                operationType: operationType,
                beforeData: beforeData,
                afterData: afterData,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KnowledgeEditHistoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$KnowledgeEditHistoriesTableReferences
                            ._projectIdTable(db),
                        referencedColumn:
                            $$KnowledgeEditHistoriesTableReferences
                                ._projectIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KnowledgeEditHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnowledgeEditHistoriesTable,
      KnowledgeEditHistory,
      $$KnowledgeEditHistoriesTableFilterComposer,
      $$KnowledgeEditHistoriesTableOrderingComposer,
      $$KnowledgeEditHistoriesTableAnnotationComposer,
      $$KnowledgeEditHistoriesTableCreateCompanionBuilder,
      $$KnowledgeEditHistoriesTableUpdateCompanionBuilder,
      (KnowledgeEditHistory, $$KnowledgeEditHistoriesTableReferences),
      KnowledgeEditHistory,
      PrefetchHooks Function({bool projectId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskCategoriesTableTableManager get taskCategories =>
      $$TaskCategoriesTableTableManager(_db, _db.taskCategories);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db, _db.taskRecords);
  $$TaskRemindersTableTableManager get taskReminders =>
      $$TaskRemindersTableTableManager(_db, _db.taskReminders);
  $$DiaryEntriesTableTableManager get diaryEntries =>
      $$DiaryEntriesTableTableManager(_db, _db.diaryEntries);
  $$DiaryTagsTableTableManager get diaryTags =>
      $$DiaryTagsTableTableManager(_db, _db.diaryTags);
  $$DiaryTagRelationsTableTableManager get diaryTagRelations =>
      $$DiaryTagRelationsTableTableManager(_db, _db.diaryTagRelations);
  $$DiaryImagesTableTableManager get diaryImages =>
      $$DiaryImagesTableTableManager(_db, _db.diaryImages);
  $$KnowledgeProjectsTableTableManager get knowledgeProjects =>
      $$KnowledgeProjectsTableTableManager(_db, _db.knowledgeProjects);
  $$KnowledgeNodesTableTableManager get knowledgeNodes =>
      $$KnowledgeNodesTableTableManager(_db, _db.knowledgeNodes);
  $$KnowledgeRelationsTableTableManager get knowledgeRelations =>
      $$KnowledgeRelationsTableTableManager(_db, _db.knowledgeRelations);
  $$KnowledgeEditHistoriesTableTableManager get knowledgeEditHistories =>
      $$KnowledgeEditHistoriesTableTableManager(
        _db,
        _db.knowledgeEditHistories,
      );
}

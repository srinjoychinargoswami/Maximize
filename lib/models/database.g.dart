// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v1());
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _customCategoryMeta =
      const VerificationMeta('customCategory');
  @override
  late final GeneratedColumn<String> customCategory = GeneratedColumn<String>(
      'custom_category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
      'page_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
      'day', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceIntervalMeta =
      const VerificationMeta('recurrenceInterval');
  @override
  late final GeneratedColumn<int> recurrenceInterval = GeneratedColumn<int>(
      'recurrence_interval', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _daysOfWeekMeta =
      const VerificationMeta('daysOfWeek');
  @override
  late final GeneratedColumn<String> daysOfWeek = GeneratedColumn<String>(
      'days_of_week', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceEndDateMeta =
      const VerificationMeta('recurrenceEndDate');
  @override
  late final GeneratedColumn<DateTime> recurrenceEndDate =
      GeneratedColumn<DateTime>('recurrence_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _parentTaskIdMeta =
      const VerificationMeta('parentTaskId');
  @override
  late final GeneratedColumn<String> parentTaskId = GeneratedColumn<String>(
      'parent_task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maxOccurrencesMeta =
      const VerificationMeta('maxOccurrences');
  @override
  late final GeneratedColumn<int> maxOccurrences = GeneratedColumn<int>(
      'max_occurrences', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _skipWeekendsMeta =
      const VerificationMeta('skipWeekends');
  @override
  late final GeneratedColumn<bool> skipWeekends = GeneratedColumn<bool>(
      'skip_weekends', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("skip_weekends" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _dayOfMonthMeta =
      const VerificationMeta('dayOfMonth');
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
      'day_of_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _weekOfMonthMeta =
      const VerificationMeta('weekOfMonth');
  @override
  late final GeneratedColumn<int> weekOfMonth = GeneratedColumn<int>(
      'week_of_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reminderEnabledMeta =
      const VerificationMeta('reminderEnabled');
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
      'reminder_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_enabled" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
      'reminder_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reminderPresetMeta =
      const VerificationMeta('reminderPreset');
  @override
  late final GeneratedColumn<String> reminderPreset = GeneratedColumn<String>(
      'reminder_preset', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        dueDate,
        completed,
        completedAt,
        category,
        priority,
        customCategory,
        pageId,
        day,
        isRecurring,
        recurrenceRule,
        recurrenceInterval,
        daysOfWeek,
        recurrenceEndDate,
        parentTaskId,
        maxOccurrences,
        skipWeekends,
        dayOfMonth,
        weekOfMonth,
        reminderEnabled,
        reminderTime,
        reminderPreset
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<TaskData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('custom_category')) {
      context.handle(
          _customCategoryMeta,
          customCategory.isAcceptableOrUnknown(
              data['custom_category']!, _customCategoryMeta));
    }
    if (data.containsKey('page_id')) {
      context.handle(_pageIdMeta,
          pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    if (data.containsKey('recurrence_interval')) {
      context.handle(
          _recurrenceIntervalMeta,
          recurrenceInterval.isAcceptableOrUnknown(
              data['recurrence_interval']!, _recurrenceIntervalMeta));
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
          _daysOfWeekMeta,
          daysOfWeek.isAcceptableOrUnknown(
              data['days_of_week']!, _daysOfWeekMeta));
    }
    if (data.containsKey('recurrence_end_date')) {
      context.handle(
          _recurrenceEndDateMeta,
          recurrenceEndDate.isAcceptableOrUnknown(
              data['recurrence_end_date']!, _recurrenceEndDateMeta));
    }
    if (data.containsKey('parent_task_id')) {
      context.handle(
          _parentTaskIdMeta,
          parentTaskId.isAcceptableOrUnknown(
              data['parent_task_id']!, _parentTaskIdMeta));
    }
    if (data.containsKey('max_occurrences')) {
      context.handle(
          _maxOccurrencesMeta,
          maxOccurrences.isAcceptableOrUnknown(
              data['max_occurrences']!, _maxOccurrencesMeta));
    }
    if (data.containsKey('skip_weekends')) {
      context.handle(
          _skipWeekendsMeta,
          skipWeekends.isAcceptableOrUnknown(
              data['skip_weekends']!, _skipWeekendsMeta));
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
          _dayOfMonthMeta,
          dayOfMonth.isAcceptableOrUnknown(
              data['day_of_month']!, _dayOfMonthMeta));
    }
    if (data.containsKey('week_of_month')) {
      context.handle(
          _weekOfMonthMeta,
          weekOfMonth.isAcceptableOrUnknown(
              data['week_of_month']!, _weekOfMonthMeta));
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
          _reminderEnabledMeta,
          reminderEnabled.isAcceptableOrUnknown(
              data['reminder_enabled']!, _reminderEnabledMeta));
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
    }
    if (data.containsKey('reminder_preset')) {
      context.handle(
          _reminderPresetMeta,
          reminderPreset.isAcceptableOrUnknown(
              data['reminder_preset']!, _reminderPresetMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      customCategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_category']),
      pageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}page_id']),
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      recurrenceInterval: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recurrence_interval']),
      daysOfWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}days_of_week']),
      recurrenceEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recurrence_end_date']),
      parentTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_task_id']),
      maxOccurrences: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_occurrences']),
      skipWeekends: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}skip_weekends'])!,
      dayOfMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_month']),
      weekOfMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}week_of_month']),
      reminderEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reminder_enabled'])!,
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reminder_time']),
      reminderPreset: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_preset']),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskData extends DataClass implements Insertable<TaskData> {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool completed;
  final DateTime? completedAt;
  final String? category;
  final String priority;
  final String? customCategory;
  final String? pageId;
  final String? day;
  final bool isRecurring;
  final String? recurrenceRule;
  final int? recurrenceInterval;
  final String? daysOfWeek;
  final DateTime? recurrenceEndDate;
  final String? parentTaskId;
  final int? maxOccurrences;
  final bool skipWeekends;
  final int? dayOfMonth;
  final int? weekOfMonth;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final String? reminderPreset;
  const TaskData(
      {required this.id,
      required this.title,
      this.description,
      required this.dueDate,
      required this.completed,
      this.completedAt,
      this.category,
      required this.priority,
      this.customCategory,
      this.pageId,
      this.day,
      required this.isRecurring,
      this.recurrenceRule,
      this.recurrenceInterval,
      this.daysOfWeek,
      this.recurrenceEndDate,
      this.parentTaskId,
      this.maxOccurrences,
      required this.skipWeekends,
      this.dayOfMonth,
      this.weekOfMonth,
      required this.reminderEnabled,
      this.reminderTime,
      this.reminderPreset});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || customCategory != null) {
      map['custom_category'] = Variable<String>(customCategory);
    }
    if (!nullToAbsent || pageId != null) {
      map['page_id'] = Variable<String>(pageId);
    }
    if (!nullToAbsent || day != null) {
      map['day'] = Variable<String>(day);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || recurrenceInterval != null) {
      map['recurrence_interval'] = Variable<int>(recurrenceInterval);
    }
    if (!nullToAbsent || daysOfWeek != null) {
      map['days_of_week'] = Variable<String>(daysOfWeek);
    }
    if (!nullToAbsent || recurrenceEndDate != null) {
      map['recurrence_end_date'] = Variable<DateTime>(recurrenceEndDate);
    }
    if (!nullToAbsent || parentTaskId != null) {
      map['parent_task_id'] = Variable<String>(parentTaskId);
    }
    if (!nullToAbsent || maxOccurrences != null) {
      map['max_occurrences'] = Variable<int>(maxOccurrences);
    }
    map['skip_weekends'] = Variable<bool>(skipWeekends);
    if (!nullToAbsent || dayOfMonth != null) {
      map['day_of_month'] = Variable<int>(dayOfMonth);
    }
    if (!nullToAbsent || weekOfMonth != null) {
      map['week_of_month'] = Variable<int>(weekOfMonth);
    }
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<DateTime>(reminderTime);
    }
    if (!nullToAbsent || reminderPreset != null) {
      map['reminder_preset'] = Variable<String>(reminderPreset);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: Value(dueDate),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      priority: Value(priority),
      customCategory: customCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(customCategory),
      pageId:
          pageId == null && nullToAbsent ? const Value.absent() : Value(pageId),
      day: day == null && nullToAbsent ? const Value.absent() : Value(day),
      isRecurring: Value(isRecurring),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      recurrenceInterval: recurrenceInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceInterval),
      daysOfWeek: daysOfWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(daysOfWeek),
      recurrenceEndDate: recurrenceEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceEndDate),
      parentTaskId: parentTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTaskId),
      maxOccurrences: maxOccurrences == null && nullToAbsent
          ? const Value.absent()
          : Value(maxOccurrences),
      skipWeekends: Value(skipWeekends),
      dayOfMonth: dayOfMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(dayOfMonth),
      weekOfMonth: weekOfMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(weekOfMonth),
      reminderEnabled: Value(reminderEnabled),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      reminderPreset: reminderPreset == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderPreset),
    );
  }

  factory TaskData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      category: serializer.fromJson<String?>(json['category']),
      priority: serializer.fromJson<String>(json['priority']),
      customCategory: serializer.fromJson<String?>(json['customCategory']),
      pageId: serializer.fromJson<String?>(json['pageId']),
      day: serializer.fromJson<String?>(json['day']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      recurrenceInterval: serializer.fromJson<int?>(json['recurrenceInterval']),
      daysOfWeek: serializer.fromJson<String?>(json['daysOfWeek']),
      recurrenceEndDate:
          serializer.fromJson<DateTime?>(json['recurrenceEndDate']),
      parentTaskId: serializer.fromJson<String?>(json['parentTaskId']),
      maxOccurrences: serializer.fromJson<int?>(json['maxOccurrences']),
      skipWeekends: serializer.fromJson<bool>(json['skipWeekends']),
      dayOfMonth: serializer.fromJson<int?>(json['dayOfMonth']),
      weekOfMonth: serializer.fromJson<int?>(json['weekOfMonth']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderTime: serializer.fromJson<DateTime?>(json['reminderTime']),
      reminderPreset: serializer.fromJson<String?>(json['reminderPreset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'category': serializer.toJson<String?>(category),
      'priority': serializer.toJson<String>(priority),
      'customCategory': serializer.toJson<String?>(customCategory),
      'pageId': serializer.toJson<String?>(pageId),
      'day': serializer.toJson<String?>(day),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'recurrenceInterval': serializer.toJson<int?>(recurrenceInterval),
      'daysOfWeek': serializer.toJson<String?>(daysOfWeek),
      'recurrenceEndDate': serializer.toJson<DateTime?>(recurrenceEndDate),
      'parentTaskId': serializer.toJson<String?>(parentTaskId),
      'maxOccurrences': serializer.toJson<int?>(maxOccurrences),
      'skipWeekends': serializer.toJson<bool>(skipWeekends),
      'dayOfMonth': serializer.toJson<int?>(dayOfMonth),
      'weekOfMonth': serializer.toJson<int?>(weekOfMonth),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderTime': serializer.toJson<DateTime?>(reminderTime),
      'reminderPreset': serializer.toJson<String?>(reminderPreset),
    };
  }

  TaskData copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? dueDate,
          bool? completed,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> category = const Value.absent(),
          String? priority,
          Value<String?> customCategory = const Value.absent(),
          Value<String?> pageId = const Value.absent(),
          Value<String?> day = const Value.absent(),
          bool? isRecurring,
          Value<String?> recurrenceRule = const Value.absent(),
          Value<int?> recurrenceInterval = const Value.absent(),
          Value<String?> daysOfWeek = const Value.absent(),
          Value<DateTime?> recurrenceEndDate = const Value.absent(),
          Value<String?> parentTaskId = const Value.absent(),
          Value<int?> maxOccurrences = const Value.absent(),
          bool? skipWeekends,
          Value<int?> dayOfMonth = const Value.absent(),
          Value<int?> weekOfMonth = const Value.absent(),
          bool? reminderEnabled,
          Value<DateTime?> reminderTime = const Value.absent(),
          Value<String?> reminderPreset = const Value.absent()}) =>
      TaskData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        dueDate: dueDate ?? this.dueDate,
        completed: completed ?? this.completed,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        category: category.present ? category.value : this.category,
        priority: priority ?? this.priority,
        customCategory:
            customCategory.present ? customCategory.value : this.customCategory,
        pageId: pageId.present ? pageId.value : this.pageId,
        day: day.present ? day.value : this.day,
        isRecurring: isRecurring ?? this.isRecurring,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
        recurrenceInterval: recurrenceInterval.present
            ? recurrenceInterval.value
            : this.recurrenceInterval,
        daysOfWeek: daysOfWeek.present ? daysOfWeek.value : this.daysOfWeek,
        recurrenceEndDate: recurrenceEndDate.present
            ? recurrenceEndDate.value
            : this.recurrenceEndDate,
        parentTaskId:
            parentTaskId.present ? parentTaskId.value : this.parentTaskId,
        maxOccurrences:
            maxOccurrences.present ? maxOccurrences.value : this.maxOccurrences,
        skipWeekends: skipWeekends ?? this.skipWeekends,
        dayOfMonth: dayOfMonth.present ? dayOfMonth.value : this.dayOfMonth,
        weekOfMonth: weekOfMonth.present ? weekOfMonth.value : this.weekOfMonth,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        reminderTime:
            reminderTime.present ? reminderTime.value : this.reminderTime,
        reminderPreset:
            reminderPreset.present ? reminderPreset.value : this.reminderPreset,
      );
  TaskData copyWithCompanion(TasksCompanion data) {
    return TaskData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      customCategory: data.customCategory.present
          ? data.customCategory.value
          : this.customCategory,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      day: data.day.present ? data.day.value : this.day,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      recurrenceInterval: data.recurrenceInterval.present
          ? data.recurrenceInterval.value
          : this.recurrenceInterval,
      daysOfWeek:
          data.daysOfWeek.present ? data.daysOfWeek.value : this.daysOfWeek,
      recurrenceEndDate: data.recurrenceEndDate.present
          ? data.recurrenceEndDate.value
          : this.recurrenceEndDate,
      parentTaskId: data.parentTaskId.present
          ? data.parentTaskId.value
          : this.parentTaskId,
      maxOccurrences: data.maxOccurrences.present
          ? data.maxOccurrences.value
          : this.maxOccurrences,
      skipWeekends: data.skipWeekends.present
          ? data.skipWeekends.value
          : this.skipWeekends,
      dayOfMonth:
          data.dayOfMonth.present ? data.dayOfMonth.value : this.dayOfMonth,
      weekOfMonth:
          data.weekOfMonth.present ? data.weekOfMonth.value : this.weekOfMonth,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      reminderPreset: data.reminderPreset.present
          ? data.reminderPreset.value
          : this.reminderPreset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('customCategory: $customCategory, ')
          ..write('pageId: $pageId, ')
          ..write('day: $day, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('recurrenceEndDate: $recurrenceEndDate, ')
          ..write('parentTaskId: $parentTaskId, ')
          ..write('maxOccurrences: $maxOccurrences, ')
          ..write('skipWeekends: $skipWeekends, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('weekOfMonth: $weekOfMonth, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderPreset: $reminderPreset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        description,
        dueDate,
        completed,
        completedAt,
        category,
        priority,
        customCategory,
        pageId,
        day,
        isRecurring,
        recurrenceRule,
        recurrenceInterval,
        daysOfWeek,
        recurrenceEndDate,
        parentTaskId,
        maxOccurrences,
        skipWeekends,
        dayOfMonth,
        weekOfMonth,
        reminderEnabled,
        reminderTime,
        reminderPreset
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.customCategory == this.customCategory &&
          other.pageId == this.pageId &&
          other.day == this.day &&
          other.isRecurring == this.isRecurring &&
          other.recurrenceRule == this.recurrenceRule &&
          other.recurrenceInterval == this.recurrenceInterval &&
          other.daysOfWeek == this.daysOfWeek &&
          other.recurrenceEndDate == this.recurrenceEndDate &&
          other.parentTaskId == this.parentTaskId &&
          other.maxOccurrences == this.maxOccurrences &&
          other.skipWeekends == this.skipWeekends &&
          other.dayOfMonth == this.dayOfMonth &&
          other.weekOfMonth == this.weekOfMonth &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderTime == this.reminderTime &&
          other.reminderPreset == this.reminderPreset);
}

class TasksCompanion extends UpdateCompanion<TaskData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> dueDate;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  final Value<String?> category;
  final Value<String> priority;
  final Value<String?> customCategory;
  final Value<String?> pageId;
  final Value<String?> day;
  final Value<bool> isRecurring;
  final Value<String?> recurrenceRule;
  final Value<int?> recurrenceInterval;
  final Value<String?> daysOfWeek;
  final Value<DateTime?> recurrenceEndDate;
  final Value<String?> parentTaskId;
  final Value<int?> maxOccurrences;
  final Value<bool> skipWeekends;
  final Value<int?> dayOfMonth;
  final Value<int?> weekOfMonth;
  final Value<bool> reminderEnabled;
  final Value<DateTime?> reminderTime;
  final Value<String?> reminderPreset;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.customCategory = const Value.absent(),
    this.pageId = const Value.absent(),
    this.day = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.recurrenceEndDate = const Value.absent(),
    this.parentTaskId = const Value.absent(),
    this.maxOccurrences = const Value.absent(),
    this.skipWeekends = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.weekOfMonth = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderPreset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required DateTime dueDate,
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.category = const Value.absent(),
    required String priority,
    this.customCategory = const Value.absent(),
    this.pageId = const Value.absent(),
    this.day = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.recurrenceEndDate = const Value.absent(),
    this.parentTaskId = const Value.absent(),
    this.maxOccurrences = const Value.absent(),
    this.skipWeekends = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.weekOfMonth = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderPreset = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : title = Value(title),
        dueDate = Value(dueDate),
        priority = Value(priority);
  static Insertable<TaskData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
    Expression<String>? category,
    Expression<String>? priority,
    Expression<String>? customCategory,
    Expression<String>? pageId,
    Expression<String>? day,
    Expression<bool>? isRecurring,
    Expression<String>? recurrenceRule,
    Expression<int>? recurrenceInterval,
    Expression<String>? daysOfWeek,
    Expression<DateTime>? recurrenceEndDate,
    Expression<String>? parentTaskId,
    Expression<int>? maxOccurrences,
    Expression<bool>? skipWeekends,
    Expression<int>? dayOfMonth,
    Expression<int>? weekOfMonth,
    Expression<bool>? reminderEnabled,
    Expression<DateTime>? reminderTime,
    Expression<String>? reminderPreset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (customCategory != null) 'custom_category': customCategory,
      if (pageId != null) 'page_id': pageId,
      if (day != null) 'day': day,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (recurrenceInterval != null) 'recurrence_interval': recurrenceInterval,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (recurrenceEndDate != null) 'recurrence_end_date': recurrenceEndDate,
      if (parentTaskId != null) 'parent_task_id': parentTaskId,
      if (maxOccurrences != null) 'max_occurrences': maxOccurrences,
      if (skipWeekends != null) 'skip_weekends': skipWeekends,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (weekOfMonth != null) 'week_of_month': weekOfMonth,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (reminderPreset != null) 'reminder_preset': reminderPreset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? dueDate,
      Value<bool>? completed,
      Value<DateTime?>? completedAt,
      Value<String?>? category,
      Value<String>? priority,
      Value<String?>? customCategory,
      Value<String?>? pageId,
      Value<String?>? day,
      Value<bool>? isRecurring,
      Value<String?>? recurrenceRule,
      Value<int?>? recurrenceInterval,
      Value<String?>? daysOfWeek,
      Value<DateTime?>? recurrenceEndDate,
      Value<String?>? parentTaskId,
      Value<int?>? maxOccurrences,
      Value<bool>? skipWeekends,
      Value<int?>? dayOfMonth,
      Value<int?>? weekOfMonth,
      Value<bool>? reminderEnabled,
      Value<DateTime?>? reminderTime,
      Value<String?>? reminderPreset,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      customCategory: customCategory ?? this.customCategory,
      pageId: pageId ?? this.pageId,
      day: day ?? this.day,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      maxOccurrences: maxOccurrences ?? this.maxOccurrences,
      skipWeekends: skipWeekends ?? this.skipWeekends,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      weekOfMonth: weekOfMonth ?? this.weekOfMonth,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderPreset: reminderPreset ?? this.reminderPreset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (customCategory.present) {
      map['custom_category'] = Variable<String>(customCategory.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (recurrenceInterval.present) {
      map['recurrence_interval'] = Variable<int>(recurrenceInterval.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(daysOfWeek.value);
    }
    if (recurrenceEndDate.present) {
      map['recurrence_end_date'] = Variable<DateTime>(recurrenceEndDate.value);
    }
    if (parentTaskId.present) {
      map['parent_task_id'] = Variable<String>(parentTaskId.value);
    }
    if (maxOccurrences.present) {
      map['max_occurrences'] = Variable<int>(maxOccurrences.value);
    }
    if (skipWeekends.present) {
      map['skip_weekends'] = Variable<bool>(skipWeekends.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (weekOfMonth.present) {
      map['week_of_month'] = Variable<int>(weekOfMonth.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
    }
    if (reminderPreset.present) {
      map['reminder_preset'] = Variable<String>(reminderPreset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('customCategory: $customCategory, ')
          ..write('pageId: $pageId, ')
          ..write('day: $day, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('recurrenceEndDate: $recurrenceEndDate, ')
          ..write('parentTaskId: $parentTaskId, ')
          ..write('maxOccurrences: $maxOccurrences, ')
          ..write('skipWeekends: $skipWeekends, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('weekOfMonth: $weekOfMonth, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderPreset: $reminderPreset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtasksTable extends Subtasks
    with TableInfo<$SubtasksTable, SubtaskData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v1());
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES tasks(id) NOT NULL');
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, title, completed, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtasks';
  @override
  VerificationContext validateIntegrity(Insertable<SubtaskData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubtaskData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubtaskData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $SubtasksTable createAlias(String alias) {
    return $SubtasksTable(attachedDatabase, alias);
  }
}

class SubtaskData extends DataClass implements Insertable<SubtaskData> {
  final String id;
  final String taskId;
  final String title;
  final bool completed;
  final DateTime? completedAt;
  const SubtaskData(
      {required this.id,
      required this.taskId,
      required this.title,
      required this.completed,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['title'] = Variable<String>(title);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  SubtasksCompanion toCompanion(bool nullToAbsent) {
    return SubtasksCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory SubtaskData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubtaskData(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  SubtaskData copyWith(
          {String? id,
          String? taskId,
          String? title,
          bool? completed,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      SubtaskData(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        completed: completed ?? this.completed,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  SubtaskData copyWithCompanion(SubtasksCompanion data) {
    return SubtaskData(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubtaskData(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, title, completed, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubtaskData &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt);
}

class SubtasksCompanion extends UpdateCompanion<SubtaskData> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const SubtasksCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtasksCompanion.insert({
    this.id = const Value.absent(),
    required String taskId,
    required String title,
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : taskId = Value(taskId),
        title = Value(title);
  static Insertable<SubtaskData> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? title,
      Value<bool>? completed,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return SubtasksCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtasksCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, EventData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v1());
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commentsMeta =
      const VerificationMeta('comments');
  @override
  late final GeneratedColumn<String> comments = GeneratedColumn<String>(
      'comments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateTimeMeta =
      const VerificationMeta('startDateTime');
  @override
  late final GeneratedColumn<DateTime> startDateTime =
      GeneratedColumn<DateTime>('start_date_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateTimeMeta =
      const VerificationMeta('endDateTime');
  @override
  late final GeneratedColumn<DateTime> endDateTime = GeneratedColumn<DateTime>(
      'end_date_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _customCategoryMeta =
      const VerificationMeta('customCategory');
  @override
  late final GeneratedColumn<String> customCategory = GeneratedColumn<String>(
      'custom_category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentEventIdMeta =
      const VerificationMeta('parentEventId');
  @override
  late final GeneratedColumn<String> parentEventId = GeneratedColumn<String>(
      'parent_event_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceExceptionDatesMeta =
      const VerificationMeta('recurrenceExceptionDates');
  @override
  late final GeneratedColumn<String> recurrenceExceptionDates =
      GeneratedColumn<String>('recurrence_exception_dates', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceEndDateMeta =
      const VerificationMeta('recurrenceEndDate');
  @override
  late final GeneratedColumn<DateTime> recurrenceEndDate =
      GeneratedColumn<DateTime>('recurrence_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceCountMeta =
      const VerificationMeta('recurrenceCount');
  @override
  late final GeneratedColumn<int> recurrenceCount = GeneratedColumn<int>(
      'recurrence_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reminderEnabledMeta =
      const VerificationMeta('reminderEnabled');
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
      'reminder_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_enabled" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
      'reminder_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reminderPresetMeta =
      const VerificationMeta('reminderPreset');
  @override
  late final GeneratedColumn<String> reminderPreset = GeneratedColumn<String>(
      'reminder_preset', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        comments,
        startDateTime,
        endDateTime,
        customCategory,
        color,
        completed,
        completedAt,
        isRecurring,
        recurrenceRule,
        parentEventId,
        recurrenceExceptionDates,
        recurrenceEndDate,
        recurrenceCount,
        reminderEnabled,
        reminderTime,
        reminderPreset
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<EventData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    if (data.containsKey('start_date_time')) {
      context.handle(
          _startDateTimeMeta,
          startDateTime.isAcceptableOrUnknown(
              data['start_date_time']!, _startDateTimeMeta));
    } else if (isInserting) {
      context.missing(_startDateTimeMeta);
    }
    if (data.containsKey('end_date_time')) {
      context.handle(
          _endDateTimeMeta,
          endDateTime.isAcceptableOrUnknown(
              data['end_date_time']!, _endDateTimeMeta));
    } else if (isInserting) {
      context.missing(_endDateTimeMeta);
    }
    if (data.containsKey('custom_category')) {
      context.handle(
          _customCategoryMeta,
          customCategory.isAcceptableOrUnknown(
              data['custom_category']!, _customCategoryMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    if (data.containsKey('parent_event_id')) {
      context.handle(
          _parentEventIdMeta,
          parentEventId.isAcceptableOrUnknown(
              data['parent_event_id']!, _parentEventIdMeta));
    }
    if (data.containsKey('recurrence_exception_dates')) {
      context.handle(
          _recurrenceExceptionDatesMeta,
          recurrenceExceptionDates.isAcceptableOrUnknown(
              data['recurrence_exception_dates']!,
              _recurrenceExceptionDatesMeta));
    }
    if (data.containsKey('recurrence_end_date')) {
      context.handle(
          _recurrenceEndDateMeta,
          recurrenceEndDate.isAcceptableOrUnknown(
              data['recurrence_end_date']!, _recurrenceEndDateMeta));
    }
    if (data.containsKey('recurrence_count')) {
      context.handle(
          _recurrenceCountMeta,
          recurrenceCount.isAcceptableOrUnknown(
              data['recurrence_count']!, _recurrenceCountMeta));
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
          _reminderEnabledMeta,
          reminderEnabled.isAcceptableOrUnknown(
              data['reminder_enabled']!, _reminderEnabledMeta));
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
    }
    if (data.containsKey('reminder_preset')) {
      context.handle(
          _reminderPresetMeta,
          reminderPreset.isAcceptableOrUnknown(
              data['reminder_preset']!, _reminderPresetMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      comments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comments']),
      startDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}start_date_time'])!,
      endDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}end_date_time'])!,
      customCategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_category']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      parentEventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_event_id']),
      recurrenceExceptionDates: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recurrence_exception_dates']),
      recurrenceEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recurrence_end_date']),
      recurrenceCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_count']),
      reminderEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reminder_enabled'])!,
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reminder_time']),
      reminderPreset: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_preset']),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class EventData extends DataClass implements Insertable<EventData> {
  final String id;
  final String title;
  final String? description;
  final String? comments;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? customCategory;
  final String? color;
  final bool completed;
  final DateTime? completedAt;
  final bool isRecurring;
  final String? recurrenceRule;
  final String? parentEventId;
  final String? recurrenceExceptionDates;
  final DateTime? recurrenceEndDate;
  final int? recurrenceCount;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final String? reminderPreset;
  const EventData(
      {required this.id,
      required this.title,
      this.description,
      this.comments,
      required this.startDateTime,
      required this.endDateTime,
      this.customCategory,
      this.color,
      required this.completed,
      this.completedAt,
      required this.isRecurring,
      this.recurrenceRule,
      this.parentEventId,
      this.recurrenceExceptionDates,
      this.recurrenceEndDate,
      this.recurrenceCount,
      required this.reminderEnabled,
      this.reminderTime,
      this.reminderPreset});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || comments != null) {
      map['comments'] = Variable<String>(comments);
    }
    map['start_date_time'] = Variable<DateTime>(startDateTime);
    map['end_date_time'] = Variable<DateTime>(endDateTime);
    if (!nullToAbsent || customCategory != null) {
      map['custom_category'] = Variable<String>(customCategory);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || parentEventId != null) {
      map['parent_event_id'] = Variable<String>(parentEventId);
    }
    if (!nullToAbsent || recurrenceExceptionDates != null) {
      map['recurrence_exception_dates'] =
          Variable<String>(recurrenceExceptionDates);
    }
    if (!nullToAbsent || recurrenceEndDate != null) {
      map['recurrence_end_date'] = Variable<DateTime>(recurrenceEndDate);
    }
    if (!nullToAbsent || recurrenceCount != null) {
      map['recurrence_count'] = Variable<int>(recurrenceCount);
    }
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<DateTime>(reminderTime);
    }
    if (!nullToAbsent || reminderPreset != null) {
      map['reminder_preset'] = Variable<String>(reminderPreset);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      comments: comments == null && nullToAbsent
          ? const Value.absent()
          : Value(comments),
      startDateTime: Value(startDateTime),
      endDateTime: Value(endDateTime),
      customCategory: customCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(customCategory),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      isRecurring: Value(isRecurring),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      parentEventId: parentEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentEventId),
      recurrenceExceptionDates: recurrenceExceptionDates == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceExceptionDates),
      recurrenceEndDate: recurrenceEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceEndDate),
      recurrenceCount: recurrenceCount == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceCount),
      reminderEnabled: Value(reminderEnabled),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      reminderPreset: reminderPreset == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderPreset),
    );
  }

  factory EventData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      comments: serializer.fromJson<String?>(json['comments']),
      startDateTime: serializer.fromJson<DateTime>(json['startDateTime']),
      endDateTime: serializer.fromJson<DateTime>(json['endDateTime']),
      customCategory: serializer.fromJson<String?>(json['customCategory']),
      color: serializer.fromJson<String?>(json['color']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      parentEventId: serializer.fromJson<String?>(json['parentEventId']),
      recurrenceExceptionDates:
          serializer.fromJson<String?>(json['recurrenceExceptionDates']),
      recurrenceEndDate:
          serializer.fromJson<DateTime?>(json['recurrenceEndDate']),
      recurrenceCount: serializer.fromJson<int?>(json['recurrenceCount']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderTime: serializer.fromJson<DateTime?>(json['reminderTime']),
      reminderPreset: serializer.fromJson<String?>(json['reminderPreset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'comments': serializer.toJson<String?>(comments),
      'startDateTime': serializer.toJson<DateTime>(startDateTime),
      'endDateTime': serializer.toJson<DateTime>(endDateTime),
      'customCategory': serializer.toJson<String?>(customCategory),
      'color': serializer.toJson<String?>(color),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'parentEventId': serializer.toJson<String?>(parentEventId),
      'recurrenceExceptionDates':
          serializer.toJson<String?>(recurrenceExceptionDates),
      'recurrenceEndDate': serializer.toJson<DateTime?>(recurrenceEndDate),
      'recurrenceCount': serializer.toJson<int?>(recurrenceCount),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderTime': serializer.toJson<DateTime?>(reminderTime),
      'reminderPreset': serializer.toJson<String?>(reminderPreset),
    };
  }

  EventData copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> comments = const Value.absent(),
          DateTime? startDateTime,
          DateTime? endDateTime,
          Value<String?> customCategory = const Value.absent(),
          Value<String?> color = const Value.absent(),
          bool? completed,
          Value<DateTime?> completedAt = const Value.absent(),
          bool? isRecurring,
          Value<String?> recurrenceRule = const Value.absent(),
          Value<String?> parentEventId = const Value.absent(),
          Value<String?> recurrenceExceptionDates = const Value.absent(),
          Value<DateTime?> recurrenceEndDate = const Value.absent(),
          Value<int?> recurrenceCount = const Value.absent(),
          bool? reminderEnabled,
          Value<DateTime?> reminderTime = const Value.absent(),
          Value<String?> reminderPreset = const Value.absent()}) =>
      EventData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        comments: comments.present ? comments.value : this.comments,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        customCategory:
            customCategory.present ? customCategory.value : this.customCategory,
        color: color.present ? color.value : this.color,
        completed: completed ?? this.completed,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        isRecurring: isRecurring ?? this.isRecurring,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
        parentEventId:
            parentEventId.present ? parentEventId.value : this.parentEventId,
        recurrenceExceptionDates: recurrenceExceptionDates.present
            ? recurrenceExceptionDates.value
            : this.recurrenceExceptionDates,
        recurrenceEndDate: recurrenceEndDate.present
            ? recurrenceEndDate.value
            : this.recurrenceEndDate,
        recurrenceCount: recurrenceCount.present
            ? recurrenceCount.value
            : this.recurrenceCount,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        reminderTime:
            reminderTime.present ? reminderTime.value : this.reminderTime,
        reminderPreset:
            reminderPreset.present ? reminderPreset.value : this.reminderPreset,
      );
  EventData copyWithCompanion(EventsCompanion data) {
    return EventData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      comments: data.comments.present ? data.comments.value : this.comments,
      startDateTime: data.startDateTime.present
          ? data.startDateTime.value
          : this.startDateTime,
      endDateTime:
          data.endDateTime.present ? data.endDateTime.value : this.endDateTime,
      customCategory: data.customCategory.present
          ? data.customCategory.value
          : this.customCategory,
      color: data.color.present ? data.color.value : this.color,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      parentEventId: data.parentEventId.present
          ? data.parentEventId.value
          : this.parentEventId,
      recurrenceExceptionDates: data.recurrenceExceptionDates.present
          ? data.recurrenceExceptionDates.value
          : this.recurrenceExceptionDates,
      recurrenceEndDate: data.recurrenceEndDate.present
          ? data.recurrenceEndDate.value
          : this.recurrenceEndDate,
      recurrenceCount: data.recurrenceCount.present
          ? data.recurrenceCount.value
          : this.recurrenceCount,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      reminderPreset: data.reminderPreset.present
          ? data.reminderPreset.value
          : this.reminderPreset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('comments: $comments, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('customCategory: $customCategory, ')
          ..write('color: $color, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('parentEventId: $parentEventId, ')
          ..write('recurrenceExceptionDates: $recurrenceExceptionDates, ')
          ..write('recurrenceEndDate: $recurrenceEndDate, ')
          ..write('recurrenceCount: $recurrenceCount, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderPreset: $reminderPreset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      comments,
      startDateTime,
      endDateTime,
      customCategory,
      color,
      completed,
      completedAt,
      isRecurring,
      recurrenceRule,
      parentEventId,
      recurrenceExceptionDates,
      recurrenceEndDate,
      recurrenceCount,
      reminderEnabled,
      reminderTime,
      reminderPreset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.comments == this.comments &&
          other.startDateTime == this.startDateTime &&
          other.endDateTime == this.endDateTime &&
          other.customCategory == this.customCategory &&
          other.color == this.color &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt &&
          other.isRecurring == this.isRecurring &&
          other.recurrenceRule == this.recurrenceRule &&
          other.parentEventId == this.parentEventId &&
          other.recurrenceExceptionDates == this.recurrenceExceptionDates &&
          other.recurrenceEndDate == this.recurrenceEndDate &&
          other.recurrenceCount == this.recurrenceCount &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderTime == this.reminderTime &&
          other.reminderPreset == this.reminderPreset);
}

class EventsCompanion extends UpdateCompanion<EventData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> comments;
  final Value<DateTime> startDateTime;
  final Value<DateTime> endDateTime;
  final Value<String?> customCategory;
  final Value<String?> color;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  final Value<bool> isRecurring;
  final Value<String?> recurrenceRule;
  final Value<String?> parentEventId;
  final Value<String?> recurrenceExceptionDates;
  final Value<DateTime?> recurrenceEndDate;
  final Value<int?> recurrenceCount;
  final Value<bool> reminderEnabled;
  final Value<DateTime?> reminderTime;
  final Value<String?> reminderPreset;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.comments = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.customCategory = const Value.absent(),
    this.color = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.parentEventId = const Value.absent(),
    this.recurrenceExceptionDates = const Value.absent(),
    this.recurrenceEndDate = const Value.absent(),
    this.recurrenceCount = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderPreset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.comments = const Value.absent(),
    required DateTime startDateTime,
    required DateTime endDateTime,
    this.customCategory = const Value.absent(),
    this.color = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.parentEventId = const Value.absent(),
    this.recurrenceExceptionDates = const Value.absent(),
    this.recurrenceEndDate = const Value.absent(),
    this.recurrenceCount = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderPreset = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : title = Value(title),
        startDateTime = Value(startDateTime),
        endDateTime = Value(endDateTime);
  static Insertable<EventData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? comments,
    Expression<DateTime>? startDateTime,
    Expression<DateTime>? endDateTime,
    Expression<String>? customCategory,
    Expression<String>? color,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
    Expression<bool>? isRecurring,
    Expression<String>? recurrenceRule,
    Expression<String>? parentEventId,
    Expression<String>? recurrenceExceptionDates,
    Expression<DateTime>? recurrenceEndDate,
    Expression<int>? recurrenceCount,
    Expression<bool>? reminderEnabled,
    Expression<DateTime>? reminderTime,
    Expression<String>? reminderPreset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (comments != null) 'comments': comments,
      if (startDateTime != null) 'start_date_time': startDateTime,
      if (endDateTime != null) 'end_date_time': endDateTime,
      if (customCategory != null) 'custom_category': customCategory,
      if (color != null) 'color': color,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (parentEventId != null) 'parent_event_id': parentEventId,
      if (recurrenceExceptionDates != null)
        'recurrence_exception_dates': recurrenceExceptionDates,
      if (recurrenceEndDate != null) 'recurrence_end_date': recurrenceEndDate,
      if (recurrenceCount != null) 'recurrence_count': recurrenceCount,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (reminderPreset != null) 'reminder_preset': reminderPreset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? comments,
      Value<DateTime>? startDateTime,
      Value<DateTime>? endDateTime,
      Value<String?>? customCategory,
      Value<String?>? color,
      Value<bool>? completed,
      Value<DateTime?>? completedAt,
      Value<bool>? isRecurring,
      Value<String?>? recurrenceRule,
      Value<String?>? parentEventId,
      Value<String?>? recurrenceExceptionDates,
      Value<DateTime?>? recurrenceEndDate,
      Value<int?>? recurrenceCount,
      Value<bool>? reminderEnabled,
      Value<DateTime?>? reminderTime,
      Value<String?>? reminderPreset,
      Value<int>? rowid}) {
    return EventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      comments: comments ?? this.comments,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      customCategory: customCategory ?? this.customCategory,
      color: color ?? this.color,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      parentEventId: parentEventId ?? this.parentEventId,
      recurrenceExceptionDates:
          recurrenceExceptionDates ?? this.recurrenceExceptionDates,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      recurrenceCount: recurrenceCount ?? this.recurrenceCount,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderPreset: reminderPreset ?? this.reminderPreset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String>(comments.value);
    }
    if (startDateTime.present) {
      map['start_date_time'] = Variable<DateTime>(startDateTime.value);
    }
    if (endDateTime.present) {
      map['end_date_time'] = Variable<DateTime>(endDateTime.value);
    }
    if (customCategory.present) {
      map['custom_category'] = Variable<String>(customCategory.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (parentEventId.present) {
      map['parent_event_id'] = Variable<String>(parentEventId.value);
    }
    if (recurrenceExceptionDates.present) {
      map['recurrence_exception_dates'] =
          Variable<String>(recurrenceExceptionDates.value);
    }
    if (recurrenceEndDate.present) {
      map['recurrence_end_date'] = Variable<DateTime>(recurrenceEndDate.value);
    }
    if (recurrenceCount.present) {
      map['recurrence_count'] = Variable<int>(recurrenceCount.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
    }
    if (reminderPreset.present) {
      map['reminder_preset'] = Variable<String>(reminderPreset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('comments: $comments, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('customCategory: $customCategory, ')
          ..write('color: $color, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('parentEventId: $parentEventId, ')
          ..write('recurrenceExceptionDates: $recurrenceExceptionDates, ')
          ..write('recurrenceEndDate: $recurrenceEndDate, ')
          ..write('recurrenceCount: $recurrenceCount, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderPreset: $reminderPreset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClassesTable extends Classes with TableInfo<$ClassesTable, ClassData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v1());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateTimeMeta =
      const VerificationMeta('endDateTime');
  @override
  late final GeneratedColumn<DateTime> endDateTime = GeneratedColumn<DateTime>(
      'end_date_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
      'day', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, startTime, endDateTime, day];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classes';
  @override
  VerificationContext validateIntegrity(Insertable<ClassData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_date_time')) {
      context.handle(
          _endDateTimeMeta,
          endDateTime.isAcceptableOrUnknown(
              data['end_date_time']!, _endDateTimeMeta));
    } else if (isInserting) {
      context.missing(_endDateTimeMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}end_date_time'])!,
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day'])!,
    );
  }

  @override
  $ClassesTable createAlias(String alias) {
    return $ClassesTable(attachedDatabase, alias);
  }
}

class ClassData extends DataClass implements Insertable<ClassData> {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endDateTime;
  final String day;
  const ClassData(
      {required this.id,
      required this.name,
      required this.startTime,
      required this.endDateTime,
      required this.day});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_date_time'] = Variable<DateTime>(endDateTime);
    map['day'] = Variable<String>(day);
    return map;
  }

  ClassesCompanion toCompanion(bool nullToAbsent) {
    return ClassesCompanion(
      id: Value(id),
      name: Value(name),
      startTime: Value(startTime),
      endDateTime: Value(endDateTime),
      day: Value(day),
    );
  }

  factory ClassData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endDateTime: serializer.fromJson<DateTime>(json['endDateTime']),
      day: serializer.fromJson<String>(json['day']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endDateTime': serializer.toJson<DateTime>(endDateTime),
      'day': serializer.toJson<String>(day),
    };
  }

  ClassData copyWith(
          {String? id,
          String? name,
          DateTime? startTime,
          DateTime? endDateTime,
          String? day}) =>
      ClassData(
        id: id ?? this.id,
        name: name ?? this.name,
        startTime: startTime ?? this.startTime,
        endDateTime: endDateTime ?? this.endDateTime,
        day: day ?? this.day,
      );
  ClassData copyWithCompanion(ClassesCompanion data) {
    return ClassData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endDateTime:
          data.endDateTime.present ? data.endDateTime.value : this.endDateTime,
      day: data.day.present ? data.day.value : this.day,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startTime: $startTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('day: $day')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, startTime, endDateTime, day);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassData &&
          other.id == this.id &&
          other.name == this.name &&
          other.startTime == this.startTime &&
          other.endDateTime == this.endDateTime &&
          other.day == this.day);
}

class ClassesCompanion extends UpdateCompanion<ClassData> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> startTime;
  final Value<DateTime> endDateTime;
  final Value<String> day;
  final Value<int> rowid;
  const ClassesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.day = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startTime,
    required DateTime endDateTime,
    required String day,
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        startTime = Value(startTime),
        endDateTime = Value(endDateTime),
        day = Value(day);
  static Insertable<ClassData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endDateTime,
    Expression<String>? day,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startTime != null) 'start_time': startTime,
      if (endDateTime != null) 'end_date_time': endDateTime,
      if (day != null) 'day': day,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<DateTime>? startTime,
      Value<DateTime>? endDateTime,
      Value<String>? day,
      Value<int>? rowid}) {
    return ClassesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endDateTime: endDateTime ?? this.endDateTime,
      day: day ?? this.day,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endDateTime.present) {
      map['end_date_time'] = Variable<DateTime>(endDateTime.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startTime: $startTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('day: $day, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, ReminderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 500),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _scheduledTimeMeta =
      const VerificationMeta('scheduledTime');
  @override
  late final GeneratedColumn<DateTime> scheduledTime =
      GeneratedColumn<DateTime>('scheduled_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<String> notificationId = GeneratedColumn<String>(
      'notification_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentReminderIdMeta =
      const VerificationMeta('parentReminderId');
  @override
  late final GeneratedColumn<String> parentReminderId = GeneratedColumn<String>(
      'parent_reminder_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceExceptionDatesMeta =
      const VerificationMeta('recurrenceExceptionDates');
  @override
  late final GeneratedColumn<String> recurrenceExceptionDates =
      GeneratedColumn<String>('recurrence_exception_dates', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceEndDateMeta =
      const VerificationMeta('recurrenceEndDate');
  @override
  late final GeneratedColumn<DateTime> recurrenceEndDate =
      GeneratedColumn<DateTime>('recurrence_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceCountMeta =
      const VerificationMeta('recurrenceCount');
  @override
  late final GeneratedColumn<int> recurrenceCount = GeneratedColumn<int>(
      'recurrence_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        body,
        scheduledTime,
        notificationId,
        completed,
        completedAt,
        isRecurring,
        recurrenceRule,
        parentReminderId,
        recurrenceExceptionDates,
        recurrenceEndDate,
        recurrenceCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<ReminderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
          _scheduledTimeMeta,
          scheduledTime.isAcceptableOrUnknown(
              data['scheduled_time']!, _scheduledTimeMeta));
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    if (data.containsKey('parent_reminder_id')) {
      context.handle(
          _parentReminderIdMeta,
          parentReminderId.isAcceptableOrUnknown(
              data['parent_reminder_id']!, _parentReminderIdMeta));
    }
    if (data.containsKey('recurrence_exception_dates')) {
      context.handle(
          _recurrenceExceptionDatesMeta,
          recurrenceExceptionDates.isAcceptableOrUnknown(
              data['recurrence_exception_dates']!,
              _recurrenceExceptionDatesMeta));
    }
    if (data.containsKey('recurrence_end_date')) {
      context.handle(
          _recurrenceEndDateMeta,
          recurrenceEndDate.isAcceptableOrUnknown(
              data['recurrence_end_date']!, _recurrenceEndDateMeta));
    }
    if (data.containsKey('recurrence_count')) {
      context.handle(
          _recurrenceCountMeta,
          recurrenceCount.isAcceptableOrUnknown(
              data['recurrence_count']!, _recurrenceCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      scheduledTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_time'])!,
      notificationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_id'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      parentReminderId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}parent_reminder_id']),
      recurrenceExceptionDates: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recurrence_exception_dates']),
      recurrenceEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recurrence_end_date']),
      recurrenceCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_count']),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class ReminderData extends DataClass implements Insertable<ReminderData> {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final String notificationId;
  final bool completed;
  final DateTime? completedAt;
  final bool isRecurring;
  final String? recurrenceRule;
  final String? parentReminderId;
  final String? recurrenceExceptionDates;
  final DateTime? recurrenceEndDate;
  final int? recurrenceCount;
  const ReminderData(
      {required this.id,
      required this.title,
      required this.body,
      required this.scheduledTime,
      required this.notificationId,
      required this.completed,
      this.completedAt,
      required this.isRecurring,
      this.recurrenceRule,
      this.parentReminderId,
      this.recurrenceExceptionDates,
      this.recurrenceEndDate,
      this.recurrenceCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['scheduled_time'] = Variable<DateTime>(scheduledTime);
    map['notification_id'] = Variable<String>(notificationId);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || parentReminderId != null) {
      map['parent_reminder_id'] = Variable<String>(parentReminderId);
    }
    if (!nullToAbsent || recurrenceExceptionDates != null) {
      map['recurrence_exception_dates'] =
          Variable<String>(recurrenceExceptionDates);
    }
    if (!nullToAbsent || recurrenceEndDate != null) {
      map['recurrence_end_date'] = Variable<DateTime>(recurrenceEndDate);
    }
    if (!nullToAbsent || recurrenceCount != null) {
      map['recurrence_count'] = Variable<int>(recurrenceCount);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      scheduledTime: Value(scheduledTime),
      notificationId: Value(notificationId),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      isRecurring: Value(isRecurring),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      parentReminderId: parentReminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentReminderId),
      recurrenceExceptionDates: recurrenceExceptionDates == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceExceptionDates),
      recurrenceEndDate: recurrenceEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceEndDate),
      recurrenceCount: recurrenceCount == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceCount),
    );
  }

  factory ReminderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      scheduledTime: serializer.fromJson<DateTime>(json['scheduledTime']),
      notificationId: serializer.fromJson<String>(json['notificationId']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      parentReminderId: serializer.fromJson<String?>(json['parentReminderId']),
      recurrenceExceptionDates:
          serializer.fromJson<String?>(json['recurrenceExceptionDates']),
      recurrenceEndDate:
          serializer.fromJson<DateTime?>(json['recurrenceEndDate']),
      recurrenceCount: serializer.fromJson<int?>(json['recurrenceCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'scheduledTime': serializer.toJson<DateTime>(scheduledTime),
      'notificationId': serializer.toJson<String>(notificationId),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'parentReminderId': serializer.toJson<String?>(parentReminderId),
      'recurrenceExceptionDates':
          serializer.toJson<String?>(recurrenceExceptionDates),
      'recurrenceEndDate': serializer.toJson<DateTime?>(recurrenceEndDate),
      'recurrenceCount': serializer.toJson<int?>(recurrenceCount),
    };
  }

  ReminderData copyWith(
          {String? id,
          String? title,
          String? body,
          DateTime? scheduledTime,
          String? notificationId,
          bool? completed,
          Value<DateTime?> completedAt = const Value.absent(),
          bool? isRecurring,
          Value<String?> recurrenceRule = const Value.absent(),
          Value<String?> parentReminderId = const Value.absent(),
          Value<String?> recurrenceExceptionDates = const Value.absent(),
          Value<DateTime?> recurrenceEndDate = const Value.absent(),
          Value<int?> recurrenceCount = const Value.absent()}) =>
      ReminderData(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        notificationId: notificationId ?? this.notificationId,
        completed: completed ?? this.completed,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        isRecurring: isRecurring ?? this.isRecurring,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
        parentReminderId: parentReminderId.present
            ? parentReminderId.value
            : this.parentReminderId,
        recurrenceExceptionDates: recurrenceExceptionDates.present
            ? recurrenceExceptionDates.value
            : this.recurrenceExceptionDates,
        recurrenceEndDate: recurrenceEndDate.present
            ? recurrenceEndDate.value
            : this.recurrenceEndDate,
        recurrenceCount: recurrenceCount.present
            ? recurrenceCount.value
            : this.recurrenceCount,
      );
  ReminderData copyWithCompanion(RemindersCompanion data) {
    return ReminderData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      parentReminderId: data.parentReminderId.present
          ? data.parentReminderId.value
          : this.parentReminderId,
      recurrenceExceptionDates: data.recurrenceExceptionDates.present
          ? data.recurrenceExceptionDates.value
          : this.recurrenceExceptionDates,
      recurrenceEndDate: data.recurrenceEndDate.present
          ? data.recurrenceEndDate.value
          : this.recurrenceEndDate,
      recurrenceCount: data.recurrenceCount.present
          ? data.recurrenceCount.value
          : this.recurrenceCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('notificationId: $notificationId, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('parentReminderId: $parentReminderId, ')
          ..write('recurrenceExceptionDates: $recurrenceExceptionDates, ')
          ..write('recurrenceEndDate: $recurrenceEndDate, ')
          ..write('recurrenceCount: $recurrenceCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      body,
      scheduledTime,
      notificationId,
      completed,
      completedAt,
      isRecurring,
      recurrenceRule,
      parentReminderId,
      recurrenceExceptionDates,
      recurrenceEndDate,
      recurrenceCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderData &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.scheduledTime == this.scheduledTime &&
          other.notificationId == this.notificationId &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt &&
          other.isRecurring == this.isRecurring &&
          other.recurrenceRule == this.recurrenceRule &&
          other.parentReminderId == this.parentReminderId &&
          other.recurrenceExceptionDates == this.recurrenceExceptionDates &&
          other.recurrenceEndDate == this.recurrenceEndDate &&
          other.recurrenceCount == this.recurrenceCount);
}

class RemindersCompanion extends UpdateCompanion<ReminderData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<DateTime> scheduledTime;
  final Value<String> notificationId;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  final Value<bool> isRecurring;
  final Value<String?> recurrenceRule;
  final Value<String?> parentReminderId;
  final Value<String?> recurrenceExceptionDates;
  final Value<DateTime?> recurrenceEndDate;
  final Value<int?> recurrenceCount;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.parentReminderId = const Value.absent(),
    this.recurrenceExceptionDates = const Value.absent(),
    this.recurrenceEndDate = const Value.absent(),
    this.recurrenceCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String notificationId,
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.parentReminderId = const Value.absent(),
    this.recurrenceExceptionDates = const Value.absent(),
    this.recurrenceEndDate = const Value.absent(),
    this.recurrenceCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : title = Value(title),
        body = Value(body),
        scheduledTime = Value(scheduledTime),
        notificationId = Value(notificationId);
  static Insertable<ReminderData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? scheduledTime,
    Expression<String>? notificationId,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
    Expression<bool>? isRecurring,
    Expression<String>? recurrenceRule,
    Expression<String>? parentReminderId,
    Expression<String>? recurrenceExceptionDates,
    Expression<DateTime>? recurrenceEndDate,
    Expression<int>? recurrenceCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (notificationId != null) 'notification_id': notificationId,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (parentReminderId != null) 'parent_reminder_id': parentReminderId,
      if (recurrenceExceptionDates != null)
        'recurrence_exception_dates': recurrenceExceptionDates,
      if (recurrenceEndDate != null) 'recurrence_end_date': recurrenceEndDate,
      if (recurrenceCount != null) 'recurrence_count': recurrenceCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<DateTime>? scheduledTime,
      Value<String>? notificationId,
      Value<bool>? completed,
      Value<DateTime?>? completedAt,
      Value<bool>? isRecurring,
      Value<String?>? recurrenceRule,
      Value<String?>? parentReminderId,
      Value<String?>? recurrenceExceptionDates,
      Value<DateTime?>? recurrenceEndDate,
      Value<int?>? recurrenceCount,
      Value<int>? rowid}) {
    return RemindersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      notificationId: notificationId ?? this.notificationId,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      parentReminderId: parentReminderId ?? this.parentReminderId,
      recurrenceExceptionDates:
          recurrenceExceptionDates ?? this.recurrenceExceptionDates,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      recurrenceCount: recurrenceCount ?? this.recurrenceCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<DateTime>(scheduledTime.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<String>(notificationId.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (parentReminderId.present) {
      map['parent_reminder_id'] = Variable<String>(parentReminderId.value);
    }
    if (recurrenceExceptionDates.present) {
      map['recurrence_exception_dates'] =
          Variable<String>(recurrenceExceptionDates.value);
    }
    if (recurrenceEndDate.present) {
      map['recurrence_end_date'] = Variable<DateTime>(recurrenceEndDate.value);
    }
    if (recurrenceCount.present) {
      map['recurrence_count'] = Variable<int>(recurrenceCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('notificationId: $notificationId, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('parentReminderId: $parentReminderId, ')
          ..write('recurrenceExceptionDates: $recurrenceExceptionDates, ')
          ..write('recurrenceEndDate: $recurrenceEndDate, ')
          ..write('recurrenceCount: $recurrenceCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#FFD700'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, content, category, color, createdAt, updatedAt, isPinned];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String title;
  final String content;
  final String? category;
  final String color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  const Note(
      {required this.id,
      required this.title,
      required this.content,
      this.category,
      required this.color,
      required this.createdAt,
      required this.updatedAt,
      required this.isPinned});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['color'] = Variable<String>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_pinned'] = Variable<bool>(isPinned);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      color: Value(color),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isPinned: Value(isPinned),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<String?>(json['category']),
      color: serializer.fromJson<String>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<String?>(category),
      'color': serializer.toJson<String>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isPinned': serializer.toJson<bool>(isPinned),
    };
  }

  Note copyWith(
          {String? id,
          String? title,
          String? content,
          Value<String?> category = const Value.absent(),
          String? color,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isPinned}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        category: category.present ? category.value : this.category,
        color: color ?? this.color,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isPinned: isPinned ?? this.isPinned,
      );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      category: data.category.present ? data.category.value : this.category,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPinned: $isPinned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, content, category, color, createdAt, updatedAt, isPinned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.category == this.category &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isPinned == this.isPinned);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> category;
  final Value<String> color;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isPinned;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    this.category = const Value.absent(),
    this.color = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isPinned = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : title = Value(title),
        content = Value(content),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? category,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isPinned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (category != null) 'category': category,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isPinned != null) 'is_pinned': isPinned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? content,
      Value<String?>? category,
      Value<String>? color,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isPinned,
      Value<int>? rowid}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $SubtasksTable subtasks = $SubtasksTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $ClassesTable classes = $ClassesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $NotesTable notes = $NotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [tasks, subtasks, events, classes, reminders, notes];
}

typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  required String title,
  Value<String?> description,
  required DateTime dueDate,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<String?> category,
  required String priority,
  Value<String?> customCategory,
  Value<String?> pageId,
  Value<String?> day,
  Value<bool> isRecurring,
  Value<String?> recurrenceRule,
  Value<int?> recurrenceInterval,
  Value<String?> daysOfWeek,
  Value<DateTime?> recurrenceEndDate,
  Value<String?> parentTaskId,
  Value<int?> maxOccurrences,
  Value<bool> skipWeekends,
  Value<int?> dayOfMonth,
  Value<int?> weekOfMonth,
  Value<bool> reminderEnabled,
  Value<DateTime?> reminderTime,
  Value<String?> reminderPreset,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> dueDate,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<String?> category,
  Value<String> priority,
  Value<String?> customCategory,
  Value<String?> pageId,
  Value<String?> day,
  Value<bool> isRecurring,
  Value<String?> recurrenceRule,
  Value<int?> recurrenceInterval,
  Value<String?> daysOfWeek,
  Value<DateTime?> recurrenceEndDate,
  Value<String?> parentTaskId,
  Value<int?> maxOccurrences,
  Value<bool> skipWeekends,
  Value<int?> dayOfMonth,
  Value<int?> weekOfMonth,
  Value<bool> reminderEnabled,
  Value<DateTime?> reminderTime,
  Value<String?> reminderPreset,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, TaskData> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubtasksTable, List<SubtaskData>>
      _subtasksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.subtasks,
              aliasName: $_aliasNameGenerator(db.tasks.id, db.subtasks.taskId));

  $$SubtasksTableProcessedTableManager get subtasksRefs {
    final manager = $$SubtasksTableTableManager($_db, $_db.subtasks)
        .filter((f) => f.taskId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_subtasksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customCategory => $composableBuilder(
      column: $table.customCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pageId => $composableBuilder(
      column: $table.pageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recurrenceInterval => $composableBuilder(
      column: $table.recurrenceInterval,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentTaskId => $composableBuilder(
      column: $table.parentTaskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxOccurrences => $composableBuilder(
      column: $table.maxOccurrences,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get skipWeekends => $composableBuilder(
      column: $table.skipWeekends, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekOfMonth => $composableBuilder(
      column: $table.weekOfMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderPreset => $composableBuilder(
      column: $table.reminderPreset,
      builder: (column) => ColumnFilters(column));

  Expression<bool> subtasksRefs(
      Expression<bool> Function($$SubtasksTableFilterComposer f) f) {
    final $$SubtasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subtasks,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubtasksTableFilterComposer(
              $db: $db,
              $table: $db.subtasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customCategory => $composableBuilder(
      column: $table.customCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pageId => $composableBuilder(
      column: $table.pageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recurrenceInterval => $composableBuilder(
      column: $table.recurrenceInterval,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentTaskId => $composableBuilder(
      column: $table.parentTaskId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxOccurrences => $composableBuilder(
      column: $table.maxOccurrences,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get skipWeekends => $composableBuilder(
      column: $table.skipWeekends,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekOfMonth => $composableBuilder(
      column: $table.weekOfMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderPreset => $composableBuilder(
      column: $table.reminderPreset,
      builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get customCategory => $composableBuilder(
      column: $table.customCategory, builder: (column) => column);

  GeneratedColumn<String> get pageId =>
      $composableBuilder(column: $table.pageId, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<int> get recurrenceInterval => $composableBuilder(
      column: $table.recurrenceInterval, builder: (column) => column);

  GeneratedColumn<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => column);

  GeneratedColumn<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate, builder: (column) => column);

  GeneratedColumn<String> get parentTaskId => $composableBuilder(
      column: $table.parentTaskId, builder: (column) => column);

  GeneratedColumn<int> get maxOccurrences => $composableBuilder(
      column: $table.maxOccurrences, builder: (column) => column);

  GeneratedColumn<bool> get skipWeekends => $composableBuilder(
      column: $table.skipWeekends, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => column);

  GeneratedColumn<int> get weekOfMonth => $composableBuilder(
      column: $table.weekOfMonth, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<String> get reminderPreset => $composableBuilder(
      column: $table.reminderPreset, builder: (column) => column);

  Expression<T> subtasksRefs<T extends Object>(
      Expression<T> Function($$SubtasksTableAnnotationComposer a) f) {
    final $$SubtasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subtasks,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubtasksTableAnnotationComposer(
              $db: $db,
              $table: $db.subtasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskData,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskData, $$TasksTableReferences),
    TaskData,
    PrefetchHooks Function({bool subtasksRefs})> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String?> customCategory = const Value.absent(),
            Value<String?> pageId = const Value.absent(),
            Value<String?> day = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<int?> recurrenceInterval = const Value.absent(),
            Value<String?> daysOfWeek = const Value.absent(),
            Value<DateTime?> recurrenceEndDate = const Value.absent(),
            Value<String?> parentTaskId = const Value.absent(),
            Value<int?> maxOccurrences = const Value.absent(),
            Value<bool> skipWeekends = const Value.absent(),
            Value<int?> dayOfMonth = const Value.absent(),
            Value<int?> weekOfMonth = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<String?> reminderPreset = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            title: title,
            description: description,
            dueDate: dueDate,
            completed: completed,
            completedAt: completedAt,
            category: category,
            priority: priority,
            customCategory: customCategory,
            pageId: pageId,
            day: day,
            isRecurring: isRecurring,
            recurrenceRule: recurrenceRule,
            recurrenceInterval: recurrenceInterval,
            daysOfWeek: daysOfWeek,
            recurrenceEndDate: recurrenceEndDate,
            parentTaskId: parentTaskId,
            maxOccurrences: maxOccurrences,
            skipWeekends: skipWeekends,
            dayOfMonth: dayOfMonth,
            weekOfMonth: weekOfMonth,
            reminderEnabled: reminderEnabled,
            reminderTime: reminderTime,
            reminderPreset: reminderPreset,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime dueDate,
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> category = const Value.absent(),
            required String priority,
            Value<String?> customCategory = const Value.absent(),
            Value<String?> pageId = const Value.absent(),
            Value<String?> day = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<int?> recurrenceInterval = const Value.absent(),
            Value<String?> daysOfWeek = const Value.absent(),
            Value<DateTime?> recurrenceEndDate = const Value.absent(),
            Value<String?> parentTaskId = const Value.absent(),
            Value<int?> maxOccurrences = const Value.absent(),
            Value<bool> skipWeekends = const Value.absent(),
            Value<int?> dayOfMonth = const Value.absent(),
            Value<int?> weekOfMonth = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<String?> reminderPreset = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            title: title,
            description: description,
            dueDate: dueDate,
            completed: completed,
            completedAt: completedAt,
            category: category,
            priority: priority,
            customCategory: customCategory,
            pageId: pageId,
            day: day,
            isRecurring: isRecurring,
            recurrenceRule: recurrenceRule,
            recurrenceInterval: recurrenceInterval,
            daysOfWeek: daysOfWeek,
            recurrenceEndDate: recurrenceEndDate,
            parentTaskId: parentTaskId,
            maxOccurrences: maxOccurrences,
            skipWeekends: skipWeekends,
            dayOfMonth: dayOfMonth,
            weekOfMonth: weekOfMonth,
            reminderEnabled: reminderEnabled,
            reminderTime: reminderTime,
            reminderPreset: reminderPreset,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TasksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({subtasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (subtasksRefs) db.subtasks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subtasksRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$TasksTableReferences._subtasksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TasksTableReferences(db, table, p0).subtasksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.taskId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskData,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskData, $$TasksTableReferences),
    TaskData,
    PrefetchHooks Function({bool subtasksRefs})>;
typedef $$SubtasksTableCreateCompanionBuilder = SubtasksCompanion Function({
  Value<String> id,
  required String taskId,
  required String title,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$SubtasksTableUpdateCompanionBuilder = SubtasksCompanion Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> title,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

final class $$SubtasksTableReferences
    extends BaseReferences<_$AppDatabase, $SubtasksTable, SubtaskData> {
  $$SubtasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks
      .createAlias($_aliasNameGenerator(db.subtasks.taskId, db.tasks.id));

  $$TasksTableProcessedTableManager get taskId {
    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.id($_item.taskId));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SubtasksTableFilterComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubtasksTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableOrderingComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubtasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubtasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubtasksTable,
    SubtaskData,
    $$SubtasksTableFilterComposer,
    $$SubtasksTableOrderingComposer,
    $$SubtasksTableAnnotationComposer,
    $$SubtasksTableCreateCompanionBuilder,
    $$SubtasksTableUpdateCompanionBuilder,
    (SubtaskData, $$SubtasksTableReferences),
    SubtaskData,
    PrefetchHooks Function({bool taskId})> {
  $$SubtasksTableTableManager(_$AppDatabase db, $SubtasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubtasksCompanion(
            id: id,
            taskId: taskId,
            title: title,
            completed: completed,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String taskId,
            required String title,
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubtasksCompanion.insert(
            id: id,
            taskId: taskId,
            title: title,
            completed: completed,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SubtasksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (taskId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.taskId,
                    referencedTable: $$SubtasksTableReferences._taskIdTable(db),
                    referencedColumn:
                        $$SubtasksTableReferences._taskIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SubtasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubtasksTable,
    SubtaskData,
    $$SubtasksTableFilterComposer,
    $$SubtasksTableOrderingComposer,
    $$SubtasksTableAnnotationComposer,
    $$SubtasksTableCreateCompanionBuilder,
    $$SubtasksTableUpdateCompanionBuilder,
    (SubtaskData, $$SubtasksTableReferences),
    SubtaskData,
    PrefetchHooks Function({bool taskId})>;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<String> id,
  required String title,
  Value<String?> description,
  Value<String?> comments,
  required DateTime startDateTime,
  required DateTime endDateTime,
  Value<String?> customCategory,
  Value<String?> color,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<bool> isRecurring,
  Value<String?> recurrenceRule,
  Value<String?> parentEventId,
  Value<String?> recurrenceExceptionDates,
  Value<DateTime?> recurrenceEndDate,
  Value<int?> recurrenceCount,
  Value<bool> reminderEnabled,
  Value<DateTime?> reminderTime,
  Value<String?> reminderPreset,
  Value<int> rowid,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String?> comments,
  Value<DateTime> startDateTime,
  Value<DateTime> endDateTime,
  Value<String?> customCategory,
  Value<String?> color,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<bool> isRecurring,
  Value<String?> recurrenceRule,
  Value<String?> parentEventId,
  Value<String?> recurrenceExceptionDates,
  Value<DateTime?> recurrenceEndDate,
  Value<int?> recurrenceCount,
  Value<bool> reminderEnabled,
  Value<DateTime?> reminderTime,
  Value<String?> reminderPreset,
  Value<int> rowid,
});

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comments => $composableBuilder(
      column: $table.comments, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDateTime => $composableBuilder(
      column: $table.startDateTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDateTime => $composableBuilder(
      column: $table.endDateTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customCategory => $composableBuilder(
      column: $table.customCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentEventId => $composableBuilder(
      column: $table.parentEventId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceExceptionDates => $composableBuilder(
      column: $table.recurrenceExceptionDates,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderPreset => $composableBuilder(
      column: $table.reminderPreset,
      builder: (column) => ColumnFilters(column));
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comments => $composableBuilder(
      column: $table.comments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDateTime => $composableBuilder(
      column: $table.startDateTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDateTime => $composableBuilder(
      column: $table.endDateTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customCategory => $composableBuilder(
      column: $table.customCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentEventId => $composableBuilder(
      column: $table.parentEventId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceExceptionDates => $composableBuilder(
      column: $table.recurrenceExceptionDates,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderPreset => $composableBuilder(
      column: $table.reminderPreset,
      builder: (column) => ColumnOrderings(column));
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<DateTime> get startDateTime => $composableBuilder(
      column: $table.startDateTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endDateTime => $composableBuilder(
      column: $table.endDateTime, builder: (column) => column);

  GeneratedColumn<String> get customCategory => $composableBuilder(
      column: $table.customCategory, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<String> get parentEventId => $composableBuilder(
      column: $table.parentEventId, builder: (column) => column);

  GeneratedColumn<String> get recurrenceExceptionDates => $composableBuilder(
      column: $table.recurrenceExceptionDates, builder: (column) => column);

  GeneratedColumn<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate, builder: (column) => column);

  GeneratedColumn<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<String> get reminderPreset => $composableBuilder(
      column: $table.reminderPreset, builder: (column) => column);
}

class $$EventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventsTable,
    EventData,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (EventData, BaseReferences<_$AppDatabase, $EventsTable, EventData>),
    EventData,
    PrefetchHooks Function()> {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> comments = const Value.absent(),
            Value<DateTime> startDateTime = const Value.absent(),
            Value<DateTime> endDateTime = const Value.absent(),
            Value<String?> customCategory = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<String?> parentEventId = const Value.absent(),
            Value<String?> recurrenceExceptionDates = const Value.absent(),
            Value<DateTime?> recurrenceEndDate = const Value.absent(),
            Value<int?> recurrenceCount = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<String?> reminderPreset = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventsCompanion(
            id: id,
            title: title,
            description: description,
            comments: comments,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            customCategory: customCategory,
            color: color,
            completed: completed,
            completedAt: completedAt,
            isRecurring: isRecurring,
            recurrenceRule: recurrenceRule,
            parentEventId: parentEventId,
            recurrenceExceptionDates: recurrenceExceptionDates,
            recurrenceEndDate: recurrenceEndDate,
            recurrenceCount: recurrenceCount,
            reminderEnabled: reminderEnabled,
            reminderTime: reminderTime,
            reminderPreset: reminderPreset,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> comments = const Value.absent(),
            required DateTime startDateTime,
            required DateTime endDateTime,
            Value<String?> customCategory = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<String?> parentEventId = const Value.absent(),
            Value<String?> recurrenceExceptionDates = const Value.absent(),
            Value<DateTime?> recurrenceEndDate = const Value.absent(),
            Value<int?> recurrenceCount = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<String?> reminderPreset = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventsCompanion.insert(
            id: id,
            title: title,
            description: description,
            comments: comments,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            customCategory: customCategory,
            color: color,
            completed: completed,
            completedAt: completedAt,
            isRecurring: isRecurring,
            recurrenceRule: recurrenceRule,
            parentEventId: parentEventId,
            recurrenceExceptionDates: recurrenceExceptionDates,
            recurrenceEndDate: recurrenceEndDate,
            recurrenceCount: recurrenceCount,
            reminderEnabled: reminderEnabled,
            reminderTime: reminderTime,
            reminderPreset: reminderPreset,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventsTable,
    EventData,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (EventData, BaseReferences<_$AppDatabase, $EventsTable, EventData>),
    EventData,
    PrefetchHooks Function()>;
typedef $$ClassesTableCreateCompanionBuilder = ClassesCompanion Function({
  Value<String> id,
  required String name,
  required DateTime startTime,
  required DateTime endDateTime,
  required String day,
  Value<int> rowid,
});
typedef $$ClassesTableUpdateCompanionBuilder = ClassesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> startTime,
  Value<DateTime> endDateTime,
  Value<String> day,
  Value<int> rowid,
});

class $$ClassesTableFilterComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDateTime => $composableBuilder(
      column: $table.endDateTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));
}

class $$ClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDateTime => $composableBuilder(
      column: $table.endDateTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));
}

class $$ClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endDateTime => $composableBuilder(
      column: $table.endDateTime, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);
}

class $$ClassesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClassesTable,
    ClassData,
    $$ClassesTableFilterComposer,
    $$ClassesTableOrderingComposer,
    $$ClassesTableAnnotationComposer,
    $$ClassesTableCreateCompanionBuilder,
    $$ClassesTableUpdateCompanionBuilder,
    (ClassData, BaseReferences<_$AppDatabase, $ClassesTable, ClassData>),
    ClassData,
    PrefetchHooks Function()> {
  $$ClassesTableTableManager(_$AppDatabase db, $ClassesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> endDateTime = const Value.absent(),
            Value<String> day = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClassesCompanion(
            id: id,
            name: name,
            startTime: startTime,
            endDateTime: endDateTime,
            day: day,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            required DateTime startTime,
            required DateTime endDateTime,
            required String day,
            Value<int> rowid = const Value.absent(),
          }) =>
              ClassesCompanion.insert(
            id: id,
            name: name,
            startTime: startTime,
            endDateTime: endDateTime,
            day: day,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClassesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClassesTable,
    ClassData,
    $$ClassesTableFilterComposer,
    $$ClassesTableOrderingComposer,
    $$ClassesTableAnnotationComposer,
    $$ClassesTableCreateCompanionBuilder,
    $$ClassesTableUpdateCompanionBuilder,
    (ClassData, BaseReferences<_$AppDatabase, $ClassesTable, ClassData>),
    ClassData,
    PrefetchHooks Function()>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  required String title,
  required String body,
  required DateTime scheduledTime,
  required String notificationId,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<bool> isRecurring,
  Value<String?> recurrenceRule,
  Value<String?> parentReminderId,
  Value<String?> recurrenceExceptionDates,
  Value<DateTime?> recurrenceEndDate,
  Value<int?> recurrenceCount,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> body,
  Value<DateTime> scheduledTime,
  Value<String> notificationId,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<bool> isRecurring,
  Value<String?> recurrenceRule,
  Value<String?> parentReminderId,
  Value<String?> recurrenceExceptionDates,
  Value<DateTime?> recurrenceEndDate,
  Value<int?> recurrenceCount,
  Value<int> rowid,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentReminderId => $composableBuilder(
      column: $table.parentReminderId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceExceptionDates => $composableBuilder(
      column: $table.recurrenceExceptionDates,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount,
      builder: (column) => ColumnFilters(column));
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentReminderId => $composableBuilder(
      column: $table.parentReminderId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceExceptionDates => $composableBuilder(
      column: $table.recurrenceExceptionDates,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount,
      builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => column);

  GeneratedColumn<String> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<String> get parentReminderId => $composableBuilder(
      column: $table.parentReminderId, builder: (column) => column);

  GeneratedColumn<String> get recurrenceExceptionDates => $composableBuilder(
      column: $table.recurrenceExceptionDates, builder: (column) => column);

  GeneratedColumn<DateTime> get recurrenceEndDate => $composableBuilder(
      column: $table.recurrenceEndDate, builder: (column) => column);

  GeneratedColumn<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount, builder: (column) => column);
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    ReminderData,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (
      ReminderData,
      BaseReferences<_$AppDatabase, $RemindersTable, ReminderData>
    ),
    ReminderData,
    PrefetchHooks Function()> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<DateTime> scheduledTime = const Value.absent(),
            Value<String> notificationId = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<String?> parentReminderId = const Value.absent(),
            Value<String?> recurrenceExceptionDates = const Value.absent(),
            Value<DateTime?> recurrenceEndDate = const Value.absent(),
            Value<int?> recurrenceCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            title: title,
            body: body,
            scheduledTime: scheduledTime,
            notificationId: notificationId,
            completed: completed,
            completedAt: completedAt,
            isRecurring: isRecurring,
            recurrenceRule: recurrenceRule,
            parentReminderId: parentReminderId,
            recurrenceExceptionDates: recurrenceExceptionDates,
            recurrenceEndDate: recurrenceEndDate,
            recurrenceCount: recurrenceCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String title,
            required String body,
            required DateTime scheduledTime,
            required String notificationId,
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<String?> parentReminderId = const Value.absent(),
            Value<String?> recurrenceExceptionDates = const Value.absent(),
            Value<DateTime?> recurrenceEndDate = const Value.absent(),
            Value<int?> recurrenceCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            title: title,
            body: body,
            scheduledTime: scheduledTime,
            notificationId: notificationId,
            completed: completed,
            completedAt: completedAt,
            isRecurring: isRecurring,
            recurrenceRule: recurrenceRule,
            parentReminderId: parentReminderId,
            recurrenceExceptionDates: recurrenceExceptionDates,
            recurrenceEndDate: recurrenceEndDate,
            recurrenceCount: recurrenceCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    ReminderData,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (
      ReminderData,
      BaseReferences<_$AppDatabase, $RemindersTable, ReminderData>
    ),
    ReminderData,
    PrefetchHooks Function()>;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  required String title,
  required String content,
  Value<String?> category,
  Value<String> color,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isPinned,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> content,
  Value<String?> category,
  Value<String> color,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isPinned,
  Value<int> rowid,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            title: title,
            content: content,
            category: category,
            color: color,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isPinned: isPinned,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String title,
            required String content,
            Value<String?> category = const Value.absent(),
            Value<String> color = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isPinned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            title: title,
            content: content,
            category: category,
            color: color,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isPinned: isPinned,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db, _db.subtasks);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$ClassesTableTableManager get classes =>
      $$ClassesTableTableManager(_db, _db.classes);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
}

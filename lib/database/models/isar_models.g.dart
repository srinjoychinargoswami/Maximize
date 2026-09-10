// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarTaskCollection on Isar {
  IsarCollection<IsarTask> get isarTasks => this.collection();
}

const IsarTaskSchema = CollectionSchema(
  name: r'IsarTask',
  id: 8117048608637594012,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'completed': PropertySchema(
      id: 1,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'completedAt': PropertySchema(
      id: 2,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customCategory': PropertySchema(
      id: 4,
      name: r'customCategory',
      type: IsarType.string,
    ),
    r'day': PropertySchema(
      id: 5,
      name: r'day',
      type: IsarType.string,
    ),
    r'dayOfMonth': PropertySchema(
      id: 6,
      name: r'dayOfMonth',
      type: IsarType.long,
    ),
    r'daysOfWeek': PropertySchema(
      id: 7,
      name: r'daysOfWeek',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 8,
      name: r'description',
      type: IsarType.string,
    ),
    r'dueDate': PropertySchema(
      id: 9,
      name: r'dueDate',
      type: IsarType.dateTime,
    ),
    r'isRecurring': PropertySchema(
      id: 10,
      name: r'isRecurring',
      type: IsarType.bool,
    ),
    r'maxOccurrences': PropertySchema(
      id: 11,
      name: r'maxOccurrences',
      type: IsarType.long,
    ),
    r'pageId': PropertySchema(
      id: 12,
      name: r'pageId',
      type: IsarType.string,
    ),
    r'parentTaskId': PropertySchema(
      id: 13,
      name: r'parentTaskId',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 14,
      name: r'priority',
      type: IsarType.string,
    ),
    r'recurrenceEndDate': PropertySchema(
      id: 15,
      name: r'recurrenceEndDate',
      type: IsarType.dateTime,
    ),
    r'recurrenceInterval': PropertySchema(
      id: 16,
      name: r'recurrenceInterval',
      type: IsarType.long,
    ),
    r'recurrenceRule': PropertySchema(
      id: 17,
      name: r'recurrenceRule',
      type: IsarType.string,
    ),
    r'reminderEnabled': PropertySchema(
      id: 18,
      name: r'reminderEnabled',
      type: IsarType.bool,
    ),
    r'reminderPreset': PropertySchema(
      id: 19,
      name: r'reminderPreset',
      type: IsarType.string,
    ),
    r'reminderTime': PropertySchema(
      id: 20,
      name: r'reminderTime',
      type: IsarType.dateTime,
    ),
    r'skipWeekends': PropertySchema(
      id: 21,
      name: r'skipWeekends',
      type: IsarType.bool,
    ),
    r'taskId': PropertySchema(
      id: 22,
      name: r'taskId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 23,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 24,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weekOfMonth': PropertySchema(
      id: 25,
      name: r'weekOfMonth',
      type: IsarType.long,
    )
  },
  estimateSize: _isarTaskEstimateSize,
  serialize: _isarTaskSerialize,
  deserialize: _isarTaskDeserialize,
  deserializeProp: _isarTaskDeserializeProp,
  idName: r'id',
  indexes: {
    r'taskId': IndexSchema(
      id: -6391211041487498726,
      name: r'taskId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'completed': IndexSchema(
      id: -1755850151728404861,
      name: r'completed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completed',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isRecurring': IndexSchema(
      id: 1211429805563284888,
      name: r'isRecurring',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isRecurring',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'parentTaskId': IndexSchema(
      id: 1235852618244535635,
      name: r'parentTaskId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parentTaskId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarTaskGetId,
  getLinks: _isarTaskGetLinks,
  attach: _isarTaskAttach,
  version: '3.1.0+1',
);

int _isarTaskEstimateSize(
  IsarTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customCategory;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.day;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.daysOfWeek;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pageId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.parentTaskId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.priority.length * 3;
  {
    final value = object.recurrenceRule;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reminderPreset;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.taskId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _isarTaskSerialize(
  IsarTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeBool(offsets[1], object.completed);
  writer.writeDateTime(offsets[2], object.completedAt);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.customCategory);
  writer.writeString(offsets[5], object.day);
  writer.writeLong(offsets[6], object.dayOfMonth);
  writer.writeString(offsets[7], object.daysOfWeek);
  writer.writeString(offsets[8], object.description);
  writer.writeDateTime(offsets[9], object.dueDate);
  writer.writeBool(offsets[10], object.isRecurring);
  writer.writeLong(offsets[11], object.maxOccurrences);
  writer.writeString(offsets[12], object.pageId);
  writer.writeString(offsets[13], object.parentTaskId);
  writer.writeString(offsets[14], object.priority);
  writer.writeDateTime(offsets[15], object.recurrenceEndDate);
  writer.writeLong(offsets[16], object.recurrenceInterval);
  writer.writeString(offsets[17], object.recurrenceRule);
  writer.writeBool(offsets[18], object.reminderEnabled);
  writer.writeString(offsets[19], object.reminderPreset);
  writer.writeDateTime(offsets[20], object.reminderTime);
  writer.writeBool(offsets[21], object.skipWeekends);
  writer.writeString(offsets[22], object.taskId);
  writer.writeString(offsets[23], object.title);
  writer.writeDateTime(offsets[24], object.updatedAt);
  writer.writeLong(offsets[25], object.weekOfMonth);
}

IsarTask _isarTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarTask();
  object.category = reader.readStringOrNull(offsets[0]);
  object.completed = reader.readBool(offsets[1]);
  object.completedAt = reader.readDateTimeOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.customCategory = reader.readStringOrNull(offsets[4]);
  object.day = reader.readStringOrNull(offsets[5]);
  object.dayOfMonth = reader.readLongOrNull(offsets[6]);
  object.daysOfWeek = reader.readStringOrNull(offsets[7]);
  object.description = reader.readStringOrNull(offsets[8]);
  object.dueDate = reader.readDateTimeOrNull(offsets[9]);
  object.id = id;
  object.isRecurring = reader.readBool(offsets[10]);
  object.maxOccurrences = reader.readLongOrNull(offsets[11]);
  object.pageId = reader.readStringOrNull(offsets[12]);
  object.parentTaskId = reader.readStringOrNull(offsets[13]);
  object.priority = reader.readString(offsets[14]);
  object.recurrenceEndDate = reader.readDateTimeOrNull(offsets[15]);
  object.recurrenceInterval = reader.readLongOrNull(offsets[16]);
  object.recurrenceRule = reader.readStringOrNull(offsets[17]);
  object.reminderEnabled = reader.readBool(offsets[18]);
  object.reminderPreset = reader.readStringOrNull(offsets[19]);
  object.reminderTime = reader.readDateTimeOrNull(offsets[20]);
  object.skipWeekends = reader.readBool(offsets[21]);
  object.taskId = reader.readString(offsets[22]);
  object.title = reader.readString(offsets[23]);
  object.updatedAt = reader.readDateTime(offsets[24]);
  object.weekOfMonth = reader.readLongOrNull(offsets[25]);
  return object;
}

P _isarTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 21:
      return (reader.readBool(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readDateTime(offset)) as P;
    case 25:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarTaskGetId(IsarTask object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarTaskGetLinks(IsarTask object) {
  return [];
}

void _isarTaskAttach(IsarCollection<dynamic> col, Id id, IsarTask object) {
  object.id = id;
}

extension IsarTaskQueryWhereSort on QueryBuilder<IsarTask, IsarTask, QWhere> {
  QueryBuilder<IsarTask, IsarTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhere> anyCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completed'),
      );
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhere> anyIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isRecurring'),
      );
    });
  }
}

extension IsarTaskQueryWhere on QueryBuilder<IsarTask, IsarTask, QWhereClause> {
  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> taskIdEqualTo(
      String taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId',
        value: [taskId],
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> taskIdNotEqualTo(
      String taskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> completedEqualTo(
      bool completed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completed',
        value: [completed],
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> completedNotEqualTo(
      bool completed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> isRecurringEqualTo(
      bool isRecurring) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isRecurring',
        value: [isRecurring],
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> isRecurringNotEqualTo(
      bool isRecurring) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [],
              upper: [isRecurring],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [isRecurring],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [isRecurring],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [],
              upper: [isRecurring],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> parentTaskIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentTaskId',
        value: [null],
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> parentTaskIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentTaskId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> parentTaskIdEqualTo(
      String? parentTaskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentTaskId',
        value: [parentTaskId],
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterWhereClause> parentTaskIdNotEqualTo(
      String? parentTaskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentTaskId',
              lower: [],
              upper: [parentTaskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentTaskId',
              lower: [parentTaskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentTaskId',
              lower: [parentTaskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentTaskId',
              lower: [],
              upper: [parentTaskId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarTaskQueryFilter
    on QueryBuilder<IsarTask, IsarTask, QFilterCondition> {
  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> completedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> completedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customCategory',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customCategory',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> customCategoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> customCategoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customCategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> customCategoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customCategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      customCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'day',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'day',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'day',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'day',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'day',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'day',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayOfMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayOfMonth',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      dayOfMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayOfMonth',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayOfMonthEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayOfMonthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayOfMonthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dayOfMonthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'daysOfWeek',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      daysOfWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'daysOfWeek',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'daysOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'daysOfWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'daysOfWeek',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> daysOfWeekIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daysOfWeek',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      daysOfWeekIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'daysOfWeek',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dueDate',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dueDate',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dueDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dueDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dueDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> dueDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dueDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> isRecurringEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRecurring',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      maxOccurrencesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maxOccurrences',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      maxOccurrencesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maxOccurrences',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> maxOccurrencesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxOccurrences',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      maxOccurrencesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxOccurrences',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      maxOccurrencesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxOccurrences',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> maxOccurrencesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxOccurrences',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pageId',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pageId',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> pageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pageId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> parentTaskIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentTaskId',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      parentTaskIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentTaskId',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> parentTaskIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      parentTaskIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> parentTaskIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> parentTaskIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentTaskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      parentTaskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> parentTaskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> parentTaskIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> parentTaskIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentTaskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      parentTaskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      parentTaskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'priority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> priorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceEndDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceEndDate',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceEndDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceEndDate',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceEndDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceEndDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceEndDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceEndDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceEndDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceIntervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceInterval',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceIntervalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceInterval',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceIntervalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceIntervalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceIntervalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceIntervalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceRule',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceRule',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> recurrenceRuleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> recurrenceRuleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceRule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> recurrenceRuleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recurrenceRule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceRule',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      recurrenceRuleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recurrenceRule',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reminderPreset',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reminderPreset',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> reminderPresetEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> reminderPresetBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderPreset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> reminderPresetMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reminderPreset',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderPreset',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderPresetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reminderPreset',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> reminderTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reminderTime',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reminderTime',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> reminderTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      reminderTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> reminderTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> reminderTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> skipWeekendsEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skipWeekends',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> taskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> weekOfMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekOfMonth',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      weekOfMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekOfMonth',
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> weekOfMonthEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition>
      weekOfMonthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> weekOfMonthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterFilterCondition> weekOfMonthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarTaskQueryObject
    on QueryBuilder<IsarTask, IsarTask, QFilterCondition> {}

extension IsarTaskQueryLinks
    on QueryBuilder<IsarTask, IsarTask, QFilterCondition> {}

extension IsarTaskQuerySortBy on QueryBuilder<IsarTask, IsarTask, QSortBy> {
  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCustomCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByCustomCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'day', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'day', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDaysOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOfWeek', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDaysOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOfWeek', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByMaxOccurrences() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxOccurrences', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByMaxOccurrencesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxOccurrences', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByPageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageId', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByPageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageId', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByParentTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTaskId', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByParentTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTaskId', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByRecurrenceEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByRecurrenceInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceInterval', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy>
      sortByRecurrenceIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceInterval', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByRecurrenceRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByRecurrenceRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByReminderPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderPreset', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByReminderPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderPreset', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortBySkipWeekends() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipWeekends', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortBySkipWeekendsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipWeekends', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByWeekOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekOfMonth', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> sortByWeekOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekOfMonth', Sort.desc);
    });
  }
}

extension IsarTaskQuerySortThenBy
    on QueryBuilder<IsarTask, IsarTask, QSortThenBy> {
  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCustomCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByCustomCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'day', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'day', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDaysOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOfWeek', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDaysOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysOfWeek', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByMaxOccurrences() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxOccurrences', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByMaxOccurrencesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxOccurrences', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByPageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageId', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByPageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageId', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByParentTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTaskId', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByParentTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTaskId', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByRecurrenceEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByRecurrenceInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceInterval', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy>
      thenByRecurrenceIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceInterval', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByRecurrenceRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByRecurrenceRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByReminderPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderPreset', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByReminderPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderPreset', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenBySkipWeekends() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipWeekends', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenBySkipWeekendsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipWeekends', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByWeekOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekOfMonth', Sort.asc);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QAfterSortBy> thenByWeekOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekOfMonth', Sort.desc);
    });
  }
}

extension IsarTaskQueryWhereDistinct
    on QueryBuilder<IsarTask, IsarTask, QDistinct> {
  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByCustomCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customCategory',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByDay(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'day', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfMonth');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByDaysOfWeek(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'daysOfWeek', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueDate');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRecurring');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByMaxOccurrences() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxOccurrences');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByPageId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByParentTaskId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentTaskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByPriority(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceEndDate');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByRecurrenceInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceInterval');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByRecurrenceRule(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceRule',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderEnabled');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByReminderPreset(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderPreset',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderTime');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctBySkipWeekends() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skipWeekends');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByTaskId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<IsarTask, IsarTask, QDistinct> distinctByWeekOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekOfMonth');
    });
  }
}

extension IsarTaskQueryProperty
    on QueryBuilder<IsarTask, IsarTask, QQueryProperty> {
  QueryBuilder<IsarTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<IsarTask, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<IsarTask, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<IsarTask, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> customCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customCategory');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> dayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'day');
    });
  }

  QueryBuilder<IsarTask, int?, QQueryOperations> dayOfMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfMonth');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> daysOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'daysOfWeek');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<IsarTask, DateTime?, QQueryOperations> dueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueDate');
    });
  }

  QueryBuilder<IsarTask, bool, QQueryOperations> isRecurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRecurring');
    });
  }

  QueryBuilder<IsarTask, int?, QQueryOperations> maxOccurrencesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxOccurrences');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> pageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageId');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> parentTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentTaskId');
    });
  }

  QueryBuilder<IsarTask, String, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<IsarTask, DateTime?, QQueryOperations>
      recurrenceEndDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceEndDate');
    });
  }

  QueryBuilder<IsarTask, int?, QQueryOperations> recurrenceIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceInterval');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> recurrenceRuleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceRule');
    });
  }

  QueryBuilder<IsarTask, bool, QQueryOperations> reminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderEnabled');
    });
  }

  QueryBuilder<IsarTask, String?, QQueryOperations> reminderPresetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderPreset');
    });
  }

  QueryBuilder<IsarTask, DateTime?, QQueryOperations> reminderTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderTime');
    });
  }

  QueryBuilder<IsarTask, bool, QQueryOperations> skipWeekendsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skipWeekends');
    });
  }

  QueryBuilder<IsarTask, String, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<IsarTask, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<IsarTask, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<IsarTask, int?, QQueryOperations> weekOfMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekOfMonth');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarSubtaskCollection on Isar {
  IsarCollection<IsarSubtask> get isarSubtasks => this.collection();
}

const IsarSubtaskSchema = CollectionSchema(
  name: r'IsarSubtask',
  id: 5864488705088081175,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'subtaskId': PropertySchema(
      id: 3,
      name: r'subtaskId',
      type: IsarType.string,
    ),
    r'taskId': PropertySchema(
      id: 4,
      name: r'taskId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 5,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarSubtaskEstimateSize,
  serialize: _isarSubtaskSerialize,
  deserialize: _isarSubtaskDeserialize,
  deserializeProp: _isarSubtaskDeserializeProp,
  idName: r'id',
  indexes: {
    r'subtaskId': IndexSchema(
      id: 7818895549504634059,
      name: r'subtaskId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'subtaskId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'taskId': IndexSchema(
      id: -6391211041487498726,
      name: r'taskId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'completed': IndexSchema(
      id: -1755850151728404861,
      name: r'completed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completed',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarSubtaskGetId,
  getLinks: _isarSubtaskGetLinks,
  attach: _isarSubtaskAttach,
  version: '3.1.0+1',
);

int _isarSubtaskEstimateSize(
  IsarSubtask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.subtaskId.length * 3;
  bytesCount += 3 + object.taskId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _isarSubtaskSerialize(
  IsarSubtask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.subtaskId);
  writer.writeString(offsets[4], object.taskId);
  writer.writeString(offsets[5], object.title);
  writer.writeDateTime(offsets[6], object.updatedAt);
}

IsarSubtask _isarSubtaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarSubtask();
  object.completed = reader.readBool(offsets[0]);
  object.completedAt = reader.readDateTimeOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.subtaskId = reader.readString(offsets[3]);
  object.taskId = reader.readString(offsets[4]);
  object.title = reader.readString(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  return object;
}

P _isarSubtaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarSubtaskGetId(IsarSubtask object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarSubtaskGetLinks(IsarSubtask object) {
  return [];
}

void _isarSubtaskAttach(
    IsarCollection<dynamic> col, Id id, IsarSubtask object) {
  object.id = id;
}

extension IsarSubtaskQueryWhereSort
    on QueryBuilder<IsarSubtask, IsarSubtask, QWhere> {
  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhere> anyCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completed'),
      );
    });
  }
}

extension IsarSubtaskQueryWhere
    on QueryBuilder<IsarSubtask, IsarSubtask, QWhereClause> {
  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> subtaskIdEqualTo(
      String subtaskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'subtaskId',
        value: [subtaskId],
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> subtaskIdNotEqualTo(
      String subtaskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'subtaskId',
              lower: [],
              upper: [subtaskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'subtaskId',
              lower: [subtaskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'subtaskId',
              lower: [subtaskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'subtaskId',
              lower: [],
              upper: [subtaskId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> taskIdEqualTo(
      String taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId',
        value: [taskId],
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> taskIdNotEqualTo(
      String taskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> completedEqualTo(
      bool completed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completed',
        value: [completed],
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterWhereClause> completedNotEqualTo(
      bool completed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarSubtaskQueryFilter
    on QueryBuilder<IsarSubtask, IsarSubtask, QFilterCondition> {
  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtaskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subtaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subtaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subtaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subtaskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      subtaskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subtaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> taskIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      taskIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> taskIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> taskIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      taskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> taskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> taskIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> taskIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      taskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      taskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarSubtaskQueryObject
    on QueryBuilder<IsarSubtask, IsarSubtask, QFilterCondition> {}

extension IsarSubtaskQueryLinks
    on QueryBuilder<IsarSubtask, IsarSubtask, QFilterCondition> {}

extension IsarSubtaskQuerySortBy
    on QueryBuilder<IsarSubtask, IsarSubtask, QSortBy> {
  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortBySubtaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtaskId', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortBySubtaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtaskId', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarSubtaskQuerySortThenBy
    on QueryBuilder<IsarSubtask, IsarSubtask, QSortThenBy> {
  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenBySubtaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtaskId', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenBySubtaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtaskId', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarSubtaskQueryWhereDistinct
    on QueryBuilder<IsarSubtask, IsarSubtask, QDistinct> {
  QueryBuilder<IsarSubtask, IsarSubtask, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QDistinct> distinctBySubtaskId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtaskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QDistinct> distinctByTaskId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSubtask, IsarSubtask, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarSubtaskQueryProperty
    on QueryBuilder<IsarSubtask, IsarSubtask, QQueryProperty> {
  QueryBuilder<IsarSubtask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarSubtask, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<IsarSubtask, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<IsarSubtask, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarSubtask, String, QQueryOperations> subtaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtaskId');
    });
  }

  QueryBuilder<IsarSubtask, String, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<IsarSubtask, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<IsarSubtask, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarEventCollection on Isar {
  IsarCollection<IsarEvent> get isarEvents => this.collection();
}

const IsarEventSchema = CollectionSchema(
  name: r'IsarEvent',
  id: 5962100766301502855,
  properties: {
    r'color': PropertySchema(
      id: 0,
      name: r'color',
      type: IsarType.string,
    ),
    r'comments': PropertySchema(
      id: 1,
      name: r'comments',
      type: IsarType.string,
    ),
    r'completed': PropertySchema(
      id: 2,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'completedAt': PropertySchema(
      id: 3,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customCategory': PropertySchema(
      id: 5,
      name: r'customCategory',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 6,
      name: r'description',
      type: IsarType.string,
    ),
    r'endDateTime': PropertySchema(
      id: 7,
      name: r'endDateTime',
      type: IsarType.dateTime,
    ),
    r'eventId': PropertySchema(
      id: 8,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'isRecurring': PropertySchema(
      id: 9,
      name: r'isRecurring',
      type: IsarType.bool,
    ),
    r'parentEventId': PropertySchema(
      id: 10,
      name: r'parentEventId',
      type: IsarType.string,
    ),
    r'recurrenceCount': PropertySchema(
      id: 11,
      name: r'recurrenceCount',
      type: IsarType.long,
    ),
    r'recurrenceEndDate': PropertySchema(
      id: 12,
      name: r'recurrenceEndDate',
      type: IsarType.dateTime,
    ),
    r'recurrenceExceptionDates': PropertySchema(
      id: 13,
      name: r'recurrenceExceptionDates',
      type: IsarType.string,
    ),
    r'recurrenceRule': PropertySchema(
      id: 14,
      name: r'recurrenceRule',
      type: IsarType.string,
    ),
    r'reminderEnabled': PropertySchema(
      id: 15,
      name: r'reminderEnabled',
      type: IsarType.bool,
    ),
    r'reminderPreset': PropertySchema(
      id: 16,
      name: r'reminderPreset',
      type: IsarType.string,
    ),
    r'reminderTime': PropertySchema(
      id: 17,
      name: r'reminderTime',
      type: IsarType.dateTime,
    ),
    r'startDateTime': PropertySchema(
      id: 18,
      name: r'startDateTime',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 19,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 20,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarEventEstimateSize,
  serialize: _isarEventSerialize,
  deserialize: _isarEventDeserialize,
  deserializeProp: _isarEventDeserializeProp,
  idName: r'id',
  indexes: {
    r'eventId': IndexSchema(
      id: -2707901133518603130,
      name: r'eventId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'eventId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'completed': IndexSchema(
      id: -1755850151728404861,
      name: r'completed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completed',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isRecurring': IndexSchema(
      id: 1211429805563284888,
      name: r'isRecurring',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isRecurring',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'parentEventId': IndexSchema(
      id: 376097465822909102,
      name: r'parentEventId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parentEventId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarEventGetId,
  getLinks: _isarEventGetLinks,
  attach: _isarEventAttach,
  version: '3.1.0+1',
);

int _isarEventEstimateSize(
  IsarEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.color;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.comments;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customCategory;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.eventId.length * 3;
  {
    final value = object.parentEventId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recurrenceExceptionDates;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recurrenceRule;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reminderPreset;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _isarEventSerialize(
  IsarEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.color);
  writer.writeString(offsets[1], object.comments);
  writer.writeBool(offsets[2], object.completed);
  writer.writeDateTime(offsets[3], object.completedAt);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.customCategory);
  writer.writeString(offsets[6], object.description);
  writer.writeDateTime(offsets[7], object.endDateTime);
  writer.writeString(offsets[8], object.eventId);
  writer.writeBool(offsets[9], object.isRecurring);
  writer.writeString(offsets[10], object.parentEventId);
  writer.writeLong(offsets[11], object.recurrenceCount);
  writer.writeDateTime(offsets[12], object.recurrenceEndDate);
  writer.writeString(offsets[13], object.recurrenceExceptionDates);
  writer.writeString(offsets[14], object.recurrenceRule);
  writer.writeBool(offsets[15], object.reminderEnabled);
  writer.writeString(offsets[16], object.reminderPreset);
  writer.writeDateTime(offsets[17], object.reminderTime);
  writer.writeDateTime(offsets[18], object.startDateTime);
  writer.writeString(offsets[19], object.title);
  writer.writeDateTime(offsets[20], object.updatedAt);
}

IsarEvent _isarEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarEvent();
  object.color = reader.readStringOrNull(offsets[0]);
  object.comments = reader.readStringOrNull(offsets[1]);
  object.completed = reader.readBool(offsets[2]);
  object.completedAt = reader.readDateTimeOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.customCategory = reader.readStringOrNull(offsets[5]);
  object.description = reader.readStringOrNull(offsets[6]);
  object.endDateTime = reader.readDateTimeOrNull(offsets[7]);
  object.eventId = reader.readString(offsets[8]);
  object.id = id;
  object.isRecurring = reader.readBool(offsets[9]);
  object.parentEventId = reader.readStringOrNull(offsets[10]);
  object.recurrenceCount = reader.readLongOrNull(offsets[11]);
  object.recurrenceEndDate = reader.readDateTimeOrNull(offsets[12]);
  object.recurrenceExceptionDates = reader.readStringOrNull(offsets[13]);
  object.recurrenceRule = reader.readStringOrNull(offsets[14]);
  object.reminderEnabled = reader.readBool(offsets[15]);
  object.reminderPreset = reader.readStringOrNull(offsets[16]);
  object.reminderTime = reader.readDateTimeOrNull(offsets[17]);
  object.startDateTime = reader.readDateTimeOrNull(offsets[18]);
  object.title = reader.readString(offsets[19]);
  object.updatedAt = reader.readDateTime(offsets[20]);
  return object;
}

P _isarEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarEventGetId(IsarEvent object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarEventGetLinks(IsarEvent object) {
  return [];
}

void _isarEventAttach(IsarCollection<dynamic> col, Id id, IsarEvent object) {
  object.id = id;
}

extension IsarEventQueryWhereSort
    on QueryBuilder<IsarEvent, IsarEvent, QWhere> {
  QueryBuilder<IsarEvent, IsarEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhere> anyCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completed'),
      );
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhere> anyIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isRecurring'),
      );
    });
  }
}

extension IsarEventQueryWhere
    on QueryBuilder<IsarEvent, IsarEvent, QWhereClause> {
  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> eventIdEqualTo(
      String eventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventId',
        value: [eventId],
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> eventIdNotEqualTo(
      String eventId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> completedEqualTo(
      bool completed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completed',
        value: [completed],
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> completedNotEqualTo(
      bool completed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> isRecurringEqualTo(
      bool isRecurring) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isRecurring',
        value: [isRecurring],
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> isRecurringNotEqualTo(
      bool isRecurring) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [],
              upper: [isRecurring],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [isRecurring],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [isRecurring],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [],
              upper: [isRecurring],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> parentEventIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentEventId',
        value: [null],
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause>
      parentEventIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentEventId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> parentEventIdEqualTo(
      String? parentEventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentEventId',
        value: [parentEventId],
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterWhereClause> parentEventIdNotEqualTo(
      String? parentEventId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentEventId',
              lower: [],
              upper: [parentEventId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentEventId',
              lower: [parentEventId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentEventId',
              lower: [parentEventId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentEventId',
              lower: [],
              upper: [parentEventId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarEventQueryFilter
    on QueryBuilder<IsarEvent, IsarEvent, QFilterCondition> {
  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'comments',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      commentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'comments',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'comments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'comments',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> commentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comments',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      commentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'comments',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> completedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> completedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customCategory',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customCategory',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customCategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customCategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      customCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      endDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDateTime',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      endDateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDateTime',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> endDateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      endDateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> endDateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> endDateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> isRecurringEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRecurring',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentEventId',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentEventId',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentEventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentEventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentEventId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      parentEventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentEventId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceCount',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceCount',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceEndDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceEndDate',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceEndDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceEndDate',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceEndDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceEndDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceEndDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceEndDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceEndDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceExceptionDates',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceExceptionDates',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceExceptionDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recurrenceExceptionDates',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceExceptionDates',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceExceptionDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recurrenceExceptionDates',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceRule',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceRule',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceRule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recurrenceRule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceRule',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      recurrenceRuleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recurrenceRule',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reminderPreset',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reminderPreset',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderPreset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reminderPreset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reminderPreset',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderPreset',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderPresetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reminderPreset',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reminderTime',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reminderTime',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> reminderTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      reminderTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> reminderTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      startDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startDateTime',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      startDateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startDateTime',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      startDateTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      startDateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      startDateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      startDateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarEventQueryObject
    on QueryBuilder<IsarEvent, IsarEvent, QFilterCondition> {}

extension IsarEventQueryLinks
    on QueryBuilder<IsarEvent, IsarEvent, QFilterCondition> {}

extension IsarEventQuerySortBy on QueryBuilder<IsarEvent, IsarEvent, QSortBy> {
  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCommentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCustomCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByCustomCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByEndDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateTime', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByEndDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateTime', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByParentEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentEventId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByParentEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentEventId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByRecurrenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceCount', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByRecurrenceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceCount', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy>
      sortByRecurrenceEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy>
      sortByRecurrenceExceptionDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceExceptionDates', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy>
      sortByRecurrenceExceptionDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceExceptionDates', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByRecurrenceRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByRecurrenceRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByReminderPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderPreset', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByReminderPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderPreset', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByStartDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateTime', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByStartDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateTime', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarEventQuerySortThenBy
    on QueryBuilder<IsarEvent, IsarEvent, QSortThenBy> {
  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCommentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCustomCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByCustomCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByEndDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateTime', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByEndDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateTime', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByParentEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentEventId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByParentEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentEventId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByRecurrenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceCount', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByRecurrenceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceCount', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy>
      thenByRecurrenceEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy>
      thenByRecurrenceExceptionDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceExceptionDates', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy>
      thenByRecurrenceExceptionDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceExceptionDates', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByRecurrenceRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByRecurrenceRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByReminderPreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderPreset', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByReminderPresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderPreset', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByStartDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateTime', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByStartDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateTime', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarEventQueryWhereDistinct
    on QueryBuilder<IsarEvent, IsarEvent, QDistinct> {
  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByComments(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comments', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByCustomCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customCategory',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByEndDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDateTime');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRecurring');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByParentEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentEventId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByRecurrenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceCount');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceEndDate');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct>
      distinctByRecurrenceExceptionDates({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceExceptionDates',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByRecurrenceRule(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceRule',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderEnabled');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByReminderPreset(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderPreset',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderTime');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByStartDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDateTime');
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvent, IsarEvent, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarEventQueryProperty
    on QueryBuilder<IsarEvent, IsarEvent, QQueryProperty> {
  QueryBuilder<IsarEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarEvent, String?, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<IsarEvent, String?, QQueryOperations> commentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comments');
    });
  }

  QueryBuilder<IsarEvent, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<IsarEvent, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<IsarEvent, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarEvent, String?, QQueryOperations> customCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customCategory');
    });
  }

  QueryBuilder<IsarEvent, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<IsarEvent, DateTime?, QQueryOperations> endDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDateTime');
    });
  }

  QueryBuilder<IsarEvent, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<IsarEvent, bool, QQueryOperations> isRecurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRecurring');
    });
  }

  QueryBuilder<IsarEvent, String?, QQueryOperations> parentEventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentEventId');
    });
  }

  QueryBuilder<IsarEvent, int?, QQueryOperations> recurrenceCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceCount');
    });
  }

  QueryBuilder<IsarEvent, DateTime?, QQueryOperations>
      recurrenceEndDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceEndDate');
    });
  }

  QueryBuilder<IsarEvent, String?, QQueryOperations>
      recurrenceExceptionDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceExceptionDates');
    });
  }

  QueryBuilder<IsarEvent, String?, QQueryOperations> recurrenceRuleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceRule');
    });
  }

  QueryBuilder<IsarEvent, bool, QQueryOperations> reminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderEnabled');
    });
  }

  QueryBuilder<IsarEvent, String?, QQueryOperations> reminderPresetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderPreset');
    });
  }

  QueryBuilder<IsarEvent, DateTime?, QQueryOperations> reminderTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderTime');
    });
  }

  QueryBuilder<IsarEvent, DateTime?, QQueryOperations> startDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDateTime');
    });
  }

  QueryBuilder<IsarEvent, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<IsarEvent, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarReminderCollection on Isar {
  IsarCollection<IsarReminder> get isarReminders => this.collection();
}

const IsarReminderSchema = CollectionSchema(
  name: r'IsarReminder',
  id: -9071037972073274484,
  properties: {
    r'body': PropertySchema(
      id: 0,
      name: r'body',
      type: IsarType.string,
    ),
    r'completed': PropertySchema(
      id: 1,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'completedAt': PropertySchema(
      id: 2,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isRecurring': PropertySchema(
      id: 4,
      name: r'isRecurring',
      type: IsarType.bool,
    ),
    r'notificationId': PropertySchema(
      id: 5,
      name: r'notificationId',
      type: IsarType.string,
    ),
    r'parentReminderId': PropertySchema(
      id: 6,
      name: r'parentReminderId',
      type: IsarType.string,
    ),
    r'recurrenceCount': PropertySchema(
      id: 7,
      name: r'recurrenceCount',
      type: IsarType.long,
    ),
    r'recurrenceEndDate': PropertySchema(
      id: 8,
      name: r'recurrenceEndDate',
      type: IsarType.dateTime,
    ),
    r'recurrenceExceptionDates': PropertySchema(
      id: 9,
      name: r'recurrenceExceptionDates',
      type: IsarType.string,
    ),
    r'recurrenceRule': PropertySchema(
      id: 10,
      name: r'recurrenceRule',
      type: IsarType.string,
    ),
    r'reminderId': PropertySchema(
      id: 11,
      name: r'reminderId',
      type: IsarType.string,
    ),
    r'scheduledTime': PropertySchema(
      id: 12,
      name: r'scheduledTime',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 13,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarReminderEstimateSize,
  serialize: _isarReminderSerialize,
  deserialize: _isarReminderDeserialize,
  deserializeProp: _isarReminderDeserializeProp,
  idName: r'id',
  indexes: {
    r'reminderId': IndexSchema(
      id: 3675930301236523255,
      name: r'reminderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reminderId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'completed': IndexSchema(
      id: -1755850151728404861,
      name: r'completed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completed',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isRecurring': IndexSchema(
      id: 1211429805563284888,
      name: r'isRecurring',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isRecurring',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'parentReminderId': IndexSchema(
      id: -7640807198321443062,
      name: r'parentReminderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parentReminderId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarReminderGetId,
  getLinks: _isarReminderGetLinks,
  attach: _isarReminderAttach,
  version: '3.1.0+1',
);

int _isarReminderEstimateSize(
  IsarReminder object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.body.length * 3;
  bytesCount += 3 + object.notificationId.length * 3;
  {
    final value = object.parentReminderId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recurrenceExceptionDates;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recurrenceRule;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.reminderId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _isarReminderSerialize(
  IsarReminder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.body);
  writer.writeBool(offsets[1], object.completed);
  writer.writeDateTime(offsets[2], object.completedAt);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeBool(offsets[4], object.isRecurring);
  writer.writeString(offsets[5], object.notificationId);
  writer.writeString(offsets[6], object.parentReminderId);
  writer.writeLong(offsets[7], object.recurrenceCount);
  writer.writeDateTime(offsets[8], object.recurrenceEndDate);
  writer.writeString(offsets[9], object.recurrenceExceptionDates);
  writer.writeString(offsets[10], object.recurrenceRule);
  writer.writeString(offsets[11], object.reminderId);
  writer.writeDateTime(offsets[12], object.scheduledTime);
  writer.writeString(offsets[13], object.title);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

IsarReminder _isarReminderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarReminder();
  object.body = reader.readString(offsets[0]);
  object.completed = reader.readBool(offsets[1]);
  object.completedAt = reader.readDateTimeOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.isRecurring = reader.readBool(offsets[4]);
  object.notificationId = reader.readString(offsets[5]);
  object.parentReminderId = reader.readStringOrNull(offsets[6]);
  object.recurrenceCount = reader.readLongOrNull(offsets[7]);
  object.recurrenceEndDate = reader.readDateTimeOrNull(offsets[8]);
  object.recurrenceExceptionDates = reader.readStringOrNull(offsets[9]);
  object.recurrenceRule = reader.readStringOrNull(offsets[10]);
  object.reminderId = reader.readString(offsets[11]);
  object.scheduledTime = reader.readDateTimeOrNull(offsets[12]);
  object.title = reader.readString(offsets[13]);
  object.updatedAt = reader.readDateTime(offsets[14]);
  return object;
}

P _isarReminderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarReminderGetId(IsarReminder object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarReminderGetLinks(IsarReminder object) {
  return [];
}

void _isarReminderAttach(
    IsarCollection<dynamic> col, Id id, IsarReminder object) {
  object.id = id;
}

extension IsarReminderQueryWhereSort
    on QueryBuilder<IsarReminder, IsarReminder, QWhere> {
  QueryBuilder<IsarReminder, IsarReminder, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhere> anyCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completed'),
      );
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhere> anyIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isRecurring'),
      );
    });
  }
}

extension IsarReminderQueryWhere
    on QueryBuilder<IsarReminder, IsarReminder, QWhereClause> {
  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause> reminderIdEqualTo(
      String reminderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reminderId',
        value: [reminderId],
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause>
      reminderIdNotEqualTo(String reminderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [],
              upper: [reminderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [reminderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [reminderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderId',
              lower: [],
              upper: [reminderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause> completedEqualTo(
      bool completed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completed',
        value: [completed],
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause>
      completedNotEqualTo(bool completed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause>
      isRecurringEqualTo(bool isRecurring) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isRecurring',
        value: [isRecurring],
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause>
      isRecurringNotEqualTo(bool isRecurring) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [],
              upper: [isRecurring],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [isRecurring],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [isRecurring],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isRecurring',
              lower: [],
              upper: [isRecurring],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause>
      parentReminderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentReminderId',
        value: [null],
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause>
      parentReminderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentReminderId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause>
      parentReminderIdEqualTo(String? parentReminderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentReminderId',
        value: [parentReminderId],
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterWhereClause>
      parentReminderIdNotEqualTo(String? parentReminderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentReminderId',
              lower: [],
              upper: [parentReminderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentReminderId',
              lower: [parentReminderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentReminderId',
              lower: [parentReminderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentReminderId',
              lower: [],
              upper: [parentReminderId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarReminderQueryFilter
    on QueryBuilder<IsarReminder, IsarReminder, QFilterCondition> {
  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> bodyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      bodyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> bodyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> bodyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'body',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> bodyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> bodyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'body',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      isRecurringEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRecurring',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notificationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      notificationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notificationId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentReminderId',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentReminderId',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentReminderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentReminderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentReminderId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      parentReminderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentReminderId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceCount',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceCount',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceEndDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceEndDate',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceEndDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceEndDate',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceEndDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceEndDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceEndDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceEndDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceEndDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceExceptionDates',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceExceptionDates',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceExceptionDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recurrenceExceptionDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recurrenceExceptionDates',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceExceptionDates',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceExceptionDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recurrenceExceptionDates',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrenceRule',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrenceRule',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrenceRule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recurrenceRule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recurrenceRule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrenceRule',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      recurrenceRuleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recurrenceRule',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reminderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      reminderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reminderId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      scheduledTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduledTime',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      scheduledTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduledTime',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      scheduledTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      scheduledTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      scheduledTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      scheduledTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarReminderQueryObject
    on QueryBuilder<IsarReminder, IsarReminder, QFilterCondition> {}

extension IsarReminderQueryLinks
    on QueryBuilder<IsarReminder, IsarReminder, QFilterCondition> {}

extension IsarReminderQuerySortBy
    on QueryBuilder<IsarReminder, IsarReminder, QSortBy> {
  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByParentReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentReminderId', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByParentReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentReminderId', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByRecurrenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceCount', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByRecurrenceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceCount', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByRecurrenceEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByRecurrenceExceptionDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceExceptionDates', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByRecurrenceExceptionDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceExceptionDates', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByRecurrenceRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByRecurrenceRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      sortByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarReminderQuerySortThenBy
    on QueryBuilder<IsarReminder, IsarReminder, QSortThenBy> {
  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByParentReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentReminderId', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByParentReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentReminderId', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByRecurrenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceCount', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByRecurrenceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceCount', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByRecurrenceEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceEndDate', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByRecurrenceExceptionDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceExceptionDates', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByRecurrenceExceptionDatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceExceptionDates', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByRecurrenceRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByRecurrenceRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrenceRule', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderId', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy>
      thenByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarReminderQueryWhereDistinct
    on QueryBuilder<IsarReminder, IsarReminder, QDistinct> {
  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByBody(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRecurring');
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByNotificationId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct>
      distinctByParentReminderId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentReminderId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct>
      distinctByRecurrenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceCount');
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct>
      distinctByRecurrenceEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceEndDate');
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct>
      distinctByRecurrenceExceptionDates({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceExceptionDates',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByRecurrenceRule(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrenceRule',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByReminderId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct>
      distinctByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledTime');
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReminder, IsarReminder, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarReminderQueryProperty
    on QueryBuilder<IsarReminder, IsarReminder, QQueryProperty> {
  QueryBuilder<IsarReminder, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarReminder, String, QQueryOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<IsarReminder, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<IsarReminder, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<IsarReminder, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarReminder, bool, QQueryOperations> isRecurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRecurring');
    });
  }

  QueryBuilder<IsarReminder, String, QQueryOperations>
      notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationId');
    });
  }

  QueryBuilder<IsarReminder, String?, QQueryOperations>
      parentReminderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentReminderId');
    });
  }

  QueryBuilder<IsarReminder, int?, QQueryOperations> recurrenceCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceCount');
    });
  }

  QueryBuilder<IsarReminder, DateTime?, QQueryOperations>
      recurrenceEndDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceEndDate');
    });
  }

  QueryBuilder<IsarReminder, String?, QQueryOperations>
      recurrenceExceptionDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceExceptionDates');
    });
  }

  QueryBuilder<IsarReminder, String?, QQueryOperations>
      recurrenceRuleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrenceRule');
    });
  }

  QueryBuilder<IsarReminder, String, QQueryOperations> reminderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderId');
    });
  }

  QueryBuilder<IsarReminder, DateTime?, QQueryOperations>
      scheduledTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTime');
    });
  }

  QueryBuilder<IsarReminder, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<IsarReminder, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarNoteCollection on Isar {
  IsarCollection<IsarNote> get isarNotes => this.collection();
}

const IsarNoteSchema = CollectionSchema(
  name: r'IsarNote',
  id: -6588628299822617142,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 1,
      name: r'color',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 2,
      name: r'content',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isPinned': PropertySchema(
      id: 4,
      name: r'isPinned',
      type: IsarType.bool,
    ),
    r'noteId': PropertySchema(
      id: 5,
      name: r'noteId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarNoteEstimateSize,
  serialize: _isarNoteSerialize,
  deserialize: _isarNoteDeserialize,
  deserializeProp: _isarNoteDeserializeProp,
  idName: r'id',
  indexes: {
    r'noteId': IndexSchema(
      id: -9014133502494436840,
      name: r'noteId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'noteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'isPinned': IndexSchema(
      id: 7607338673446676027,
      name: r'isPinned',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isPinned',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarNoteGetId,
  getLinks: _isarNoteGetLinks,
  attach: _isarNoteAttach,
  version: '3.1.0+1',
);

int _isarNoteEstimateSize(
  IsarNote object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.color.length * 3;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.noteId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _isarNoteSerialize(
  IsarNote object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeString(offsets[1], object.color);
  writer.writeString(offsets[2], object.content);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeBool(offsets[4], object.isPinned);
  writer.writeString(offsets[5], object.noteId);
  writer.writeString(offsets[6], object.title);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

IsarNote _isarNoteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarNote();
  object.category = reader.readStringOrNull(offsets[0]);
  object.color = reader.readString(offsets[1]);
  object.content = reader.readString(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.isPinned = reader.readBool(offsets[4]);
  object.noteId = reader.readString(offsets[5]);
  object.title = reader.readString(offsets[6]);
  object.updatedAt = reader.readDateTime(offsets[7]);
  return object;
}

P _isarNoteDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarNoteGetId(IsarNote object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarNoteGetLinks(IsarNote object) {
  return [];
}

void _isarNoteAttach(IsarCollection<dynamic> col, Id id, IsarNote object) {
  object.id = id;
}

extension IsarNoteQueryWhereSort on QueryBuilder<IsarNote, IsarNote, QWhere> {
  QueryBuilder<IsarNote, IsarNote, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhere> anyIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isPinned'),
      );
    });
  }
}

extension IsarNoteQueryWhere on QueryBuilder<IsarNote, IsarNote, QWhereClause> {
  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> noteIdEqualTo(
      String noteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'noteId',
        value: [noteId],
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> noteIdNotEqualTo(
      String noteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [],
              upper: [noteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [noteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [noteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [],
              upper: [noteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> isPinnedEqualTo(
      bool isPinned) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isPinned',
        value: [isPinned],
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> isPinnedNotEqualTo(
      bool isPinned) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isPinned',
              lower: [],
              upper: [isPinned],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isPinned',
              lower: [isPinned],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isPinned',
              lower: [isPinned],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isPinned',
              lower: [],
              upper: [isPinned],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarNoteQueryFilter
    on QueryBuilder<IsarNote, IsarNote, QFilterCondition> {
  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> isPinnedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinned',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> noteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarNoteQueryObject
    on QueryBuilder<IsarNote, IsarNote, QFilterCondition> {}

extension IsarNoteQueryLinks
    on QueryBuilder<IsarNote, IsarNote, QFilterCondition> {}

extension IsarNoteQuerySortBy on QueryBuilder<IsarNote, IsarNote, QSortBy> {
  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarNoteQuerySortThenBy
    on QueryBuilder<IsarNote, IsarNote, QSortThenBy> {
  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarNoteQueryWhereDistinct
    on QueryBuilder<IsarNote, IsarNote, QDistinct> {
  QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByNoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarNoteQueryProperty
    on QueryBuilder<IsarNote, IsarNote, QQueryProperty> {
  QueryBuilder<IsarNote, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarNote, String?, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<IsarNote, String, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<IsarNote, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<IsarNote, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarNote, bool, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<IsarNote, String, QQueryOperations> noteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteId');
    });
  }

  QueryBuilder<IsarNote, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<IsarNote, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarEnergyEntryCollection on Isar {
  IsarCollection<IsarEnergyEntry> get isarEnergyEntrys => this.collection();
}

const IsarEnergyEntrySchema = CollectionSchema(
  name: r'IsarEnergyEntry',
  id: -6463371732450004644,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'energyLevel': PropertySchema(
      id: 1,
      name: r'energyLevel',
      type: IsarType.long,
    ),
    r'entryId': PropertySchema(
      id: 2,
      name: r'entryId',
      type: IsarType.string,
    ),
    r'location': PropertySchema(
      id: 3,
      name: r'location',
      type: IsarType.string,
    ),
    r'moodTags': PropertySchema(
      id: 4,
      name: r'moodTags',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'privacyContext': PropertySchema(
      id: 6,
      name: r'privacyContext',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 7,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 9,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarEnergyEntryEstimateSize,
  serialize: _isarEnergyEntrySerialize,
  deserialize: _isarEnergyEntryDeserialize,
  deserializeProp: _isarEnergyEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'entryId': IndexSchema(
      id: 3733379884318738402,
      name: r'entryId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entryId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarEnergyEntryGetId,
  getLinks: _isarEnergyEntryGetLinks,
  attach: _isarEnergyEntryAttach,
  version: '3.1.0+1',
);

int _isarEnergyEntryEstimateSize(
  IsarEnergyEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.entryId.length * 3;
  {
    final value = object.location;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.moodTags;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.privacyContext;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarEnergyEntrySerialize(
  IsarEnergyEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.energyLevel);
  writer.writeString(offsets[2], object.entryId);
  writer.writeString(offsets[3], object.location);
  writer.writeString(offsets[4], object.moodTags);
  writer.writeString(offsets[5], object.notes);
  writer.writeString(offsets[6], object.privacyContext);
  writer.writeDateTime(offsets[7], object.timestamp);
  writer.writeDateTime(offsets[8], object.updatedAt);
  writer.writeString(offsets[9], object.userId);
}

IsarEnergyEntry _isarEnergyEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarEnergyEntry();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.energyLevel = reader.readLong(offsets[1]);
  object.entryId = reader.readString(offsets[2]);
  object.id = id;
  object.location = reader.readStringOrNull(offsets[3]);
  object.moodTags = reader.readStringOrNull(offsets[4]);
  object.notes = reader.readStringOrNull(offsets[5]);
  object.privacyContext = reader.readStringOrNull(offsets[6]);
  object.timestamp = reader.readDateTime(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  object.userId = reader.readStringOrNull(offsets[9]);
  return object;
}

P _isarEnergyEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarEnergyEntryGetId(IsarEnergyEntry object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarEnergyEntryGetLinks(IsarEnergyEntry object) {
  return [];
}

void _isarEnergyEntryAttach(
    IsarCollection<dynamic> col, Id id, IsarEnergyEntry object) {
  object.id = id;
}

extension IsarEnergyEntryQueryWhereSort
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QWhere> {
  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension IsarEnergyEntryQueryWhere
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QWhereClause> {
  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      entryIdEqualTo(String entryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entryId',
        value: [entryId],
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      entryIdNotEqualTo(String entryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entryId',
              lower: [],
              upper: [entryId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entryId',
              lower: [entryId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entryId',
              lower: [entryId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entryId',
              lower: [],
              upper: [entryId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      timestampEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      timestampNotEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      timestampGreaterThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      timestampLessThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterWhereClause>
      timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarEnergyEntryQueryFilter
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QFilterCondition> {
  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      energyLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      energyLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      energyLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      energyLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energyLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      entryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entryId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'location',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'location',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'location',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moodTags',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moodTags',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moodTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodTags',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      moodTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moodTags',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'privacyContext',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'privacyContext',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'privacyContext',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'privacyContext',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privacyContext',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      privacyContextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'privacyContext',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension IsarEnergyEntryQueryObject
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QFilterCondition> {}

extension IsarEnergyEntryQueryLinks
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QFilterCondition> {}

extension IsarEnergyEntryQuerySortBy
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QSortBy> {
  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByEnergyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy> sortByEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByMoodTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTags', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByMoodTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTags', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByPrivacyContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyContext', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByPrivacyContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyContext', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension IsarEnergyEntryQuerySortThenBy
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QSortThenBy> {
  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByEnergyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy> thenByEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByMoodTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTags', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByMoodTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTags', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByPrivacyContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyContext', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByPrivacyContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyContext', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension IsarEnergyEntryQueryWhereDistinct
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct> {
  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct>
      distinctByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energyLevel');
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct> distinctByEntryId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct> distinctByLocation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct> distinctByMoodTags(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodTags', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct>
      distinctByPrivacyContext({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'privacyContext',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarEnergyEntryQueryProperty
    on QueryBuilder<IsarEnergyEntry, IsarEnergyEntry, QQueryProperty> {
  QueryBuilder<IsarEnergyEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarEnergyEntry, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarEnergyEntry, int, QQueryOperations> energyLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyLevel');
    });
  }

  QueryBuilder<IsarEnergyEntry, String, QQueryOperations> entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryId');
    });
  }

  QueryBuilder<IsarEnergyEntry, String?, QQueryOperations> locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<IsarEnergyEntry, String?, QQueryOperations> moodTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodTags');
    });
  }

  QueryBuilder<IsarEnergyEntry, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<IsarEnergyEntry, String?, QQueryOperations>
      privacyContextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'privacyContext');
    });
  }

  QueryBuilder<IsarEnergyEntry, DateTime, QQueryOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<IsarEnergyEntry, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<IsarEnergyEntry, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarCompletionLogCollection on Isar {
  IsarCollection<IsarCompletionLog> get isarCompletionLogs => this.collection();
}

const IsarCompletionLogSchema = CollectionSchema(
  name: r'IsarCompletionLog',
  id: -8429320206322375764,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'energyLevel': PropertySchema(
      id: 4,
      name: r'energyLevel',
      type: IsarType.long,
    ),
    r'isSubtask': PropertySchema(
      id: 5,
      name: r'isSubtask',
      type: IsarType.bool,
    ),
    r'location': PropertySchema(
      id: 6,
      name: r'location',
      type: IsarType.string,
    ),
    r'logId': PropertySchema(
      id: 7,
      name: r'logId',
      type: IsarType.string,
    ),
    r'moodTags': PropertySchema(
      id: 8,
      name: r'moodTags',
      type: IsarType.string,
    ),
    r'parentTaskTitle': PropertySchema(
      id: 9,
      name: r'parentTaskTitle',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 10,
      name: r'priority',
      type: IsarType.string,
    ),
    r'privacyContext': PropertySchema(
      id: 11,
      name: r'privacyContext',
      type: IsarType.string,
    ),
    r'taskId': PropertySchema(
      id: 12,
      name: r'taskId',
      type: IsarType.string,
    ),
    r'taskTitle': PropertySchema(
      id: 13,
      name: r'taskTitle',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarCompletionLogEstimateSize,
  serialize: _isarCompletionLogSerialize,
  deserialize: _isarCompletionLogDeserialize,
  deserializeProp: _isarCompletionLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'logId': IndexSchema(
      id: 3089637606214822530,
      name: r'logId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'logId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'completedAt': IndexSchema(
      id: -3156591011457686752,
      name: r'completedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isSubtask': IndexSchema(
      id: -3720960203244867673,
      name: r'isSubtask',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSubtask',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarCompletionLogGetId,
  getLinks: _isarCompletionLogGetLinks,
  attach: _isarCompletionLogAttach,
  version: '3.1.0+1',
);

int _isarCompletionLogEstimateSize(
  IsarCompletionLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.location;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.logId.length * 3;
  {
    final value = object.moodTags;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.parentTaskTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.priority;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.privacyContext;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.taskId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.taskTitle.length * 3;
  return bytesCount;
}

void _isarCompletionLogSerialize(
  IsarCompletionLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.description);
  writer.writeLong(offsets[4], object.energyLevel);
  writer.writeBool(offsets[5], object.isSubtask);
  writer.writeString(offsets[6], object.location);
  writer.writeString(offsets[7], object.logId);
  writer.writeString(offsets[8], object.moodTags);
  writer.writeString(offsets[9], object.parentTaskTitle);
  writer.writeString(offsets[10], object.priority);
  writer.writeString(offsets[11], object.privacyContext);
  writer.writeString(offsets[12], object.taskId);
  writer.writeString(offsets[13], object.taskTitle);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

IsarCompletionLog _isarCompletionLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarCompletionLog();
  object.category = reader.readStringOrNull(offsets[0]);
  object.completedAt = reader.readDateTime(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.description = reader.readStringOrNull(offsets[3]);
  object.energyLevel = reader.readLongOrNull(offsets[4]);
  object.id = id;
  object.isSubtask = reader.readBool(offsets[5]);
  object.location = reader.readStringOrNull(offsets[6]);
  object.logId = reader.readString(offsets[7]);
  object.moodTags = reader.readStringOrNull(offsets[8]);
  object.parentTaskTitle = reader.readStringOrNull(offsets[9]);
  object.priority = reader.readStringOrNull(offsets[10]);
  object.privacyContext = reader.readStringOrNull(offsets[11]);
  object.taskId = reader.readStringOrNull(offsets[12]);
  object.taskTitle = reader.readString(offsets[13]);
  object.updatedAt = reader.readDateTime(offsets[14]);
  return object;
}

P _isarCompletionLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarCompletionLogGetId(IsarCompletionLog object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarCompletionLogGetLinks(
    IsarCompletionLog object) {
  return [];
}

void _isarCompletionLogAttach(
    IsarCollection<dynamic> col, Id id, IsarCompletionLog object) {
  object.id = id;
}

extension IsarCompletionLogQueryWhereSort
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QWhere> {
  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhere>
      anyCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completedAt'),
      );
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhere>
      anyIsSubtask() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSubtask'),
      );
    });
  }
}

extension IsarCompletionLogQueryWhere
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QWhereClause> {
  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      logIdEqualTo(String logId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'logId',
        value: [logId],
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      logIdNotEqualTo(String logId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'logId',
              lower: [],
              upper: [logId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'logId',
              lower: [logId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'logId',
              lower: [logId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'logId',
              lower: [],
              upper: [logId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      completedAtEqualTo(DateTime completedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completedAt',
        value: [completedAt],
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      completedAtNotEqualTo(DateTime completedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [],
              upper: [completedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [completedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [completedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [],
              upper: [completedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      completedAtGreaterThan(
    DateTime completedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [completedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      completedAtLessThan(
    DateTime completedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [],
        upper: [completedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      completedAtBetween(
    DateTime lowerCompletedAt,
    DateTime upperCompletedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [lowerCompletedAt],
        includeLower: includeLower,
        upper: [upperCompletedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      isSubtaskEqualTo(bool isSubtask) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSubtask',
        value: [isSubtask],
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterWhereClause>
      isSubtaskNotEqualTo(bool isSubtask) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubtask',
              lower: [],
              upper: [isSubtask],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubtask',
              lower: [isSubtask],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubtask',
              lower: [isSubtask],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSubtask',
              lower: [],
              upper: [isSubtask],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarCompletionLogQueryFilter
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QFilterCondition> {
  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      completedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      completedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      energyLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'energyLevel',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      energyLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'energyLevel',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      energyLevelEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      energyLevelGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      energyLevelLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      energyLevelBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energyLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      isSubtaskEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSubtask',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'location',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'location',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'location',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      logIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moodTags',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moodTags',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moodTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moodTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodTags',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      moodTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moodTags',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentTaskTitle',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentTaskTitle',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentTaskTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentTaskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentTaskTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTaskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      parentTaskTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentTaskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priority',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priority',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'priority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      priorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'privacyContext',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'privacyContext',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'privacyContext',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'privacyContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'privacyContext',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privacyContext',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      privacyContextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'privacyContext',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taskId',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taskId',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      taskTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarCompletionLogQueryObject
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QFilterCondition> {}

extension IsarCompletionLogQueryLinks
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QFilterCondition> {}

extension IsarCompletionLogQuerySortBy
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QSortBy> {
  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByEnergyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByIsSubtask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubtask', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByIsSubtaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubtask', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logId', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByLogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logId', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByMoodTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTags', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByMoodTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTags', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByParentTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTaskTitle', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByParentTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTaskTitle', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByPrivacyContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyContext', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByPrivacyContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyContext', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarCompletionLogQuerySortThenBy
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QSortThenBy> {
  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByEnergyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByIsSubtask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubtask', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByIsSubtaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubtask', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logId', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByLogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logId', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByMoodTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTags', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByMoodTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTags', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByParentTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTaskTitle', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByParentTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTaskTitle', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByPrivacyContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyContext', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByPrivacyContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privacyContext', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.desc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarCompletionLogQueryWhereDistinct
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct> {
  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energyLevel');
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByIsSubtask() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSubtask');
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct> distinctByLogId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByMoodTags({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodTags', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByParentTaskTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentTaskTitle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByPriority({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByPrivacyContext({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'privacyContext',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByTaskId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByTaskTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarCompletionLog, IsarCompletionLog, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarCompletionLogQueryProperty
    on QueryBuilder<IsarCompletionLog, IsarCompletionLog, QQueryProperty> {
  QueryBuilder<IsarCompletionLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarCompletionLog, String?, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<IsarCompletionLog, DateTime, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<IsarCompletionLog, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarCompletionLog, String?, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<IsarCompletionLog, int?, QQueryOperations>
      energyLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyLevel');
    });
  }

  QueryBuilder<IsarCompletionLog, bool, QQueryOperations> isSubtaskProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSubtask');
    });
  }

  QueryBuilder<IsarCompletionLog, String?, QQueryOperations>
      locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<IsarCompletionLog, String, QQueryOperations> logIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logId');
    });
  }

  QueryBuilder<IsarCompletionLog, String?, QQueryOperations>
      moodTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodTags');
    });
  }

  QueryBuilder<IsarCompletionLog, String?, QQueryOperations>
      parentTaskTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentTaskTitle');
    });
  }

  QueryBuilder<IsarCompletionLog, String?, QQueryOperations>
      priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<IsarCompletionLog, String?, QQueryOperations>
      privacyContextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'privacyContext');
    });
  }

  QueryBuilder<IsarCompletionLog, String?, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<IsarCompletionLog, String, QQueryOperations>
      taskTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskTitle');
    });
  }

  QueryBuilder<IsarCompletionLog, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

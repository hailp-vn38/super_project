// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_read.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrackReadCollection on Isar {
  IsarCollection<TrackRead> get trackReads => this.collection();
}

const TrackReadSchema = CollectionSchema(
  name: r'TrackRead',
  id: 6574406807537300432,
  properties: {
    r'bookId': PropertySchema(
      id: 0,
      name: r'bookId',
      type: IsarType.long,
    ),
    r'chapterId': PropertySchema(
      id: 1,
      name: r'chapterId',
      type: IsarType.long,
    ),
    r'currentChapterName': PropertySchema(
      id: 2,
      name: r'currentChapterName',
      type: IsarType.string,
    ),
    r'currentPage': PropertySchema(
      id: 3,
      name: r'currentPage',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 4,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'indexChapter': PropertySchema(
      id: 5,
      name: r'indexChapter',
      type: IsarType.long,
    ),
    r'lastChapterName': PropertySchema(
      id: 6,
      name: r'lastChapterName',
      type: IsarType.string,
    ),
    r'offset': PropertySchema(
      id: 7,
      name: r'offset',
      type: IsarType.double,
    ),
    r'percent': PropertySchema(
      id: 8,
      name: r'percent',
      type: IsarType.long,
    ),
    r'totalChapter': PropertySchema(
      id: 9,
      name: r'totalChapter',
      type: IsarType.long,
    ),
    r'totalPage': PropertySchema(
      id: 10,
      name: r'totalPage',
      type: IsarType.long,
    )
  },
  estimateSize: _trackReadEstimateSize,
  serialize: _trackReadSerialize,
  deserialize: _trackReadDeserialize,
  deserializeProp: _trackReadDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _trackReadGetId,
  getLinks: _trackReadGetLinks,
  attach: _trackReadAttach,
  version: '3.1.0+1',
);

int _trackReadEstimateSize(
  TrackRead object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.currentChapterName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastChapterName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _trackReadSerialize(
  TrackRead object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bookId);
  writer.writeLong(offsets[1], object.chapterId);
  writer.writeString(offsets[2], object.currentChapterName);
  writer.writeLong(offsets[3], object.currentPage);
  writer.writeLong(offsets[4], object.hashCode);
  writer.writeLong(offsets[5], object.indexChapter);
  writer.writeString(offsets[6], object.lastChapterName);
  writer.writeDouble(offsets[7], object.offset);
  writer.writeLong(offsets[8], object.percent);
  writer.writeLong(offsets[9], object.totalChapter);
  writer.writeLong(offsets[10], object.totalPage);
}

TrackRead _trackReadDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackRead(
    bookId: reader.readLongOrNull(offsets[0]),
    chapterId: reader.readLongOrNull(offsets[1]),
    currentChapterName: reader.readStringOrNull(offsets[2]),
    currentPage: reader.readLongOrNull(offsets[3]),
    id: id,
    indexChapter: reader.readLongOrNull(offsets[5]),
    lastChapterName: reader.readStringOrNull(offsets[6]),
    offset: reader.readDoubleOrNull(offsets[7]),
    percent: reader.readLongOrNull(offsets[8]),
    totalChapter: reader.readLongOrNull(offsets[9]),
    totalPage: reader.readLongOrNull(offsets[10]),
  );
  return object;
}

P _trackReadDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _trackReadGetId(TrackRead object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _trackReadGetLinks(TrackRead object) {
  return [];
}

void _trackReadAttach(IsarCollection<dynamic> col, Id id, TrackRead object) {
  object.id = id;
}

extension TrackReadQueryWhereSort
    on QueryBuilder<TrackRead, TrackRead, QWhere> {
  QueryBuilder<TrackRead, TrackRead, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrackReadQueryWhere
    on QueryBuilder<TrackRead, TrackRead, QWhereClause> {
  QueryBuilder<TrackRead, TrackRead, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TrackRead, TrackRead, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterWhereClause> idBetween(
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
}

extension TrackReadQueryFilter
    on QueryBuilder<TrackRead, TrackRead, QFilterCondition> {
  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> bookIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bookId',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> bookIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bookId',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> bookIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> bookIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> bookIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> bookIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> chapterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> chapterIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      chapterIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> chapterIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> chapterIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentChapterName',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentChapterName',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentChapterName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentChapterName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentChapterName',
        value: '',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentChapterNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentChapterName',
        value: '',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentPageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentPage',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentPageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentPage',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> currentPageEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      currentPageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> currentPageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> currentPageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      indexChapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'indexChapter',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      indexChapterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'indexChapter',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> indexChapterEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'indexChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      indexChapterGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'indexChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      indexChapterLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'indexChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> indexChapterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'indexChapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastChapterName',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastChapterName',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastChapterName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastChapterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastChapterName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastChapterName',
        value: '',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      lastChapterNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastChapterName',
        value: '',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> offsetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'offset',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> offsetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'offset',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> offsetEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offset',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> offsetGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offset',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> offsetLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offset',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> offsetBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> percentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'percent',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> percentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'percent',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> percentEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percent',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> percentGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percent',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> percentLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percent',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> percentBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      totalChapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalChapter',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      totalChapterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalChapter',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> totalChapterEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      totalChapterGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      totalChapterLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> totalChapterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalChapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> totalPageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalPage',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      totalPageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalPage',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> totalPageEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPage',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      totalPageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPage',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> totalPageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPage',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> totalPageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TrackReadQueryObject
    on QueryBuilder<TrackRead, TrackRead, QFilterCondition> {}

extension TrackReadQueryLinks
    on QueryBuilder<TrackRead, TrackRead, QFilterCondition> {}

extension TrackReadQuerySortBy on QueryBuilder<TrackRead, TrackRead, QSortBy> {
  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByCurrentChapterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentChapterName', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy>
      sortByCurrentChapterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentChapterName', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByIndexChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indexChapter', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByIndexChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indexChapter', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByLastChapterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterName', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByLastChapterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterName', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offset', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offset', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percent', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percent', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByTotalChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByTotalPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPage', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByTotalPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPage', Sort.desc);
    });
  }
}

extension TrackReadQuerySortThenBy
    on QueryBuilder<TrackRead, TrackRead, QSortThenBy> {
  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByCurrentChapterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentChapterName', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy>
      thenByCurrentChapterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentChapterName', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByIndexChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indexChapter', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByIndexChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indexChapter', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByLastChapterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterName', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByLastChapterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterName', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offset', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offset', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percent', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percent', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByTotalChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.desc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByTotalPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPage', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByTotalPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPage', Sort.desc);
    });
  }
}

extension TrackReadQueryWhereDistinct
    on QueryBuilder<TrackRead, TrackRead, QDistinct> {
  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookId');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterId');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByCurrentChapterName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentChapterName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPage');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByIndexChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'indexChapter');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByLastChapterName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastChapterName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'offset');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percent');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalChapter');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByTotalPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPage');
    });
  }
}

extension TrackReadQueryProperty
    on QueryBuilder<TrackRead, TrackRead, QQueryProperty> {
  QueryBuilder<TrackRead, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrackRead, int?, QQueryOperations> bookIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookId');
    });
  }

  QueryBuilder<TrackRead, int?, QQueryOperations> chapterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterId');
    });
  }

  QueryBuilder<TrackRead, String?, QQueryOperations>
      currentChapterNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentChapterName');
    });
  }

  QueryBuilder<TrackRead, int?, QQueryOperations> currentPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPage');
    });
  }

  QueryBuilder<TrackRead, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<TrackRead, int?, QQueryOperations> indexChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'indexChapter');
    });
  }

  QueryBuilder<TrackRead, String?, QQueryOperations> lastChapterNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastChapterName');
    });
  }

  QueryBuilder<TrackRead, double?, QQueryOperations> offsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'offset');
    });
  }

  QueryBuilder<TrackRead, int?, QQueryOperations> percentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percent');
    });
  }

  QueryBuilder<TrackRead, int?, QQueryOperations> totalChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalChapter');
    });
  }

  QueryBuilder<TrackRead, int?, QQueryOperations> totalPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPage');
    });
  }
}

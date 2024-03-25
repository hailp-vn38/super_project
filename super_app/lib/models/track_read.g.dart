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
    r'readCurrentChapter': PropertySchema(
      id: 0,
      name: r'readCurrentChapter',
      type: IsarType.long,
    )
  },
  estimateSize: _trackReadEstimateSize,
  serialize: _trackReadSerialize,
  deserialize: _trackReadDeserialize,
  deserializeProp: _trackReadDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'book': LinkSchema(
      id: -3533736344729586396,
      name: r'book',
      target: r'Book',
      single: true,
    )
  },
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
  return bytesCount;
}

void _trackReadSerialize(
  TrackRead object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.readCurrentChapter);
}

TrackRead _trackReadDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackRead(
    id: id,
    readCurrentChapter: reader.readLongOrNull(offsets[0]),
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _trackReadGetId(TrackRead object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _trackReadGetLinks(TrackRead object) {
  return [object.book];
}

void _trackReadAttach(IsarCollection<dynamic> col, Id id, TrackRead object) {
  object.id = id;
  object.book.attach(col, col.isar.collection<Book>(), r'book', id);
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
      readCurrentChapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'readCurrentChapter',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      readCurrentChapterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'readCurrentChapter',
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      readCurrentChapterEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readCurrentChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      readCurrentChapterGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readCurrentChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      readCurrentChapterLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readCurrentChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition>
      readCurrentChapterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readCurrentChapter',
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
    on QueryBuilder<TrackRead, TrackRead, QFilterCondition> {
  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> book(
      FilterQuery<Book> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'book');
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterFilterCondition> bookIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'book', 0, true, 0, true);
    });
  }
}

extension TrackReadQuerySortBy on QueryBuilder<TrackRead, TrackRead, QSortBy> {
  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> sortByReadCurrentChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readCurrentChapter', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy>
      sortByReadCurrentChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readCurrentChapter', Sort.desc);
    });
  }
}

extension TrackReadQuerySortThenBy
    on QueryBuilder<TrackRead, TrackRead, QSortThenBy> {
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

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy> thenByReadCurrentChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readCurrentChapter', Sort.asc);
    });
  }

  QueryBuilder<TrackRead, TrackRead, QAfterSortBy>
      thenByReadCurrentChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readCurrentChapter', Sort.desc);
    });
  }
}

extension TrackReadQueryWhereDistinct
    on QueryBuilder<TrackRead, TrackRead, QDistinct> {
  QueryBuilder<TrackRead, TrackRead, QDistinct> distinctByReadCurrentChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readCurrentChapter');
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

  QueryBuilder<TrackRead, int?, QQueryOperations> readCurrentChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readCurrentChapter');
    });
  }
}

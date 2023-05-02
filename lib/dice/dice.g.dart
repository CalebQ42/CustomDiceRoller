// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDieCollection on Isar {
  IsarCollection<Die> get dies => this.collection();
}

const DieSchema = CollectionSchema(
  name: r'Die',
  id: 8759452183937794663,
  properties: {
    r'lastSave': PropertySchema(
      id: 0,
      name: r'lastSave',
      type: IsarType.dateTime,
    ),
    r'sides': PropertySchema(
      id: 1,
      name: r'sides',
      type: IsarType.objectList,
      target: r'Side',
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 3,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _dieEstimateSize,
  serialize: _dieSerialize,
  deserialize: _dieDeserialize,
  deserializeProp: _dieDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'Side': SideSchema, r'SidePart': SidePartSchema},
  getId: _dieGetId,
  getLinks: _dieGetLinks,
  attach: _dieAttach,
  version: '3.1.0+1',
);

int _dieEstimateSize(
  Die object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sides.length * 3;
  {
    final offsets = allOffsets[Side]!;
    for (var i = 0; i < object.sides.length; i++) {
      final value = object.sides[i];
      bytesCount += SideSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _dieSerialize(
  Die object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastSave);
  writer.writeObjectList<Side>(
    offsets[1],
    allOffsets,
    SideSchema.serialize,
    object.sides,
  );
  writer.writeString(offsets[2], object.title);
  writer.writeString(offsets[3], object.uuid);
}

Die _dieDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Die(
    sides: reader.readObjectList<Side>(
          offsets[1],
          SideSchema.deserialize,
          allOffsets,
          Side(),
        ) ??
        const [],
    title: reader.readString(offsets[2]),
  );
  object.id = id;
  object.lastSave = reader.readDateTime(offsets[0]);
  object.uuid = reader.readString(offsets[3]);
  return object;
}

P _dieDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readObjectList<Side>(
            offset,
            SideSchema.deserialize,
            allOffsets,
            Side(),
          ) ??
          const []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dieGetId(Die object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dieGetLinks(Die object) {
  return [];
}

void _dieAttach(IsarCollection<dynamic> col, Id id, Die object) {
  object.id = id;
}

extension DieByIndex on IsarCollection<Die> {
  Future<Die?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  Die? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<Die?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<Die?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(Die object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(Die object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<Die> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<Die> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }

  Future<Die?> getByTitle(String title) {
    return getByIndex(r'title', [title]);
  }

  Die? getByTitleSync(String title) {
    return getByIndexSync(r'title', [title]);
  }

  Future<bool> deleteByTitle(String title) {
    return deleteByIndex(r'title', [title]);
  }

  bool deleteByTitleSync(String title) {
    return deleteByIndexSync(r'title', [title]);
  }

  Future<List<Die?>> getAllByTitle(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return getAllByIndex(r'title', values);
  }

  List<Die?> getAllByTitleSync(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'title', values);
  }

  Future<int> deleteAllByTitle(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'title', values);
  }

  int deleteAllByTitleSync(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'title', values);
  }

  Future<Id> putByTitle(Die object) {
    return putByIndex(r'title', object);
  }

  Id putByTitleSync(Die object, {bool saveLinks = true}) {
    return putByIndexSync(r'title', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTitle(List<Die> objects) {
    return putAllByIndex(r'title', objects);
  }

  List<Id> putAllByTitleSync(List<Die> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'title', objects, saveLinks: saveLinks);
  }
}

extension DieQueryWhereSort on QueryBuilder<Die, Die, QWhere> {
  QueryBuilder<Die, Die, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DieQueryWhere on QueryBuilder<Die, Die, QWhereClause> {
  QueryBuilder<Die, Die, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Die, Die, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Die, Die, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Die, Die, QAfterWhereClause> idBetween(
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

  QueryBuilder<Die, Die, QAfterWhereClause> uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterWhereClause> uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Die, Die, QAfterWhereClause> titleEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterWhereClause> titleNotEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DieQueryFilter on QueryBuilder<Die, Die, QFilterCondition> {
  QueryBuilder<Die, Die, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<Die, Die, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<Die, Die, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<Die, Die, QAfterFilterCondition> lastSaveEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSave',
        value: value,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> lastSaveGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSave',
        value: value,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> lastSaveLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSave',
        value: value,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> lastSaveBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSave',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> sidesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sides',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> sidesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sides',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> sidesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sides',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> sidesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sides',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> sidesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sides',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> sidesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sides',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<Die, Die, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<Die, Die, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<Die, Die, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<Die, Die, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<Die, Die, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<Die, Die, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<Die, Die, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension DieQueryObject on QueryBuilder<Die, Die, QFilterCondition> {
  QueryBuilder<Die, Die, QAfterFilterCondition> sidesElement(
      FilterQuery<Side> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sides');
    });
  }
}

extension DieQueryLinks on QueryBuilder<Die, Die, QFilterCondition> {}

extension DieQuerySortBy on QueryBuilder<Die, Die, QSortBy> {
  QueryBuilder<Die, Die, QAfterSortBy> sortByLastSave() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSave', Sort.asc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> sortByLastSaveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSave', Sort.desc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension DieQuerySortThenBy on QueryBuilder<Die, Die, QSortThenBy> {
  QueryBuilder<Die, Die, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> thenByLastSave() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSave', Sort.asc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> thenByLastSaveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSave', Sort.desc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Die, Die, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension DieQueryWhereDistinct on QueryBuilder<Die, Die, QDistinct> {
  QueryBuilder<Die, Die, QDistinct> distinctByLastSave() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSave');
    });
  }

  QueryBuilder<Die, Die, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Die, Die, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension DieQueryProperty on QueryBuilder<Die, Die, QQueryProperty> {
  QueryBuilder<Die, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Die, DateTime, QQueryOperations> lastSaveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSave');
    });
  }

  QueryBuilder<Die, List<Side>, QQueryOperations> sidesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sides');
    });
  }

  QueryBuilder<Die, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Die, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SideSchema = Schema(
  name: r'Side',
  id: 4840541204856315386,
  properties: {
    r'parts': PropertySchema(
      id: 0,
      name: r'parts',
      type: IsarType.objectList,
      target: r'SidePart',
    )
  },
  estimateSize: _sideEstimateSize,
  serialize: _sideSerialize,
  deserialize: _sideDeserialize,
  deserializeProp: _sideDeserializeProp,
);

int _sideEstimateSize(
  Side object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.parts.length * 3;
  {
    final offsets = allOffsets[SidePart]!;
    for (var i = 0; i < object.parts.length; i++) {
      final value = object.parts[i];
      bytesCount += SidePartSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _sideSerialize(
  Side object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<SidePart>(
    offsets[0],
    allOffsets,
    SidePartSchema.serialize,
    object.parts,
  );
}

Side _sideDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Side();
  object.parts = reader.readObjectList<SidePart>(
        offsets[0],
        SidePartSchema.deserialize,
        allOffsets,
        SidePart(),
      ) ??
      [];
  return object;
}

P _sideDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<SidePart>(
            offset,
            SidePartSchema.deserialize,
            allOffsets,
            SidePart(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SideQueryFilter on QueryBuilder<Side, Side, QFilterCondition> {
  QueryBuilder<Side, Side, QAfterFilterCondition> partsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Side, Side, QAfterFilterCondition> partsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Side, Side, QAfterFilterCondition> partsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Side, Side, QAfterFilterCondition> partsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Side, Side, QAfterFilterCondition> partsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Side, Side, QAfterFilterCondition> partsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'parts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SideQueryObject on QueryBuilder<Side, Side, QFilterCondition> {
  QueryBuilder<Side, Side, QAfterFilterCondition> partsElement(
      FilterQuery<SidePart> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'parts');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SidePartSchema = Schema(
  name: r'SidePart',
  id: 8597548793712253229,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 1,
      name: r'value',
      type: IsarType.long,
    )
  },
  estimateSize: _sidePartEstimateSize,
  serialize: _sidePartSerialize,
  deserialize: _sidePartDeserialize,
  deserializeProp: _sidePartDeserializeProp,
);

int _sidePartEstimateSize(
  SidePart object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _sidePartSerialize(
  SidePart object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeLong(offsets[1], object.value);
}

SidePart _sidePartDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SidePart(
    name: reader.readStringOrNull(offsets[0]) ?? "",
    value: reader.readLongOrNull(offsets[1]) ?? 1,
  );
  return object;
}

P _sidePartDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SidePartQueryFilter
    on QueryBuilder<SidePart, SidePart, QFilterCondition> {
  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SidePartQueryObject
    on QueryBuilder<SidePart, SidePart, QFilterCondition> {}

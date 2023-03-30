// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetDiceGroupCollection on Isar {
  IsarCollection<DiceGroup> get diceGroups => this.collection();
}

const DiceGroupSchema = CollectionSchema(
  name: r'DiceGroup',
  id: 5610959011544525199,
  properties: {
    r'dice': PropertySchema(
      id: 0,
      name: r'dice',
      type: IsarType.objectList,
      target: r'EmbeddedDie',
    ),
    r'title': PropertySchema(
      id: 1,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _diceGroupEstimateSize,
  serialize: _diceGroupSerialize,
  deserialize: _diceGroupDeserialize,
  deserializeProp: _diceGroupDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'EmbeddedDie': EmbeddedDieSchema,
    r'Side': SideSchema,
    r'SidePart': SidePartSchema
  },
  getId: _diceGroupGetId,
  getLinks: _diceGroupGetLinks,
  attach: _diceGroupAttach,
  version: '3.0.5',
);

int _diceGroupEstimateSize(
  DiceGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dice.length * 3;
  {
    final offsets = allOffsets[EmbeddedDie]!;
    for (var i = 0; i < object.dice.length; i++) {
      final value = object.dice[i];
      bytesCount += EmbeddedDieSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _diceGroupSerialize(
  DiceGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<EmbeddedDie>(
    offsets[0],
    allOffsets,
    EmbeddedDieSchema.serialize,
    object.dice,
  );
  writer.writeString(offsets[1], object.title);
}

DiceGroup _diceGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiceGroup(
    dice: reader.readObjectList<EmbeddedDie>(
          offsets[0],
          EmbeddedDieSchema.deserialize,
          allOffsets,
          EmbeddedDie(),
        ) ??
        const [],
    title: reader.readStringOrNull(offsets[1]) ?? "New Group",
  );
  object.id = id;
  return object;
}

P _diceGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<EmbeddedDie>(
            offset,
            EmbeddedDieSchema.deserialize,
            allOffsets,
            EmbeddedDie(),
          ) ??
          const []) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "New Group") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _diceGroupGetId(DiceGroup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _diceGroupGetLinks(DiceGroup object) {
  return [];
}

void _diceGroupAttach(IsarCollection<dynamic> col, Id id, DiceGroup object) {
  object.id = id;
}

extension DiceGroupQueryWhereSort
    on QueryBuilder<DiceGroup, DiceGroup, QWhere> {
  QueryBuilder<DiceGroup, DiceGroup, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DiceGroupQueryWhere
    on QueryBuilder<DiceGroup, DiceGroup, QWhereClause> {
  QueryBuilder<DiceGroup, DiceGroup, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterWhereClause> idBetween(
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

extension DiceGroupQueryFilter
    on QueryBuilder<DiceGroup, DiceGroup, QFilterCondition> {
  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> diceLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dice',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> diceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dice',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> diceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dice',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> diceLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dice',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition>
      diceLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dice',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> diceLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dice',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleContains(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleMatches(
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

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension DiceGroupQueryObject
    on QueryBuilder<DiceGroup, DiceGroup, QFilterCondition> {
  QueryBuilder<DiceGroup, DiceGroup, QAfterFilterCondition> diceElement(
      FilterQuery<EmbeddedDie> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'dice');
    });
  }
}

extension DiceGroupQueryLinks
    on QueryBuilder<DiceGroup, DiceGroup, QFilterCondition> {}

extension DiceGroupQuerySortBy on QueryBuilder<DiceGroup, DiceGroup, QSortBy> {
  QueryBuilder<DiceGroup, DiceGroup, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension DiceGroupQuerySortThenBy
    on QueryBuilder<DiceGroup, DiceGroup, QSortThenBy> {
  QueryBuilder<DiceGroup, DiceGroup, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DiceGroup, DiceGroup, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension DiceGroupQueryWhereDistinct
    on QueryBuilder<DiceGroup, DiceGroup, QDistinct> {
  QueryBuilder<DiceGroup, DiceGroup, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension DiceGroupQueryProperty
    on QueryBuilder<DiceGroup, DiceGroup, QQueryProperty> {
  QueryBuilder<DiceGroup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiceGroup, List<EmbeddedDie>, QQueryOperations> diceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dice');
    });
  }

  QueryBuilder<DiceGroup, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetDieCollection on Isar {
  IsarCollection<Die> get dies => this.collection();
}

const DieSchema = CollectionSchema(
  name: r'Die',
  id: 8759452183937794663,
  properties: {
    r'sides': PropertySchema(
      id: 0,
      name: r'sides',
      type: IsarType.objectList,
      target: r'Side',
    ),
    r'title': PropertySchema(
      id: 1,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _dieEstimateSize,
  serialize: _dieSerialize,
  deserialize: _dieDeserialize,
  deserializeProp: _dieDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Side': SideSchema, r'SidePart': SidePartSchema},
  getId: _dieGetId,
  getLinks: _dieGetLinks,
  attach: _dieAttach,
  version: '3.0.5',
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
  return bytesCount;
}

void _dieSerialize(
  Die object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Side>(
    offsets[0],
    allOffsets,
    SideSchema.serialize,
    object.sides,
  );
  writer.writeString(offsets[1], object.title);
}

Die _dieDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Die(
    sides: reader.readObjectList<Side>(
          offsets[0],
          SideSchema.deserialize,
          allOffsets,
          Side(),
        ) ??
        const [],
    title: reader.readStringOrNull(offsets[1]) ?? "New Die",
  );
  object.id = id;
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
      return (reader.readObjectList<Side>(
            offset,
            SideSchema.deserialize,
            allOffsets,
            Side(),
          ) ??
          const []) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "New Die") as P;
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
}

extension DieQueryWhereDistinct on QueryBuilder<Die, Die, QDistinct> {
  QueryBuilder<Die, Die, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension DieQueryProperty on QueryBuilder<Die, Die, QQueryProperty> {
  QueryBuilder<Die, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
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
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const EmbeddedDieSchema = Schema(
  name: r'EmbeddedDie',
  id: -5649109980333418003,
  properties: {
    r'sides': PropertySchema(
      id: 0,
      name: r'sides',
      type: IsarType.objectList,
      target: r'Side',
    ),
    r'title': PropertySchema(
      id: 1,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _embeddedDieEstimateSize,
  serialize: _embeddedDieSerialize,
  deserialize: _embeddedDieDeserialize,
  deserializeProp: _embeddedDieDeserializeProp,
);

int _embeddedDieEstimateSize(
  EmbeddedDie object,
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
  return bytesCount;
}

void _embeddedDieSerialize(
  EmbeddedDie object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Side>(
    offsets[0],
    allOffsets,
    SideSchema.serialize,
    object.sides,
  );
  writer.writeString(offsets[1], object.title);
}

EmbeddedDie _embeddedDieDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmbeddedDie(
    sides: reader.readObjectList<Side>(
          offsets[0],
          SideSchema.deserialize,
          allOffsets,
          Side(),
        ) ??
        const [],
    title: reader.readStringOrNull(offsets[1]) ?? "",
  );
  return object;
}

P _embeddedDieDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Side>(
            offset,
            SideSchema.deserialize,
            allOffsets,
            Side(),
          ) ??
          const []) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension EmbeddedDieQueryFilter
    on QueryBuilder<EmbeddedDie, EmbeddedDie, QFilterCondition> {
  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition>
      sidesLengthEqualTo(int length) {
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> sidesIsEmpty() {
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition>
      sidesIsNotEmpty() {
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition>
      sidesLengthLessThan(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition>
      sidesLengthGreaterThan(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition>
      sidesLengthBetween(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition>
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> titleContains(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> titleMatches(
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

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension EmbeddedDieQueryObject
    on QueryBuilder<EmbeddedDie, EmbeddedDie, QFilterCondition> {
  QueryBuilder<EmbeddedDie, EmbeddedDie, QAfterFilterCondition> sidesElement(
      FilterQuery<Side> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sides');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

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
  final object = Side(
    parts: reader.readObjectList<SidePart>(
          offsets[0],
          SidePartSchema.deserialize,
          allOffsets,
          SidePart(),
        ) ??
        const [],
  );
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
          const []) as P;
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
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const SidePartSchema = Schema(
  name: r'SidePart',
  id: 8597548793712253229,
  properties: {
    r'number': PropertySchema(
      id: 0,
      name: r'number',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: 1,
      name: r'value',
      type: IsarType.string,
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
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _sidePartSerialize(
  SidePart object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.number);
  writer.writeString(offsets[1], object.value);
}

SidePart _sidePartDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SidePart(
    number: reader.readLongOrNull(offsets[0]) ?? 1,
    value: reader.readStringOrNull(offsets[1]) ?? "",
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
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SidePartQueryFilter
    on QueryBuilder<SidePart, SidePart, QFilterCondition> {
  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> numberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> numberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> numberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> numberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'number',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<SidePart, SidePart, QAfterFilterCondition> valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension SidePartQueryObject
    on QueryBuilder<SidePart, SidePart, QFilterCondition> {}

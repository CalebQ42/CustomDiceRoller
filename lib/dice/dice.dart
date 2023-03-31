import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'dice.g.dart';

@collection
class DiceGroup{
  Id id = Id.parse(const Uuid().v4());

  String title;
  List<EmbeddedDie> dice;

  DiceGroup({this.title = "New Group", this.dice = const []});
}

@embedded
class EmbeddedDie{
  String title;
  List<Side> sides;

  EmbeddedDie({this.title = "", this.sides = const []});
}

@collection
class Die {
  Id id = Id.parse(const Uuid().v4());

  String title = "";
  List<Side> sides = [];

  Die({this.title = "New Die", this.sides = const []});
  Die.numberDie(int maxNum, AppLocalizations localizations) :
    title = localizations.dieNotation + maxNum.toString(),
    sides = List<Side>.generate(maxNum, (index) => Side.simple((index + 1).toString()));

  EmbeddedDie toEmbeded() => EmbeddedDie(title: title, sides: sides);
}

@embedded
class Side{
  List<SidePart> parts;

  Side({this.parts = const []});
  Side.simple(String value) : parts = [SidePart(value: value)];
}

@embedded
class SidePart{
  int number;
  String value;

  SidePart({this.number = 1, this.value = ""});
}
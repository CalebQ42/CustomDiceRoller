import 'package:customdiceroller/CustVars/JsonSavable.dart';

class SimpleSide extends JsonSavable{
  String _value;

  SimpleSide(this._value);
  SimpleSide.fromJson(Map<String,dynamic> mp){load(mp);}

  JsonSavable clone() => SimpleSide(_value);
  void load(Map<String, dynamic> mp) {
    _value = mp["value"];
  }
  Map<String, dynamic> toJson() => {"value":_value};
  int intSide() => int.parse(_value);
  String stringSide() => _value;
  bool isInt() => int.parse(_value,onError: (source) => null) != null;
  void setString(String side) => _value = side;
  void setInt(int side)=> _value = side.toString();
  String toString()=>_value;

  //TODO: static void edit
}

class ComplexSide extends JsonSavable{
  int number;
  List<ComplexSidePart> parts = new List<ComplexSidePart>();

  ComplexSide({this.number = 0,this.parts});
  ComplexSide.fromJson(Map<String,dynamic> mp){load(mp);}

  JsonSavable clone() => ComplexSide(number:number,parts:new List<ComplexSidePart>.from(parts));
  void load(Map<String, dynamic> mp) {
    number = mp["number"];
    parts.clear();
    (mp["parts"] as List<Map<String,dynamic>>).forEach((mp)=>parts.add(new ComplexSidePart.fromJson(mp)));
  }
  Map<String, dynamic> toJson() => {"number":number,"parts":parts};
  String toString(){
    var out = new List<String>();
    if(number != 0)
      out.add(number.toString());
    parts.forEach((s)=>out.add(s.toString()));
    return out.join();
  }

  //TODO: static void edit
  //TODO: EditItemAdapter (List Adapter)
}

class ComplexSidePart extends JsonSavable{
  String name;
  int value;

  ComplexSidePart({this.name = "",this.value = 0});
  ComplexSidePart.fromJson(Map<String,dynamic> mp){load(mp);}

  JsonSavable clone() => ComplexSidePart(name:name,value:value);
  void load(Map<String, dynamic> mp){
    name = mp["Name"];
    value = mp["Value"];
  }
  Map<String, dynamic> toJson() => {"Name":name,"Value":value};
  String toString() => value.toString() + " " + name;
}
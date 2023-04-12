import 'package:customdiceroller/dice/dice.dart';
import 'package:flutter/material.dart';

class DiceResults{
  int _num = 0;
  int get numRes => _num;
  bool _hasNumRes = false;
  bool get hasNumRes => _hasNumRes;
  final Map<String, int> _res = {};
  List<String> get values => _res.keys.toList();
  final List<Side> _indResults = [];

  bool subtractMode = false;
  bool problem = false;
  
  void addAll(List<Side> sides){
    for(var s in sides){
      add(s);
    }
  }
  void add(Side s) {
    for(int i = 0; i < s.parts.length; i++){
      if(subtractMode) s.parts[i].value *= -1;
      if(s.parts[i].name == ""){
        _num += s.parts[i].value;
        _hasNumRes = true;
      }else{
        _res[s.parts[i].name] = (_res[s.parts[i].name] ?? 0) + s.parts[i].value;
      }
    }
    _indResults.add(s);
  }
  int getResult(String name) => _res[name] ?? 0;
  void showResults(BuildContext context){
    //TODO: popup
  }

  @override
  String toString(){
    var out = "";
    if(_hasNumRes) out += "Number: $_num; ";
    if(out.isNotEmpty) out += "Results: $_res; ";
    if(_indResults.isNotEmpty) out += "Individual Results: $_indResults";
    return out;
  }
}
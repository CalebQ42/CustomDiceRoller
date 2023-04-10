import 'package:customdiceroller/dice/dice.dart';

class DiceResults{
  
  int _num = 0;
  int get numRes => _num;
  bool _hasNumRes = false;
  bool get hasNumRes => _hasNumRes;
  final Map<String, int> _res = {};
  List<String> get values => _res.keys.toList();
  
  void add(Side s) {
    for(var p in s.parts){
      if(p.name == ""){
        _num += p.value;
        _hasNumRes = true;
      }else{
        _res[p.name] = (_res[p.name] ?? 0) + p.value;
      }
    }
  }
  int getResult(String name) => _res[name] ?? 0;

  static DiceResults parse(String dieNotation){
    DiceResults dr = DiceResults();
    //TODO
    return dr;
  }
}
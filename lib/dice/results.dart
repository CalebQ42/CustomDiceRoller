class DiceResults{
  
  int _num = 0;
  int get numRes => _num;
  bool _hasNumRes = false;
  bool get hasNumRes => _hasNumRes;
  final Map<String, int> _res = {};

  List<String> get values => _res.keys.toList();

  void addResult(String name, int value) => _res[name] = (_res[name] ?? 0) + value;
  int getResult(String name) => _res[name] ?? 0;
  void addNumRes(int value){
    _hasNumRes = true;
    _num += value;
  }

  static DiceResults parse(String dieNotation){
    DiceResults dr = DiceResults();
    //TODO
    return dr;
  }
}
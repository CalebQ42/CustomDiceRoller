class DiceResults{
  int _number = 0;
  List<Result> _reses = new List<Result>();
  var subtractMode = false;
  var problem = false;
  var resList = new List();
  void add(Result res){
    if(subtractMode)
      res.value *= -1;
    resList.add(new Result(res.name,res.value));
    if (has(res.name))
      _reses[indexOf(res.name)];
    else
      _reses.add(res);
  }
  void addNum(int i){
    if (subtractMode)
      i*=-1;
    _number += i;
    resList.add(i);
  }
  bool has(String name) => _reses.any((r)=>r.name == name);
  int indexOf(String name){
    var out = _reses.indexWhere((res)=>res.name == name);
    out ??=-1;
    return out;
  }
  int size() => _reses.length;
  void set(String name, int value)=>_reses.firstWhere((res)=>res.name==name,orElse: ()=>null)?.value = value;
  int get(String name){
    var out = _reses.firstWhere((res)=>res.name==name,orElse: ()=>null)?.value;
    out ??=0;
    return out;
  }
  int getNum() => _number;
  void combineWith(DiceResults dr){
    dr.resList.forEach((r){
      if(r is int)
        addNum(r);
      else if(r is Result)
        add(r);
    });
  }
  bool isNumOnly() => resList.length == 0;
  //TODO: showDialog
  //TODO: showCombinedDialog
  //TODO: showIndividualDialog
  String toString(){
    var out = _number.toString();
    _reses.forEach((r)=> out += ", "+r.value.toString()+" "+r.name);
    return out;
  }
}

class Result{
  String name;
  int value;
  Result(this.name,this.value);
  String toString() => value.toString() + " " + name;
}
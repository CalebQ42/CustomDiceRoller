import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:customdiceroller/ui/bottom.dart';
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
    if(CDR.of(context).prefs.individual()){
      showIndividualResults(context);
    }else{
      showCombinedResults(context);
    }
  }
  void showCombinedResults(BuildContext context) =>
    Bottom(
      child: (c) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(_hasNumRes) Text(
            _num.toString(),
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          ...List.generate(
            _res.length,
            (index) {
              var key = values[index];
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("$key:"),
                  Expanded(
                    child: Text(
                      _res[key].toString(),
                      textAlign: TextAlign.center,
                    )
                  )
                ],
              );
            }
          )
        ],
      ),
      buttons: (c) =>[
        TextButton(
          onPressed: (){
            Navigator.of(c).pop();
            showIndividualResults(c);
          },
          child: Text(CDR.of(c).locale.individual)
        )
      ],
    ).show(context);
  void showIndividualResults(BuildContext context) =>
    Bottom(
      child: (c) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          _indResults.length,
          (index) =>
            Text(
              _indResults[index].toString(),
              textAlign: TextAlign.center,
              style: Theme.of(c).textTheme.headlineSmall,
            )
        )
      ),
      buttons: (c) =>[
        TextButton(
          onPressed: (){
            Navigator.of(c).pop();
            showCombinedResults(c);
          },
          child: Text(CDR.of(c).locale.combined)
        )
      ],
    ).show(context);

  @override
  String toString(){
    var out = "";
    if(_hasNumRes) out += "Number: $_num; ";
    if(out.isNotEmpty) out += "Results: $_res; ";
    if(_indResults.isNotEmpty) out += "Individual Results: $_indResults";
    return out;
  }
}
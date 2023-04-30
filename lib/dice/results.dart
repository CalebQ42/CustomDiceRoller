import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/dice.dart';
import 'package:darkstorm_common/bottom.dart';
import 'package:flutter/material.dart';

class DiceResults{
  int _num = 0;
  int get numRes => _num;
  bool _hasNumRes = false;
  bool get hasNumRes => _hasNumRes;
  final Map<String, int> _res = {};
  List<String> get values => _res.keys.toList();
  final List<String> _indResults = [];

  bool subtractMode = false;
  bool problem = false;
  
  void addAll(List<Side> sides, String dieName){
    for(var s in sides){
      add(s, dieName);
    }
  }
  void add(Side s, String dieName) {
    for(int i = 0; i < s.parts.length; i++){
      if(subtractMode) s.parts[i].value *= -1;
      if(s.parts[i].name == ""){
        _num += s.parts[i].value;
        _hasNumRes = true;
      }else{
        _res[s.parts[i].name] = (_res[s.parts[i].name] ?? 0) + s.parts[i].value;
      }
    }
    if(dieName == ""){
      _indResults.add(s.toString());
    }else{
      _indResults.add("$dieName: $s");
    }
  }
  int getResult(String name) => _res[name] ?? 0;

  void showResults(BuildContext context){
    if(!problem){
      if(CDR.of(context).prefs.individual()){
        showIndividualResults(context);
      }else{
        showCombinedResults(context);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(CDR.of(context).locale.parseError))
      );
    }
  }
  void showCombinedResults(BuildContext context) {
    bool showNums = false;
    for(var k in _res.keys){
      if(_res[k] != 0 && _res[k] != 1){
        showNums = true;
        break;
      }
    }
    Bottom(
      children: (c) =>
        [
          if(_hasNumRes) Text(
            _num.toString(),
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          ...List.generate(
            _res.length,
            (index) {
              var key = values[index];
              return _res[key] != 0 ? Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        key,
                        style: Theme.of(c).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      )
                    ),
                    if(showNums) Container(width: 10),
                    if(showNums) Expanded(
                      child: Text(
                        _res[key].toString(),
                        style: Theme.of(c).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      )
                    )
                  ],
                )
              ) : Container();
            }
          )
        ],
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
  }
  void showIndividualResults(BuildContext context) =>
    Bottom(
      children: (c) => List.generate(
        _indResults.length,
        (index) =>
          Text(
            _indResults[index],
            textAlign: TextAlign.center,
            style: Theme.of(c).textTheme.headlineSmall,
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
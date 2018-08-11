import 'package:flutter/material.dart';

import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/Preferences.dart';

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
      _reses[indexOf(res.name)].value += res.value;
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
  void showResultDialog(BuildContext bc,CDR cdr, String problemMessage){
    if(cdr.prefs.getBool(Preferences.individualResults)??false){
      showIndividualDialog(bc);
    }else{
      showCombinedDialog(bc);
    }
  }
  void showCombinedDialog(BuildContext bc){
    var children = new List<Widget>();
    children.add(
      new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text("Number:"),
          new Text(
            _number.toString(),
            style: Theme.of(bc).textTheme.title.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      )
    );
    for(var r in _reses){
      children.add(new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(r.name,
            textAlign: TextAlign.start,
          ),
          new Text(r.value.toString(),
            textAlign: TextAlign.end,
            style: Theme.of(bc).textTheme.title.copyWith(fontWeight: FontWeight.bold)
          )
        ],
      ));
    }
    showDialog(
      context: bc,
      builder: (bc) => AlertDialog(
        content: new SingleChildScrollView(
          child: new Column(
            children: children,
          )
        ),
        actions: [
            new FlatButton(
              child: new Text("Individual"),
              onPressed: (){
                Navigator.pop(bc);
                showIndividualDialog(bc);
              }
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: ()=> Navigator.pop(bc)
            )
          ]
      )
    );
  }
  void showIndividualDialog(BuildContext bc){
    var children = List<Widget>();
    for(var l in resList){
      children.add(new Text(
        l.toString(),
        textAlign: TextAlign.center,
      ));
    }
    showDialog(
      context: bc,
      builder: (bc){
        return new AlertDialog(
          content: new SingleChildScrollView(
            child: new Column(
              children: children,
            )
          ),
          actions: [
            new FlatButton(
              child: new Text("Combined"),
              onPressed: (){
                Navigator.pop(bc);
                showCombinedDialog(bc);
              }
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: ()=> Navigator.pop(bc)
            )
          ]
        );
      }
    );
  }
  String toString(){
    var out = "";
    if(_number !=1){
      out+=_number.toString();
    }
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